import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {

            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            ScannerView()
                .tabItem {
                    Label("Scan", systemImage: "barcode.viewfinder")
                }

            MyBooksView()
                .tabItem {
                    Label("My Books", systemImage: "books.vertical")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

#Preview {
    WelcomeView()
}
