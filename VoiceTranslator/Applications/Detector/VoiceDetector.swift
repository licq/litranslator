import Foundation

protocol VoiceDetector{
    func detect(_ audioData: [Float]) -> Bool
}
