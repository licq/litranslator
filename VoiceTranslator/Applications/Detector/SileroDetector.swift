import Foundation

class SileroDetector:VoiceDetector{
    private var vad: SileroLib!
    
    init(){
        let url = Bundle.main.url(forResource: "silero_vad", withExtension: "onnx", subdirectory: "models")!
        vad = SileroLib(modelPath: url.path(), sampleRate: Int64(SAMPLE_RATE), frameSize: 100, threshold: 0.5, minSilenceDurationMs: 50, speechPadMs: 0)
    }
    
    func detect(_ audioData: [Float]) -> Bool {
        do {
            let result =  try vad.predict(data: audioData)
//            vad.resetState()
            return result
        }catch{
            print("error \(error)")
            return false
        }
    }
    
    func reset(){
        vad.resetState()
    }
}
