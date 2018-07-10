import sys
import timeit
import nltk

from nltk.corpus import stopwords
from nltk.corpus import wordnet as wn

from nltk.tokenize import word_tokenize
from nltk.tokenize import sent_tokenize


# tokenizes an input string and converts all words to lowercase
# returns list of tokens
def process_text(text):
    words = word_tokenize(text)
    return [word.lower() for word in words]
    
# returns list of stemmed tokens using provided stemmer
def stem(tokens, stemmer):
    return [stemmer.stem(token) for token in tokens]

# uses the stem function with a variety of stemmers for results comparison   
def compare_stemmers(tokens):
    snow_stemmer = nltk.stem.SnowballStemmer('english')
    lanc_stemmer = nltk.stem.LancasterStemmer()
    port_stemmer = nltk.stem.PorterStemmer()

    print('Porter Stemmer:', stem(tokens, port_stemmer))
    print()
    print('Snowball Stemmer:', stem(tokens, snow_stemmer))
    print()
    print('Lancaster Stemmer:', stem(tokens, lanc_stemmer))

# lemmatizes the provided tokens
# lemmatizing reduces the tokens to their stem if and only if that stem
# appears in the WordNet dictionary
def lemmatize(tokens):
    lemmatizer = nltk.WordNetLemmatizer()
    return [lemmatizer.lemmatize(token) for token in tokens]

# remove stopwords from provided word list
# stop words are frequently occuring words of low lexical content
# note that the predefined list of stopwords contains all the question words
# this will need to be adjusted if this is ever of any use
def remove_stopwords(words):
    stopwords = nltk.corpus.stopwords.words('english')
    return [w for w in words if w not in stopwords]

# returns a list of question words found in a given sentence
def extract_question_words(words):
    question_words = ['which', 'how', 'who', 'why', 'when', 'where', 'what']
    return[w for w in words if w in question_words]

# tags parts of speech
# see 
def tag_pos(words):
    return nltk.pos_tag(words)

# prints synonyms of words (using most common usage for now)
def list_synonyms(word):
    if len(wn.synsets(word)) > 0:
        synset = wn.synsets(word)[0]
        print(synset.name(), ' ', synset.definition())
        print(synset.lemma_names())
        print()
    

def main():
    text = input('Input a sentence:')
    print('Original Sentence:', text)
    print()
    tokens = process_text(text)
    print('Tokenized Sentence:', tokens)
    compare_stemmers(tokens)
    print()
    print('Lemmatized Sentence:', lemmatize(tokens))
    print()
    print('Contains Question Words:', extract_question_words(tokens))
    print()
    sig_words = remove_stopwords(tokens)
    print('Stopwards Removed:', sig_words)
    print()
    print('Synonyms of Significant Words:')
    for word in sig_words:
        list_synonyms(word)
    print()
    print('Tagged Parts of Speech', tag_pos(tokens))
    
    


if __name__ == "__main__":
  main()
