import Foundation

class OnlineTranslator: Translator {
    private let url = URL(string: "http://192.168.0.53:5001/translate")!

    func translate(from: String, to: String, text: String, completion: @escaping (String?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let translationRequest = TranslationRequest(from_language: from, to_language: to, text: text)
        request.httpBody = try? JSONEncoder().encode(translationRequest)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                completion(nil, NSError(domain: "", code: httpResponse.statusCode, userInfo: nil))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let translatedText = json["translated_text"] as? String
                    completion(translatedText, nil)
                }
            } catch let parseError {
                completion(nil, parseError)
            }
        }

        task.resume()
    }
}


