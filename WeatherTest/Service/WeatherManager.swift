//
//  WeatherService.swift
//  WeatherTest
//
//  Created by Гурген on 03.03.2021.
//

import UIKit

class WeatherManager {
    func fetchWeather(lat: Double, lon: Double, _ compitionHandler: @escaping (Weather) -> Void) {
        let urlString = "https://weatherapi-com.p.rapidapi.com/forecast.json?q=\(lat),\(lon)"
        guard let url = URL(string: urlString) else {return}
        
        let headers = [
            "x-rapidapi-key": apiKey,
            "x-rapidapi-host": apiHost
        ]
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print(String(describing: error))
                
                return
            }
            if let weather = self.parseJson(withData: data) {
                compitionHandler(weather)
            }
        }
        task.resume()
        
    }
    
    func parseJson(withData data: Data) -> Weather? {
        let decoder = JSONDecoder()
        do {
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            guard let weather = Weather(weatherData: weatherData) else {return nil}
             
            return weather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func downloadIMage(url: String, compitionHandler: @escaping (UIImage) -> Void) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    compitionHandler(image)
                }
            }
        }.resume()
    }
}
