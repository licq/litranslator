import Foundation

struct LanguageAndText: Codable{
    let language: String
    let text: String
    
    init(_ language: String, _ text: String){
        self.language = language
        self.text = text
    }
    
    func isNotEmpty() -> Bool{
        !text.isEmpty
    }
}
