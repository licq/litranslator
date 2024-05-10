import SwiftUI
import SwiftData

struct AssistantHistoriesView: View {
    @State private var showingConfirmation = false
    @Query(sort: \AssistantDialog.time, order: .reverse) private var dialogs: [AssistantDialog]
    @Environment(\.modelContext) private var modelContext: ModelContext

    var body: some View {
        NavigationStack {
            List {
                ForEach(dialogs, id: \.time) { dialog in
                    NavigationLink(destination: AssistantHistoryView(dialog: dialog)) {
                       AssistantCardView(dialog: dialog)
                    }
                }
                .onDelete { indexSet in
                    for i in indexSet{
                        modelContext.delete(dialogs[i])
                    }
                }
            }
            .navigationBarTitle(LocalizedStringKey("histories.view.title"))
            .navigationBarItems(trailing:
                Button{
                    showingConfirmation = true
            } label: {
                    Text(LocalizedStringKey("histories.view.button.clear"))
                }
            )
            .alert(isPresented: $showingConfirmation) {
                Alert(
                    title: Text(LocalizedStringKey("histories.view.button.delete.all.title")),
                    message: Text(LocalizedStringKey("histories.view.button.delete.all.message")),
                    primaryButton: .default(Text(LocalizedStringKey("Yes"))) {
                        do{
                            try self.modelContext.delete(model: AssistantDialog.self)
                        }catch{
                            print("delete all failed \(error)")
                        }
                    },
                    secondaryButton: .cancel(Text(LocalizedStringKey("No")))
                )
            }
        }
    }
}

#Preview(){
    AssistantHistoriesView()
}
