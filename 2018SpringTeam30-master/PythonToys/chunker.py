import sys
import nltk, re, pprint
import timeit

from nltk.corpus import stopwords
from nltk.corpus import wordnet as wn

from nltk.tokenize import word_tokenize
from nltk.tokenize import sent_tokenize


# tokenizes an input string and converts all words to lowercase
# returns list of tokens
def process_text(text):
    words = word_tokenize(text)
    return [word.lower() for word in words]


# remove stopwords from provided word list
# stop words are frequently occuring words of low lexical content
# note that the predefined list of stopwords contains all the question words
# this will need to be adjusted if this is ever of any use
def remove_stopwords(words):
    stopwords = nltk.corpus.stopwords.words('english')
    return [w for w in words if w not in stopwords]


# Preprocesses the given document by tokenizing it
# and splitting it up in to sentences
def preprocess(text):
    sentences = nltk.sent_tokenize(text)
    sentences = [nltk.word_tokenize(sent) for sent in sentences]
    sentences = [nltk.pos_tag(sent) for sent in sentences]
    return sentences


def main():
    with open('answers.txt', encoding='utf8') as fa:
        answers = [preprocess(line) for line in fa.readlines()]
    with open('questions.txt', encoding='utf8') as fq:
        questions = [line for line in fq.readlines()]

    grammar = "NP: {<DT>?<JJ>*<NN>}"
    cp = nltk.RegexpParser(grammar)

    sentence = [("the", "DT"), ("little", "JJ"), ("yellow", "JJ"), ("dog", "NN"), ("barked", "VBD"), ("at", "IN"),  ("the", "DT"), ("cat", "NN")]

    print(sentence)
    print(answers[0])
    result = cp.parse(sentence)
    print(result)

    results = []

    for line in answers:
        for sent in line:
            results.append(cp.parse(sent))

    print(results[0])


if __name__ == "__main__":
    main()
