//
//  CitiesViewController.swift
//  AlotOfCities
//
//  Created by Aly Yakan on 30/01/2021.
//

import UIKit

protocol CitiesViewControllerOutput: class {
    func showDetailView(forCity city: City)
}

class CitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView?
    private let viewModel: CitiesViewModel
    private let cancelBag = CancelBag()
    private weak var coordinator: CitiesViewControllerOutput?

    init(viewModel: CitiesViewModel, coordinator: CitiesViewControllerOutput) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        viewModel.startFetching()
        super.init(nibName: String(describing: CitiesViewController.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    // MARK: - ViewController life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSearchController()
        listenToViewStateChanges()
    }

    deinit {
        cancelBag.cancel()
    }

    // MARK: - Helper functions

    private func setupView() {
        title = "Cities"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView?.tableFooterView = UIView(frame: .zero)
        tableView?.register(CitiesTableViewCell.self, forCellReuseIdentifier: CitiesTableViewCell.kReuseIdentifier)
        tableView?.delegate = self
        tableView?.dataSource = self
    }

    private func addSearchController() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search for a city"
        navigationItem.searchController = search
    }

    private func listenToViewStateChanges() {
        viewModel.$viewState.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView?.reloadData()
            }
        }.store(in: cancelBag)
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CitiesTableViewCell.kReuseIdentifier, for: indexPath) as? CitiesTableViewCell else {
            return UITableViewCell()
        }

        guard let city = viewModel.city(at: indexPath) else { return cell }

        cell.titleLabel.text = "\(city.name), \(city.country)"
        cell.subtitleLabel.text = "latitude: \(city.coord.lat), longitude: \(city.coord.lon)"

        return cell
    }

    // MARK: - Table view delegate

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.headerTitle()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        coordinator?.showDetailView(forCity: viewModel.cities[indexPath.row])
    }
}

extension CitiesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }

        viewModel.search(for: text)
    }
}

