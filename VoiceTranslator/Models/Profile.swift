import Foundation

enum TranslationProvider: String, Codable, CaseIterable {
    case shared = "Shared"
    case myOwn = "My Own"
}

class Profile: ObservableObject, Codable {
    static let jsonFileName = "profile.json"
    static let SubscriptionKey: String = MICROSOFT_SUBSCRIPTION_KEY
    static let Region: String = "eastasia"
    static let Endpoint: String = "https://api.cognitive.microsofttranslator.com"
    
    @Published var sourceLanguage: String
    @Published var targetLanguage: String
    @Published var pauseDuration: Double = 1.0
    @Published var translationProvider: TranslationProvider = .shared
    @Published var endpoint: String = ""
    @Published var region: String = ""
    @Published var key: String = ""
    
    init(sourceLanguage: String, targetLanguage: String) {
        self.sourceLanguage = sourceLanguage
        self.targetLanguage = targetLanguage
    }
    
    var selectedKey: String {
        translationProvider == .shared ? Self.SubscriptionKey : self.key
    }
    
    var selectedEndpoint: String {
        translationProvider == .shared ? Self.Endpoint : self.endpoint
    }
    
    var selectedRegion: String {
        translationProvider == .shared ? Self.Region : self.region
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sourceLanguage = try container.decode(String.self, forKey: .sourceLanguage)
        targetLanguage = try container.decode(String.self, forKey: .targetLanguage)
        pauseDuration = try container.decode(Double.self, forKey: .pauseDuration)
        translationProvider = try container.decode(TranslationProvider.self, forKey: .translationProvider)
        endpoint = try container.decode(String.self, forKey: .endpoint)
        region = try container.decode(String.self, forKey: .region)
        key = try container.decode(String.self, forKey: .key)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sourceLanguage, forKey: .sourceLanguage)
        try container.encode(targetLanguage, forKey: .targetLanguage)
        try container.encode(pauseDuration, forKey: .pauseDuration)
        try container.encode(translationProvider, forKey: .translationProvider)
        try container.encode(endpoint, forKey: .endpoint)
        try container.encode(region, forKey: .region)
        try container.encode(key, forKey: .key)
    }
    
    enum CodingKeys: String, CodingKey {
        case sourceLanguage
        case targetLanguage
        case pauseDuration
        case translationProvider
        case endpoint
        case region
        case key
    }
    
    func save() {
        do{
            let data = try JSONEncoder().encode(self)
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let filePath = documentsDirectory.appendingPathComponent(Profile.jsonFileName)
            try data.write(to: filePath)
        }catch{
            print("save profile config file failed")
        }
    }
    
    static func load() throws -> Profile {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentsDirectory.appendingPathComponent(Profile.jsonFileName)
        let data = try Data(contentsOf: filePath)
        return try JSONDecoder().decode(Profile.self, from: data)
    }
}

extension Profile {
    static var shared: Profile = {
        do {
            let profile = try Profile.load()
            return profile
        }catch{
            print("can't find the profile config file, return default")
            
            var sourceLanguage = Language.current()!
            var targetLanguage = Language.English
            if Language.isEnglish(sourceLanguage.code) {
                targetLanguage = Language.Chinese
            }
            
            return Profile(sourceLanguage: sourceLanguage.code, targetLanguage: targetLanguage.code)
        }
    }()
}
