import SwiftUI

struct BookCardView: View {
    let book: Book

    var body: some View {
        HStack(spacing: 16) {
            Image(book.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 90)
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 6) {
                Text(book.title)
                    .font(.headline)

                Text(book.author)
                    .foregroundColor(.gray)
                    .font(.subheadline)

                HStack {
                    Text(book.category)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.15))
                        .foregroundColor(.blue)
                        .cornerRadius(8)

                    Spacer()

                    StatusBadge(status: book.status)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 8)
    }
}
