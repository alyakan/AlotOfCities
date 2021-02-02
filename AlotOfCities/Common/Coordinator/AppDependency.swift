//
//  AppDependency.swift
//  AlotOfCities
//
//  Created by Aly Yakan on 02/02/2021.
//

import Foundation

protocol HasDataTransportLayer {
    var dataTransportLayer: DataTransportLayer { get }
}

class AppDependency: HasDataTransportLayer {
    lazy var dataTransportLayer: DataTransportLayer = JsonDataTransportLayer()
}
