//import SwiftUI
//
//struct LoginView: View {
//    
//    // State variables to hold text inputs and the visibility of password
//    @State private var username: String = ""
//    @State private var password: String = ""
//    @State private var showPassword: Bool = false
//    @State private var showAlert: Bool = false
//    
//    var body: some View {
//        VStack {
//            // Title
//            Text("Login")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .padding(.top, 50)
//            
//            // Spacer to push elements to the top of the screen
//            Spacer()
//
//            // Username field
//            TextField("Enter Username", text: $username)
//                .padding()
//                .background(Color.gray.opacity(0.1))
//                .cornerRadius(10)
//                .padding(.horizontal)
//                .autocapitalization(.none)
//                .disableAutocorrection(true)
//            
//            // Password field with show/hide toggle
//            HStack {
//                if showPassword {
//                    TextField("Enter Password", text: $password)
//                        .padding()
//                        .background(Color.gray.opacity(0.1))
//                        .cornerRadius(10)
//                        .padding(.horizontal)
//                        .autocapitalization(.none)
//                        .disableAutocorrection(true)
//                } else {
//                    SecureField("Enter Password", text: $password)
//                        .padding()
//                        .background(Color.gray.opacity(0.1))
//                        .cornerRadius(10)
//                        .padding(.horizontal)
//                        .autocapitalization(.none)
//                        .disableAutocorrection(true)
//                }
//
//                // Show/Hide password button
//                Button(action: {
//                    showPassword.toggle() // Toggle visibility of the password
//                }) {
//                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
//                        .foregroundColor(.gray)
//                }
//                .padding(.trailing)
//            }
//
//            // Login Button
//            Button(action: {
//                // Check if username or password is empty
//                if username.isEmpty || password.isEmpty {
//                    showAlert = true // Show the alert if fields are empty
//                } else {
//                    // Handle successful login (for now, just print)
//                    print("Login successful!")
//                }
//            }) {
//                Text("Login")
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .frame(width: 250, height: 50)
//                    .background(Color.blue)
//                    .cornerRadius(10)
//                    .padding()
//            }
//            .alert(isPresented: $showAlert) {
//                Alert(
//                    title: Text("Error"),
//                    message: Text("Please fill in both username and password."),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
//            
//            Spacer()
//
//            // Optional: Links for SignUp and Forgot Password (just for structure)
//            HStack {
//                Button("Sign Up") {
//                    // Add action for sign-up here
//                }
//                .foregroundColor(.blue)
//                
//                Spacer()
//                
//                Button("Forgot Password") {
//                    // Add action for forgot password here
//                }
//                .foregroundColor(.blue)
//            }
//            .padding(.horizontal)
//        }
//        .padding()
//    }
//}
//
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
