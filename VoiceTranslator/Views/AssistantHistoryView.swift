import SwiftUI

struct AssistantHistoryView: View {
    let dialog: AssistantDialog
    
    var body: some View {
        ScrollView(.vertical, showsIndicators:false){
            VStack{
                ForEach(dialog.messages, id: \.id){ message in
                    AssistantMessageView(message: message)
                }
            }
        }
        .navigationTitle(dialog.time.localDescription())
    }
}

#Preview {
    AssistantHistoryView(dialog: AssistantDialog.sample)
}
