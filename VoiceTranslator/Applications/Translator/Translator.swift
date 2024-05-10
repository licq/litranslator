
protocol Translator{
    func translate(from: String, to:String, text: String, completion: @escaping (String?, Error?) -> Void)
}


struct TranslationRequest: Codable {
    let from_language: String
    let to_language: String
    let text: String
}
