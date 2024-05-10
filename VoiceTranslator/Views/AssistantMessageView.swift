import SwiftUI

struct AssistantMessageView: View{
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    var message: AssistantMessage
    
    var body: some View {
        HStack {
            if alignRight {
                Spacer()
            }
            VStack(alignment: .leading) {
                Text(message.content)
                    .font(.title3)
                    .foregroundStyle(.blue)
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
        message.role == .user
    }
}

#Preview {
    AssistantMessageView(message: AssistantMessage.sample)
}

extension AssistantMessage{
    static var sample: AssistantMessage{
        AssistantMessage(content:"今天刷牙了没有？", role: .user)
    }
}
