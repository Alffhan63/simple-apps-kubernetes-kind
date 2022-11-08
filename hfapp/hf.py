from flask import Flask
from flask import jsonify
from flask import request

app = Flask(__name__)

@app.route('/', methods=['GET'])
def input():
    args = request.args
    height = args.get('height')
    print(height)
    weight = args.get('password')
    print(weight)
    result = { key == height and value == }
    return result

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0',port=3080)
