import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase: ScenePhase
    
    var body: some View {
        TabView(){
            TranslateView()
                .tabItem { Image(systemName: "person.2.fill") }
                .tag("translate")
                .onAppear {
                    UIApplication.shared.isIdleTimerDisabled = true
                }
                .onDisappear {
                    UIApplication.shared.isIdleTimerDisabled = false
                }
            
            TranslateHistoriesView()
                .tabItem { Image(systemName: "clock.fill") }
                .tag("histories")
            
            SettingsView()
                .tabItem { Image(systemName: "gear")}
                .tag("settings")
        }
        .task {
            let _ = Processor.shared
        }
        .onChange(of: scenePhase){
            if scenePhase != .active{
                Profile.shared.save()
            }
        }
    }
}

#Preview {
    ContentView()
}
