#import pandas
import pandas as pd
import time as timer
import datetime
import random as rand
import qa as answerer
import numpy as np
import math
import scipy
from question import QuestionSet, Question
from config import data_generator_types, data_generator_input_file, data_generator_output_file



NUMBER_COLS = 7

def get_answer(userQuestion, method, category):
    """
    Gets a matching method's answer to a particular question

    Args:
        userQuestion (str): question to match
        method (QA.qa.NLPMethod): matching method to use
        category (str): "frog" or "smv"

    Returns:
        list of all matches (see :any:`QA.qa.NLPMethod.gen_results` for format of object)
    """
    
    result = answerer.get_response(userQuestion, True, 2 if category == "frog" else 1, 59 if category =="frog" else 23, [method], False)
    return result['results'][method]['matches']

def main():
    """
    Main method
    """
    types = data_generator_types
  
    #store file name of spreadsheet
    file = data_generator_input_file
    #load spreadsheet
    df = pd.read_csv(file)
 
    newCols = {}
    newCols['correct'] = []

    for methodName in types:
        newCols[methodName + "_confidence"] = []

    for methodName in types:

        total = 0

        for ans in df['Test Question']:
            category = 'smv' if 'SMV' in df['Test ID'][total] else 'frog'
            results = get_answer(ans, methodName, category)
            for result in results:     
                if methodName == "spacy_subject":
                    if df['Expected Answer'][total] == result['question']:
                        newCols['correct'].append(1)
                    else:
                        newCols['correct'].append(-1)
                newCols[methodName + "_confidence"].append(result['match'])
            total += 1 

    for key in newCols.keys():
        print(key)
        
    out_file = data_generator_output_file

    df2 = pd.DataFrame(data = newCols)
    df2.to_csv(data_generator_output_file, index = False)

if __name__ == "__main__":
    main()

