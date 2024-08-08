import SwiftUI

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewModel()
    @Binding var newItemPresented: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("COFFEE DETAILS").foregroundColor(.gray)) {
                    CustomInputField(title: "Coffee Name", text: $viewModel.title, placeholder: "Name")
                    CustomInputField(title: "Roaster Name", text: $viewModel.roasterName, placeholder: "Roaster")
                }
                
                Section(header: Text("DATES").foregroundColor(.gray)) {
                    CustomDatePicker(title: "Roasted Date", selection: $viewModel.roastedDate)
                    CustomDatePicker(title: "Open Date", selection: $viewModel.openDate)
                }
                
                Section(header: Text("BREW INFORMATION").foregroundColor(.gray)) {
                    CustomInputField(title: "Grind Setting", text: $viewModel.grindSetting, placeholder: "settings")
                    CustomInputField(title: "Brew Weight", text: $viewModel.brewWeight, placeholder: "grams")
                    CustomInputField(title: "Coffee Yield", text: $viewModel.coffeeYield, placeholder: "grams")
                    CustomInputField(title: "Brew Time", text: $viewModel.brewTime, placeholder: "seconds")
                }
            }
            .listStyle(.insetGrouped)
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
        .background(Color(hex: "1C1C1D")) // Sheet colour
        .edgesIgnoringSafeArea(.all) 
        .environment(\.colorScheme, .dark)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text("Please fill in all fields"))
        }
    }
}

struct CustomInputField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
            Spacer()
            TextField(placeholder, text: $text)
                .multilineTextAlignment(.trailing)
                .foregroundColor(.gray)
        }
    }
}


struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView(newItemPresented: .constant(true))
    }
}


// Hex Color function

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
