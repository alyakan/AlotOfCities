//
//  AlotOfCitiesTests.swift
//  AlotOfCitiesTests
//
//  Created by Aly Yakan on 30/01/2021.
//

import XCTest
@testable import AlotOfCities

class AlotOfCitiesTests: XCTestCase {

    // MARK: - JsonDataTransportLayer Tests

    func testFetchingCitiesJsonAsCityObjectsReturnsSuccessfully() throws {
        // Given
        let dataLayer: DataTransportLayer = JsonDataTransportLayer()
        let exp = XCTestExpectation(description: "Couldn't load citities")

        // When
        dataLayer.fetch(.cities, type: [City].self) { result in
            switch result {
            // Then
            case .success(let cities): XCTAssertEqual(cities.count, TestConstants.kNumberOfCities)
            case .failure(let error): XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: TestConstants.kWaitTimeout)
    }

    func testFetchingCitiesJsonAsCityObjectsPerformance() throws {
        measure {
            do {
                try testFetchingCitiesJsonAsCityObjectsReturnsSuccessfully()
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }

    // MARK: - CityProvider Tests

    func testCityProviderFetchesAllCities() throws {
        // Given
        let exp = XCTestExpectation(description: "Couldn't load citities")

        // When
        MockViewModel().fetchCities { result in
            switch result {
            // Then
            case .success(let cities): XCTAssertEqual(cities.count, TestConstants.kNumberOfCities)
            case .failure(let error): XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: TestConstants.kWaitTimeout)
    }
}
