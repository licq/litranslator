from flask import Flask, request, jsonify
import os
from translator import MicrosoftTranslator
from assistant import Assistant

app = Flask(__name__)

key_var_name = 'TRANSLATOR_TEXT_SUBSCRIPTION_KEY'
if not key_var_name in os.environ:
    raise Exception('Please set/export the environment variable: {}'.format(key_var_name))
subscription_key = os.environ[key_var_name]

region_var_name = 'TRANSLATOR_TEXT_REGION'
if not region_var_name in os.environ:
    raise Exception('Please set/export the environment variable: {}'.format(region_var_name))
region = os.environ[region_var_name]

translator = MicrosoftTranslator(subscription_key, region)
assistant = Assistant()

@app.route('/translate', methods=['POST'])
def translate():
    data = request.get_json()
    from_language = data.get('from_language')
    to_language = data.get('to_language')
    text = data.get('text')

    if not from_language or not to_language or not text:
        return jsonify({'error': 'Invalid request data'}), 400

    translated_text = translator.translate(from_language, to_language, text)

    return jsonify({'translated_text': translated_text}), 200

@app.route('/chat', methods = ['POST'])
def chat():
    data = request.get_json()
    data = list(map(lambda x: (x.get('role'), x.get('content')), data))
    answer = assistant.chat(data)
    print(answer)
    return jsonify({'answer': answer}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)
