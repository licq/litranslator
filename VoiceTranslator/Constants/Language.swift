import Foundation

struct Language: Codable, Hashable {
    let code: String
    let nativeName: String
    
    func isSame(_ lang: Language) -> Bool{
        self.code == lang.code
    }
}

extension Language{
    static let all: [Language] = [
        Language(code: "af", nativeName: "Afrikaans"),
        Language(code: "am", nativeName: "አማርኛ"),
        Language(code: "ar", nativeName: "العربية"),
        Language(code: "as", nativeName: "অসমীয়া"),
        Language(code: "az", nativeName: "Azərbaycan"),
        Language(code: "ba", nativeName: "Bashkir"),
        Language(code: "bg", nativeName: "Български"),
        Language(code: "bn", nativeName: "বাংলা"),
        Language(code: "bo", nativeName: "བོད་སྐད་"),
        Language(code: "bs", nativeName: "Bosnian"),
        Language(code: "ca", nativeName: "Català"),
        Language(code: "cs", nativeName: "Čeština"),
        Language(code: "cy", nativeName: "Cymraeg"),
        Language(code: "da", nativeName: "Dansk"),
        Language(code: "de", nativeName: "Deutsch"),
        Language(code: "el", nativeName: "Ελληνικά"),
        Language(code: "en", nativeName: "English"),
        Language(code: "es", nativeName: "Español"),
        Language(code: "et", nativeName: "Eesti"),
        Language(code: "eu", nativeName: "Euskara"),
        Language(code: "fa", nativeName: "فارسی"),
        Language(code: "fi", nativeName: "Suomi"),
        Language(code: "fo", nativeName: "Føroyskt"),
        Language(code: "fr", nativeName: "Français"),
        Language(code: "gl", nativeName: "Galego"),
        Language(code: "gu", nativeName: "ગુજરાતી"),
        Language(code: "ha", nativeName: "Hausa"),
        Language(code: "he", nativeName: "עברית"),
        Language(code: "hi", nativeName: "हिन्दी"),
        Language(code: "hr", nativeName: "Hrvatski"),
        Language(code: "hu", nativeName: "Magyar"),
        Language(code: "hy", nativeName: "Հայերեն"),
        Language(code: "id", nativeName: "Indonesia"),
        Language(code: "is", nativeName: "Íslenska"),
        Language(code: "it", nativeName: "Italiano"),
        Language(code: "ja", nativeName: "日本語"),
        Language(code: "ka", nativeName: "ქართული"),
        Language(code: "kk", nativeName: "Қазақ Тілі"),
        Language(code: "km", nativeName: "ខ្មែរ"),
        Language(code: "kn", nativeName: "ಕನ್ನಡ"),
        Language(code: "ko", nativeName: "한국어"),
        Language(code: "ln", nativeName: "Lingála"),
        Language(code: "lo", nativeName: "ລາວ"),
        Language(code: "lt", nativeName: "Lietuvių"),
        Language(code: "lv", nativeName: "Latviešu"),
        Language(code: "mg", nativeName: "Malagasy"),
        Language(code: "mi", nativeName: "Te Reo Māori"),
        Language(code: "mk", nativeName: "Македонски"),
        Language(code: "ml", nativeName: "മലയാളം"),
        Language(code: "mr", nativeName: "मराठी"),
        Language(code: "ms", nativeName: "Melayu"),
        Language(code: "mt", nativeName: "Malti"),
        Language(code: "my", nativeName: "မြန်မာ"),
        Language(code: "ne", nativeName: "नेपाली"),
        Language(code: "nl", nativeName: "Nederlands"),
        Language(code: "pa", nativeName: "ਪੰਜਾਬੀ"),
        Language(code: "pl", nativeName: "Polski"),
        Language(code: "ps", nativeName: "پښتو"),
        Language(code: "pt", nativeName: "Português (Brasil)"),
        Language(code: "ro", nativeName: "Română"),
        Language(code: "ru", nativeName: "Русский"),
        Language(code: "sd", nativeName: "سنڌي"),
        Language(code: "si", nativeName: "සිංහල"),
        Language(code: "sk", nativeName: "Slovenčina"),
        Language(code: "sl", nativeName: "Slovenščina"),
        Language(code: "sn", nativeName: "chiShona"),
        Language(code: "so", nativeName: "Soomaali"),
        Language(code: "sq", nativeName: "Shqip"),
        Language(code: "sv", nativeName: "Svenska"),
        Language(code: "sw", nativeName: "Kiswahili"),
        Language(code: "ta", nativeName: "தமிழ்"),
        Language(code: "te", nativeName: "తెలుగు"),
        Language(code: "th", nativeName: "ไทย"),
        Language(code: "tk", nativeName: "Türkmen Dili"),
        Language(code: "tr", nativeName: "Türkçe"),
        Language(code: "tt", nativeName: "Татар"),
        Language(code: "uk", nativeName: "Українська"),
        Language(code: "ur", nativeName: "اردو"),
        Language(code: "uz", nativeName: "Uzbek (Latin)"),
        Language(code: "vi", nativeName: "Tiếng Việt"),
        Language(code: "yo", nativeName: "Èdè Yorùbá"),
        Language(code: "yue", nativeName: "粵語 (繁體)"),
        Language(code: "zh", nativeName: "中文")
    ]
    
    static func getNativeName(from code: String) -> String? {
        return all.filter { $0.code == code }.first?.nativeName
    }
    
    static func by(code: String) -> Language?{
        all.filter {$0.code == code}.first
    }
    
    static func current() -> Language?{
        if let languageCode = Locale.current.language.languageCode?.identifier{
            return Language.by(code: languageCode)
        }
        return nil
    }
    
    static var Chinese: Language{
        Language.by(code: "zh")!
    }
    
    static var English: Language{
        Language.by(code: "en")!
    }
    
    static func isChinese(_ languageCode: String) -> Bool{
        languageCode == "zh"
    }
    
    static func isEnglish(_ languageCode: String) -> Bool{
        languageCode == "en"
    }
}
