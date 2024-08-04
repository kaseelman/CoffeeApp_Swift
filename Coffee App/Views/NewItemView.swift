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
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
            case coffeeName, roasterName, grindSetting, brewWeight, coffeeYield, brewTime
        }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Coffee Details")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        // Coffee Name
                        InputField(title: "Coffee Name", text: $viewModel.title)
                            .focused($focusedField, equals: .coffeeName)
                        // Roaster Name
                        InputField(title: "Roaster Name", text: $viewModel.roasterName)
                            
                        // Roasted Date
                        CustomDatePicker(title: "Roasted Date", selection: $viewModel.roastedDate)
                            .focused($focusedField, equals: .roasterName)
                        // Open Date
                        CustomDatePicker(title: "Open Date", selection: $viewModel.openDate)
                        
                        Text("Brew Information")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        // Grind Setting
                        InputField(title: "Grind Setting", text: $viewModel.grindSetting)
                            .focused($focusedField, equals: .grindSetting)
                        // Brew Weight
                        InputField(title: "Brew Weight (g)", text: $viewModel.brewWeight)
                            .focused($focusedField, equals: .brewWeight)
                        // Coffee Yield
                        InputField(title: "Coffee Yield (g)", text: $viewModel.coffeeYield)
                            .focused($focusedField, equals: .coffeeYield)
                        // Brew Time
                        InputField(title: "Brew Time", text: $viewModel.brewTime)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Add Coffee")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if viewModel.canSave {
                            viewModel.save()
                            dismiss()
                        } else {
                            viewModel.showAlert = true
                        }
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text("Please fill in all fields"))
        }
    }
}

struct CustomDatePicker: View {
    let title: String
    @Binding var selection: Date
    @State private var showPicker = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(Color.gray.opacity(0.7))
            
            Button(action: {
                showPicker = true
            }) {
                Text(selection, style: .date)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(hex: "3E3E40"))
                    .cornerRadius(8)
            }
        }
        .sheet(isPresented: $showPicker) {
            if #available(iOS 16.4, *) {
                VStack {
                    DatePicker("", selection: $selection, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .accentColor(.blue)
                        .padding()
                    
                    Button("Done") {
                        showPicker = false
                    }
                    .padding()
                }
                .presentationDetents([.height(500)])
                .presentationBackground(Color(UIColor.systemBackground))
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

struct InputField: View {
    let title: String
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .foregroundColor(Color(hex: "88888E")) // New color for the label
            
            TextField("", text: $text)
                .padding()
                .background(Color(hex: "3E3E40"))
                .cornerRadius(8)
                .foregroundColor(.white)
                .accentColor(.blue)
                .focused($isFocused)
                .onTapGesture {
                    isFocused = true
                }
        }
    }
}
// Extension to create a Color from a hex string
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView(newItemPresented: .constant(true))
            .preferredColorScheme(.dark)
    }
}
