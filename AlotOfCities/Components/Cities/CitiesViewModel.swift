//
//  CitiesViewModel.swift
//  AlotOfCities
//
//  Created by Aly Yakan on 30/01/2021.
//

import Foundation

enum ViewState {
    case initial, loadingData, dataLoaded, error
}

/**
 I found a normal list to be convenient in representation and suitable for binary searches on partial text input.
 */
class CitiesViewModel: CityProvider, ObservableObject {
    let dataTransportLayer: DataTransportLayer
    private(set) var cities: [City] = []
    private(set) var error: Error?
    @Published var viewState: ViewState = .initial

    private let searchAgent = SearchAgent()
    private var citiesBackup: [City] = []

    init(dataTransportLayer: DataTransportLayer) {
        self.dataTransportLayer = dataTransportLayer
    }

    func startFetching() {
        viewState = .loadingData
        fetchCities(updateViewModel(withFetchResult:))
    }

    func search(for searchString: String, using algorithm: SearchAgent.Algorithm = .binary) {
        guard viewState == .dataLoaded else { return }

        guard searchString.isEmpty == false else {
            viewState = .dataLoaded
            cities = citiesBackup
            return
        }

        viewState = .loadingData

        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }

            self.cities = self.searchAgent.search(for: searchString, in: self.citiesBackup, using: algorithm)
            self.viewState = .dataLoaded
        }
    }

    // MARK: - Helper functions

    private func updateViewModel(withFetchResult result: Result<[City], Error>) {
        switch result {
        case .success(let cities):
            self.cities = cities.sorted(by: { ($0.name, $0.country) <= ($1.name, $1.country) })
            self.citiesBackup = self.cities
            self.viewState = .dataLoaded
        case .failure(let error):
            self.error = error
            self.viewState = .error
        }
    }
}
