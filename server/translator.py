import requests
import uuid

class MicrosoftTranslator:
    def __init__(self, subscription_key, region):
        self.subscription_key = subscription_key
        self.region = region
        self.endpoint = "https://api.cognitive.microsofttranslator.com"

    def translate(self, from_language, to_language, text):
        path = '/translate?api-version=3.0'
        params = '&from={}&to={}'.format(from_language, to_language)
        constructed_url = self.endpoint + path + params

        headers = {
            'Ocp-Apim-Subscription-Key': self.subscription_key,
            'Ocp-Apim-Subscription-Region': self.region, # 'westeurope' is the default region for the free tier
            'Content-type': 'application/json',
            'X-ClientTraceId': str(uuid.uuid4())
        }

        body = [{'text': text}]
        response = requests.post(constructed_url, headers=headers, json=body)
        result = response.json()

        return result[0]['translations'][0]['text']
