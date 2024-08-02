//
//  LoginView.swift
//  Coffee App
//
//  Created by Kas Eelman on 24/04/2024.
//

import SwiftUI

   
struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()

    var body: some View {
        NavigationView{
            VStack{
                //header
                HeaderView(title: "Coffee Grind Tracker", subtitle: "Keep track of your coffees", angle: 0, background: .blue)
                
                // login form
                
                
                Form {
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(Color.red)
                    }
                    
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    CLButton(title: "Login",
                             background: .blue)
                    {
                        viewModel.login()
                    }
                    
                }
                
                // create account
                
                VStack{
                    Text("New Around Here?")
                    NavigationLink("Create an Account",
                                   destination: RegisterView())
                    
                        // Show Registration
                }
                .padding(.bottom,30)
                Spacer()
            }
        }
    }
        }

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
