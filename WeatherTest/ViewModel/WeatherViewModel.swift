//
//  WeatherViewModel.swift
//  WeatherTest
//
//  Created by Гурген on 03.03.2021.
//

import UIKit
import CoreData

protocol WeatherViewModelProtocol {
    func viewLoad(tableView: UITableView)
    func addNewCity(name: String, complitionHandler:@escaping (Int) -> Void)
    func deleteCity(index: IndexPath)
    
    func numberOfRows() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> WeatherCellViewModelProtocol?
    func selectRow(atIndexPath indexPath: IndexPath)
    func viewModelForSelectedRow() -> DetailViewModelProtocol?
    
    func filterContentForSearchTexy(_ searchText: String, tableview: UITableView)
    func filtredNumberOfRows() -> Int
    func filtredCellViewModel(forIndexPath indexPath: IndexPath) -> WeatherCellViewModelProtocol?
    func filteredSelectRow(atIndexPath indexPath: IndexPath)
    func filtredViewModelForSelectedRow() -> DetailViewModelProtocol?
    
    func addDataBase(city: String)
    func deleteDatBase(name: String)
}

class WeatherViewModel: WeatherViewModelProtocol {

    private var weatherManager = WeatherManager()
    private var dataManager = DataManager()
    
    var weathersCities: [Weather] = []
    var filtered: [Weather] = []
    
    var selectedIndexPath: IndexPath?
    var filtredSelectedIndexPath: IndexPath?
    
    func viewLoad(tableView: UITableView) {
        fetchDataBase()
        didFetch(data: dataManager.cities, tableView: tableView)
        print(1)
    }
    
    // MARK: tableViewDataSource
    func numberOfRows() -> Int {
        return weathersCities.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> WeatherCellViewModelProtocol? {
        let weather = weathersCities[indexPath.row]
        return WeatherCellViewModel(weather: weather)
    }
    
    func viewModelForSelectedRow() -> DetailViewModelProtocol? {
        guard let selectedIndexPath = selectedIndexPath else { return nil}
        return DetailViewModel(weather: weathersCities[selectedIndexPath.row])
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    // MARK: SeatchBarResult
    func filterContentForSearchTexy(_ searchText: String, tableview: UITableView) {
        filtered = weathersCities.filter({ $0.name.contains(searchText) })
        tableview.reloadData()
    }
    
    func filtredNumberOfRows() -> Int {
        return filtered.count
    }
    
    func filtredCellViewModel(forIndexPath indexPath: IndexPath) -> WeatherCellViewModelProtocol?  {
        let weather = filtered[indexPath.row]
        return WeatherCellViewModel(weather: weather)
    }
    
    func filteredSelectRow(atIndexPath indexPath: IndexPath) {
        self.filtredSelectedIndexPath = indexPath
    }
    
    func filtredViewModelForSelectedRow() -> DetailViewModelProtocol? {
        guard let filteredSelectedIndexPath = filtredSelectedIndexPath else { return nil}
        return DetailViewModel(weather: filtered[filteredSelectedIndexPath.row])
    }
    
    // MARK: Network
    func addNewCity(name: String, complitionHandler:@escaping (Int) -> Void) {
        self.getCoord(city: name) { (location, error) in
            guard let location = location else { return }
            self.weatherManager.fetchWeather(lat: location.latitude, lon: location.longitude) { (weather) in
                var weather = weather
                weather.name = name
                self.weathersCities.append(weather)
                complitionHandler(self.weathersCities.count)
            }
        }
    }
    
    func didFetch(data: [City], tableView: UITableView){
        for i in data {
            self.getCoord(city: i.name) { (location, error) in
                guard let location = location else { return }
                self.weatherManager.fetchWeather(lat: location.latitude, lon: location.longitude) { (weather) in
                    var weather = weather
                    print(weather)
                    weather.name = i.name!
                    self.weathersCities.append(weather)
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func deleteCity(index: IndexPath) {
        self.weathersCities.remove(at: index.row)
    }

    private func getCoord(city: String?, completion: @escaping (_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> Void ) {
        guard let city = city else { return }
        CLGeocoder().geocodeAddressString(city) { (placemark, error) in
            completion(placemark?.first?.location!.coordinate, error )
        }
    }
    
    // MARK: DataBase
    func fetchDataBase(){
        dataManager.fetchData()
    }
    
    func addDataBase(city: String) {
        dataManager.addDataBase(city: city)
    }
    
    func deleteDatBase(name: String){
        dataManager.deleteDatBase(name: name)
    }
}
