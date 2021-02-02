//
//  Coordinator.swift
//  AlotOfCities
//
//  Created by Aly Yakan on 02/02/2021.
//

import UIKit

protocol Coordinator: class {
    var rootController: UINavigationController { get set }

    func start()
}
