import SwiftUI
import FirebaseFirestoreSwift

struct CoffeeListView: View {
    @StateObject var viewModel: CoffeeListViewModel
    @FirestoreQuery var items: [CoffeeListItem]
    
    init(userId: String) {
        self._items = FirestoreQuery(
            collectionPath: "users/\(userId)/coffees"
        )
        self._viewModel = StateObject(
            wrappedValue: CoffeeListViewModel(userId: userId))
        
        // Customize list appearance
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                List {
                    ForEach(items) { item in
                        NavigationLink(destination: CoffeeDetailView(coffee: item)) {
                            CoffeeListItemView(item: item)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .swipeActions {
                            Button("Delete") {
                                viewModel.delete(id: item.id)
                            }
                            .tint(.red)
                        }
                        
                        // Spacer row
                        Color.clear
                            .frame(height: 12)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(PlainListStyle())
                .padding(.top, 20)
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
