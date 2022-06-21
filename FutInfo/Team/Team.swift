//
//  Team.swift
//  FutInfo
//
//  Created by Yahya Aščić on 15.05.22.
//

import Foundation

struct Team: Decodable {
    let id: Int
    let name: String
    
    let area: Area?
    
    let shortName: String?
    let tla: String?
    let clubColors: String?
    let crestUrl: String?
    let address: String?
    let phone: String?
    let website: String?
    let email: String?
    let founded: Int?
    let venue: String?
    let squad: [Player]?
}

struct Area: Decodable {
    let id: Int
    let name: String?
}
