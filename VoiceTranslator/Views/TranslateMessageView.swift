import SwiftUI

struct TranslateMessageView: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    var message: Message
    
    var body: some View {
        HStack {
            if alignRight {
                Spacer()
            }
            VStack(alignment: .leading) {
                Text(message.left.text)
                    .font(.title3)
                    .foregroundStyle(.blue)
                Text(message.right.text)
                    .font(.title3)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
            }
            .padding()
            .background(colorScheme == .dark ? Color.gray.opacity(0.6) : Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            if !alignRight {
                Spacer()
            }
        }
    }
    
    private var alignRight: Bool {
        message.putOn == .right
    }
}

#Preview {
    TranslateMessageView(message: Message.sample)
}

extension Message{
    static var sample: Message{
        Message(left: LanguageAndText("zh", "今天天气不错"), right: LanguageAndText("en", "the weather is ok"), putOn: .left)
    }
}
