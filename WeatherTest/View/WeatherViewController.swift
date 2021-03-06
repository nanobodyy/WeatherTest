//
//  WeatherViewController.swift
//  WeatherTest
//
//  Created by Гурген on 03.03.2021.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: WeatherViewModelProtocol?
    
    let network = WeatherManager()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return true }
        return text.isEmpty
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        configureNavController()
        configureSerchController()
        viewModel?.viewLoad(tableView: self.tableView)
    }
    
    func configureSerchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func configureNavController() {
        title = "погода"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(WeatherViewController.addTarget))
    }
    
    @objc func addTarget() {
        let ac = UIAlertController(title: "Город", message: "добавить город", preferredStyle:.alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
            
            let textField = ac.textFields?[0]
            guard let text = textField?.text else { return }
            
            self.viewModel?.addNewCity(name: text, complitionHandler: { (count) in
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: [IndexPath(row: count - 1, section: 0)], with: .automatic)
                    self.tableView.endUpdates()
                }
            })
            self.viewModel?.addDataBase(city: text)
        }
        
        let cancel = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        ac.addTextField { (textField) in
            
        }
        
        ac.addAction(ok)
        ac.addAction(cancel)
        
        present(ac, animated: true, completion: nil)
    }
    
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return viewModel?.filtredNumberOfRows() ?? 0
        }
        return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherTableViewCell
        
        if isFiltering {
            let cellViewModel = viewModel?.filtredCellViewModel(forIndexPath: indexPath)
            cell.viewModel = cellViewModel
        } else {
            let cellViewModel = viewModel?.cellViewModel(forIndexPath: indexPath)
            cell.viewModel = cellViewModel
        }
        return cell
    }
}

extension WeatherViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let cellViewModel = viewModel?.cellViewModel(forIndexPath: indexPath)
        guard let cityName = cellViewModel?.cityName else { return }
        
        self.viewModel?.deleteDatBase(name: cityName)
        self.viewModel?.deleteCity(index: indexPath)

        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        
        if isFiltering {
            viewModel?.filteredSelectRow(atIndexPath: indexPath)
            let detailViewModel = viewModel?.filtredViewModelForSelectedRow()
            detailViewController.viewModel = detailViewModel
        } else {
            viewModel?.selectRow(atIndexPath: indexPath)
            let detailViewModel = viewModel?.viewModelForSelectedRow()
            detailViewController.viewModel = detailViewModel
        }
    
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension WeatherViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel?.filterContentForSearchTexy(searchController.searchBar.text!, tableview: tableView)
    }
    
}
