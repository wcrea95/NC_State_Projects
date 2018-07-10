from sqlalchemy import *
from sqlalchemy.exc import OperationalError
from config import production_database, test_database, connection_type
import sys


def connect_to_db(db):
    """
    Connects to a given database

    Args:
        db (str): database address

    Returns:
        bool: True if successfully connected, False otherwise

    Example:
        connect_to_db('mysql://root:password@localhost:3306/database')
    """
    global engine, metadata, connected
    try:
        engine = create_engine(db)
        metadata = MetaData(engine)
        text('select 1', bind=engine).execute()
        connected = True
        return True
    except OperationalError:
        connected = False
        return False


def connect():
    """
    Tries to connect to the database based on the values in config.py

    Returns:
        bool: True if successful
    """
    if connection_type == "PRODUCTION" or connection_type == "PROD_FALLBACK_TEST":
        print("Attempting to connect to production database...", file=sys.stderr)
        if connect_to_db(production_database):
            print("Successfully connected to database", file=sys.stderr)
            return True
        else:
            print("Connection to database failed", file=sys.stderr)
    if connection_type == "TEST" or connection_type == "PROD_FALLBACK_TEST":
        print("Attempting to connect to test database...", file=sys.stderr)
        if connect_to_db(test_database):
            print("Successfully connected to database", file=sys.stderr)
            return True
        else:
            print("Connection to database failed", file=sys.stderr)
    return False
            

def initialize():
    """
    Initializes the database and database tables
    """
    global subject, faq, video
    connect()
    if connected:
        subject = Table('subject', metadata, autoload=True)
        faq = Table('faq', metadata, autoload=True)
        video = Table('video', metadata, autoload=True)
    else:
        print("Could not initialize, not connected to database", file=sys.stderr)


def get_subjects(sub_id = None):
    """
    Returns either a list of subjects or the specifics of a single subject

    Args:
        sub_id (int, optional): the subject id to get information on

    Returns:
        sqlalchemy.ResultProxy: list of results in format [sub_id, sub_name]
    """
    if sub_id is None:
        return select([subject.c.sub_id, subject.c.sub_name]).execute()
    else:
        return select([subject.c.sub_id, subject.c.sub_name], subject.c.sub_id == sub_id).execute()


def get_questions(sub_id):
    """
    Gets the list of questions/answers for a particular subject id

    Args:
        sub_id (int): the subject id to get questions for

    Returns:
        sqlalchemy.ResultProxy: list of results in format [faq_question, vid_script]
    """
    return select([faq.c.faq_question, video.c.vid_script], and_(faq.c.faq_sub_id == sub_id, faq.c.faq_vid_id == video.c.vid_id)).execute()


#if __name__ == "__main__":
initialize()