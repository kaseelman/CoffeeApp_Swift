import SwiftUI
import FirebaseFirestoreSwift

struct CoffeeListView: View {
    @StateObject var viewModel: CoffeeListViewModel
    @FirestoreQuery var items: [CoffeeListItem]
    @State private var selectedTab: Int = 0
    
    init(userId: String) {
        // Initialize FirestoreQuery with the correct path
        self._items = FirestoreQuery(
            collectionPath: "users/\(userId)/coffees"
        )
        // Initialize the view model
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
                    // Search bar
                    searchBar
                        .padding(.top, 10)
                        .padding(.horizontal)
                    
                    // Custom segmented control
                    customSegmentedControl
                        .padding(.top, 18)
                        .padding(.bottom, 22)
                    
                    // List of coffee items
                    List {
                        ForEach(filteredItems) { item in
                            NavigationLink(destination: CoffeeDetailView(coffee: item)) {
                                CoffeeListItemView(item: item)
                            }
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                // Delete button
                                Button {
                                    viewModel.delete(id: item.id)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                                
                                // Toggle status button
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
        .alert("Delete Coffee", isPresented: $viewModel.showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.confirmDelete()
            }
        } message: {
            Text("Are you sure you want to delete this coffee? This action cannot be undone.")
        }
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(hex: "#88888E"))
            
            ZStack(alignment: .leading) {
                if viewModel.searchText.isEmpty {
                    Text("Search coffees...")
                        .foregroundColor(Color(hex: "#88888E"))
                }
                TextField("", text: $viewModel.searchText)
                    .foregroundColor(.white)
            }
            
            if !viewModel.searchText.isEmpty {
                Button(action: {
                    viewModel.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(hex: "#88888E"))
                }
            }
        }
        .padding(8)
        .background(Color(hex: "#1C1C1D"))
        .cornerRadius(10)
    }

    // MARK: - Custom Segmented Control
    private var customSegmentedControl: some View {
            VStack(spacing: 0) {
                HStack(spacing: 40) {
                    ForEach(0..<2) { index in
                        VStack(spacing: 4) {
                            HStack(spacing: 8) {
                                Text(index == 0 ? "Opened" : "Finished")
                                    .font(.headline)
                                    .foregroundColor(selectedTab == index ? .white : .gray)
                                
                                CountIndicator(
                                    count: viewModel.countItems(items, isDone: index == 1),
                                    isSelected: selectedTab == index
                                )
                            }
                            .padding(.horizontal, 0)
                            .frame(height: 30)
                            
                            ZStack {
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(height: 6)
                                
                                if selectedTab == index {
                                    Rectangle()
                                        .fill(Color.blue)
                                        .frame(height: 2)
                                        .padding(.top, 4)
                                        .matchedGeometryEffect(id: "underline", in: namespace)
                                }
                            }
                        }
                        .frame(minWidth: 100)
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
    
    // MARK: - Filtered Items
    private var filteredItems: [CoffeeListItem] {
        viewModel.filteredItems(items, selectedTab: selectedTab)
    }
}

// MARK: - Count Indicator
struct CountIndicator: View {
    let count: Int
    let isSelected: Bool
    
    var body: some View {
        Text("\(count)")
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color(hex: "#98989E").opacity(isSelected ? 1.0 : 0.4))
            .cornerRadius(6)
    }
}

// MARK: - Preview
struct CoffeeListView_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeListView(userId: "nxSnz4NiiUT7qwUV50uR18hKX0L2")
    }
}
