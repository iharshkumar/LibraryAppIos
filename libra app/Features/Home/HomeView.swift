import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {

                // Title
                Text("Discover Books")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField(
                        "Search by title, author, or subject",
                        text: $vm.searchText
                    )
                    .textInputAutocapitalization(.none)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)

                // Filters
                FilterChips(selected: $vm.selectedFilter)

                // Books
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(vm.filteredBooks) { book in
                            BookCardView(book: book)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .animation(.spring(), value: vm.filteredBooks)
        }
    }
}
