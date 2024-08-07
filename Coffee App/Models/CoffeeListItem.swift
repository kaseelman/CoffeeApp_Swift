//
//  CoffeeListItem.swift
//  Coffee App
//
//  Created by Kas Eelman on 01/08/2024.
//

import Foundation

struct CoffeeListItem: Codable, Identifiable {
    let id: String
    let title: String
    let roasterName: String
    let roastedDate: TimeInterval
    let openDate: TimeInterval // Added this line
    let grindSetting: String
    let brewWeight: String
    let coffeeYield: String
    let brewTime: String
    let createdDate: TimeInterval
    var isDone: Bool
    var isFavorite: Bool // New property
    
    mutating func setDone(_ state: Bool) {
        isDone = state
    }
    
    mutating func setFavorite(_ state: Bool) { 
            isFavorite = state
        }
}
