import sys
import time
import json
import os
import nltk
from nltk.corpus import wordnet as wn
from nltk.stem.porter import *
from abc import ABC, abstractmethod
from question import Question, QuestionSet, preprocess_db, SQLError
from nltk.metrics import edit_distance
import numpy as np
from sklearn.tree import DecisionTreeClassifier, export_graphviz
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import GaussianNB, MultinomialNB, BernoulliNB
import pandas as pd
from config import smv_cutoffs, frog_cutoffs, combined_cutoffs, tree_model_data


dt = DecisionTreeClassifier(min_samples_split=40, max_depth=4, random_state=52)
"""Model for decision tree learning/classification"""

nb_b = BernoulliNB()
"""Model for Bernoulli naive bayes learning/classification"""

nb_g = GaussianNB()
"""Model for Gaussian naive bayes learning/classification"""

cutoffs = combined_cutoffs
"""confidence cutoffs for if answer exists or not"""

#nb_m = MultinomialNB()


def gen_tree():
    """
    Generates the tree model data for :any:`QA.qa.dt` based on :any:`QA.config.tree_model_data`. Also generates
    data for :any:`QA.qa.nb_g` and :any:`QA.qa.nb_b` based on that same data.
    """
    global dt, tree_keys, nb_g, nb_b
    file = tree_model_data

    df = pd.read_csv(file)
    tree_keys = [key for key in df.keys() if key not in ['correct', 'tree_confidence']]
    X_train, X_test, Y_train, Y_test = train_test_split(df[tree_keys], df['correct'], test_size = 0.3, random_state=52)

    dt.fit(X_train, Y_train)
    print('Tree accuracy on test data split: ', dt.score(X_test, Y_test))

    nb_b.fit(X_train, Y_train)
    nb_g.fit(X_train, Y_train)
    #nb_m.fit(x, y)


# create the tree
gen_tree()
# initialize the stemmer
stemmer = PorterStemmer()



def get_question_sets():
    """
    Gets all preprocessed subjects

    Returns:
        generator: all preprocessed subjects
    """
    for root, dirs, files in os.walk('./preprocessed'):
        for file_name in files:
            yield file_name
    #return get_subjects_from_sql()

def preprocess():
    """
    Does any necessary preprocessing for qa to start.

    All this now entails is a call to question.preprocess_db
    """
   
    print("preprocessing questions", file=sys.stderr)

    try:
        preprocess_db()
    except SQLError:
        pass

    print("questions processed", file=sys.stderr)


# This is our abstract class for our different matching techniques.
class NLPMethod(ABC):
    """
    Abstract class to extend to create a matching technique.
    """
    @staticmethod
    def gen_results(matches, p_time, debug, cutoff):
        """
        This function returns the matches as a dictionary formatted as follows:

            {
                "matched": <question that is the best match, or "No answer matched.">,

                "ans": <answer to best matched question, or "No answer matched.">,

                "time": <time taken to run this method>,

                "cutoff": <the cutoff used to determine if a match is actually an answer>,

                "matches": [

                    {<match_prob>, <matched question>

                        "match": <match confidence>,

                        "question": <matched question>

                    },
                    ...
                ]
            }

        the "matches" part of the dictionary is only included if debug is set to True

        Args:
            matches (list): list of matches in format ``[(<match_probability>, <Question>), ...]`` sorted by best answer
                first (highest probability first)
            p_time (float): time it took to process the results
            debug (bool): whether to show debug information or not
            cutoff (float): the cutoff for determining if an answer exists

        Returns:
            dict: the formatted list of matches
        """
        result = {"matched": None, "ans": None, "matches": [], 'time': p_time}
        if matches:
            if matches[0][0] < cutoff:
                result['matched'] = 'No answer matched.'
                result['ans'] = 'No answer matched.'
            else:
                result['matched'] = matches[0][1].question
                result['ans'] = matches[0][1].answer
            result['cutoff'] = cutoff
            if debug:
                result['matches'] = [{'match': question[0], 'question': question[1].question} for question in matches]
        return result

    def run_method(self, question, db, debug, top_n=5, cutoff =0.0, sorted=True):
        """
        Runs the NLPMethod and determines the best matches, if any

        Args:
            question (str): the user question being asked
            db (QuestionSet): the set of questions to compare against
            debug (bool): whether or not to return debugging info
            top_n (int, optional): the amount of results to show in debugging info. Defaults to 5
            cutoff (float, optional): the cutoff used to determine if a match is actually an answer or not.
                Defaults to 0, meaning that every match will be considered an answer by default.

        Returns:
            dict: the formatted list of matches, formatted as shown in NLPMethod.gen_results
        """
        start = time.time()
        out = []
        for q in db:
            out.append((self.match_prob(question, q), q))
        if sorted:
            out.sort(key=lambda x: x[0], reverse=True)
        return NLPMethod.gen_results(out[:top_n] if top_n else out, time.time() - start, debug, cutoff)

    @abstractmethod
    def match_prob(self, question1, question2):
        """
        Finds the probability that two questions are a match. Abstract method of :class:`QA.qa.NLPMethod`, override in any
        subclasses.

        Args:
            question1 (question.Question): user inputted question
            question2 (question.Question): the existing question being compared against

        Returns:
            float: probability of the questions being a correct match
        """
        pass

