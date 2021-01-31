//
//  SearchAgentTests.swift
//  AlotOfCitiesTests
//
//  Created by Aly Yakan on 31/01/2021.
//

import XCTest
@testable import AlotOfCities

class SearchAgentTests: XCTestCase, TestsCityFetcher {

    func testSearchAgentUsingBuiltInAlgorithmReturnsCorrectResult() throws {
        // Given
        let searchAgent = SearchAgent()
        let fetchedCities = fetchCities()

        // When
        let searchString = "Aachen"
        let result = searchAgent.search(for: searchString, in: fetchedCities, using: .builtIn)

        // Then
        XCTAssertEqual(result.count, 2, "Incorrect search count \(result)")
        let firstResult = result[0]
        let secondResult = result[1]
        XCTAssertEqual(firstResult.name, searchString, "City name mismatch with search string. search: \(searchString), result: \(firstResult)")
        XCTAssertEqual(firstResult.country, "DE")
        XCTAssertTrue(secondResult.name.starts(with: searchString), "Irrelevant result found")
    }

    func testSearchAgentUsingBinaryAlgorithmReturnsCorrectResult() throws {
        // Given
        let searchAgent = SearchAgent()
        let fetchedCities = fetchCities()

        // When
        let searchString = "Aachen"
        let result = searchAgent.search(for: searchString, in: fetchedCities, using: .binary)

        // Then
        XCTAssertEqual(result.count, 2, "Incorrect search count \(result)")
        let firstResult = result[0]
        let secondResult = result[1]
        XCTAssertEqual(firstResult.name, searchString, "City name mismatch with search string. search: \(searchString), result: \(firstResult)")
        XCTAssertEqual(firstResult.country, "DE")
        XCTAssertTrue(secondResult.name.starts(with: searchString), "Irrelevant result found")
    }

    /**
     You can switch between the two search algorithms in the measure block (builtIn or binary). You will find the
     test reports the built-in search has an avg. Time: 0.110 sec (~135437% worse than binary)
     */
    func testSearchPerformance() {
        // Given
        let searchAgent = SearchAgent()
        let fetchedCities = fetchCities()

        // When
        let searchString = "Cair"
        var result: [City] = []
        measure {
            result = searchAgent.search(for: searchString, in: fetchedCities, using: .binary)
//            result = searchAgent.search(for: searchString, in: fetchedCities, using: .builtIn)
        }

        for element in result {
            guard element.name.lowercased().starts(with: "Cair".lowercased()) else {
                XCTFail("\(element)")
                return
            }
        }
    }
}
