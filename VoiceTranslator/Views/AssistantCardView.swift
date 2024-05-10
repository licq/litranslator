import SwiftUI

struct AssistantCardView: View {
    var dialog: AssistantDialog
    
    var body: some View {
        VStack(alignment: .leading){
            Text(dialog.time.localDescription())
                .font(.title2)
                .bold()
            
            if !dialog.messages.isEmpty{
                Text(dialog.messages[0].content)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    AssistantCardView(dialog: AssistantDialog.sample)
}
