//
//  CoffeeListItemView.swift
//  Coffee App
//
//  Created by Kas Eelman on 24/04/2024.
//

import SwiftUI

struct CoffeeListItemView: View {
    let item: CoffeeListItem
    
    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray)
                
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Lot61")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        DateSection(title: "Opened On", date: item.openDate)
                        DateSection(title: "Roasted On", date: item.createdDate)
                        Spacer()
                        Circle()
                            .fill(Color.green)
                            .frame(width: 10, height: 10)
                    }
                }
                .padding(16)
            }
            .frame(height: 120)
            .padding(.horizontal)
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
                        roastedDate: Date().addingTimeInterval(-7*24*60*60).timeIntervalSince1970, // 1 week ago
                        openDate: Date().timeIntervalSince1970,
                        grindSetting: "Medium",
                        brewWeight: "18",
                        coffeeYield: "36",
                        brewTime: "35",
                        createdDate: Date().timeIntervalSince1970,
                        isDone: false
                    ))
                    .previewLayout(.sizeThatFits)
                    .padding()
                    .background(Color.black)
                }
            }
