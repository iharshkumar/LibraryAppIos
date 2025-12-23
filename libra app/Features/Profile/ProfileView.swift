import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ProfileHeaderView()
                    LibraryActivityView()

                    VStack(spacing: 0) {
                        ProfileOptionRow(icon: "bell", title: "Notifications")
                        Divider()
                        ProfileOptionRow(icon: "book", title: "Borrowing History")
                        Divider()
                        ProfileOptionRow(icon: "gearshape", title: "Settings")
                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)

                    LogoutButton()
                }
                .padding()
            }
            .navigationTitle("Profile")
        }
    }
}
