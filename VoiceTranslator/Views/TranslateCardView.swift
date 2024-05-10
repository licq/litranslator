import SwiftUI

struct TranslateCardView: View {
    var dialog: Dialog
    
    var body: some View {
        VStack(alignment: .leading){
            Text(dialog.time.localDescription())
                .font(.title2)
                .bold()
            
            if !dialog.messages.isEmpty{
                Text(dialog.messages[0].left.text)
                Text(dialog.messages[0].right.text)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    TranslateCardView(dialog: Dialog.sample)
}
