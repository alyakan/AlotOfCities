//
//  BuiltInSearchAgent.swift
//  AlotOfCities
//
//  Created by Aly Yakan on 31/01/2021.
//

import Foundation

struct BuiltInSearchAgent: SearchAlgorithmAgent {
    func search<T: HasAName>(for searchString: String, in list: [T]) -> [T] {
        return list.filter {
            $0.name.lowercased().starts(with: searchString.lowercased())
        }
    }
}
