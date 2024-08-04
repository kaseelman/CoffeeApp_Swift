import SwiftUI

struct EditItemView: View {
    @StateObject private var viewModel: EditItemViewModel
    @Binding var isPresented: Bool
    @EnvironmentObject var detailViewModel: CoffeeDetailViewModel
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case coffeeName, roasterName, grindSetting, brewWeight, coffeeYield, brewTime
    }
    
    init(coffee: CoffeeListItem, isPresented: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: EditItemViewModel(coffee: coffee))
        self._isPresented = isPresented
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#1C1C1D").edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Coffee Details")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        InputField(title: "Coffee Name", text: $viewModel.title)
                            .focused($focusedField, equals: .coffeeName)
                        InputField(title: "Roaster Name", text: $viewModel.roasterName)
                            .focused($focusedField, equals: .roasterName)
                        CustomDatePicker(title: "Roasted Date", selection: $viewModel.roastedDate)
                        CustomDatePicker(title: "Open Date", selection: $viewModel.openDate)
                        
                        Text("Brew Information")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        InputField(title: "Grind Setting", text: $viewModel.grindSetting)
                            .focused($focusedField, equals: .grindSetting)
                        InputField(title: "Brew Weight (g)", text: $viewModel.brewWeight)
                            .focused($focusedField, equals: .brewWeight)
                        InputField(title: "Coffee Yield (g)", text: $viewModel.coffeeYield)
                            .focused($focusedField, equals: .coffeeYield)
                        InputField(title: "Brew Time", text: $viewModel.brewTime)
                            .focused($focusedField, equals: .brewTime)
                    }
                    .padding()
                }
            }
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
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text("Please fill in all fields"))
        }
    }
}

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
            isDone: false
        )
        
        // Update Firestore here
        
        return updatedCoffee
    }
}
