import sql
import config
import question
import qa
__all__ = ["qa", "sql", "question"]


def initialize(production_db=config.production_database, test_db=config.test_database, connection_type=config.connection_type):
    config.production_database = production_db
    config.test_database = test_db
    config.connection_type = connection_type
    sql.initialize()
    question.initialize()
    qa.preprocess()
