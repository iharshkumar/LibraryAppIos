import SwiftUI

struct SearchView: View {

    @State private var searchText: String = ""
    @State private var selectedDept: String = "All"

    let departments = ["All", "CS", "ECE", "ME", "CE"]

    let books: [SearchBook] = [
        SearchBook(title: "Introduction to Algorithms", author: "Cormen", dept: "CS"),
        SearchBook(title: "Clean Code", author: "Robert C. Martin", dept: "CS"),
        SearchBook(title: "Digital Electronics", author: "Morris Mano", dept: "ECE"),
        SearchBook(title: "Signals & Systems", author: "Oppenheim", dept: "ECE"),
        SearchBook(title: "Thermodynamics", author: "Cengel", dept: "ME"),
        SearchBook(title: "Structural Analysis", author: "C.S Reddy", dept: "CE")
    ]

    var filteredBooks: [SearchBook] {
        books.filter {
            (selectedDept == "All" || $0.dept == selectedDept) &&
            (searchText.isEmpty ||
             $0.title.localizedCaseInsensitiveContains(searchText) ||
             $0.author.localizedCaseInsensitiveContains(searchText))
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                // 🔍 Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("Search books, authors, subjects", text: $searchText)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)

                // 🏷 Dept Filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(departments, id: \.self) { dept in
                            Text(dept)
                                .fontWeight(.medium)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    selectedDept == dept
                                    ? Color.blue
                                    : Color(.systemGray5)
                                )
                                .foregroundColor(
                                    selectedDept == dept
                                    ? .white
                                    : .gray
                                )
                                .cornerRadius(20)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        selectedDept = dept
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                }

                // 📚 Search Results
                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(filteredBooks) { book in
                            searchCard(book)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .navigationTitle("Search")
        }
    }

    // MARK: - Book Card
    func searchCard(_ book: SearchBook) -> some View {
        HStack(spacing: 14) {
            Image(systemName: "book.fill")
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 50, height: 60)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.headline)

                Text(book.author)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(book.dept)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.blue.opacity(0.15))
                    .foregroundColor(.blue)
                    .cornerRadius(6)
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.05), radius: 6)
    }
}


struct SearchBook: Identifiable {
    let id = UUID()
    let title: String
    let author: String
    let dept: String
}
