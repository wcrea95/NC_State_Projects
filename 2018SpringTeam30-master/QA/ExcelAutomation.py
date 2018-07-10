#import pandas
import sys
import pandas as pd
import time as timer
import datetime
import random as rand
import qa as answerer
import numpy as np
import math
import scipy
from question import QuestionSet, Question
from config import test_questions_input, test_output, test_output_accuracy, test_output_stats


input_file = test_questions_input
output_file = test_output
accuracy_output_file = test_output_accuracy
stats_output_file = test_output_stats
NUMBER_COLS = 7


def get_accuracies(cutOff, correctConf, incorrectConf, nonExistantConf):
    """
    generates the potential accuracy for a set of responses based on a confidence cutoff

    Args:
        cutOff (float): confidence cutoff to check
        correctConf (list): list of confidence values for correct answers as floats
        incorrectConf (list): list of confidence values for incorrect answers as floats
        nonExistantConf (list): list of confidence values for nonexistance answers as floats

    Returns:
        dict: dictionary with keys "Existing Accuracy" and "Non Existant Accuracy"
    """
    results = {}
    results['Existing Accuracy'] = len([entry for entry in correctConf if entry >= cutOff]) / (len(correctConf) + len(incorrectConf))
    results['Non Existant Accuracy'] = len([entry for entry in nonExistantConf if entry < cutOff]) / len(nonExistantConf)

    return results



def confidence_analysis(cutOff, correctConf, incorrectConf, nonExistantConf, sign=1):
    """
    used to help determine the ideal confidence based on a set of responses

    Args:
        cutOff (float): confidence cutoff
        correctConf (list): list of confidence values for correct answers as floats
        incorrectConf (list): list of confidence values for incorrect answers as floats
        nonExistantConf (list): list of confidence values for nonexistance answers as floats
        sign (int): 1 or -1 (-1 is an option because scipy has minimize but not maximize)

    Returns:
        float: accuracy of confidences
    """

    num_correct = 0
    num_correct += len([entry for entry in correctConf if entry >= cutOff])
    num_correct += len([entry for entry in nonExistantConf if entry < cutOff])

    return sign*round(num_correct / (len(correctConf) + len(incorrectConf) + len(nonExistantConf)), 3)


def get_answer(userQuestion, method, category):
    """
    Gets a matching method's answer to a particular question

    Args:
        userQuestion (str): question to match
        method (QA.qa.NLPMethod): matching method to use
        category (str): "frog" or "smv"

    Returns:
        tuple: matched question, matched answer
    """
    
    result = answerer.get_response(userQuestion, True, 2 if category == "frog" else  1, 2, [method])

    return str(result['results'][method]['matches'][0]['question']),str(result['results'][method]['matches'][0]['match'])



def main():
    """
    Run automated tests
    """
    global input_file, output_file


    #load spreadsheet
    df = pd.read_csv(input_file)
 
    newCols = {}
    
    stats = {'Method': [], 'Best Confidence Cutoff': [], 'Best Accuracy': [], 'Correct Confidence Average': [],
            'Incorrect Confidence Average': [], 'Non-Existant Confidence Average': [], 'Existing Accuracy': [],
            'Non Existant Accuracy': []}

    accuracies = {'Confidence': np.arange(0.0, 1.0, .005)}

    #obtains the sets of responses for each method to test
    for methodName in answerer.methods.keys(): 
        newCols[methodName + "_ans"] = []
        newCols[methodName + "_confidence"] = []
        newCols[methodName + "_time"] = []
        total = 0

        correct_results = []
        incorrect_results = []
        non_existant_results = []
        
        # generates statistics and stores the responess in an array based on if they are correct or not
        for ans in df['Test Question']:
            now = timer.clock()
            category = 'smv' if 'SMV' in df['Test ID'][total] else 'frog'
            ans,conf = get_answer(ans, methodName, category)
            conf_value = float(conf)
        
            if df['Expected Answer'][total] == ans:
                correct_results.append(float(conf))
            else:
                if df['Expected Answer'][total] == 'No answer matched.':
                    non_existant_results.append(float(conf))
                else:
                    incorrect_results.append(float(conf))
            total += 1 
            newCols[methodName + "_ans"].append(ans)
            newCols[methodName + "_time"].append( timer.clock() - now)
            newCols[methodName + "_confidence"].append(conf)


       # prints and saves the statistics for average confidences
        print()
        print('For ', methodName)
        print('  Correct Confidence Average: ', np.mean(correct_results))
        stats['Correct Confidence Average'].append(np.mean(correct_results))
        if incorrect_results:
            print('  Incorrect Confidence Average: ', np.mean(incorrect_results))
            stats['Incorrect Confidence Average'].append(np.mean(incorrect_results))
        else:
            stats['Incorrect Confidence Average'].append("No incorrect results")
        if non_existant_results:
            print('  No Answer Confidence Average: ', np.mean(non_existant_results))
            stats['Non-Existant Confidence Average'].append(np.mean(non_existant_results))
        else:
             stats['Non-Existant Confidence Average'].append("No non-existant results")

        sys.stdout.flush()
        print('Best accuracy:')

        best_acc, next_acc = 0, 0
        middle_conf = 0.5


        max_conf = 1.0
        min_conf = 0.0

        x0 =(.5,)

        # calcaultes ideal confidence using sciPiy optimize
        arg_list = (correct_results, incorrect_results, non_existant_results, -1)
        res = scipy.optimize.minimize(confidence_analysis, x0 , method='Nelder-Mead', args=arg_list, tol = 0.0001)
        print('SciPy Minimize - Confidence Cut-off: ', res.x[0], ' Accuracy: ', -1*res.fun)
        sys.stdout.flush()

        if -1*res.fun > best_acc:
            best_acc = -1*res.fun
            middle_conf = res.x[0]

        max_acc = 0.0
        max_conf = 0.0
        accuracies[methodName] = []
       # calculates ideal confidence using brute force 
        for entry in np.arange(0.0, 1.0, .005):
            acc = confidence_analysis(entry, correct_results, incorrect_results, non_existant_results)
            accuracies[methodName].append(acc)
            if acc > max_acc:
                max_acc = acc
                max_conf = entry

        print('Brute Force   -  Confidence Cut-off:', max_conf, ' Accuracy: ', max_acc)
        sys.stdout.flush()

        if max_acc > best_acc:
            best_acc = max_acc
            middle_conf = max_conf


        # appends the relevant statistics 
        df[methodName + "_ans"] = newCols[methodName + "_ans"]
        df[methodName + "_time"] = newCols[methodName + "_time"]
        df[methodName + "_confidence"] = newCols[methodName + "_confidence"]

        stats['Method'].append(methodName)
        stats['Best Confidence Cutoff'].append(middle_conf)
        stats['Best Accuracy'].append(best_acc)

        results = get_accuracies(middle_conf, correct_results, incorrect_results, non_existant_results)

        for entry in results.keys():
            stats[entry].append(results[entry])

    #df2 = pd.DataFrame(data = stats)
    
    #df2 = df2[['Method', 'Best Accuracy', 'Best Confidence Cutoff', 'Correct Confidence Average', 
              #  'Incorrect Confidence Average', 'Non-Existant Confidence Average', 'Existing Accuracy',
              #  'Non Existant Accuracy']]
    
   # populates and saves the relevant statistics 
    df3 = pd.DataFrame(data = accuracies)
    df.to_csv(output_file)
    #df2.to_csv(stats_output_file, index = False)
    df3.to_csv(accuracy_output_file, index = False)

if __name__ == "__main__":
    main()

