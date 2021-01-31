//
//  MockViewModel.swift
//  AlotOfCitiesTests
//
//  Created by Aly Yakan on 31/01/2021.
//

import Foundation
@testable import AlotOfCities

struct MockViewModel: CityProvider {
    let dataTransportLayer: DataTransportLayer = JsonDataTransportLayer()
}
