import Foundation

class HomeViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedFilter: BookStatus? = nil

    @Published var books: [Book] = [
        Book(
            title: "Introduction to Algorithms",
            author: "Thomas H. Cormen",
            category: "Computer Science",
            imageName: "algo",
            status: .available
        ),
        Book(
            title: "Clean Code",
            author: "Robert C. Martin",
            category: "Software Engineering",
            imageName: "cleancode",
            status: .available
        ),
        Book(
            title: "The Art of War",
            author: "Sun Tzu",
            category: "Philosophy",
            imageName: "artofwar",
            status: .borrowed
        ),
        Book(
            title: "Sapiens",
            author: "Yuval Noah Harari",
            category: "History",
            imageName: "sapiens",
            status: .available
        ),
        Book(
            title: "Sapiens",
            author: "Yuval Noah Harari",
            category: "History",
            imageName: "sapiens",
            status: .available
        ),
        Book(
            title: "Sapiens",
            author: "Yuval Noah Harari",
            category: "History",
            imageName: "sapiens",
            status: .available
        ),
        Book(
            title: "Sapiens",
            author: "Yuval Noah Harari",
            category: "History",
            imageName: "sapiens",
            status: .available
        ),
        Book(
            title: "Sapiens",
            author: "Yuval Noah Harari",
            category: "History",
            imageName: "sapiens",
            status: .reserved
        )
    ]

    var filteredBooks: [Book] {
        books.filter { book in
            (selectedFilter == nil || book.status == selectedFilter) &&
            (searchText.isEmpty ||
             book.title.localizedCaseInsensitiveContains(searchText) ||
             book.author.localizedCaseInsensitiveContains(searchText))
        }
    }
}
