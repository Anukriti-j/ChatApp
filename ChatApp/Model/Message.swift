import Foundation

enum Sender: String, Codable {
    case user
    case bot
}

enum MessageStatus: Codable {
    case sending
    case sent
    case failed
}

struct Message: Identifiable, Codable {
    let id: UUID
    let text: String
    let sender: Sender
    let timestamp: Date
    var messageStatus: MessageStatus
}
