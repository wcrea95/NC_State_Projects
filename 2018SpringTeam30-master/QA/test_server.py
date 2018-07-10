from flask import render_template
from rest_server import app


@app.route('/')
def mainPage():
    return render_template('index.html')


if __name__ == "__main__":
    #import __init__
    #__init__.initialize()
    app.run(host='0.0.0.0', port=80)
