//
//  NewItemViewModel.swift
//  Coffee App
//
//  Created by Kas Eelman on 24/04/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewItemViewModel: ObservableObject{
    
    @Published var title = ""
    @Published var openDate = Date()
    @Published var showAlert = false
    
    
    init () {}
    
    func save() {
        guard canSave else {
            return
        }
        
        // get current user ID
        guard let uId = Auth.auth().currentUser?.uid else{
            return
        }
        
        
        
        // Create model
        let newId = UUID().uuidString
        let newItem = CoffeeListItem(
            id: newId,
            title: title,
            openDate: openDate.timeIntervalSince1970,
            createdDate: Date().timeIntervalSince1970,
            isDone: false)
        
        // Save model to DB
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("coffees")
            .document(newId)
            .setData(newItem.asDictionary())
        
    }
    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else{
            return false
        }
        
        return true
    }
}
