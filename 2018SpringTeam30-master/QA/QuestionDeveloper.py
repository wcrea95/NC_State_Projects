from nltk.tag import StanfordNERTagger
from nltk.tokenize import word_tokenize
from nltk.parse.stanford import StanfordDependencyParser
from nltk.tag.stanford import StanfordPOSTagger
import os

# Change the path according to your system
stanford_classifier = 'stanford-ner-2018-02-27\\stanford-ner-2018-02-27\\classifiers\\english.all.3class.distsim.crf.ser.gz'
stanford_ner_path = 'stanford-ner-2018-02-27\\stanford-ner-2018-02-27\\stanford-ner.jar'
java_path = "C:\\Program Files\\Java\\jre1.8.0_171\\bin\\java.exe"
os.environ['JAVAHOME'] = java_path

 # These paths also need to be changed per system.
path_to_jar = 'stanford-parser-full-2018-02-27\\stanford-parser-full-2018-02-27\\stanford-parser.jar'
path_to_models_jar = 'stanford-parser-full-2018-02-27\\stanford-parser-full-2018-02-27\\stanford-parser-3.9.1-models.jar'
dependency_parser = StanfordDependencyParser(path_to_jar, path_to_models_jar)

# POS tagger
# These paths also need to be changed per system
pos_path = 'stanford-postagger-full-2018-02-27\\stanford-postagger-full-2018-02-27\\models\\english-bidirectional-distsim.tagger'
pos_jar = 'stanford-postagger-full-2018-02-27\\stanford-postagger-full-2018-02-27\\stanford-postagger.jar'
pos_tagger = StanfordPOSTagger(pos_path, pos_jar)

# Creating Tagger Object
st = StanfordNERTagger(stanford_classifier, stanford_ner_path, encoding='utf-8')

answer_file = "question_sets\\answers.txt"
with open(answer_file, 'r', encoding='UTF8', errors='replace') as f:
    answers = f.readlines()


answer_index = 1;
for answer in answers:
    result, = dependency_parser.raw_parse(answer)
    print(str(answer_index) + ". " + answer)
    tagged_result = pos_tagger.tag((answer.split()))
    print(tagged_result)
    for index, pair in enumerate(tagged_result):


        if pair[1] == 'MD':
            if tagged_result[index - 1][1] == 'NN':
                noun_pair = tagged_result[index - 1]
            for i, verb_pair in enumerate(tagged_result):
                if verb_pair[1] == 'VB':
                    print("What", pair[0], noun_pair[0], verb_pair[0] + "?")

    print(result.to_conll(4))
    print(result.tree().pretty_print())

    print()
    print()
    print()
    answer_index += 1