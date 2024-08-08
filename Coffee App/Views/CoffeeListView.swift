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
        
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    searchBar
                        .padding(.top, 10)
                        .padding(.horizontal)
                    
                    customSegmentedControl
                        .padding(.top, 18)
                        .padding(.bottom, 22)
                    
                    if filteredItems.isEmpty {
                        emptyStateView
                    } else {
                        List {
                            ForEach(filteredItems) { item in
                                NavigationLink(destination: CoffeeDetailView(coffee: item)) {
                                    CoffeeListItemView(item: item)
                                }
                                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
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
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                    Button {
                                        viewModel.toggleFavorite(item: item)
                                    } label: {
                                        Label(item.isFavorite ? "Unfavorite" : "Favorite", systemImage: item.isFavorite ? "star.slash" : "star.fill")
                                    }
                                    .tint(.yellow)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.black)
                    }
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
    
    private var emptyStateView: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Image("EmptyState")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                
                Text("Nothing to see here, add a coffee to get started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .background(Color.black)
    }
    
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
    
    private var filteredItems: [CoffeeListItem] {
        viewModel.filteredItems(items, selectedTab: selectedTab)
    }
}

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

struct CoffeeListView_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeListView(userId: "nxSnz4NiiUT7qwUV50uR18hKX0L2")
    }
}
