import SwiftUI

@main
struct libra_appApp: App {

    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    var body: some Scene {
        WindowGroup {
            MainTabView()
            
        }
    }
}
