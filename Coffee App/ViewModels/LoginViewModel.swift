//
//  LoginViewModel.swift
//  Coffee App
//
//  Created by Kas Eelman on 24/04/2024.
//
import FirebaseAuth
import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""

    // @State when the view changes it will render any changes as a result of state changes. Published does the same but for a slightly different use case. 
    
    init() {}
    
    func login() {
        guard validate () else {
            return
        }
        
    // try log in
    Auth.auth().signIn(withEmail: email, password: password)
        
    }
    
   private func validate () -> Bool {
       errorMessage = ""
       guard !email.trimmingCharacters(in:.whitespaces).isEmpty,
             !password.trimmingCharacters(in:.whitespaces).isEmpty else {
           errorMessage = "Please fill in all fields"
           return false
       }
       
       guard email.contains("@") && email.contains (".") else {
           errorMessage = "Please enter valid email!"
           return false
       }
       
       return true
        
    }
}
