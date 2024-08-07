import SwiftUI
import FirebaseFirestoreSwift

struct FavoritesView: View {
    @StateObject var viewModel: CoffeeListViewModel
    @FirestoreQuery var items: [CoffeeListItem]
    @Binding var selectedTab: Int
    
    init(userId: String, selectedTab: Binding<Int>) {
        self._items = FirestoreQuery(
            collectionPath: "users/\(userId)/coffees",
            predicates: [.where("isFavorite", isEqualTo: true)]
        )
        self._viewModel = StateObject(
            wrappedValue: CoffeeListViewModel(userId: userId))
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Search bar
                    searchBar
                        .padding(.top, 10)
                        .padding(.bottom, 14)
                        .padding(.horizontal)
                    
                    // List of favorite coffee items
                    List {
                        ForEach(filteredItems) { item in
                            NavigationLink(destination: CoffeeDetailView(coffee: item)) {
                                CoffeeListItemView(item: item)
                            }
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                // Unfavorite button
                                Button {
                                    viewModel.toggleFavorite(item: item)
                                } label: {
                                    Label("Unfavorite", systemImage: "star.slash")
                                }
                                .tint(.yellow)
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
                    Text("Favorites")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        selectedTab = 0
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(hex: "#88888E"))
            
            ZStack(alignment: .leading) {
                if viewModel.searchText.isEmpty {
                    Text("Search your favorites...")
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
    
    // MARK: - Filtered Items
    private var filteredItems: [CoffeeListItem] {
        if viewModel.searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.title.lowercased().contains(viewModel.searchText.lowercased()) }
        }
    }
}
