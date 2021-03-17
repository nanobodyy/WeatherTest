//
//  Weather.swift
//  WeatherTest
//
//  Created by Гурген on 03.03.2021.
//

import Foundation

struct WeatherData: Codable {
    var current: Current
    var forecast: Forecast
    var location: Location
    
}

struct Location: Codable {
    let name, region, country: String
}

struct Current: Codable {
    var tempC: Int
    var windKph: Double
    var condition: Condition
    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case windKph = "wind_kph"
        case condition
    }
}

struct Condition: Codable {
    var text: String
    var icon: String
}

//enum Text: String, Codable {
//    case lightRain = "Light rain"
//    case overcast = "Overcast"
//    case partlyCloudy = "Partly cloudy"
//    case patchyRainPossible = "Patchy rain possible"
//    case sunny = "Sunny"
//}

struct Forecast: Codable {
    var forecastday: [Forecastday]
}

struct Forecastday: Codable {
    var date: String
    var day: Day
    var astro: Astro
    
    enum CodingKeys: String, CodingKey {
            case date
            case day, astro
        }
}

struct Day: Codable {
    var maxtempC, maxtempF, mintempC, mintempF: Double
    var avgtempC, avgtempF, maxwindMph, maxwindKph: Double
    var totalprecipMm, totalprecipIn, avgvisKM: Double
    var avgvisMiles, avghumidity, dailyWillItRain: Int
    var dailyChanceOfRain: String
    var dailyWillItSnow: Int
    var dailyChanceOfSnow: String
    var condition: Condition
    var uv: Int

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case maxtempF = "maxtemp_f"
        case mintempC = "mintemp_c"
        case mintempF = "mintemp_f"
        case avgtempC = "avgtemp_c"
        case avgtempF = "avgtemp_f"
        case maxwindMph = "maxwind_mph"
        case maxwindKph = "maxwind_kph"
        case totalprecipMm = "totalprecip_mm"
        case totalprecipIn = "totalprecip_in"
        case avgvisKM = "avgvis_km"
        case avgvisMiles = "avgvis_miles"
        case avghumidity
        case dailyWillItRain = "daily_will_it_rain"
        case dailyChanceOfRain = "daily_chance_of_rain"
        case dailyWillItSnow = "daily_will_it_snow"
        case dailyChanceOfSnow = "daily_chance_of_snow"
        case condition, uv
    }
}

struct Astro: Codable {
    var sunrise, sunset : String
    
    enum CodingKeys: String, CodingKey {
            case sunrise, sunset
        }
}
