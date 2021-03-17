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
    func addNewCity(tableView:UITableView, name: String)
    func deleteCity(index: IndexPath)
    
    func numberOfRows() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> WeatherCellViewModelProtocol?
    
    func selectRow(atIndexPath indexPath: IndexPath)
    func viewModelForSelectedRow() -> DetailViewModelProtocol?
}

class WeatherViewModel: WeatherViewModelProtocol {

    var weatherManager = WeatherManager()
    var cities = ["Москва", "Киев", "Коломна"]
    var weathersCities: [Weather] = []
    
    var selectedIndexPath: IndexPath?
    
    func viewLoad(tableView: UITableView) {
        didFetch(data: cities, tableView: tableView)
        print(1)
    }
    
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
    
    func addNewCity(tableView:UITableView, name: String) {
        self.getCoord(city: name) { (location, error) in
            guard let location = location else { return }
            self.weatherManager.fetchWeather(lat: location.latitude, lon: location.longitude) { (weather) in
                var weather = weather
                weather.name = name
                self.weathersCities.append(weather)
                DispatchQueue.main.async {
                    tableView.beginUpdates()
                    tableView.insertRows(at: [IndexPath(row: self.weathersCities.count - 1, section: 0)], with: .automatic)
                    tableView.endUpdates()
                }
            }
        }
    }
    
    func didFetch(data: [String], tableView: UITableView){
        for i in data {
            self.getCoord(city: i) { (location, error) in
                guard let location = location else { return }
                self.weatherManager.fetchWeather(lat: location.latitude, lon: location.longitude) { (weather) in
                    var weather = weather
                    weather.name = i
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
}
