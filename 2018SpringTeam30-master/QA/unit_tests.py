import unittest

#sql.py

import sql
from question import Question

class ConnectTest(unittest.TestCase):
    """Tests connection to database in :any:`QA.sql`"""
    def testFail(self):
        """Tests invalid connection in :any:`QA.sql.connect_to_db`"""
        assert not sql.connect_to_db("mysql://invalid:invalid@localhost:1234/invaliddatabasename"), "connect_to_db should return False when invalid connection"
        assert not sql.connected, "global var connected should be False when connection is invalid"
# TODO Rest is integration testing, not unit testing. Worry about this later

#question.py

import question
class StaticTest(unittest.TestCase):
    """Tests several static parts of :any:`QA.question`"""
    def testSpacy(self):
        """Tests spaCy is properly loaded"""
        assert question.sNLP is not None, "sNLP variable is still null. Make sure SpaCy is properly configured"

    def testProcessText(self):
        """Tests :any:`QA.question.Question.process_text`"""
        assert question.Question.process_text("Hello world!") == ["hello", "world"]

    def testRemoveStopwords(self):
        """Tests :any:`QA.question.Question.remove_stopwords`"""
        assert question.Question.remove_stopwords(["the", "elephant"]) == ["elephant"]


class QuestionSetTest(unittest.TestCase):
    """Tests :class:`QA.question.QuestionSet`"""
    def setUp(self):
        """Sets up tests with test_files/questions.txt and test_files/answers.txt"""
        self.temp = question.QuestionSet.from_text('test_files/questions.txt', 'test_files/answers.txt')

    def testFromFile(self):
        """Tests :any:`QA.question.QuestionSet.from_text`"""
        assert len(self.temp.questions) == 2
        assert self.temp.questions[0].question == "What is your favorite color?"
        assert self.temp.questions[0].answer == "Green"
        assert self.temp.questions[1].question == "But why frogs?"
        assert self.temp.questions[1].answer == "Why not?"

    def testDeserialize(self):
        """tests :any:`QA.question.QuestionSet.deserialize` and :any:`QA.question.QuestionSet.serialize`"""
        self.temp.serialize('test_files/serialized')
        temp2 = question.QuestionSet.deserialize('test_files/serialized')
        assert len(self.temp.questions) == len(temp2.questions)
        # the following complicated-looking loop just tests that every single field has the same value, when the value is represented as a string
        for i in range(len(self.temp.questions)):            
            for k in vars(self.temp.questions[i]):
                try:
                    assert vars(self.temp.questions[i])[k] == vars(temp2.questions[i])[k], \
                        k + " is not the same (expected: " + str(vars(self.temp.questions[i])[k]) + \
                        ", actual: " + str(vars(temp2.questions[i])[k]) + ")"
                except:
                    assert str(vars(self.temp.questions[i])[k]) == str(vars(temp2.questions[i])[k]), \
                        k + " is not the same (expected: " + str(vars(self.temp.questions[i])[k]) + \
                        ", actual: " + str(vars(temp2.questions[i])[k]) + ")"

    def testPreprocessNotConnected(self):
        """Tests :any:`QA.question.preprocess_db` when database is not connected"""
        if not sql.connected:
            try:
                question.preprocess_db()
                assert False, "preprocess should have thrown an error"
            except question.SQLError:
                pass
            except:
                assert False, "preprocess threw an error that was not an SQLError"
        else:
            pass  # TODO Probably log something


class QuestionTest(unittest.TestCase):
    """Tests :class:`QA.question.Question`"""
    def setUp(self):
        """Sets up tests"""
        self.question = question.Question("TestQuestion", "TestAnswer")

    def testQuestionInit(self):
        """Tests initialization"""
        assert self.question.question == "TestQuestion"
        assert self.question.answer == "TestAnswer"
        assert self.question.sig_word_set == set(["testquestion"])
        assert self.question.sig_words == [["testquestion", set()]]


# TODO from_db and preprocess need integration tests, worry about that later

#qa.py
import qa

class QATest(unittest.TestCase):
    def testGetQuestionSets(self):
        """Tests :any:`QA.qa.get_question_sets`"""
        # TODO refactor into an integration test if we end up separating those
        assert '1' in qa.get_question_sets()


class MockQuestion:
    """Mock :class:`QA.question.Question` for :class:`QA.unit_tests.NLPMethodTest` with just question and answer fields"""
    def __init__(self, q, a):
        self.question = q
        self.answer = a


