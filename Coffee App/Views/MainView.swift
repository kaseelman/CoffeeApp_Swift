import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        Group {
            if !viewModel.currentUserId.isEmpty {
                // User is signed in (anonymously)
                accountView
            } else {
                // Show a loading view or splash screen while signing in anonymously
                ProgressView("Loading...")
            }
        }
    }
    
    @ViewBuilder
    var accountView: some View {
        TabView {
            CoffeeListView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("Brew Log", systemImage: "list.bullet")
                }
            
            FavoritesView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
