import nltk
import string
import sql
from nltk.tokenize import word_tokenize
from nltk.corpus import wordnet as wn
import spacy
import sys, os
from spacy.tokens import Doc
from spacy.vocab import Vocab
import pickle
from sqlalchemy.exc import OperationalError


# Update this variable whenever you add something to the Question class/remove something from it
version = 1.1


def initialize():
    """
    Initializes SpaCy
    """
    global sNLP
    print("spaCy loading...", file=sys.stderr)
    try:
        sNLP = spacy.load("en")
    except IOError:
        try:
            sNLP = spacy.load('en_core_web_sm')
        except IOError:
            print("SpaCy could not load 'en'")
            print("Please ensure that en is downloaded run command:  python -m spacy download en")
    print("spaCy loaded", file=sys.stderr)


"""
Dictionary to convert part-of-speech tags to wordnet parts of speech
"""
tag_to_wn = {"N": 'n', "V": 'v', "J": 'a', "R": 'r'}


class Question(object):
    """
    A Question object containing information related to an entry in the QA database.

    Args:
        question_string: the question itself
        answer_string (str, optional): the answer to the question

    Attributes:
        question (str): The complete question.
        answer (str): The complete answer to the question.
        spacy (spacy.tokens.doc.Doc): SpaCy's internal representation of the question
        spacy_stop_words (spacy.tokens.doc.Doc): SpaCy's internal representation of the question with stopwords removed
        sig_word_set (set): set of all significant words in the question
        sig_words (list): list of all significant words in their synset in the format
            ``[[word, set(synset, synset, ...)], ...]``
        pos (list): parts of speech associated with each word in the question
        most_common_synsets (list): list containing the most common synset of the proper part of speech for each word of the question
    """

    @staticmethod
    def process_text(text):
        """
        helper function to tokenize and lowercase an input string

        Args:
            text (str): input string

        Returns:
            set: Set of all words in string, converted to lowercase and with punctuation removed
        """
        words = word_tokenize(text)
        return [word.lower() for word in words if word not in string.punctuation]

    @staticmethod
    def remove_stopwords(words):
        """
        helper function to remove stopwords (common words like "the" or "of") from a set of tokens

        Args:
            words (iter): (set/list/anything with an iterator) of words

        Returns:
            list: the input words with stopwords removed

        """
        stopwords = nltk.corpus.stopwords.words('english')
        return [w for w in words if w not in stopwords]

    def __init__(self, question_string, answer_string=""):
        # the question nstring, stripped of extra space.
        self.question = question_string.strip()
        # the answer to the question
        self.answer = answer_string.strip()
        # the spacy representation of the question
        self.spacy = sNLP(question_string)
        # a tokenized version of the question, meaning it is broken into a list of words.
        self.q_tokens = Question.process_text(question_string)
        # a set version of the list of word tokens
        self.q_token_set = set(Question.process_text(question_string))
        # the list of word tokens with stop words removed, these are words with little lexical significance
        self.spacy_stop_words = sNLP(' '.join(Question.remove_stopwords(self.q_tokens)))

        # self.q_words = q_token_set & {'who', 'what', 'when', 'where', 'why', 'how', 'whose', 'whom',
        #          'which', 'can', 'whence', 'whether', 'do', 'have', 'did'}

        #a set version of the list of non stop words.
        self.sig_word_set = set(Question.remove_stopwords(self.q_token_set))
        # a list of tuples as (word, {set of synsets}) for each significant word.
        self.sig_words = [[word, set([s for s in wn.synsets(word)])] for word in self.sig_word_set]
        # a list of words with part of speech tags.
        self.pos = nltk.pos_tag(self.q_tokens)
        # the most common synset for each word in the set
        self.most_common_synsets = [s[0] for s in [wn.synsets(w[0], tag_to_wn[w[1][0]]) for w in self.pos if
                                                   w[1][0] in tag_to_wn.keys()] if s]
        

    def on_deserialize(self):
        """
        Method called on deserializing. Converts synsets from plaintext to actual synset objects
        """
        for sw in self.sig_words:
            sw[1] = set(map(lambda s: wn.synset(s), sw[1]))
        self.most_common_synsets = list(map(lambda s: wn.synset(s), self.most_common_synsets))

    def on_serialize(self):
        """
        Method called on serializing. Converts non-serializable synsets into serializable plaintext
        """
        for sw in self.sig_words:
            sw[1] = set(map(lambda s: s.name(), sw[1]))
        self.most_common_synsets = list(map(lambda s: s.name(), self.most_common_synsets))

    def restore_after_serialize(self):
        """
        Method called after serialization is done, to get the Question back into a usable state
        """
        self.on_deserialize()
 

