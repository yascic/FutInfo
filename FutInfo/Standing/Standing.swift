//
//  Standing.swift
//  FutInfo
//
//  Created by Yahya Aščić on 15.05.22.
//

import Foundation

struct TeamStanding: Decodable {
    let position: Int
    let team: Team
    
    let playedGames: Int
    let won: Int
    let draw: Int
    let lost: Int
    let points: Int
    let goalsFor: Int
    let goalsAgainst: Int
    let goalDifference: Int
}

struct StandingResponse: Decodable {
    var standings: [Standing]?
}

struct Standing: Decodable {
    let type: String
    let stage: String
    let table: [TeamStanding]
}
