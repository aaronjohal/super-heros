//
//  Hero.swift
//  super-heroes
//
//  Created by Aaron Johal on 24/04/2020.
//  Copyright © 2020 Aaron Johal. All rights reserved.
//

import Foundation

struct Hero: Codable {
    let id: String
    let name: String
    let powerstats: [String: String]
    let image: [String: String]

}

struct Powers: Codable {
    let intelligence: String
    let strength : String
    let speed: String
    let durability: String
    let power: String
    let combat: String
    
}
