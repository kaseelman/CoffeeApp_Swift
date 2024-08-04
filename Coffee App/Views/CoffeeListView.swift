//
//  CoffeeListView.swift
//  Coffee App
//
//  Created by Kas Eelman on 25/04/2024.
//

import SwiftUI
import FirebaseFirestoreSwift

struct CoffeeListView: View {
    
    @StateObject var viewModel: CoffeeListViewModel
    @FirestoreQuery var items: [CoffeeListItem]
    
    
    init(userId: String) {
        //path for data in db used for list view users/<id>/coffees/<entries>
        self._items = FirestoreQuery(
            collectionPath: "users/\(userId)/coffees"
        )
        self._viewModel = StateObject(
            wrappedValue: CoffeeListViewModel(userId: userId))
        
        
    }
    
    var body: some View {
            NavigationView {
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 0) {
                        ScrollView {
                            LazyVStack(spacing: 32) {
                                ForEach(items) { item in
                                    CoffeeListItemView(item: item)
                                        .swipeActions {
                                            Button("Delete") {
                                                viewModel.delete(id: item.id)
                                            }
                                            .tint(.red)
                                        }
                                }
                            }
                            .padding()
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Brew Log")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.showingNewItemView = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .sheet(isPresented: $viewModel.showingNewItemView) {
                NewItemView(newItemPresented: $viewModel.showingNewItemView)
            }
        }
    }

struct CoffeeListView_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeListView(userId: "nxSnz4NiiUT7qwUV50uR18hKX0L2")
    }
}
