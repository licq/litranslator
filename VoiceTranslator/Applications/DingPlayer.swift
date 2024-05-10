import AVFoundation

class DingPlayer {
    private var avPlayer: AVPlayer
    static var shared: DingPlayer{
        return DingPlayer()
    }
    
    private init(){
        guard let url = Bundle.main.url(forResource: "ding", withExtension: "wav") else { fatalError("Failed to find sound file.") }
        avPlayer = AVPlayer(url: url)
    }
    
    func ding(){
        avPlayer.seek(to: CMTime.zero)
        avPlayer.play()
    }
}
