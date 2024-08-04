import SwiftUI

class CoffeeDetailViewModel: ObservableObject {
    @Published var coffee: CoffeeListItem
    
    init(coffee: CoffeeListItem) {
        self.coffee = coffee
    }
    
    func updateCoffee(_ updatedCoffee: CoffeeListItem) {
        self.coffee = updatedCoffee
    }
    
    func calculateRatio() -> String {
        guard let brewWeight = Double(coffee.brewWeight),
              let coffeeYield = Double(coffee.coffeeYield),
              brewWeight > 0 else {
            return "N/A"
        }
        let ratio = coffeeYield / brewWeight
        return String(format: "1:%.2f", ratio)
    }
    
    func delete(id: String) {
        // Implement delete functionality here
    }
}
