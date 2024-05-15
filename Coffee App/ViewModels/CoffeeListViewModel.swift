//
//  CoffeeListView.swift
//  Coffee App
//
//  Created by Kas Eelman on 24/04/2024.
//

import Foundation
import FirebaseFirestore

// view model for list of items in main page

class CoffeeListViewModel: ObservableObject{
    
    @Published var showingNewItemView = false
    
    private let userId:String
    
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
    
}
