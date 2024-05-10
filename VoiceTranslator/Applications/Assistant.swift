import Foundation

class Assistant {
    var endpoint: String

    init() {
        self.endpoint = "http://192.168.0.159:5001/chat"
    }

    func chat(messages: [AssistantMessage], completion: @escaping (String?, (any Error)?) -> Void) {
        let constructedUrl = URL(string: self.endpoint)!

        var request = URLRequest(url: constructedUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try! JSONEncoder().encode(messages)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let answer = jsonObject["answer"] as? String{
                    completion(answer, nil)
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

