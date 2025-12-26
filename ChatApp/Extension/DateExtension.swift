import Foundation

extension Date {
    func chatTime() -> String {
        self.formatted(date: .omitted, time: .shortened)
    }
}
