import SwiftUI

@main
struct VoiceTranslatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Dialog.self])
    }
}
