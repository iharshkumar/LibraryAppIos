import SwiftUI

struct LibraryActivityView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("My Library Activity")
                .font(.headline)

            HStack(spacing: 16) {
                activityCard("8", "Books Borrowed", Color.blue.opacity(0.1))
                activityCard("2", "Active Requests", Color.green.opacity(0.1))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
    }

    func activityCard(_ value: String, _ title: String, _ color: Color) -> some View {
        VStack {
            Text(value).font(.title).bold()
            Text(title).font(.caption).foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color)
        .cornerRadius(16)
    }
}
