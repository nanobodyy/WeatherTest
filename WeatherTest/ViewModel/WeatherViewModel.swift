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
    
    func filterContentForSearchTexy(_ searchText: String, tableview: UITableView)
    func filtredNumberOfRows() -> Int
    func filtredCellViewModel(forIndexPath indexPath: IndexPath) -> WeatherCellViewModelProtocol?
    func filteredSelectRow(atIndexPath indexPath: IndexPath)
    func filtredViewModelForSelectedRow() -> DetailViewModelProtocol?
    
    func addDataBase(city: String)
    func deleteDatBase(name: String)
}

class WeatherViewModel: WeatherViewModelProtocol {

    var weatherManager = WeatherManager()
    //var cities = ["Москва", "Киев", "Коломна"]
    var cities: [City] = []
    var weathersCities: [Weather] = []
    var filtered: [Weather] = []
    
    var selectedIndexPath: IndexPath?
    var filtredSelectedIndexPath: IndexPath?
    
    func viewLoad(tableView: UITableView) {
        fetchData()
        didFetch(data: cities, tableView: tableView)
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
    
    // MARK: WeatherData
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
    
    func fetchData(){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
    
            let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
    
            do {
                cities = try context.fetch(fetchRequest)
            } catch {
                print(error.localizedDescription)
            }
        }
    
    func addDataBase(city: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
    
        let entity = NSEntityDescription.entity(forEntityName: "City", in: context)
        let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! City
        taskObject.name = city
    
        do {
            try context.save()
            cities.append(taskObject)
        } catch {
            print(error.localizedDescription)
        }
        self.fetchData()
    }
    
    func deleteDatBase(name: String){
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let result = try context.fetch(fetchRequest)
            context.delete(result[0])
            try context.save()
            print("delete")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        self.fetchData()
    }
}
