import Foundation

protocol ChatStorage {
    func saveMessages(_ messages: [Message])
    func loadMessages() -> [Message]
    func clearMessages()
}

final class ChatPersistence: ChatStorage {
    
    private let key = "user_chat_messages"
    
    func saveMessages(_ messages: [Message]) {
        guard let data = try? JSONEncoder().encode(messages) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func clearMessages() {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func loadMessages() -> [Message] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let messages = try? JSONDecoder().decode([Message].self, from: data) else {
            return []
        }
        return messages
    }
}

