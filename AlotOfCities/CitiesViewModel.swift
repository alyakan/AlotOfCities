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

class CitiesViewModel: CityProvider, ObservableObject {
    let dataTransportLayer: DataTransportLayer
    private(set) var cities: [City] = []
    private(set) var error: Error?
    @Published var viewState: ViewState = .initial

    private var citiesBackup: [City] = []

    init(dataTransportLayer: DataTransportLayer) {
        self.dataTransportLayer = dataTransportLayer
    }

    func startFetching() {
        viewState = .loadingData
        fetchCities { [weak self] result in
            guard let self = self else { return }

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

    func search(for searchString: String) {
        guard viewState == .dataLoaded else { return }

        guard searchString.isEmpty == false else {
            viewState = .dataLoaded
            cities = citiesBackup
            return
        }

        viewState = .loadingData

        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }

            self.cities = self.citiesBackup.filter {
                $0.name.lowercased().starts(with: searchString.lowercased())
            }

            self.viewState = .dataLoaded
        }
    }
}
