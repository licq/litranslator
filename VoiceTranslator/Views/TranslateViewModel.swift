import Foundation
import AVFoundation

enum Stage{
    case notRunning
    case listening
    case processing
}

class TranslateViewModel: ObservableObject{
    @Published var profile: Profile
    @Published var dialog: Dialog
    @Published var stage: Stage = .notRunning
    @Published var errorString: String = ""

    private var audioRecorder: AudioRecorder?
    private let speaker: Speaker = Speaker()
    
    init(){
        dialog = Dialog()
        profile = Profile.shared
        do {
            audioRecorder = try AudioRecorder(pauseDuration: Profile.shared.pauseDuration)
            audioRecorder?.processAudioData = processAudio
        }catch{
            errorString = "The app need the microphone usage to do speech recognization"
        }
    }
    
    func startTalking(){
        audioRecorder?.changePauseDuation(profile.pauseDuration)
        audioRecorder?.start()
    }
    
    func stopTalking(){
        audioRecorder?.stop()
        speaker.stop()
    }
    
    func processAudio(_ audioData: [Float], callback: @escaping () -> Void){
        changeStage(.processing)

        guard let transcribeResult = Processor.shared.transcriber.transcribe(audioData) else {
            changeStage(.listening)
            callback()
            return
        }
        if transcribeResult.language != profile.sourceLanguage && transcribeResult.language != profile.targetLanguage{
            changeStage(.listening)
            callback()
            return
        }
        appendMessage(Message(left: transcribeResult, putOn: transcribeResult.language == profile.sourceLanguage ? .left : .right))
        
        var targetLanguage = profile.targetLanguage
        if targetLanguage == transcribeResult.language{
            targetLanguage = profile.sourceLanguage
        }

        Processor.shared.translator.translate(from: transcribeResult.language, to: targetLanguage, text: transcribeResult.text){ message, error in
            if let error = error{
                self.changeErrorString("\(error.localizedDescription)")
            }else{
                self.changeErrorString("")
            }
            if let message = message{
                let translateResult = LanguageAndText(targetLanguage, message)
                Task{@MainActor in
                    self.dialog.replaceLast(Message(left: transcribeResult, right: translateResult, putOn: transcribeResult.language == self.profile.sourceLanguage ? .left : .right))
                }
                self.speaker.speak(translateResult)
            }
            if self.stage == .processing{
                self.changeStage(.listening)
            }
            callback()
        }
    }
    
    func changeStage(_ newStage: Stage){
        Task{@MainActor in
            self.stage = newStage
        }
        if newStage == .processing{
            DingPlayer.shared.ding()
        }
    }
    
    func appendMessage(_ message: Message){
        Task{@MainActor in
            dialog.append(message)
        }
    }
    
    func changeErrorString(_ errorString: String){
        Task{@MainActor in
            self.errorString = errorString
        }
    }
}
