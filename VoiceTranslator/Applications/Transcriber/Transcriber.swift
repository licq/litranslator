import Foundation

class Transcriber{
    enum TranscriberError: Error{
        case TranscriberInitilizationFailed
    }
    
    private let lastWordsToRemove = ["谢谢观看", "订阅", "打赏","字幕:J Chong","謝謝觀看", "打赏。","打赏,", "转发,","订阅,","请按赞,", "谢谢大家收看"]
    private var whisperContext: WhisperContext
    
    init() {
        do{
            whisperContext = try WhisperContext.createContext()
        }catch{
            print("create whisper failed: \(error.localizedDescription)")
            fatalError()
        }
    }
    
    func transcribe(_ audioData: [Float])-> LanguageAndText?{
        let lt = whisperContext.fullTranscribe(samples: audioData)
        let transcription = postProcess(lt.text)
        if transcription.isEmpty{
            return nil
        }
        return LanguageAndText(lt.language, transcription)
    }
    
    func postProcess(_ transcription: String) -> String{
        do{
            let regex = try NSRegularExpression(pattern: "\\[.*?\\]|\\(.*?\\)", options: .caseInsensitive)
            var modifiedTranscription = regex.stringByReplacingMatches(in: transcription, options: [], range: NSRange(location: 0, length: transcription.utf16.count), withTemplate: "")
            modifiedTranscription = modifiedTranscription.trimmingCharacters(in: .whitespacesAndNewlines)
            for _ in 0..<5{
                for word in lastWordsToRemove{
                    if modifiedTranscription.hasSuffix(word){
                        modifiedTranscription = String(modifiedTranscription.dropLast(word.count))
                    }
                }
            }
            modifiedTranscription = modifiedTranscription.trimmingCharacters(in: .whitespacesAndNewlines)
            return modifiedTranscription
        }catch{
            return transcription
        }
    }
}
