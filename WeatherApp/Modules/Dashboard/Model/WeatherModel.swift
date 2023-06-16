//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Victoria Belinschi on 07.06.2023.
//

import Foundation

struct Location: Decodable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tz_id: String
    let localtime_epoch: Int64
    let localtime: String
}

struct Condition: Decodable {
    let text: String?
}

struct HourlyForecast: Decodable {
    let time: String
    let temp_c: Double
    let condition: Condition
}

struct ForecastDay: Decodable {
    let day: Day
    let astro: Astro
    let hour: [HourlyForecast]
}

struct Day: Decodable {
    let totalsnow_cm: Int?
    let condition: Condition
}

struct Astro: Decodable {
}

struct WeatherResponse: Decodable {
    let location: Location
    let current: CurrentWeather
    let forecast: Forecast
}

struct CurrentWeather: Decodable {
    let temp_c: Double
    let is_day: Int
    let condition: Condition
    let wind_kph: Double
    let precip_mm: Int
    let uv: Int
}

struct Forecast: Decodable {
    let forecastday: [ForecastDay]
}