def get_answer(userQuestion, method, category):
    
    result =get_response(userQuestion, True, 2 if category == "frog" else "1", 59, [method], False)

    #[0]['question']),str(result['results'][method]['matches'][0]['match'])

    return result['results'][method]['matches']


    
# This was the first technique we developed the probability of a match is
# the number of significant words the two questions have in common divided
# by total number of different words between the two questions.
class Exact(NLPMethod):
    """
    Matches questions based on shared keywords, only taking exact matches into account.

    In the sentences "John had a cow" and "John had two cows", "John" would match, but "cow" would not match "cows"
    because the words are not exactly the same.
    """
    def match_prob(self, question1, question2):
        return len(question1.sig_word_set & question2.sig_word_set) / len(question1.sig_word_set | question2.sig_word_set)


# This technique is similar to the exact technique above. The difference
# is that this technique takes synonyms of significant words in to account.
# If a word is an exact match then it counts as 1 for the numerator, if a
# synonym is a match then it counts as .5 for the numerator.
class SynsetMatch(NLPMethod):
    """
    Matches questions based on shared keywords, taking synonyms into account. A synset is a grouping of all synonyms
    with a particular definition. Stemming is also taken into account (reducing a word to its base form, so
    "pancakes" becomes "pancake" and "devouring" becomes "devour").

    In the sentences "How much is car insurance" and "How much is automobile insurance", "car" and "automobile" should
    match because they are synonyms. The other words should still match as well. The match for the word "insurance",
    however, adds more to the similarity score than the match between "car" and "automobile" because it is an exact
    match.

    In the sentences "What would a carnivore be eating" and "What do carnivores eat", "carnivore" matches with
    "carnivores" because they have the same stem. In addition, "eating" matches with "eat" for the same reason.

    Synonyms and stems are found using NLTK's Wordnet corpus.

    It is important to note that some words might match up with several synsets. "Whale", for example, matches with the
    synset for the animal as well as the synset "giant.n.04" (words meaning "a very large person; impressive in size
    or qualities"). For this NLPMethod, all synsets that match up with a word are checked, meaning it will check
    against both "giant" and "whale".
    """
    def match_prob(self, question1, question2):
        match_num = 0.
        for wordTuple in question1.sig_words:
            match_made = 0
            for matching in question2.sig_words:
                if match_made < 1 and (wordTuple[0] == matching[0] or stemmer.stem(wordTuple[0]) == stemmer.stem(matching[0])):  # exact matches count for 1.0
                    match_num += (1 - match_made)
                    break
                elif match_made == 0 and len(wordTuple[1] & matching[1]) > 0:  # synset matches count for 0.5
                    match_num += 0.5
                    match_made = 0.5
        return match_num / (len(question1.sig_words) + len(question2.sig_words) - match_num) # This isn't actually jacard similarity but eh close enough for right now


class SynsetPathSimilarity(NLPMethod):
    """
    Compares two questions using path similarity between words. This uses synsets, which are groups of synonyms with the
    same definition. Synsets are an element of the NLTK Wordnet corpus. In it, there is a tree of all (well, most)
    synsets in the English language. In this tree, you might have something like the following (which is a real
    subset of the Wordnet tree):

    defender.n.01
        -> fireman.n.04                     \n
        -> lawman.n.01
            -> policeman.n.01

    In this tree, calculating path similarity involves computing the shortest number of edges to get from one synset to
    another. So in this example tree, "fireman" and "policeman" are close together, and would thus have a higher
    path similarity than "fireman" and "killer whale" (not shown in this tree because it's really far away)

    It is important to note that some words might match up with several synsets. "Whale", for example, matches with the
    synset for the animal as well as the synset for "giant" (meaning "a very large person; impressive in size or
    qualities"). For this NLPMethod, all synsets that match up with a word are checked, meaning it will check
    against both "giant" and "whale".
    """
    def match_prob(self, question1, question2):
        similarity = 0.
        for wordTuple in question1.sig_words:
            temp = [t for matching in question2.sig_words for t in [w1.path_similarity(w2) for w2 in matching[1] for w1 in wordTuple[1]] if t]
            if temp:
                similarity += max(temp)
        return 2 * similarity / (len(question1.sig_words) + len(question2.sig_words))


