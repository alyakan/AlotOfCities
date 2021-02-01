//
//  CityDetailViewController.swift
//  AlotOfCities
//
//  Created by Aly Yakan on 01/02/2021.
//

import UIKit
import MapKit

struct CityDetailViewModel {
    let city: City
    let region: MKCoordinateRegion

    init(city: City) {
        self.city = city
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: city.coord.lat, longitude: city.coord.lon),
            span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)
        )
    }
}

class CityDetailViewController: UIViewController {
    private let viewModel: CityDetailViewModel
    @IBOutlet private weak var mapView: MKMapView?

    init(viewModel: CityDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: CityDetailViewController.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(viewModel.city.name), \(viewModel.city.country)"
        mapView?.setRegion(viewModel.region, animated: true)
    }
}
