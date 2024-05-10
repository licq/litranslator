import Foundation
import AVFoundation

class Speaker: NSObject, AVSpeechSynthesizerDelegate{
    private let synthesizer = AVSpeechSynthesizer()
    private var semaphore = DispatchSemaphore(value: 0)
    
    func speak(_ toSpeak: LanguageAndText) {
        let utterance = AVSpeechUtterance(string: toSpeak.text)
        utterance.volume = 10
        utterance.pitchMultiplier = 1
        utterance.voice = chooseVoice(toSpeak.language)
        synthesizer.delegate = self
        
        let avAudioSession = AVAudioSession.sharedInstance()
        do {
            try avAudioSession.overrideOutputAudioPort(.speaker)
        }catch{
            print("change avaudioSession output port failed \(error)")
        }
        semaphore = DispatchSemaphore(value: 0)
        self.synthesizer.speak(utterance)
        semaphore.wait()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Thread.sleep(forTimeInterval: 1.5)
        semaphore.signal()
    }
    
    
    private func chooseVoice(_ language: String) -> AVSpeechSynthesisVoice?{
        let voices = AVSpeechSynthesisVoice.speechVoices().filter({$0.language.starts(with: "\(language)-")})
        if voices.count == 0{
            fatalError("no voice for language \(language)")
        }
        let sortedVoices = voices.sorted { $0.quality.rawValue > $1.quality.rawValue }
        return sortedVoices.first
    }
    
    func stop(){
        synthesizer.stopSpeaking(at: .immediate)
    }
}
