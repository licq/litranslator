import SwiftUI

struct TranslateHistoryView: View {
    let dialog: Dialog
    
    var body: some View {
        ScrollView(.vertical, showsIndicators:false){
            VStack{
                ForEach(dialog.messages, id: \.id){ message in
                    TranslateMessageView(message: message)
                }
            }
        }
        .navigationTitle(dialog.time.localDescription())
        
    }
}

extension Date{
    func localDescription() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let localizedDate = dateFormatter.string(from: self)
        return localizedDate
    }
}

#Preview {
    TranslateHistoryView(dialog: Dialog.sample)
}
