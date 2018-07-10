import sys
import time
import json
import os
import numpy as np
from sklearn.tree import DecisionTreeClassifier, export_graphviz
from sklearn.svm import SVC
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import GaussianNB, MultinomialNB, BernoulliNB
import pandas as pd
from config import train_tree_input_file

dt = DecisionTreeClassifier(min_samples_split=40, max_depth=4, random_state=52)
"""Decision tree classifier model"""

sv = SVC(kernel='sigmoid', shrinking=True)
"""Support vector classification model"""


def gen_tree(fileName):
	"""
	Generates data for decision tree :any:`QA.TreeUtility.dt`

	Args:
		fileName (str): file name to use to generate tree (not path)
	"""
	global dt
	file = './excel/' + fileName
	print(file)
	df = pd.read_csv(file)
	y = df['correct']
	tree_keys = [key for key in df.keys() if key not in ['correct', 'tree_confidence']]
	x = df[tree_keys]

	dt.fit(x, y)

def score_tree(fileName):
	"""
	Scores :any:`QA.TreeUtility.dt` based on another set of data

	Args:
		fileName (str): file to use to test tree

	Returns:
		float: score for tree
	"""
	global dt
	file = './excel/' + fileName
	print(file)
	df2 = pd.read_csv(file)
	y = df2['correct']
	tree_keys = [key for key in df2.keys() if key not in ['correct', 'tree_confidence']]
	x = df2[tree_keys]
	return dt.score(x, y)

def main():
	"""Main method"""
	file = train_tree_input_file
	df = pd.read_csv(file)

	X_train, X_test, Y_train, Y_test = train_test_split(df[[key for key in df.keys() if key not in ['correct']]], df['correct'], test_size = 0.3, random_state=52)

	dt.fit(X_train, Y_train)
	sv.fit(X_train, Y_train)

	print('Tree	Accuracy: ', dt.score(X_test, Y_test))
	print('SVC	Accuracy: ', sv.score(X_test, Y_test))


   



if __name__ == "__main__":
	#import __init__
	#__init__.initialize()
	#__init__.qa.main()
	main()