class SynsetWuPalmerSimilarity(NLPMethod):
    """
    Like :class:`SynsetPathSimilarity`, but with a different kind of similarity called Wu-Palmer Similarity. Wu-Palmer
    similarity is very similar to Path Similarity, except in the fact that it weights edges in the graph when
    calculating similarity values.
    """
    def match_prob(self, question1, question2):
        similarity = 0.
        for wordTuple in question1.sig_words:
            temp = [t for matching in question2.sig_words for t in [w1.wup_similarity(w2) for w2 in matching[1] for w1 in wordTuple[1]] if t]
            if temp:
                similarity += max(temp)
        return 2 * similarity / (len(question1.sig_words) + len(question2.sig_words))


class Spacy(NLPMethod):
    """
    This NLPMethod uses SpaCy's .similarity method. This uses the cosine similarity of word vectors. Honestly we're not
    sure exactly how it works, but it seems to be a rather effective way of determining sentence similarity.
    """
    def match_prob(self, question1, question2):
        return question1.spacy.similarity(question2.spacy)


class SpacyTwo(NLPMethod):
    """
    This NLPMethod is the same as the :class:`Spacy` NLPMethod, except it removes all stopwords before doing any
    processing. Stopwords are common words like "the" or "of".
    """
    def match_prob(self, question1, question2):
        return question1.spacy_stop_words.similarity(question2.spacy_stop_words)


class SpacyExactAvg(NLPMethod):
    """
    This NLPMethod averages the results from :class:`Spacy` with the results from :class:`Exact`
    """
    def match_prob(self, question1, question2):
        return (methods['spacy'].match_prob(question1, question2) + methods['exact'].match_prob(question1, question2))/2


class SpacyTimesExact(NLPMethod):
    """
    This NLPMethod multiplies the results from :class:`Spacy` with those from :class:`Exact`
    """
    def match_prob(self, question1, question2):
        return methods['spacy'].match_prob(question1, question2) * methods['exact'].match_prob(question1, question2)


class SpacySynsetAvg(NLPMethod):
    """
    This NLPMethod averages the results from :class:`Spacy` and those from :class:`SynsetMatch`
    """
    def match_prob(self, question1, question2):
        return (methods['spacy'].match_prob(question1, question2) + methods['synset'].match_prob(question1, question2))/2


class ThreeWayAverage(NLPMethod):
    """
    This NLPMethod averages the results from :class:`Spacy`, :class:`MostCommonSynsetPathSimilarity` and those from :class:`SynsetMatch`
    """
    def match_prob(self, question1, question2):
        return (methods['spacy'].match_prob(question1, question2) + methods['synset'].match_prob(question1, question2) + methods['most_common_synset_path_similarity'].match_prob(question1, question2))/3

class Distance(NLPMethod):
    """
    Calculates edit distance between two questions. Edit distance is the amount of changes it takes to get from one
    string to another. This is the Levenhstein edit distance, which deals with single characters at a time. It does
    not seem like it's actually helpful here.

    match_prob returns the inverse of edit distance so it can still be sorted in descending order (high edit distance =
    low match probability)
    """
    def match_prob(self, question1, question2):
        try:
            return 1 / edit_distance(question1, question2, 1, False)
        except ZeroDivisionError:
            return 1


# http://nlpforhackers.io/wordnet-sentence-similarity/
class MostCommonSynsetPathSimilarity(NLPMethod):
    """
    Like :class:`SynsetPathSimilarity`, but only compares the most common Synset for each word instead of checking all possible
    synsets for a word.

    Based off of http://nlpforhackers.io/wordnet-sentence-similarity/
    """
    def match_prob_oneway(self, question1, question2):
        temp = [max([t for t in [s1.path_similarity(s2) for s2 in question2.most_common_synsets] if t] or [0]) for s1 in question1.most_common_synsets]
        return sum(temp)/len(temp) if temp else 0

    def match_prob(self, question1, question2):
        return (self.match_prob_oneway(question1, question2) + self.match_prob_oneway(question2, question1)) / 2


