//
//  User.swift
//  Coffee App
//
//  Created by Kas Eelman on 24/04/2024.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email:String
    let joined: TimeInterval
}
