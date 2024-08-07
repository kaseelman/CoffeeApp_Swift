import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        Group {
            if !viewModel.currentUserId.isEmpty {
                // User is signed in (anonymously)
                accountView
            } else {
                // Show a loading view or splash screen while signing in anonymously
                ProgressView("Warming up...")
            }
        }
    }
    
    @ViewBuilder
    var accountView: some View {
        TabView(selection: $selectedTab) {
            CoffeeListView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("Brew Log", systemImage: "list.bullet")
                }
                .tag(0)
            
            FavoritesView(userId: viewModel.currentUserId, selectedTab: $selectedTab)
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
                .tag(1)
            
            SettingsView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
