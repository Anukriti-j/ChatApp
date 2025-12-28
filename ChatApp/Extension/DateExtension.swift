import Foundation

extension Date {
    func chatTime() -> String {
        self.formatted(date: .omitted, time: .shortened)
    }
}

extension Date {
    func isSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }

    func chatDateString() -> String {
        if Calendar.current.isDateInToday(self) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            return formatted(.dateTime.day().month().year())
        }
    }
}
