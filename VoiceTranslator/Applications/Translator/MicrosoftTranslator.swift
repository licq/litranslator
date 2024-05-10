import Foundation

class MicrosoftTranslator: Translator {
    var subscriptionKey: String
    var region: String
    var endpoint: String

    init(endpoint: String, region: String, key: String) {
        self.endpoint = endpoint
        self.region = region
        self.subscriptionKey = key
    }

    func translate(from: String, to: String, text: String, completion: @escaping (String?, (any Error)?) -> Void) {
        print("translate from \(from) to \(to)")
        let path = "/translate?api-version=3.0"
        let params = "&from=\(from)&to=\(to)"
        let constructedUrl = URL(string: self.endpoint + path + params)!

        var request = URLRequest(url: constructedUrl)
        request.addValue(self.subscriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.addValue(self.region, forHTTPHeaderField: "Ocp-Apim-Subscription-Region")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UUID().uuidString, forHTTPHeaderField: "X-ClientTraceId")
        request.httpMethod = "POST"

        let body = [["text": text]]
        request.httpBody = try! JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
                   let firstObject = jsonObject.first,
                   let translations = firstObject["translations"] as? [[String: Any]],
                   let firstTranslation = translations.first,
                   let translatedText = firstTranslation["text"] as? String {
                    completion(translatedText, nil)
                } else {
                    completion(nil, error)
                }
            } catch {
                print("Error: \(error)")
                completion(nil, error)
            }
        }
        task.resume()
    }
}

