import qa
import question
from flask import Flask, request, jsonify, render_template, abort
from flask_restful import Api, Resource


app = Flask(__name__)
# app.config['DEBUG'] = True
# app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 0
api = Api(app)


class QA(Resource):
    def get(self):
        return jsonify(qa.get_response(request.args.get("question"), request.args.get("debug") is not None, int(request.args.get("subject_id"))))


api.add_resource(QA, '/qa')


@app.route('/api/questions', methods=['GET'])
def get_questions():
    sets = list(qa.get_question_sets())
    if sets:
        return jsonify(sets)
    else:
        abort(404)


@app.route('/api/ask', methods=['POST'])
def ask_question():
    content = request.get_json()
    try:
       	result = qa.get_response(content['question'], content['debug'], content['question_set'], content['results'], [content['default']] if 'default' in content.keys() else None)
        return jsonify(result)
    except KeyError:
        abort(400)


@app.route('/api/preprocess', methods=['POST'])
def preprocess_everything():
    content = request.get_json()
    try:
        if content is None:
            question.preprocess_db()
        else:
            question.preprocess_db(**content)
        abort(204)
    except question.SQLError or KeyError or TypeError:
        abort(400)


if __name__ == "__main__":
    #import __init__
    #__init__.initialize()
    app.run(host='0.0.0.0', port=80)
