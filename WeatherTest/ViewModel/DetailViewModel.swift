//
//  DetailViewModel.swift
//  WeatherTest
//
//  Created by Гурген on 16.03.2021.
//

import UIKit

protocol DetailViewModelProtocol: class {
    var windspeed: Double { get }
    var sunrise: String? { get }
    var minTemp: Double? { get }
    var maxTemp: Double? { get }
    var temp: Int { get }
    var cityName: String { get }
    var conditionText: String { get }
    func getConditionImage(compitionHandler: @escaping (UIImage) -> Void)
}

class DetailViewModel: DetailViewModelProtocol {
    private var weather: Weather
    var weatherManager = WeatherManager()
    
    init(weather: Weather) {
        self.weather = weather
    }
    
    var cityName: String {
        return weather.name
    }
    
    var windspeed: Double {
        return weather.windKph
    }
    
    var sunrise: String? {
        guard let sunrise = weather.sunrise else { return nil }
        return sunrise
    }
    
    var minTemp: Double? {
        guard let minTemp = weather.mintempC else { return nil }
        return minTemp
    }
    
    var maxTemp: Double? {
        guard let maxTemp = weather.maxtempC else { return nil }
        return maxTemp
    }
    
    var temp: Int {
        return weather.tempC
    }
    
    var conditionText: String {
        return weather.conditionText
    }
    
    var conditionImage: UIImage?
    
    func getConditionImage(compitionHandler: @escaping (UIImage) -> Void) {
        let url = "https:\(self.weather.conditionIcon)"
        print(1)
        self.weatherManager.downloadIMage(url: url) { (image) in
            compitionHandler(image)
        }
    }
}
