//
//  Country.swift
//  JustCities
//
//  Created by Aly Yakan on 28/01/2021.
//  Copyright © 2021 Aly Yakan. All rights reserved.
//

import Foundation

struct City: Decodable, HasAName {
    let id: Int
    let name: String
    let country: String
    let coord: Coordinates

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
        case country = "country"
        case coord = "coord"
    }

    struct Coordinates: Decodable {
        let lon: Double
        let lat: Double
    }
}