class QuestionSet:
    """
    A container for holding :class:`Question` objects

    Args:
        question_set (list): list of questions
        sub_id (int): subject id

    Attributes:
        questions (list): List of all questions in the QuestionSet
        sub_id (int): The subject id that the question set corresponds to
    """

    def __init__(self, question_set, sub_id=None):
        self.questions = question_set
        self.sub_id = sub_id

    @staticmethod
    def from_db(sub_id):
        """
        Generates a QuestionSet using the database

        Args:
            sub_id (int): the subject ID to generate a QuestionSet for

        Returns:
            QuestionSet: The generated QuestionSet
        """
        return QuestionSet([Question(question, answer) for question, answer in sql.get_questions(sub_id)], sub_id)

    @staticmethod
    def from_text(question_file, answer_file):
        """
        Generates a QuestionSet from a text file by matching up a question file and an answer file line-by-line

        Args:
            question_file (str): the path of the file to use for questions
            answer_file (str): the path of the file to use for answers

        Returns:
            QuestionSet: the generated QuestionSet
        """
        with open(question_file, 'r', encoding='UTF8', errors='replace') as f:
            questions = f.readlines()

        with open(answer_file, 'r', encoding='UTF8', errors='replace') as f:
            answers = f.readlines()

        return QuestionSet([Question(question, answer) for question, answer in zip(questions, answers)])

    @staticmethod
    def deserialize(path):
        """
        Deserializes a QuestionSet from a serialized file

        Args:
            path (str): the path of the serialized file

        Returns:
            QuestionSet: deserialized QuestionSet
        """
        with open(path, 'rb') as f:
            temp = pickle.load(f)
            for q in temp.questions:
                q.on_deserialize()
            return temp

    def __iter__(self):
        """
        Generates an iterator for the QuestionSet

        Returns:

        """
        return self.questions.__iter__()

    def serialize(self, path):
        """
        Serializes a QuestionSet to a file

        Args:
            path: path for where to serialize QuestionSet
        """
        for q in self.questions:
            q.on_serialize()
        with open(path, 'wb') as f:
            pickle.dump(self, f)
        for q in self.questions:
            q.restore_after_serialize()


def preprocess_db(new_subjects_only=False, preprocess_everything=False, sub_id=None):
    """
    Preprocesses new categories and new/deleted/modified entries from the database

    Args:
        new_subjects_only (bool, optional): True to only preprocess new subjects, False to also look for changes in existing subjects. Defaults to False
        preprocess_everything (bool, optional): True to preprocess everything, regardless of if it is new information or not. Defaults to False
        sub_id (int, optional): If provided, will update only a specific subject

    Raises:
        SQLError: If connecting to the database fails, database was never initialized, or sub_id is invalid. Check error message for more details.
    """
    try:
        if sub_id is None:
            subjects_db = sql.get_subjects().fetchall()
        else:
            subjects_db = sql.get_subjects(sub_id).fetchall()
            if len(subjects_db) == 0:
                raise SQLError("No subject with sub_id " + str(sub_id))
        subjects_preprocessed = []

        try:
            with open('version', 'r') as f:
                if f.readline() != str(version):  # outdated version
                    print("Serialization version has changed to " + str(version) + ", preprocessing everything",
                          file=sys.stderr)
                    preprocess_everything = True
        except FileNotFoundError:
            print("No existing version file found, preprocessing everything", file=sys.stderr)
            preprocess_everything = True

        if not preprocess_everything:
            for root, dirs, files in os.walk('./preprocessed'):
                for file_name in files:
                    subjects_preprocessed.append(file_name)

        for sub_id, sub_name in subjects_db:
            path = "preprocessed/" + str(sub_id)
            if preprocess_everything or str(sub_id) not in subjects_preprocessed:  # if new subject not yet preprocessed
                QuestionSet.from_db(sub_id).serialize(path)
                print("New subject found with id " + str(sub_id) + ", preprocessing subject", file=sys.stderr)
            elif not new_subjects_only:  # check for modified/new/deleted entries in db
                preprocessed = QuestionSet.deserialize(path)
                changes_made = False
                qs = set(preprocessed.questions)
                for question, answer in sql.get_questions(sub_id):
                    for matched in qs:
                        if matched.question == question.strip():
                            if matched.answer != answer.strip():
                                matched.answer = answer.strip()
                                changes_made = True
                            qs.remove(matched)
                            break
                    else:  # no match, new question
                        preprocessed.questions.append(Question(question, answer))
                        changes_made = True
                for stored in qs:  # any questions left are ones that have been removed from the database
                    preprocessed.questions.remove(stored)
                    changes_made = True
                if changes_made:
                    preprocessed.serialize(path)
                    print("Changes made to subject " + str(sub_id) + " (" + sub_name + "), reserializing",
                          file=sys.stderr)
        if preprocess_everything:
            with open('version', 'w') as f:
                f.write(str(version))
    except NameError:
        print("Database was never started successfully; cannot preprocess questions", file=sys.stderr)
        raise SQLError("Database was never started successfully; cannot preprocess questions")
    except OperationalError:
        print("Couldn't connect to database; cannot preprocess questions", file=sys.stderr)
        raise SQLError("Couldn't connect to database; cannot preprocess questions")


class SQLError(Exception):
    """
    Error with connecting to SQL database
    """
    pass


#if __name__ == "__main__":
    #sql.initialize()
initialize()
