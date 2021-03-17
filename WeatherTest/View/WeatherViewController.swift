//
//  WeatherViewController.swift
//  WeatherTest
//
//  Created by Гурген on 03.03.2021.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let network = WeatherService()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        title = "погода"
        tableView.delegate = self
        tableView.dataSource = self
        
        network.fetchWeather(lat: 55.077633, lon: 38.804561) { (weather) in
            print(1)
        }
    }

}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherTableViewCell
        
        return cell
    }
}

extension WeatherViewController: UITableViewDelegate {
    
}