class MockSigWordSet:
    """Mock :class:`QA.question.Question` with sig_word_set for :class:`QA.unit_tests.NLPMethodTest`"""
    def __init__(self, q, a, sig_word_set):
        self.question = q
        self.answer = a
        self.sig_word_set = sig_word_set


class MockNLPMethod(qa.NLPMethod):
    """Mock :class:`QA.qa.NLPMethod` for :class:`QA.unit_tests.NLPMethodTest`"""
    def match_prob(self, question1, question2):
        return 1 if "Thanks" in (question1.question, question2.question) else 0.9


method = MockNLPMethod()


class NLPMethodTest(unittest.TestCase):
    """Tests :class:`QA.qa.NLPMethod`"""
    def testGenResults(self):
        """Tests :any:`QA.qa.NLPMethod.gen_results`"""
        temp = qa.NLPMethod.gen_results([[1, MockQuestion("Hello", "World")]], 27, True, 0.5)
        assert temp['matched'] == "Hello"
        assert temp['ans'] == "World"
        assert temp['time'] == 27
        assert temp['cutoff'] == 0.5
        assert len(temp['matches']) == 1
        assert temp['matches'][0]['match'] == 1
        assert temp['matches'][0]['question'] == "Hello"

    def testGenResultsNoAnswer(self):
        """Tests :any:`QA.qa.NLPMethod.gen_results` when there is no answer matched"""
        temp = qa.NLPMethod.gen_results([[0.2, MockQuestion("Hello", "World")]], 27, True, 0.5)
        assert temp['matched'] == "No answer matched."
        assert temp['ans'] == "No answer matched."
        assert temp['time'] == 27
        assert temp['cutoff'] == 0.5
        assert len(temp['matches']) == 1
        assert temp['matches'][0]['match'] == 0.2
        assert temp['matches'][0]['question'] == "Hello"

    def testRunMethod(self):
        """Tests :any:`QA.qa.NLPMethod.run_method`"""
        temp = method.run_method(MockQuestion("How are you?", ""), [MockQuestion("I'm good", "0"), MockQuestion("Thanks", "1"), MockQuestion("What about you?", "2")], True, 2)
        assert len(temp['matches']) == 2, "top_n should limit number of matches found"
        assert temp['matches'][0]['question'] == "Thanks"
        assert temp['matched'] == "Thanks"
         
    def testExact(self):
        """Tests :class:`QA.qa.Exact`"""
        exact = qa.methods["exact"]
        # Test that exact words are matched with a value of 1
        assert exact.match_prob(MockSigWordSet("test", "correct", set(["test"])), MockSigWordSet("test", "correct", set(["test"]))) == 1
        # Test that the ratio is being calculated correctly
        assert exact.match_prob(MockSigWordSet("test two", "correct", set(["test", "two"])), MockSigWordSet("test", "correct", set(["test"]))) == 0.5
        # If no words in common are found then return 0
        assert exact.match_prob(MockSigWordSet("test", "correct", set(["test"])), MockSigWordSet("Nothing", "Incorrect", set(["nothing"]))) == 0

    def testSynset(self):
        """Tests :class:`QA.qa.SynsetMatch`"""
        synset = qa.methods["synset"]

        # Make the question objects we will use for testing
        q1 = Question("test", "correct")
        q2 = Question("fast", "correct")
        q3 = Question("quick", "correct")
        q4 = Question("different", "correct")
        q5 = Question("difference", "correct")
        q6 = Question("cat", "correct")
        # Test that exact words are matched with a value of 1
        assert synset.match_prob(q1, q1) == 1, "Words: test, test. Expected synset match prob: 1, actual: " + synset.match_prob(q1, q1)
        # Synonyms are matched with a value of 0.5
        assert synset.match_prob(q2, q3) == 1/3, "Words: Fast, quick. Expected synset match prob: 1/3, actual: " + synset.match_prob(q2, q3)
        # Same stem has value 1
        assert synset.match_prob(q4, q5) == 1, "Words: Different, difference. Expected synset match prob: 1, actual: " + synset.match_prob(q4, q5)
        # Different words have value 0
        assert synset.match_prob(q4, q6) == 0, "Words: Different, cat. Expected synset match prob: 0, actual: " + synset.match_prob(q4, q5)

# TODO test qa.get_response

# TODO we could test server but that seems unnecessary
# TODO test ExcelAutomation.py? You don't usually need to test your tests but just because we use the results at face value when determining a confidence cutoff?


if __name__ == "__main__":
    unittest.main() # run unit tests
