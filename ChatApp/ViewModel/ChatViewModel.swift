import Foundation
import Combine

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isTyping = false
    
    private let storage: ChatStorage
    
    init() {
        self.storage = ChatPersistence()
        self.messages = storage.loadMessages()
    }
    
    func sendMessage(text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        let message = Message(
            id: UUID(),
            text: trimmedText,
            sender: .user,
            timestamp: Date(),
            messageStatus: .sending
        )
        
        messages.append(message)
        storage.saveMessages(messages)
        
        simulateSending(message: message)
    }
    
    func simulateSending(message: Message) {
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            if Bool.random() {
                updateStatus(id: message.id, messageStatus: .sent)
                await simulateBotReply()
            } else {
                updateStatus(id: message.id, messageStatus: .failed)
            }
            storage.saveMessages(messages)
        }
    }
    
    private func simulateBotReply() async {
        isTyping = true
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let reply = Message(
            id: UUID(),
            text: "Simulated bot reply",
            sender: .bot,
            timestamp: Date(),
            messageStatus: .sent
        )
        
        messages.append(reply)
        isTyping = false
    }
    
    func retry(message: Message) {
        updateStatus(id: message.id, messageStatus: .sending)
        simulateSending(message: message)
    }
    
    private func updateStatus(id: UUID, messageStatus: MessageStatus) {
        if let index = messages.firstIndex(where: { $0.id == id }) {
            messages[index].messageStatus = messageStatus
        }
        storage.saveMessages(messages)
    }
    
    func clearChat() {
        storage.clearMessages()
        messages = []
    }
}
