import SwiftUI

struct MessageBubbleView: View {
    let message: Message
    let retryAction: () -> Void?
    
    var body: some View {
        HStack {
            if message.sender == .user { Spacer() }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .bottom) {
                    Text(message.text)
                        .multilineTextAlignment(.leading)
//                        
//                    Spacer()
                    Text("\(message.timestamp.chatTime())")
                        .font(.caption2)
                }
            }
            .padding(12)
            .background(message.sender == .user ? Color.blue : Color.gray.opacity(0.3) )
            .foregroundColor(message.sender == .user ? Color.white : Color.black)
            .cornerRadius(16)
            
            statusView
            
            if message.sender == .bot { Spacer() }
        }
    }
    
    @ViewBuilder
    private var statusView: some View {
        switch message.messageStatus {
        case .sending:
            Text("Sending...")
                .font(.caption)
                .foregroundStyle(.gray)
        case .failed:
            Button {
                retryAction()
            } label: {
                Text("Retry")
            }
            .font(.caption)
            .foregroundStyle(.red)
            
        case .sent:
            EmptyView()
        }
    }
}

//#Preview {
//    MessageBubbleView(message: Message(id: UUID(), text: "hello Anukriti", sender: .bot, timestamp: Date(), messageStatus: .sent), retryAction: () -> Void)
//}