class MostCommonSynsetWuPalmerSimilarity(NLPMethod):
    """
    Like :class:`SynsetWuPalmerSimilarity`, but only compares the most common Synset for each word instead of checking
    all possible synsets for a word.

    Based off of http://nlpforhackers.io/wordnet-sentence-similarity/
    """
    def match_prob_oneway(self, question1, question2):
        temp = [max([t for t in [s1.wup_similarity(s2) for s2 in question2.most_common_synsets] if t] or [0]) for s1 in question1.most_common_synsets]
        return sum(temp)/len(temp) if temp else 0

    def match_prob(self, question1, question2):
        return (self.match_prob_oneway(question1, question2) + self.match_prob_oneway(question2, question1)) / 2


# This technique uses SpaCy to find the set of subjects of both questions.
# Once the sets have been identified, the probability is the number of
# words in common between the two sets divided by the total number of words
# between the two sets.
class SpacySubject(NLPMethod):
    """
    This NLPMethod looks at the subjects of both sentences, as identified by SpaCy, and then returns a score based on
    if there are any subjects in common.

    "John ate a banana" and "John went to the store" would return a probability of 1.0 here because "John" is the
    subject of both. On the other hand, "John ate a banana" and "A banana ate John" would return a probability of 0
    because the subject of the first sentence is "John" while the subject of the second is "banana".
    """
    def match_prob(self, question1, question2):
        
        global stemmer
        sub1 = set([stemmer.stem(stemmer.stem(token.text)) for token in question1.spacy if (token.dep_ == "nsubj" or token.dep_ == "nsubjpass")])
        sub2 = set([stemmer.stem(stemmer.stem(token.text)) for token in question2.spacy if (token.dep_ == "nsubj" or token.dep_ == "nsubjpass")])
       

        if len(sub1 | sub2) == 0:
            return 0

        total_matches = len(sub1 & sub2) / len(sub1 | sub2)
        return total_matches

class SpacyDirectObject(NLPMethod):
    """
    This NLPMethod looks at the subjects of both sentences, as identified by SpaCy, and then returns a score based on
    if there are any subjects in common.

    "John ate a banana" and "John went to the store" would return a probability of 1.0 here because "John" is the
    subject of both. On the other hand, "John ate a banana" and "A banana ate John" would return a probability of 0
    because the subject of the first sentence is "John" while the subject of the second is "banana".
    """
    def match_prob(self, question1, question2):
        global stemmer
        dobj1 = set([stemmer.stem(token.text) for token in question1.spacy if (token.dep_ == "dobj")])
        dobj2 = set([stemmer.stem(token.text) for token in question2.spacy if (token.dep_ == "dobj")])
       

        if len(dobj1 | dobj2) == 0:
            return 0

        total_matches = len(dobj1 & dobj2) / len(dobj1 | dobj2)
        return total_matches

class SpacyIndirectObject(NLPMethod):
    """
    This NLPMethod looks at the subjects of both sentences, as identified by SpaCy, and then returns a score based on
    if there are any subjects in common.

    "John ate a banana" and "John went to the store" would return a probability of 1.0 here because "John" is the
    subject of both. On the other hand, "John ate a banana" and "A banana ate John" would return a probability of 0
    because the subject of the first sentence is "John" while the subject of the second is "banana".
    """
    def match_prob(self, question1, question2):
        global stemmer

        iobj1 = set([stemmer.stem(token.text) for token in question1.spacy if (token.dep_ == "pobj")])
        iobj2 = set([stemmer.stem(token.text) for token in question2.spacy if (token.dep_ == "pobj")])


        if len(iobj1 | iobj2) == 0:
            return 0

        total_matches = len(iobj1 & iobj2) / len(iobj1 | iobj2)
        #print(total_matches)
        return total_matches


class DecisionTree(NLPMethod):
    """
    This NLPMethod uses the decision tree trained in gen_tree to classify all potential matches based on the 
    input queston and questions in the question DB. An issue with this method is that if more than one pair
    are classified as a match (value = 1) then the match which comes first in the sorted order is selected.

    Data is trained in :any:`gen_tree`. The model for this decision tree classifier is :any:`QA.qa.dt`.
    """
    def match_prob(self, question1, question2):
        results = [methods[k[:-11]].match_prob(question1, question2) for k in tree_keys]
        outcome = int(dt.predict([[methods[k[:-11]].match_prob(question1, question2) for k in tree_keys]])[0])
        return outcome
