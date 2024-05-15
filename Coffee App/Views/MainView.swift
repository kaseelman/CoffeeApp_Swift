//
//  ContentView.swift
//  Coffee App
//
//  Created by Kas Eelman on 23/04/2024.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty{
            // signed in state
            accountView
        } else {
            LoginView()
        }
     }
    
    @ViewBuilder
    var accountView: some View {
        TabView{
            CoffeeListView(userId:viewModel.currentUserId)
            
                .tabItem{
                    Label("Home", systemImage: "house")
                }
            ProfileView()
                .tabItem{
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
