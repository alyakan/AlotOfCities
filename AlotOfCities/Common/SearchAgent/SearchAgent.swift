//
//  SearchAgent.swift
//  AlotOfCities
//
//  Created by Aly Yakan on 31/01/2021.
//

import Foundation

protocol HasAName {
    var name: String { get }
}

protocol SearchAlgorithmAgent {
    func search<T: HasAName>(for searchString: String, in list: [T]) -> [T]
}

// MARK: - SearchAgent

struct SearchAgent {
    func search<T: HasAName>(for searchString: String, in list: [T], using algorithm: Algorithm) -> [T] {
        return algorithm.searchAgent.search(for: searchString, in: list)
    }
}

// MARK: - SearchAgent.Algorithm enum

extension SearchAgent {
    enum Algorithm {
        case builtIn, binary

        var searchAgent: SearchAlgorithmAgent {
            switch self {
            case .builtIn: return BuiltInSearchAgent()
            case .binary: return BinarySearchAgent()
            }
        }
    }
}
