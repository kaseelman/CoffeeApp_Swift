import SwiftUI

struct CoffeeDetailView: View {
    @StateObject private var viewModel: CoffeeDetailViewModel
    @State private var showingEditView = false
    
    init(coffee: CoffeeListItem) {
        _viewModel = StateObject(wrappedValue: CoffeeDetailViewModel(coffee: coffee))
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Coffee Name and Roaster
                    VStack(alignment: .leading, spacing: 5) {
                        Text(viewModel.coffee.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text(viewModel.coffee.roasterName)
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "88888E"))
                    }
                    
                    Divider()
                        .background(Color.gray.opacity(0.3))
                        .padding(.vertical, 16)
                    
                    // Dates and Age
                    HStack(spacing: 20) {
                        dateView(title: "Roasted On", date: viewModel.coffee.roastedDate)
                        Spacer()
                        dateView(title: "Opened On", date: viewModel.coffee.openDate)
                        Spacer()
                        daysOpenedView(openDate: viewModel.coffee.openDate)
                    }
                    
                    Divider()
                        .background(Color.gray.opacity(0.3))
                        .padding(.vertical, 16)
                    
                    // Brew Information
                    Text("Brew Information")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        brewInfoView(icon: "Gear", title: "Grind Setting", value: viewModel.coffee.grindSetting)
                        brewInfoView(icon: "Time", title: "Brew Time", value: viewModel.coffee.brewTime)
                        brewInfoView(icon: "Scale", title: "Grams In", value: "\(viewModel.coffee.brewWeight)g")
                        brewInfoView(icon: "Scale", title: "Grams Out", value: "\(viewModel.coffee.coffeeYield)g")
                        brewInfoView(icon: "BrewRatio", title: "Brew Ratio", value: viewModel.calculateRatio())
                    }
                }
                .padding()
            }
        }
        .navigationBarTitle("Brew Details", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditView = true
                }
                .foregroundColor(.blue)
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditItemView(coffee: viewModel.coffee, isPresented: $showingEditView)
                .environmentObject(viewModel)
        }
    }
    
    private func dateView(title: String, date: TimeInterval) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(Color(hex: "88888E"))
            Text(Date(timeIntervalSince1970: date).formatted(date: .abbreviated, time: .omitted))
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
    
    private func daysOpenedView(openDate: TimeInterval) -> some View {
        let days = Calendar.current.dateComponents([.day], from: Date(timeIntervalSince1970: openDate), to: Date()).day ?? 0
        return VStack(alignment: .trailing, spacing: 5) {
            Text("Days Open")
                .font(.caption)
                .foregroundColor(Color(hex: "88888E"))
            Text("\(days)")
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
    
    private func brewInfoView(icon: String, title: String, value: String) -> some View {
           HStack(spacing: 10) {
              SVGIcon(name: icon)
                .foregroundColor(Color(hex: "2C2C2D"))
                .frame(width: 22, height: 22)
               
               VStack(alignment: .leading, spacing: 2) {
                   Text(title)
                       .font(.caption)
                       .foregroundColor(Color(hex: "2C2C2D"))
                   Text(value)
                       .font(.subheadline)
                       .fontWeight(.bold)
                       .foregroundColor(Color(hex: "181818"))
               }
               
               Spacer()
           }
           .padding(.horizontal, 10)
           .frame(width: 160, height: 50)
           .background(Color(hex: "D9D9D9"))
           .cornerRadius(8)
        
        // .overlay( added for debugging purposes, can keep this for future use
               //Text("Icon: \(icon)")
               //    .font(.system(size: 8))
               //   .foregroundColor(.red)
               //   .padding(2),
               // alignment: .topLeading
          // )
       }

    
    struct CoffeeDetailView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                CoffeeDetailView(coffee: CoffeeListItem(
                    id: "1",
                    title: "Ethiopia Yirgacheffe",
                    roasterName: "Lot61",
                    roastedDate: Date().timeIntervalSince1970 - 10 * 24 * 60 * 60,
                    openDate: Date().timeIntervalSince1970 - 5 * 24 * 60 * 60,
                    grindSetting: "18",
                    brewWeight: "18",
                    coffeeYield: "36",
                    brewTime: "30s",
                    createdDate: Date().timeIntervalSince1970,
                    isDone: false,
                    isFavorite: true
                ))
            }
            .preferredColorScheme(.dark)
        }
    }
}
