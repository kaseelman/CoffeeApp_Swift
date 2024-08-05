import Foundation
import FirebaseFirestore

class CoffeeListViewModel: ObservableObject {
    @Published var showingNewItemView = false
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    func delete(id: String) {
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("coffees")
            .document(id)
            .delete()
    }
    
    func toggleCoffeeStatus(coffee: CoffeeListItem) {
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("coffees")
            .document(coffee.id)
            .updateData(["isDone": !coffee.isDone])
    }
}
