//
//  AlotOfCitiesTests.swift
//  AlotOfCitiesTests
//
//  Created by Aly Yakan on 30/01/2021.
//

import XCTest
@testable import AlotOfCities

class AlotOfCitiesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchingCitiesJsonAsCityObjectsReturnsSuccessfully() throws {
        // Given
        let dataLayer: DataTransportLayer = JsonDataTransportLayer()
        let exp = XCTestExpectation(description: "Couldn't load citities")

        // When
        dataLayer.fetch(.cities, type: [City].self) { result in
            switch result {
            // Then
            case .success(let cities): XCTAssertEqual(cities.count, 209557)
            case .failure(let error): XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10)
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
}
