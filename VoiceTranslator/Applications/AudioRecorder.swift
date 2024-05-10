import Foundation
import SwiftUI
import AVFoundation

class AudioRecorder{
    private var buffers: [AVAudioPCMBuffer] = [AVAudioPCMBuffer]()
    private var listening = false
    
    private var silenceCount : Int = 0
    private var activeCount: Int = 0
    private var silenceThreshold: Int = 10
    private let activeThreshold: Int = 3
    var processAudioData: (([Float], @escaping () -> Void) -> Void)?
    
    private var audioEngine: AVAudioEngine? = nil
    private var vad: VoiceDetector
    
    private let outputFormat = AVAudioFormat(standardFormatWithSampleRate: Double(SAMPLE_RATE), channels: 1)!
    
    init(pauseDuration: Double) throws{
        self.silenceThreshold = Int(pauseDuration * 10)
        vad = SileroDetector()
        
        var recordPermission = true
        AVAudioApplication.requestRecordPermission(){ granted in
            recordPermission = granted
        }
        if !recordPermission{
            throw Errors.MicrophonePermissionDenied
        }
    }
    
    func changePauseDuation(_ pauseDuration: Double){
        self.silenceThreshold = Int(pauseDuration * 10)
    }

    func start(){
        buffers.removeAll()
        listening = true
        do{
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.duckOthers, .defaultToSpeaker])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            audioEngine = AVAudioEngine()
            let inputNode = audioEngine!.inputNode
            let inputFormat = inputNode.outputFormat(forBus: 0)
            inputNode.removeTap(onBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: UInt32(SAMPLE_RATE / 10), format: inputFormat){(buffer, when) in
                if self.listening{
                    self.append(self.convertTo16k(buffer))
                    if self.sentenceCompleted{
                        self.listening = false
                        self.processAudioData?(self.audioData){
                            self.listening = true
                        }
                    }
            }}
            
            audioEngine?.prepare()
            try audioEngine?.start()
        }catch{
            print("audioEngine start failed: \(error)")
        }
    }
    
    func stop(){
        print("audiorecorder stop")
        listening = false
        audioEngine?.inputNode.removeTap(onBus: 0)
        audioEngine?.stop()
        audioEngine = nil
        buffers.removeAll()
    }
}

//MARK： for audioData storage
extension AudioRecorder{
    func append(_ buffer: AVAudioPCMBuffer){
        let channelData = buffer.floatChannelData![0]
        let channelDataValueArray = Array(UnsafeBufferPointer(start: channelData, count: Int(buffer.frameLength)))
        
        let active = vad.detect(channelDataValueArray)
        if !active{
            silenceCount += 1
        }else{
            silenceCount = 0
            activeCount += 1
        }
        buffers.append(buffer)
        if activeCount == 0 && buffers.count > 10{
            buffers = Array(buffers[(buffers.count - 10)..<buffers.count])
        }
    }
    
    public var sentenceCompleted: Bool{
        activeCount > activeThreshold && silenceCount >= silenceThreshold
    }
    
    public var audioData: [Float]{
        guard let firstBuffer = buffers.first else {
            return []
        }
        
        let activeBuffers = buffers[0..<buffers.count - silenceCount]
        let totalFrames = activeBuffers.reduce(0) { $0 + $1.frameLength }
        let mergedBuffer = AVAudioPCMBuffer(pcmFormat: firstBuffer.format, frameCapacity: totalFrames)!
        mergedBuffer.frameLength = totalFrames
        
        var frameOffset: AVAudioFramePosition = 0
        for buffer in activeBuffers {
            let channels = Int(buffer.format.channelCount)
            for channel in 0..<channels {
                memcpy(mergedBuffer.floatChannelData![channel] + Int(frameOffset),
                       buffer.floatChannelData![channel],
                       Int(buffer.frameLength) * MemoryLayout<Float>.stride)
            }
            frameOffset += AVAudioFramePosition(buffer.frameLength)
        }
        
        guard let channelData = mergedBuffer.floatChannelData else {
            return []
        }
        
        let count = Int(mergedBuffer.frameLength)
        var data = [Float]()
        data.reserveCapacity(count)
        
        for i in 0..<count {
            let sample = channelData.pointee[i]
            data.append(sample)
        }
        
        buffers.removeAll()
        silenceCount = 0
        activeCount = 0
        
        return data
    }
}

//MARK: utility function
extension AudioRecorder{
    private func convertTo16k(_ buffer: AVAudioPCMBuffer) -> AVAudioPCMBuffer{
        let inputCallback: AVAudioConverterInputBlock = {
            inNumPackets, outStatus in
            outStatus.pointee = .haveData
            return buffer
        }

        let converter = AVAudioConverter(from: buffer.format, to: outputFormat)!
        let convertedBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: AVAudioFrameCount(outputFormat.sampleRate) * buffer.frameLength / AVAudioFrameCount(buffer.format.sampleRate))!
        var  error: NSError?
        let _ = converter.convert(to: convertedBuffer, error: &error, withInputFrom: inputCallback)
        return convertedBuffer
    }
}
