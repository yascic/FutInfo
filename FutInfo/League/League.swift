//
//  League.swift
//  FutInfo
//
//  Created by Yahya Aščić on 20.03.22.
//

import UIKit

struct League {
    let id: Int
    let logo: UIImage!
    let name: String
    
    static let topFive: [League] = [
        League(id: 2002, logo: UIImage(named: "bundesliga"), name: "Bundesliga"),
        League(id: 2014, logo: UIImage(named: "la-liga-santander"), name: "La Liga Santander"),
        League(id: 2021, logo: UIImage(named: "premier-league"), name: "Premier League"),
        League(id: 2015, logo: UIImage(named: "ligue-1"), name: "Ligue 1"),
        League(id: 2019, logo: UIImage(named: "serie-a"), name: "Serie A")
    ]
}
