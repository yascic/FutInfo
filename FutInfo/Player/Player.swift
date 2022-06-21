//
//  Player.swift
//  FutInfo
//
//  Created by Yahya Aščić on 15.05.22.
//

import Foundation

struct Player: Decodable {
    var name: String?
    var firstName: String?
    var dateOfBirth: String?
    var countryOfBirth: String?
    var nationality: String?
    var position: String?
    var shirtNumber: Int?
    var role: String?
}