class NB_B(NLPMethod):
    """
    This method uses a Bernoulli Naive Bayes Classifier to predict if the questions are the same or not, based
    on the same training data used for :class:`DecisionTree` in :any:`gen_tree`. The model for this classifier
    is :any:`QA.qa.nb_b`.
    """
    def match_prob(self, question1, question2):
        return float(nb_b.predict([[methods[k[:-11]].match_prob(question1, question2) for k in tree_keys]])[0])
class NB_G(NLPMethod):
    """
    This method uses a Gaussian Naive Bayes Classifier to predict if the questions are the same or not, based
    on the same training data used for :class:`DecisionTree` in :any:`gen_tree`. The model for this classifier
    is :any:`QA.qa.nb_g`.
    """
    def match_prob(self, question1, question2):
        return float(nb_g.predict([[methods[k[:-11]].match_prob(question1, question2) for k in tree_keys]])[0])
#class NB_M(NLPMethod):
#    def match_prob(self, question1, question2):
#        return float(nb_m.predict([[methods[k[:-11]].match_prob(question1, question2) for k in tree_keys]])[0])


# This is a list of all of the matching techniques described above.
methods = {
           "tree": DecisionTree(),
           "nb_g": NB_G(),
           "nb_b": NB_B(),
            #"nb_m": NB_M(),
           "spacy_synset_average": SpacySynsetAvg(),
           "exact": Exact(),
           "synset": SynsetMatch(), 
           "spacy": Spacy(), 
           # "spacy_without_stopwords": SpacyTwo(),
           #"spacy_exact_average": SpacyExactAvg(), "spacy_times_exact": SpacyTimesExact(),
            "most_common_synset_path_similarity": MostCommonSynsetPathSimilarity(),
            "most_common_synset_Wu_Palmer_similarity": MostCommonSynsetWuPalmerSimilarity(),
           #"synset_path_similarity": SynsetPathSimilarity(), "synset_wu_palmer_similarity": SynsetWuPalmerSimilarity(),
           "spacy_subject": SpacySubject(), "spacy_dir_object": SpacyDirectObject(),
           "spacy_ind_object": SpacyIndirectObject()
           # "three_way_average": ThreeWayAverage()
           }
"""
This is a dictionary of all matching techniques that the program can use. Keys are what is used to specify what
    techniques to use, whereas values are instances of the actual technique classes themselves.
"""


def get_response(inp_question, debug, subject, top_n=None, algorithms=None, sorted=True):
    """
    Gets the data for the best possible match given a user question

    Output format:
        {
            'results': {
                <method name>: <output from NLPMethod.run_method>,
                ...
            },
            'timers': {
                'preprocessingTime': <time>,\n
                'processingTime': <time>,\n
                'overallTime': <preprocessingTime + processingTime>
            },
            'inp_question': <user question>
            'debug': <debug>
        }

    Args:
        inp_question (str): the user-inputted question
        debug (bool): whether or not to show debug information
        subject (int): the subject id to compare the question against
        top_n (int, optional): the number of results to show in debug information
        algorithms (list, optional): a list of algorithms to use, as described in the global variable :any:`QA.qa.methods`
            (Defaults to running all methods)

    Returns:
        dict: Lots of data regarding the matches found
    """
    start = time.time()
    result = {'results': {}}
    result['timers'] = {}
    user_question = Question(inp_question)
    result['timers']['preprocessingTime'] = round(time.time() - start,10)
    mid = time.time()
    questions = QuestionSet.deserialize("preprocessed/" + str(subject))
    for a in (algorithms if algorithms else methods.keys()):
        if a not in methods.keys():
            continue
        # result['results'][a] = methods[a].run_method(user_question, db_questions[subject], debug, top_n)
        result['results'][a] = methods[a].run_method(user_question, questions, debug, top_n, cutoffs[a] if a in cutoffs else 0.0, sorted)

    #result['tree_result'] = tree(inp_question, questions, subject)
    #print(result['tree_result'])

    result['timers']['processingTime'] = round(time.time() - mid,10)
    result['timers']['overallTime'] = round(time.time() - start,10)
    result['inp_question'] = inp_question
    result['debug'] = debug
    return result


def main():
    """
    When qa.py is run on its own, the user can enter a question in the console and see the result with debugging.
    """
    debug = len(sys.argv) > 2 or len(sys.argv) == 1
    if len(sys.argv) > 1:
        inp_question = sys.argv[1]
    else:
        inp_question = input("Enter question: ")
    print(json.dumps(get_response(inp_question, debug, 1, 5)))
   

preprocess()

if __name__ == "__main__":
    #import __init__
    #__init__.initialize()
    #__init__.qa.main()
    main()
