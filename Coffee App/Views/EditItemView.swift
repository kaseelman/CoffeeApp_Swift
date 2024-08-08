import SwiftUI

struct EditItemView: View {
    @StateObject private var viewModel: EditItemViewModel
    @Binding var isPresented: Bool
    @EnvironmentObject var detailViewModel: CoffeeDetailViewModel
    
    init(coffee: CoffeeListItem, isPresented: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: EditItemViewModel(coffee: coffee))
        self._isPresented = isPresented
    }
    
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
                    Text("Edit Coffee")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(.blue)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if viewModel.canSave {
                            let updatedCoffee = viewModel.save()
                            detailViewModel.updateCoffee(updatedCoffee)
                            isPresented = false
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


struct CustomDatePicker: View {
    let title: String
    @Binding var selection: Date
    @State private var showPicker = false
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Text(selection, style: .date)
                .foregroundColor(.gray)
        }
        .onTapGesture {
            showPicker = true
        }
        .sheet(isPresented: $showPicker) {
            if #available(iOS 16.4, *) {
                VStack {
                    DatePicker("", selection: $selection, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .colorScheme(.dark)
                        .padding()
                    
                    Button("Done") {
                        showPicker = false
                    }
                    .padding()
                    .foregroundColor(.blue)
                }
                .presentationDetents([.height(400)])
                .presentationBackground(Color(UIColor.systemBackground))
                .preferredColorScheme(.dark)
                .background(Color.black.edgesIgnoringSafeArea(.all))
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

// Updating the record in Firebase

class EditItemViewModel: ObservableObject {
    @Published var title: String
    @Published var roasterName: String
    @Published var roastedDate: Date
    @Published var openDate: Date
    @Published var grindSetting: String
    @Published var brewWeight: String
    @Published var coffeeYield: String
    @Published var brewTime: String
    @Published var showAlert = false
    
    private let coffeeId: String
    
    init(coffee: CoffeeListItem) {
        self.coffeeId = coffee.id
        self.title = coffee.title
        self.roasterName = coffee.roasterName
        self.roastedDate = Date(timeIntervalSince1970: coffee.roastedDate)
        self.openDate = Date(timeIntervalSince1970: coffee.openDate)
        self.grindSetting = coffee.grindSetting
        self.brewWeight = coffee.brewWeight
        self.coffeeYield = coffee.coffeeYield
        self.brewTime = coffee.brewTime
    }
    
    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !roasterName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !grindSetting.trimmingCharacters(in: .whitespaces).isEmpty &&
        !brewWeight.trimmingCharacters(in: .whitespaces).isEmpty &&
        !coffeeYield.trimmingCharacters(in: .whitespaces).isEmpty &&
        !brewTime.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func save() -> CoffeeListItem {
        let updatedCoffee = CoffeeListItem(
            id: coffeeId,
            title: title,
            roasterName: roasterName,
            roastedDate: roastedDate.timeIntervalSince1970,
            openDate: openDate.timeIntervalSince1970,
            grindSetting: grindSetting,
            brewWeight: brewWeight,
            coffeeYield: coffeeYield,
            brewTime: brewTime,
            createdDate: Date().timeIntervalSince1970,
            isDone: false,
            isFavorite: true
        )
        
        // Update Firestore here
        
        return updatedCoffee
    }
}

// Preview code
// Preview code
struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCoffee = CoffeeListItem(
            id: "123",
            title: "Sample Coffee",
            roasterName: "Sample Roaster",
            roastedDate: Date().timeIntervalSince1970,
            openDate: Date().timeIntervalSince1970,
            grindSetting: "9",
            brewWeight: "20g",
            coffeeYield: "40g",
            brewTime: "30s",
            createdDate: Date().timeIntervalSince1970,
            isDone: false,
            isFavorite: false
        )
        
        return EditItemView(coffee: sampleCoffee, isPresented: .constant(true))
            .environmentObject(CoffeeDetailViewModel(coffee: sampleCoffee))
            .preferredColorScheme(.dark)
    }
}
