//
//  NewItemViewModel.swift
//  Coffee App
//
//  Created by Kas Eelman on 24/04/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewItemViewModel: ObservableObject {
    @Published var title = ""
    @Published var roasterName = ""
    @Published var roastedDate = Date()
    @Published var openDate = Date() // Added this line
    @Published var grindSetting = ""
    @Published var brewWeight = ""
    @Published var coffeeYield = ""
    @Published var brewTime = ""
    @Published var showAlert = false
    
    init() {}
    
    func save() {
        guard canSave else {
            return
        }
        
        // Get current user ID
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Create model
        let newId = UUID().uuidString
        let newItem = CoffeeListItem(
            id: newId,
            title: title,
            roasterName: roasterName,
            roastedDate: roastedDate.timeIntervalSince1970,
            openDate: openDate.timeIntervalSince1970, // Added this line
            grindSetting: grindSetting,
            brewWeight: brewWeight,
            coffeeYield: coffeeYield,
            brewTime: brewTime,
            createdDate: Date().timeIntervalSince1970,
            isDone: false
        )
        
        // Save model to database
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("coffees")
            .document(newId)
            .setData(newItem.asDictionary())
    }
    
    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !roasterName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !grindSetting.trimmingCharacters(in: .whitespaces).isEmpty &&
        !brewWeight.trimmingCharacters(in: .whitespaces).isEmpty &&
        !coffeeYield.trimmingCharacters(in: .whitespaces).isEmpty &&
        !brewTime.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
