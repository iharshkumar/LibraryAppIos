import SwiftUI

struct LoginView: View {
    
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Login")
                .font(.title)
                .bold()
            
            TextField("Email", text: .constant(""))
                .textFieldStyle(.roundedBorder)
            
            SecureField("Password", text: .constant(""))
                .textFieldStyle(.roundedBorder)
            
            Button("Continue") {
                print("Continue tapped")
                isLoggedIn = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $isLoggedIn){
            MainTabView()
        }
    }
}
