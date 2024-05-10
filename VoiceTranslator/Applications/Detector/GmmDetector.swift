import libfvad

class GmmDetector:VoiceDetector{
    private let sampleRate = 16000
    private var detector: VoiceActivityDetector
    private var duration: Int
    
    init(duration: Int){
        self.duration = duration
        detector = VoiceActivityDetector()
        do {
            try detector.setMode(mode: .veryAggressive)
            try detector.setSampleRate(sampleRate: self.sampleRate)
        }catch{
            print("VAD initilize failed \(error)")
        }
    }
    
    func detect(_ audioData: [Float])-> Bool{
        var detected = false
        let length = duration * sampleRate / 1000
        let startIndex = audioData.count - length
        let samples = audioData[startIndex..<audioData.count]
        let int16Samples = samples.map { f in
            var scaled = f * Float(Int16.max)
            scaled = min(scaled, Float(Int16.max))
            scaled = max(scaled, Float(Int16.min))
            return Int16(scaled)
        }
        do{
            try int16Samples.withUnsafeBufferPointer{ buffer in
                let unsafePointer = buffer.baseAddress!
                let result =  try detector.process(frame: unsafePointer, length: length)
                detected = result == .activeVoice
            }
        }catch{
            print("error: \(error)")
        }
        return detected
    }
    
    func reset(){
        detector.reset()
    }
}
