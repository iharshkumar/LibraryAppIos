import SwiftUI

struct MyBooksView: View {
    @StateObject private var vm = MyBooksViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section("Ongoing Books") {
                    ForEach(vm.records.filter { !$0.isReturned }) {
                        BorrowedBookCard(record: $0)
                    }
                }

                Section("History") {
                    ForEach(vm.records.filter { $0.isReturned }) {
                        BorrowedBookCard(record: $0)
                    }
                }
            }
            .navigationTitle("My Books")
        }
    }
}
