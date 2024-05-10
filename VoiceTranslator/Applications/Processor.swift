import Foundation

class Processor{
    var transcriber :Transcriber
    var translator: Translator
    var assistant: Assistant
    public static let shared = Processor(Profile.shared)
    
    private init(_ profile: Profile){
        transcriber = Transcriber()
        translator = MicrosoftTranslator(endpoint: profile.selectedEndpoint, region: profile.selectedRegion, key: profile.selectedKey)
        assistant = Assistant()
    }
    
    func reinitilize(_ profile: Profile){
        translator = MicrosoftTranslator(endpoint: profile.selectedEndpoint, region: profile.selectedRegion, key: profile.selectedKey)
    }
}
