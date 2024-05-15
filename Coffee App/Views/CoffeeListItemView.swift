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
        HStack{
            VStack (alignment: .leading){
                Text(item.title)
                    .bold()
                Text("\(Date(timeIntervalSince1970: item.openDate).formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote)
                    .foregroundColor(Color(.secondaryLabel))
            }
            
            Spacer()
            
            Button {
                
            } label: {
                ZStack{
                   // RoundedRectangle(cornerRadius: 40)
                       // .foregroundColor(.blue)
                    Text("Show Brew Details")
                        .foregroundColor(Color.blue)
                        .bold()
                        .font(.system(size:14))

                }
            }
        }
        .padding()
        
    }
}

struct CoffeeListItemView_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeListItemView(item: .init(id: "123", title: "Kenya Coffee", openDate: Date().timeIntervalSince1970, createdDate: Date().timeIntervalSince1970, isDone: false))
    }
}
