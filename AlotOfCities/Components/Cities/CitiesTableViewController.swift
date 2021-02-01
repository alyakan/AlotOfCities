//
//  CitiesTableViewController.swift
//  AlotOfCities
//
//  Created by Aly Yakan on 30/01/2021.
//

import UIKit

class CitiesTableViewController: UITableViewController {
    let viewModel = CitiesViewModel(dataTransportLayer: JsonDataTransportLayer())
    private let cancelBag = CancelBag()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel.startFetching()
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
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(CitiesTableViewCell.self, forCellReuseIdentifier: CitiesTableViewCell.kReuseIdentifier)
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
                self?.tableView.reloadData()
            }
        }.store(in: cancelBag)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CitiesTableViewCell.kReuseIdentifier, for: indexPath) as? CitiesTableViewCell else {
            return UITableViewCell()
        }

        guard indexPath.row < viewModel.cities.count else { return cell }

        let city = viewModel.cities[indexPath.row]
        cell.titleLabel.text = "\(city.name), \(city.country)"
        cell.subtitleLabel.text = "latitude: \(city.coord.lat), longitude: \(city.coord.lon)"

        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch viewModel.viewState {
        case .initial: return "    Loading will start shortly..."
        case .loadingData: return "    Loading..."
        case .dataLoaded: return "    \(viewModel.cities.count) cities found"
        case .error: return "    \(viewModel.error?.localizedDescription ?? "Something went wrong")"
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: move to coordinator.
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = CityDetailViewController(viewModel: CityDetailViewModel(city: viewModel.cities[indexPath.row]))
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CitiesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }

        viewModel.search(for: text)
    }
}
