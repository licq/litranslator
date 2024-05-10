import SwiftUI
import SwiftData

struct AssistantDialogView: View{
    @Bindable var dialog: AssistantDialog
    
    var body: some View{
        VStack{
            ScrollViewReader{proxy in
                ScrollView(.vertical, showsIndicators:false){
                    LazyVStack{
                        ForEach(dialog.messages, id: \.id){ message in
                            AssistantMessageView(message: message)
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

struct AssistantToggleButton: View{
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

struct AssistantView: View {
    @StateObject private var model: AssistantViewModel = AssistantViewModel()
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Environment(\.scenePhase) private var scenePhase: ScenePhase
    
    var body: some View {
        NavigationStack {
            VStack{
                AssistantDialogView(dialog: model.dialog)
                AssistantToggleButton(stage: $model.stage)
            }
            .navigationTitle(LocalizedStringKey("Translate"))
            .navigationBarTitleDisplayMode(.large)
            .onChange(of: model.stage){oldStage, newStage in
                if oldStage != .notRunning && newStage == .notRunning{
                    model.stopTalking()
                }else if oldStage == .notRunning && newStage == .listening{
                    model.startTalking()
                }
            }
            .toolbar(){
                ToolbarItemGroup(placement: .navigationBarTrailing) { // Top right placement
                    Button(action: {
                        self.save()
                        model.dialog = AssistantDialog()
                    }) {
                        Image(systemName: "plus") // Restart icon
                    }
                    .font(.title)
                }
            }
            .onDisappear(){
                self.save()
                self.model.stage = .notRunning
            }
            .onChange(of: scenePhase){
                if scenePhase == .inactive || scenePhase == .background{
                    self.save()
                    self.model.stage = .notRunning
                }
            }
        }
    }
    
    private func save(){
        if !model.dialog.messages.isEmpty{
            modelContext.insert(model.dialog)
        }
    }
}

#Preview {
    AssistantDialogView(dialog: AssistantDialog.sample)
}

#Preview(){
    AssistantView().environmentObject(AssistantViewModel.sample)
}

extension AssistantViewModel{
    static var sample: AssistantViewModel{
        let model = AssistantViewModel()
        model.dialog = AssistantDialog.sample
        return model
    }
}

extension AssistantDialog{
    static var sample : AssistantDialog{
        let dialog = AssistantDialog()
        dialog.append(AssistantMessage(content: "今天天气不错", role: .user))
        dialog.append(AssistantMessage(content: "你的心情也不错", role: .assistant))
        return dialog
    }
}
