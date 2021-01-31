//
//  BinarySearchAgent.swift
//  AlotOfCities
//
//  Created by Aly Yakan on 31/01/2021.
//

import Foundation

struct BinarySearchAgent: SearchAlgorithmAgent {
    func search<T: HasAName>(for searchString: String, in list: [T]) -> [T] {
        let lowerCasedSearchString = searchString.lowercased()
        var leftIndex = 0
        var rightIndex = list.count - 1
        var resultIndex = -1

        // Find an index for a city that starts with the search string
        while leftIndex <= rightIndex {
            let middleIndex = Int(floor(Double(leftIndex + rightIndex) / 2.0))
            let middleCityName = list[middleIndex].name.lowercased()

            if middleCityName.starts(with: lowerCasedSearchString) {
                resultIndex = middleIndex
                break
            }

            if middleCityName < searchString.lowercased() {
                leftIndex = middleIndex + 1
            } else if list[middleIndex].name.lowercased() > lowerCasedSearchString {
                rightIndex = middleIndex - 1
            }
        }

        // Find all cities starting with the search string
        var result = [T]()
        if resultIndex > -1 {
            for index in stride(from: resultIndex, to: 0, by: -1) {
                let cityName = list[index].name.lowercased()
                if cityName.starts(with: lowerCasedSearchString) == false {
                    break
                }
                result.insert(list[index], at: 0)
            }

            for index in (resultIndex+1)..<list.count {
                let cityName = list[index].name.lowercased()
                if cityName.starts(with: lowerCasedSearchString) == false {
                    break
                }
                result.append(list[index])
            }
        }

        return result
    }
}
