import Foundation

struct Message: Identifiable, Codable{
    let id: UUID
    let left: LanguageAndText
    let right: LanguageAndText
    var putOn: PutOn
    
    init(id: UUID = UUID(), left: LanguageAndText, right: LanguageAndText = LanguageAndText("",""), putOn: PutOn){
        self.id = id
        self.left = left
        self.right = right
        self.putOn = putOn
    }
}

extension Message{
    enum PutOn: Codable{
        case left
        case right
    }
}

