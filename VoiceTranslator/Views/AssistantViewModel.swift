import Foundation
import AVFoundation

class AssistantViewModel: ObservableObject{
    @Published var dialog: AssistantDialog
    @Published var stage: Stage = .notRunning

    private var audioRecorder: AudioRecorder?
    private let speaker: Speaker = Speaker()
    
    init(){
        dialog = AssistantDialog()
        do{
            audioRecorder = try AudioRecorder(pauseDuration: Profile.shared.pauseDuration)
            audioRecorder?.processAudioData = processAudio
        }catch{
            print("no audio permission")
        }
    }
    
    func startTalking(){
        audioRecorder?.start()
    }
    
    func stopTalking(){
        audioRecorder?.stop()
        speaker.stop()
    }
    
    func processAudio(_ audioData: [Float], callback: @escaping () -> Void){
        changeStage(.processing)
        guard let transcribeResult = Processor.shared.transcriber.transcribe(audioData) else{
            changeStage(.listening)
            callback()
            return
        }
        
        var messages = Array(dialog.messages.suffix(10))
        let assistantMessage = AssistantMessage(content: transcribeResult.text, role: .user)
        messages.append(assistantMessage)
        appendMessage(assistantMessage)
        
        Processor.shared.assistant.chat(messages: messages) { message, error in
            if let error = error{
                print("assistant chat error: \(error)")
                self.appendMessage(AssistantMessage(content: "can't connect to the chat server", role: .assistant))
            } else if let message = message{
                self.appendMessage(AssistantMessage(content: message, role: .assistant))
                self.speaker.speak(LanguageAndText(transcribeResult.language, message))
            }
            if self.stage == .processing {
                self.changeStage(.listening)
            }
            callback()
        }
    }
    
    func changeStage(_ newStage: Stage){
        print("change stage from \(self.stage) to \(newStage)")
        Task{@MainActor in
            self.stage = newStage
        }
        if newStage == .processing{
            DingPlayer.shared.ding()
        }
    }
    
    func appendMessage(_ message: AssistantMessage){
        Task{@MainActor in
            self.dialog.append(message)
        }
    }
}
