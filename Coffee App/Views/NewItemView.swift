//
//  NewItemView.swift
//  Coffee App
//
//  Created by Kas Eelman on 24/04/2024.
//

import SwiftUI

struct NewItemView: View {
    
    @StateObject var viewModel = NewItemViewModel()
    @Binding var newItemPresented: Bool 
    
    var body: some View {
        VStack {
            Text("New Coffee")
                .font(.system(size:32))
                .bold()
                .padding(.top, 25)
            
            Form{
                // Title
                TextField("Coffee Name", text: $viewModel.title)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                // Open Date
                
                DatePicker("Open Date", selection: $viewModel.openDate)
                    .datePickerStyle(GraphicalDatePickerStyle())
            
                // Roaster Name
                
                
                // Grind Setting
                
                
                // Grind Time
                
                
                // Button
                CLButton(
                    title: "Save",
                    background: .blue
                ){
                    if  viewModel.canSave{
                        viewModel.save()
                        newItemPresented = false
                    }
                    else {
                    viewModel.showAlert = true
                    
                    }
                }
                
                
                } .padding()
                
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text( "Error"), message: Text("Please fill in all fields"))
            }
        }
    }
}

struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView(newItemPresented: Binding (get: {
            return true
        }, set :{ _ in
            
        }))
    }
}
