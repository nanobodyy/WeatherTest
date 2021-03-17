//
//  WeatherData.swift
//  WeatherTest
//
//  Created by Гурген on 03.03.2021.
//

import Foundation

struct Weather {
    var name: String = "Название"
    var tempC: Int
    var maxtempC: Double? = 0
    var mintempC: Double? = 0
    var condition: String?
    var conditionIcon: String
    var sunrise, sunset : String?
    var windKph: Double
    
    var conditionText: String {
        switch condition {
        case "Light rain": return "Небольшой дождь"
        case "Overcast": return "Пасмурно"
        case "Partly cloudy": return "Малооблачно"
        case "Patchy rain possible": return "Возможен дождь"
        case "Sunny": return "Солнечно"
        case "Mist": return "Туман"
        case "Light drizzle": return "Мелкий дождь"
        case "Patchy heavy snow": return "Сильный снег"
        case "Moderate or heavy snow showers": return "Умеренный или сильный снегопад"
        case "Light snow": return "Легкий снег"
        case "Heavy snow": return "Сильный снег"
        case "Patchy light rain with thunder": return "Легкий дождь с грозой"
        case "Light sleet": return "Легкий мокрый снег"
        case "moderate snow": return "Легкий снег"
        case "patchy light snow": return "Легкий снег"
        default: return "Загрузка..."
        }
    }
    
    init?(weatherData: WeatherData) {
        tempC = weatherData.current.tempC
        name = weatherData.location.name
        maxtempC = weatherData.forecast.forecastday.first?.day.maxtempC
        mintempC = weatherData.forecast.forecastday.first?.day.mintempC
        condition = weatherData.current.condition.text
        conditionIcon = weatherData.current.condition.icon
        sunrise = weatherData.forecast.forecastday.first?.astro.sunrise
        sunrise = weatherData.forecast.forecastday.first?.astro.sunset
        windKph = weatherData.current.windKph
    }
}
