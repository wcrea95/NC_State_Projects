import os
this_directory = os.path.dirname(__file__)

production_database = 'mysql://root:smv@localhost:3307/smvsdc'
"""
Link to production database
"""

test_database = 'mysql://root:smv@localhost:3306/smvsdc'
"""
Link to test database
"""

connection_type = "PROD_FALLBACK_TEST"
"""
Which DB to connect to

Possible values:
    * PRODUCTION
    * TEST
    * PROD_FALLBACK_TEST - try production, fallback to test if not available
"""

smv_cutoffs = {"exact": 0.29,
           "synset": 0.40625,
           "spacy": 0.778125,
           "spacy_without_stopwords": 0.85,
           "spacy_exact_average": 0.49, 
           "spacy_times_exact": 0.215625,
           "most_common_synset_path_similarity": 0.605,
           "most_common_synset_Wu_Palmer_similarity": 0.735,
           "synset_path_similarity": 0.56, 
           "synset_wu_palmer_similarity": 0.73,
           "spacy_synset_average": 0.51875
            }
""" these are the ideal confidence cutoffs when using only the SMV question set"""

frog_cutoffs = {"exact": 0.335,
           "synset": 0.56,
           "spacy": 0.815,
           "spacy_without_stopwords": 0.88,
           "spacy_exact_average": 0.61, 
           "spacy_times_exact": 0.32,
           "most_common_synset_path_similarity": 0.6875,
           "most_common_synset_Wu_Palmer_similarity": 0.73125,
           "synset_path_similarity": 0.56, 
           "synset_wu_palmer_similarity": 0.73,
           "spacy_synset_average": 0.645,
           "tree": 0.5,
           "nb_g": 0.5,
           "nb_b": 0.5,
           "nb_m": 0.5
           }
""" these are the ideal confidence cutoffs when using only the frog question set"""

combined_cutoffs = {"exact": 0.29,
           "synset": 0.41,
           "spacy": 0.818,
           "spacy_without_stopwords": 0.88,
           "spacy_exact_average": 0.61, 
           "spacy_times_exact": 0.32,
           "most_common_synset_path_similarity": 0.62,
           "most_common_synset_Wu_Palmer_similarity": 0.734,
           "synset_path_similarity": 0.56, 
           "synset_wu_palmer_similarity": 0.73,
           "spacy_synset_average": 0.5859,
           "tree": 0.5,
           "nb_g": 0.5,
           "nb_b": 0.5,
           "nb_m": 0.5
           }

""" these are the ideal confidence cutoffs when using both frog and SMV questions"""


data_generator_types = [   
           "spacy_synset_average",
           "exact",
           "synset", 
           "spacy", 
           "most_common_synset_path_similarity",
           "most_common_synset_Wu_Palmer_similarity",
           "spacy_subject", 
           "spacy_ind_object",
           "spacy_dir_object"
           ]
""" the set of algorithms to use for  DataGenerator.py, which creates training data for the decision tree 
using DataGenerator.py 
"""

data_generator_input_file = os.path.join(this_directory, 'data/test_questions/test_questions_complete.csv')
""" the file containing the est of test questions to be used for generating the training data  
using DataGenerator.py.
 
If viewing this on the web API documentation, the start of this variable is the absolute path to the
file on the computer that generated the documentation. This first half is automatically generated
and will provide a different path on most computers, but the second half is what is actually manually
set."""

data_generator_output_file = os.path.join(this_directory, 'data/data_generator/data_complete.csv')
""" the file name in which to store output of DataGenerator.py.
 
If viewing this on the web API documentation, the start of this variable is the absolute path to the
file on the computer that generated the documentation. This first half is automatically generated
and will provide a different path on most computers, but the second half is what is actually manually
set."""

train_tree_input_file = os.path.join(this_directory, 'data/data_generator/data_complete.csv')
""" the input file for the TrainTree.py utility.
 
If viewing this on the web API documentation, the start of this variable is the absolute path to the
file on the computer that generated the documentation. This first half is automatically generated
and will provide a different path on most computers, but the second half is what is actually manually
set."""

test_questions_input = os.path.join(this_directory, 'data/test_questions/test_questions_complete.csv')
""" input file for ExcelAutomation.py.
 
If viewing this on the web API documentation, the start of this variable is the absolute path to the
file on the computer that generated the documentation. This first half is automatically generated
and will provide a different path on most computers, but the second half is what is actually manually
set."""

test_output = os.path.join(this_directory, 'data/test_output/results.csv')
""" output file for ExcelAutomation.py.
 
If viewing this on the web API documentation, the start of this variable is the absolute path to the
file on the computer that generated the documentation. This first half is automatically generated
and will provide a different path on most computers, but the second half is what is actually manually
set."""

test_output_accuracy = os.path.join(this_directory, 'data/test_output/accuracies.csv')
""" output for test accuracies from ExcelAutomation.py.
 
If viewing this on the web API documentation, the start of this variable is the absolute path to the
file on the computer that generated the documentation. This first half is automatically generated
and will provide a different path on most computers, but the second half is what is actually manually
set."""

test_output_stats = os.path.join(this_directory, 'data/test_output/stats.csv')
""" output for test stats from ExcelAutomation.py.
 
If viewing this on the web API documentation, the start of this variable is the absolute path to the
file on the computer that generated the documentation. This first half is automatically generated
and will provide a different path on most computers, but the second half is what is actually manually
set."""

tree_model_data = os.path.join(this_directory, 'data/data_generator/data_complete.csv')
""" the data to use for training the tree used in qa.py.
 
If viewing this on the web API documentation, the start of this variable is the absolute path to the
file on the computer that generated the documentation. This first half is automatically generated
and will provide a different path on most computers, but the second half is what is actually manually
set."""

