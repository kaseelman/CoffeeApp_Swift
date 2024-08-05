import SwiftUI
import FirebaseFirestoreSwift

struct CoffeeListView: View {
    @StateObject var viewModel: CoffeeListViewModel
    @FirestoreQuery var items: [CoffeeListItem]
    @State private var selectedTab: Int = 0
    
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
                
                VStack(spacing: 0) {
                    customSegmentedControl
                        .padding(.top, 18)
                        .padding(.bottom, 22)// Add more padding to shift it down
                    
                    List {
                        ForEach(filteredItems) { item in
                            NavigationLink(destination: CoffeeDetailView(coffee: item)) {
                                CoffeeListItemView(item: item)
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button {
                                    viewModel.delete(id: item.id)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                                
                                Button {
                                    viewModel.toggleCoffeeStatus(coffee: item)
                                } label: {
                                    if selectedTab == 0 {
                                        Label("Finish", systemImage: "checkmark.circle")
                                    } else {
                                        Label("Re-open", systemImage: "arrow.counterclockwise.circle")
                                    }
                                }
                                .tint(selectedTab == 0 ? .green : .blue)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.black)
                }
            }
            .background(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("All Coffees")
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
    
    private var customSegmentedControl: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                ForEach(0..<2) { index in
                    VStack(spacing: 4) {
                        Text(index == 0 ? "Opened" : "Finished")
                            .font(.headline)
                            .foregroundColor(selectedTab == index ? .white : .gray)
                        
                        ZStack {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 6)
                            
                            if selectedTab == index {
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(height: 2)
                                    .padding(.top,4)
                                    .matchedGeometryEffect(id: "underline", in: namespace)
                            }
                        }
                    }
                    .frame(width: 100)
                    .onTapGesture {
                        withAnimation {
                            selectedTab = index
                        }
                    }
                }
                Spacer()
            }
            .padding(.leading, 20)
            
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
        }
    }
    
    @Namespace private var namespace
    
    private var filteredItems: [CoffeeListItem] {
        items.filter { item in
            selectedTab == 0 ? !item.isDone : item.isDone
        }
    }
}

struct CoffeeListView_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeListView(userId: "nxSnz4NiiUT7qwUV50uR18hKX0L2")
    }
}
