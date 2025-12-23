import SwiftUI
struct WelcomeView: View {
    var body: some View { NavigationStack { VStack(spacing: 30) {
        Spacer() // Logo
        ZStack {
            Circle()
                .fill( LinearGradient( colors: [.blue, .cyan],
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                ).frame(width: 120, height: 120)
            
            Image(systemName: "book")
                .font(.system(size: 48))
                .foregroundColor(.white)
            Circle()
                .fill(Color.blue)
                .frame(width: 36, height: 36)
                .overlay( Image(systemName: "magnifyingglass")
                    .foregroundColor(.white) .font(.caption) )
                .offset(x: 45, y: 45)
        }
        
        // Title
        VStack(spacing: 8) {
            Text("Library Book Finder")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Find, Reserve & Track Books Easily")
                .foregroundColor(.gray)
        }
        
        // Get Started Button
        NavigationLink(destination:
                        LoginView()
        ) { Text("Get Started")
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(18)
        }
        
        .padding(.horizontal)
        
        // Features
        HStack(spacing: 30) {
            featureItem("magnifyingglass", "Easy Search", .blue)
            featureItem("book", "Quick Reserve", .green)
            featureItem("books.vertical", "Track Books", .purple) }
        Spacer()
    }
    .padding()
    }
        
    }
    
    func featureItem(_ icon: String, _ title: String, _ color: Color) -> some View { VStack(spacing: 8) { Image(systemName: icon) .foregroundColor(color) .padding() .background(color.opacity(0.15)) .clipShape(Circle())
        Text(title)
            .font(.caption)
            .foregroundColor(.gray)
    }
}
}
