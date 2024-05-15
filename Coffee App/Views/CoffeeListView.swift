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
        NavigationView{
            VStack{
                List(items) { item in
                    CoffeeListItemView(item: item)
                        .swipeActions {
                            Button("Delete"){
                                // Delete Coffee
                                viewModel.delete(id: item.id)
                            }
                            .tint(.red)
                            
                        }
                }
                .listStyle(PlainListStyle())
                
            }
            .navigationTitle("Coffee Tracker")
            .toolbar{
                Button {
                    // Action
                    viewModel.showingNewItemView = true
                
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.showingNewItemView) {
                NewItemView(newItemPresented:
                                $viewModel.showingNewItemView)
                
                }
            
        }
    }
}

struct CoffeeListView_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeListView(userId: "nxSnz4NiiUT7qwUV50uR18hKX0L2")
    }
}
