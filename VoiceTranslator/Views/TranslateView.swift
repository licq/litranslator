import SwiftUI
import SwiftData
import Combine

struct DialogView: View{
    @Bindable var dialog: Dialog
    
    var body: some View{
        VStack{
            ScrollViewReader{proxy in
                ScrollView(.vertical, showsIndicators:false){
                    LazyVStack{
                        ForEach(dialog.messages, id: \.id){ message in
                            TranslateMessageView(message: message)
                        }
                    }
                }
                .onChange(of: dialog.messages.count){ _, _ in
                    withAnimation{
                        if dialog.messages.count > 0{
                            proxy.scrollTo(dialog.messages[dialog.messages.count - 1].id, anchor: .bottom)
                        }
                    }
                }
            }
        }
    }
}

struct LanguagePicker: View{
    @Binding var language: String
    
    var body: some View{
        Picker("", selection: $language){
            ForEach(Language.all, id: \.code){ lang in
                Text(lang.nativeName).tag(lang.code)
                    .background(Color.accentColor)
            }
        }
    }
}

struct ToggleButton: View{
    @Binding var stage: Stage
    
    var body: some View{
        Button{
            if stage == .notRunning{
                stage = .listening
            }else{
                stage = .notRunning
            }
        } label:{
            imageSystemName
                .font(.system(size: 80))
                .fontWeight(.semibold)
        }
    }
    
    @ViewBuilder
    var imageSystemName: some View{
        switch stage {
        case .notRunning:
            Image(systemName: "mic.circle")
        case .listening:
            Image(systemName: "stop.circle")
        case .processing:
            Image(systemName: "stop.circle")
                .foregroundColor(.gray)
        }
        
    }
}

struct ControlsView: View{
    @ObservedObject var profile: Profile
    @Binding var stage: Stage
    
    var body: some View{
        HStack(){
            Spacer()
            LanguagePicker(language: $profile.sourceLanguage)
                .frame(width: 150)
            Spacer()
            ToggleButton(stage: $stage)
            Spacer()
            LanguagePicker(language: $profile.targetLanguage)
                .frame(width: 150)
            Spacer()
        }
    }
}

struct TranslateView: View {
    @StateObject private var model: TranslateViewModel = TranslateViewModel()
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Environment(\.scenePhase) private var scenePhase: ScenePhase
    @State var errorHappened = false
    
    var body: some View {
        NavigationStack {
            VStack{
                DialogView(dialog: model.dialog)
                ControlsView(profile: model.profile, stage: $model.stage)
            }
            .navigationTitle(LocalizedStringKey("translate.view.title"))
            .navigationBarTitleDisplayMode(.large)
            .onChange(of: model.stage){oldStage, newStage in
                if oldStage != .notRunning && newStage == .notRunning{
                    model.stopTalking()
                }else if oldStage == .notRunning && newStage == .listening{
                    model.startTalking()
                }
            }
            .toolbar(){
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.save()
                        self.model.dialog = Dialog()
                    }) {
                        Image(systemName: "plus")
                    }
                    .font(.title)
                }
            }
            .onDisappear(){
                print("translateview disappear")
                self.save()
                self.model.stage = .notRunning
                self.model.errorString = ""
            }
            .onChange(of: scenePhase){
                if scenePhase == .inactive || scenePhase == .background{
                    self.save()
                    self.model.stage = .notRunning
                    self.model.errorString = ""
                }
            }.sheet(isPresented: $errorHappened){
                PermissionDeniedView(errorString: model.errorString)
            }.onReceive(Just(model.errorString)){_ in
                self.errorHappened = !model.errorString.isEmpty
            }
        }
    }
    
    private func save(){
        if !model.dialog.messages.isEmpty{
            modelContext.insert(model.dialog)
        }
    }
}

struct PermissionDeniedView: View {
    var errorString: String
    
    var body: some View {
        VStack {
            if errorString.contains("microphone"){
                Text("Microphone Access Required")
                    .font(.title)
                Text("To provide live audio translation, our app requires access to your microphone. Please grant permission in settings.")
                    .padding()
                Button("Open Settings") {
                    openAppSettings()
                }
                
            }else{
                Text(errorString)
                Button("Open Settings"){
                    openAppSettings()
                }
            }
        }
        .padding()
    }
    
    func openAppSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Dialog.self, configurations: config)
        let dialog = Dialog.sample

        return DialogView(dialog: dialog)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}

#Preview(){
    LanguagePicker(language: .constant(Language.Chinese.code))
}

#Preview(){
    ControlsView(profile: Profile.shared, stage: .constant(.notRunning))
}

#Preview(){
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Dialog.self, configurations: config)

        return TranslateView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}

extension TranslateViewModel{
    static var sample: TranslateViewModel{
        let model = TranslateViewModel()
        model.dialog = Dialog.sample
        model.profile = Profile.shared
        return model
    }
}

extension Dialog{
    static var sample : Dialog{
        let dialog = Dialog()
        dialog.append(Message(left: LanguageAndText("zh", "今天天气不错"), right: LanguageAndText("en", "the weather is nice"), putOn: .left))
        dialog.append(Message(left: LanguageAndText("en", "How about you?"), right: LanguageAndText("zh", "你怎么样?"), putOn: .right))
        return dialog
    }
}
