import SwiftUI

struct BorrowedBookCard: View {
    let record: BorrowRecord

    var body: some View {
        VStack(alignment: .leading) {
            Text(record.book.title)
                .font(.headline)

            Text("Due: \(record.dueDate.formatted(date: .abbreviated, time: .omitted))")
                .font(.caption)
                .foregroundColor(.red)
        }
    }
}
