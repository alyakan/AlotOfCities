//
//  CityProvider.swift
//  AlotOfCities
//
//  Created by Aly Yakan on 30/01/2021.
//

import Foundation

protocol CityProvider {
    var dataTransportLayer: DataTransportLayer { get }

    func fetchCities(_ completion: @escaping (Result<[City], Error>) -> Void)
}

extension CityProvider {
    func fetchCities(_ completion: @escaping (Result<[City], Error>) -> Void) {
        dataTransportLayer.fetch(.cities, completion: completion)
    }
}
