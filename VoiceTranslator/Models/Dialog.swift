import Foundation
import SwiftData

@Model
class Dialog{
    let id: String
    let time: Date
    var messages: [Message]
    
    init(id: String = UUID().uuidString, time: Date = Date.now, messages: [Message] = []) {
        self.id = id
        self.time = time
        self.messages = messages
    }
}
 
extension Dialog{
    func append(_ message: Message){
        if message.left.isNotEmpty(){
            self.messages.append(message)
        }
    }
    
    func replaceLast(_ message: Message){
        if message.left.isNotEmpty(){
            messages[messages.count - 1] = message
        }
    }
}
 

