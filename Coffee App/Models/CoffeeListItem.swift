//
//  CoffeeListItem.swift
//  Coffee App
//
//  Created by Kas Eelman on 01/08/2024.
//

import Foundation

struct CoffeeListItem: Codable, Identifiable {
    let id:String
    let title: String
    let openDate: TimeInterval
    let createdDate: TimeInterval
    var isDone: Bool
    
    mutating func setDone(_ state:Bool) {
        isDone = state
    }
}
