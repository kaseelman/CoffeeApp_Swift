import Foundation
import FirebaseFirestore

class CoffeeListViewModel: ObservableObject {
    @Published var showingNewItemView = false
    @Published var showingDeleteAlert = false
    @Published var itemToDelete: String?
    @Published var searchText = ""
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    func delete(id: String) {
        itemToDelete = id
        showingDeleteAlert = true
    }
    
    func confirmDelete() {
        guard let id = itemToDelete else { return }
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("coffees")
            .document(id)
            .delete()
        
        itemToDelete = nil
    }
    
    func toggleCoffeeStatus(coffee: CoffeeListItem) {
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("coffees")
            .document(coffee.id)
            .updateData(["isDone": !coffee.isDone])
    }
    
    func filteredItems(_ items: [CoffeeListItem], selectedTab: Int) -> [CoffeeListItem] {
        items.filter { item in
            let matchesTab = selectedTab == 0 ? !item.isDone : item.isDone
            let matchesSearch = self.searchText.isEmpty ||
                item.title.lowercased().contains(self.searchText.lowercased()) ||
            (item.roasterName.lowercased().contains(self.searchText.lowercased()) ?? false)
            return matchesTab && matchesSearch
        }
    }
    
    func countItems(_ items: [CoffeeListItem], isDone: Bool) -> Int {
        items.filter { $0.isDone == isDone }.count
    }
}
