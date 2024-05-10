import Foundation
import SwiftData

@Model
class AssistantDialog{
    let id: String
    var messages: [AssistantMessage]
    var time: Date
    
    init(_ id: String = UUID().uuidString,messages: [AssistantMessage] = [], time: Date = Date.now) {
        self.id = id
        self.messages = messages
        self.time = time
    }
    
    func append(_ message: AssistantMessage){
        messages.append(message)
    }
}

enum Role: String, Codable{
    case assistant
    case user
}

class AssistantMessage: Identifiable, Codable{
    var id: String
    var content: String
    var role : Role
    
    init(_ id: String = UUID().uuidString, content: String, role: Role) {
        self.id = id
        self.content = content
        self.role = role
    }
}
