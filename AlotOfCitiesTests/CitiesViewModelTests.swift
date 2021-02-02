//
//  CitiesViewModelTests.swift
//  AlotOfCitiesTests
//
//  Created by Aly Yakan on 30/01/2021.
//

import XCTest
@testable import AlotOfCities

class CitiesViewModelTests: XCTestCase {
    private let cancelBag = CancelBag()
    private var viewModel = CitiesViewModel(dependency: AppDependency())

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = CitiesViewModel(dependency: AppDependency())
        cancelBag.cancel()
    }

    func testCitiesViewModelInitialState() throws {
        XCTAssertEqual(viewModel.viewState, .initial)
        XCTAssertTrue(viewModel.cities.isEmpty)
        XCTAssertNil(viewModel.error)
    }

    func testStartFetchingUpdatesViewState() throws {
        // When
        viewModel.startFetching()

        // Then
        XCTAssertEqual(viewModel.viewState, .loadingData)
    }

    func testCitiesViewModelFetchesAllCitiesInAscendingOrder() throws {
        // Given
        let exp = XCTestExpectation(description: "Couldn't load citities")

        // When
        viewModel.startFetching()
        viewModel.$viewState.sink { state in
            switch state {
            case .initial, .loadingData: break
            case .dataLoaded: exp.fulfill()
            case .error: XCTFail(self.viewModel.error?.localizedDescription ?? "Something went wrong")
            }
        }.store(in: cancelBag)
        wait(for: [exp], timeout: TestConstants.kWaitTimeout)

        // Then
        XCTAssertEqual(viewModel.cities.count, TestConstants.kNumberOfCities)
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

    func testSearchingForEmptyStringDoesNothing() throws {
        // When
        viewModel.search(for: "")

        // Then
        XCTAssertEqual(viewModel.viewState, .initial)
    }

    func testSearchForStringBeforDataIsLoadedDoesNothing() throws {
        // Given
        let exp = XCTestExpectation(description: "Couldn't load citities")

        // When
        viewModel.startFetching()
        viewModel.search(for: "Cair")

        viewModel.$viewState.sink { state in
            switch state {
            case .initial, .loadingData: break
            case .dataLoaded: exp.fulfill()
            case .error: XCTFail(self.viewModel.error?.localizedDescription ?? "Something went wrong")
            }
        }.store(in: cancelBag)
        wait(for: [exp], timeout: TestConstants.kWaitTimeout)

        // Then
        XCTAssertEqual(viewModel.cities.count, TestConstants.kNumberOfCities)
        XCTAssertNil(viewModel.error)
    }

    func testSearchForEmptyStringReturnsAllCitiesImmediately() throws {
        // Given
        var exp = XCTestExpectation(description: "Couldn't load citities")

        // When
        viewModel.startFetching()
        viewModel.$viewState.sink { state in
            switch state {
            case .initial, .loadingData: break
            case .dataLoaded: exp.fulfill()
            case .error: XCTFail(self.viewModel.error?.localizedDescription ?? "Something went wrong")
            }
        }.store(in: cancelBag)
        wait(for: [exp], timeout: TestConstants.kWaitTimeout)

        let searchString = ""
        viewModel.search(for: searchString)
        XCTAssertEqual(viewModel.viewState, .dataLoaded)
        XCTAssertEqual(viewModel.cities.count, TestConstants.kNumberOfCities, "Incorrect search count \(viewModel.cities)")

        exp = XCTestExpectation(description: "Failed to complete searching")
        cancelBag.cancel()
        viewModel.$viewState.sink { state in
            switch state {
            case .initial, .loadingData: break
            case .dataLoaded: exp.fulfill()
            case .error: XCTFail(self.viewModel.error?.localizedDescription ?? "Something went wrong")
            }
        }.store(in: cancelBag)
        wait(for: [exp], timeout: TestConstants.kWaitTimeout)

        // Then
        XCTAssertEqual(viewModel.cities.count, TestConstants.kNumberOfCities, "Incorrect search count \(viewModel.cities)")
    }

    func testSearchingForCityReturnsCorrectResult() throws {
        // Given
        var exp = XCTestExpectation(description: "Couldn't load citities")

        // When
        viewModel.startFetching()
        viewModel.$viewState.sink { state in
            switch state {
            case .initial, .loadingData: break
            case .dataLoaded: exp.fulfill()
            case .error: XCTFail(self.viewModel.error?.localizedDescription ?? "Something went wrong")
            }
        }.store(in: cancelBag)
        wait(for: [exp], timeout: TestConstants.kWaitTimeout)

        let searchString = "Aachen"
        viewModel.search(for: searchString, using: .binary)
        XCTAssertEqual(viewModel.viewState, .loadingData)

        exp = XCTestExpectation(description: "Failed to complete searching")
        cancelBag.cancel()
        viewModel.$viewState.sink { state in
            switch state {
            case .initial, .loadingData: break
            case .dataLoaded: exp.fulfill()
            case .error: XCTFail(self.viewModel.error?.localizedDescription ?? "Something went wrong")
            }
        }.store(in: cancelBag)
        wait(for: [exp], timeout: TestConstants.kWaitTimeout)

        // Then
        XCTAssertEqual(viewModel.cities.count, 2, "Incorrect search count \(viewModel.cities)")
        let firstResult = viewModel.cities[0]
        let secondResult = viewModel.cities[1]
        XCTAssertEqual(firstResult.name, searchString, "City name mismatch with search string. search: \(searchString), result: \(firstResult)")
        XCTAssertEqual(firstResult.country, "DE")
        XCTAssertTrue(secondResult.name.starts(with: searchString), "Irrelevant result found")
    }

    func testSearchingForWrongStringReturnsEmpty() throws {
        // Given
        var exp = XCTestExpectation(description: "Couldn't load citities")

        // When
        viewModel.startFetching()
        viewModel.$viewState.sink { state in
            switch state {
            case .initial, .loadingData: break
            case .dataLoaded: exp.fulfill()
            case .error: XCTFail(self.viewModel.error?.localizedDescription ?? "Something went wrong")
            }
        }.store(in: cancelBag)
        wait(for: [exp], timeout: TestConstants.kWaitTimeout)

        let searchString = "NotACity"
        viewModel.search(for: searchString)
        XCTAssertEqual(viewModel.viewState, .loadingData)

        exp = XCTestExpectation(description: "Failed to complete searching")
        cancelBag.cancel()
        viewModel.$viewState.sink { state in
            switch state {
            case .initial, .loadingData: break
            case .dataLoaded: exp.fulfill()
            case .error: XCTFail(self.viewModel.error?.localizedDescription ?? "Something went wrong")
            }
        }.store(in: cancelBag)
        wait(for: [exp], timeout: TestConstants.kWaitTimeout)

        // Then
        XCTAssertEqual(viewModel.cities.count, 0, "Incorrect search count \(viewModel.cities)")
    }
}
