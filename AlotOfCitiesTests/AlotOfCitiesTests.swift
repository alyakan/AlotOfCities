//
//  AlotOfCitiesTests.swift
//  AlotOfCitiesTests
//
//  Created by Aly Yakan on 30/01/2021.
//

import XCTest
@testable import AlotOfCities

struct MockViewModel: CityProvider {
    let dataTransportLayer: DataTransportLayer = JsonDataTransportLayer()
}

class AlotOfCitiesTests: XCTestCase {
    static let kNumberOfCities = 209557
    static let kWaitTimeout: TimeInterval = 10

    private let cancelBag = CancelBag()

    // MARK: - JsonDataTransportLayer Tests

    func testFetchingCitiesJsonAsCityObjectsReturnsSuccessfully() throws {
        // Given
        let dataLayer: DataTransportLayer = JsonDataTransportLayer()
        let exp = XCTestExpectation(description: "Couldn't load citities")

        // When
        dataLayer.fetch(.cities, type: [City].self) { result in
            switch result {
            // Then
            case .success(let cities): XCTAssertEqual(cities.count, Self.kNumberOfCities)
            case .failure(let error): XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: Self.kWaitTimeout)
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
            case .success(let cities): XCTAssertEqual(cities.count, Self.kNumberOfCities)
            case .failure(let error): XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: Self.kWaitTimeout)
    }

    // MARK: - CitiesViewModel Tests

    func testCitiesViewModelInitialState() {
        // Given
        let viewModel = CitiesViewModel(dataTransportLayer: JsonDataTransportLayer())

        // Then
        XCTAssertEqual(viewModel.viewState, .initial)
        XCTAssertTrue(viewModel.cities.isEmpty)
        XCTAssertNil(viewModel.error)
    }

    func testStartFetchingUpdatesViewState() {
        // Given
        let viewModel = CitiesViewModel(dataTransportLayer: JsonDataTransportLayer())

        // When
        viewModel.startFetching()

        // Then
        XCTAssertEqual(viewModel.viewState, .loadingData)
    }

    func testCitiesViewModelFetchesAllCitiesInAscendingOrder() {
        // Given
        let exp = XCTestExpectation(description: "Couldn't load citities")
        let viewModel = CitiesViewModel(dataTransportLayer: JsonDataTransportLayer())

        // When
        viewModel.startFetching()
        viewModel.$viewState.sink { state in
            switch state {
            case .initial, .loadingData: break
            case .dataLoaded: exp.fulfill()
            case .error: XCTFail(viewModel.error?.localizedDescription ?? "Something went wrong")
            }
        }.store(in: cancelBag)
        wait(for: [exp], timeout: Self.kWaitTimeout)

        // Then
        XCTAssertEqual(viewModel.cities.count, Self.kNumberOfCities)
        XCTAssertNil(viewModel.error)

        for i in 0..<viewModel.cities.count {
            guard i + 1 < viewModel.cities.count else { break }

            let currentCity = viewModel.cities[i]
            let nextCity = viewModel.cities[i+1]

            guard (currentCity.name, currentCity.country) <= (nextCity.name, nextCity.country) else {
                XCTFail("Cities were not ordered ascendingally")
                return
            }
        }
    }
}
