//
//  MainCoordinator.swift
//  AlotOfCities
//
//  Created by Aly Yakan on 02/02/2021.
//

import UIKit

class MainCoordinator: Coordinator {
    var rootController: UINavigationController
    var appDependency: AppDependency

    init(rootController: UINavigationController, appDependency: AppDependency) {
        self.rootController = rootController
        self.appDependency = appDependency
    }

    func start() {
        let viewModel = CitiesViewModel(dependency: appDependency)
        let vc = CitiesViewController(viewModel: viewModel, coordinator: self)
        rootController.pushViewController(vc, animated: false)
    }
}

extension MainCoordinator: CitiesViewControllerOutput {
    func showDetailView(forCity city: City) {
        let vc = CityDetailViewController(viewModel: CityDetailViewModel(city: city))
        rootController.pushViewController(vc, animated: true)
    }
}
