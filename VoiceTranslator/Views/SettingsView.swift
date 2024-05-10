import SwiftUI

struct SettingsView: View {
    @StateObject var profile: Profile = Profile.shared
    @Environment(\.scenePhase) private var scenePhase: ScenePhase
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(LocalizedStringKey("settings.voice.detection.threshold"))) {
                    HStack {
                        Text("0.5")
                        Spacer()
                        Text("\(String(format: "%.1f", profile.pauseDuration))").foregroundColor(.blue)
                        Spacer()
                        Text("3.0")
                    }
                    Slider(value: $profile.pauseDuration, in: 0.5...3.0, step: 0.1)
                    Text(LocalizedStringKey("settings.voice.detection.threshold.comment"))
                        .font(.footnote)
                }
                
                Section(header: Text(LocalizedStringKey("settings.translation.provider.header"))) {
                    Picker(selection: $profile.translationProvider, label: Text(LocalizedStringKey("settings.view.translation.provider.mode"))) {
                        ForEach(TranslationProvider.allCases, id: \.self) { provider in
                            Text(provider.rawValue)
                        }
                    }
                    
                    if profile.translationProvider == .shared {
                        Text(LocalizedStringKey("settings.translation.provider.shared.comment"))
                            .font(.footnote)
                        Button(action: {
                            if let url = URL(string: "https://azure.microsoft.com/en-us/products/ai-services/ai-translator") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text(LocalizedStringKey("settings.translation.provider.microsoft"))
                                .font(.footnote)
                        }
                    } else if profile.translationProvider == .myOwn {
                        TextField("Endpoint", text: $profile.endpoint)
                        TextField("Region", text: $profile.region)
                        TextField("Key", text: $profile.key)
                    }
                }
                
                Section(header: Text(LocalizedStringKey("settings.privacy.header"))) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(LocalizedStringKey("settings.privacy.content"))
                            .font(.footnote)
                    }
                }
            }
            .navigationTitle(LocalizedStringKey("settings.view.title"))
        }
        .onDisappear(){
            print("settings disappear")
            profile.save()
            Processor.shared.reinitilize(profile)
        }
    }
}

#Preview {
    SettingsView()
}
