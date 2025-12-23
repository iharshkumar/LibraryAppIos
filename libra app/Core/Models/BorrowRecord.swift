import Foundation

struct BorrowRecord: Identifiable {
    let id = UUID()
    let book: Book
    let issueDate: Date
    let dueDate: Date
    let isReturned: Bool
}
