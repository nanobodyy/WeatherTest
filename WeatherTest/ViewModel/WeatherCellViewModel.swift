//
//  WeatherCellViewModel.swift
//  WeatherTest
//
//  Created by Гурген on 16.03.2021.
//

import Foundation

protocol WeatherCellViewModelProtocol: class {
    var cityName: String { get }
    var tempC: Int { get }
    var description: String { get }
}

class WeatherCellViewModel: WeatherCellViewModelProtocol{
    
    private var weather: Weather
    
    init(weather: Weather) {
        self.weather = weather
    }
    
    var cityName: String {
        return weather.name
    }
    
    var tempC: Int {
        return weather.tempC
    }
    
    var description: String {
        return weather.conditionText
    }
}
