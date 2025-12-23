import SwiftUI

struct LogoutButton: View {

    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = true

    var body: some View {
        Button {
            withAnimation {
                isLoggedIn = false   // 🔥 LOGOUT
            }
        } label: {
            HStack {
                Image(systemName: "arrow.right.square")
                Text("Logout")
                    .fontWeight(.semibold)
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red.opacity(0.12))
            .cornerRadius(16)
        }
    }
}
