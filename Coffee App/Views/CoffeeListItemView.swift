import SwiftUI

struct CoffeeListItemView: View {
    let item: CoffeeListItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(item.roasterName)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color.white.opacity(0.7))
                }
                Spacer()
            }
            
            HStack(spacing: 16) {
                DateSection(title: "Roasted On", date: item.roastedDate)
                DateSection(title: "Opened On", date: item.openDate)
                Spacer()
            }
        }
        .padding(.leading, 16)
        .padding(.vertical, 20)
        .background(Color(hex: "#1C1C1D").opacity(0.8))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 3)
    }
}

struct DateSection: View {
    let title: String
    let date: TimeInterval
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Color.white.opacity(0.7))
            
            Text(Date(timeIntervalSince1970: date).formatted(date: .abbreviated, time: .omitted))
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.white)
        }
    }
}

struct CoffeeListItemView_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeListItemView(item: .init(
            id: "123",
            title: "Kenya Coffee",
            roasterName: "Sample Roaster",
            roastedDate: Date().addingTimeInterval(-7*24*60*60).timeIntervalSince1970,
            openDate: Date().timeIntervalSince1970,
            grindSetting: "Medium",
            brewWeight: "18",
            coffeeYield: "36",
            brewTime: "35",
            createdDate: Date().timeIntervalSince1970,
            isDone: false,
            isFavorite: true
        ))
        .previewLayout(.sizeThatFits)
        .background(Color.black)
    }
}
