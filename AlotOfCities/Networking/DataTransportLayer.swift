//
//  DataTransportLayer.swift
//  JustCities
//
//  Created by Aly Yakan on 28/01/2021.
//  Copyright © 2021 Aly Yakan. All rights reserved.
//

import Foundation

enum DataResource {
    case cities
}

enum DataTramsportLayerError: Error {
    case fileReadingFailed(name: String)

    var localizedDescription: String {
        switch self {
        case .fileReadingFailed(let name): return "Couldn't read file with name: \(name)"
        }
    }
}

protocol DataTransportLayer {
    func fetch<T: Decodable>(_ resource: DataResource, type: T.Type, completion: @escaping (Result<T, Error>) -> Void)
}
