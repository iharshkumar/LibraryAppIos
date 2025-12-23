import Foundation

class MyBooksViewModel: ObservableObject {
    @Published var records: [BorrowRecord] = []

    init() {
        let book1 = Book(
            title: "Operating Systems",
            author: "Galvin",
            category: "Computer Science",
            imageName: "book.fill",
            status: .borrowed
        )

        let book2 = Book(
            title: "DBMS",
            author: "Korth",
            category: "Computer Science",
            imageName: "book.fill",
            status: .available
        )

        records = [
            BorrowRecord(
                book: book1,
                issueDate: Date(),
                dueDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())!,
                isReturned: false
            ),
            BorrowRecord(
                book: book2,
                issueDate: Calendar.current.date(byAdding: .day, value: -30, to: Date())!,
                dueDate: Calendar.current.date(byAdding: .day, value: -15, to: Date())!,
                isReturned: true
            )
        ]
    }
}
