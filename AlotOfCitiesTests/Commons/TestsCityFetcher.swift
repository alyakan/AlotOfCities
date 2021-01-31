//
//  TestsCityFetcher.swift
//  AlotOfCitiesTests
//
//  Created by Aly Yakan on 31/01/2021.
//

import XCTest
@testable import AlotOfCities

protocol TestsCityFetcher: XCTestCase {
    func fetchCities() -> [City]
}

extension TestsCityFetcher {
    func fetchCities() -> [City] {
        let exp = XCTestExpectation(description: "Couldn't load citities")

        var fetchedCitied: [City] = []
        MockViewModel().fetchCities { result in
            switch result {
            case .success(let cities):
                XCTAssertEqual(cities.count, TestConstants.kNumberOfCities)
                fetchedCitied = cities.sorted(by: { ($0.name, $0.country) <= ($1.name, $1.country) })
            case .failure(let error): XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: TestConstants.kWaitTimeout)
        return fetchedCitied
    }
}
