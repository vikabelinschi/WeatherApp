//
//  DashboardViewModel.swift
//  WeatherApp
//
//  Created by Victoria Belinschi on 07.06.2023.
//

import Foundation
import Combine

class DashboardViewModel {

    @Published var setupCurrent: (String, String?, String, String, String, String) = ("", nil, "", "", "", "")
    @Published var setupForecast: [(String, Double, String)] = []
    private var cancellables = Set<AnyCancellable>()

    let networkService: NetworkService

    // MARK: - Initializers

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    // MARK: - Public Methods

    func getWeatherData() {
        networkService.request(httpRequest: getRequestEntity())
            .receive(on: DispatchQueue.main)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                    case .finished:
                        print("Finished")
                    case .failure(let error):
                        print(error)
                }
            } receiveValue: { data in
                self.updateWeatherAndForecastData(weatherData: data)
            }.store(in: &cancellables)
    }

    // MARK: - Private Methods

    private func updateWeatherAndForecastData(weatherData: WeatherResponse) {
        setupWeatherData(weatherData: weatherData)
        setupForecastData(forecastData: weatherData)
    }

    private func setupWeatherData(weatherData: WeatherResponse) {
        let condition = weatherData.current.condition.text ?? ""
        var conditionString = ""

        if condition.lowercased() == "sunny" {
            conditionString = "sunny_animation"
        } else if condition.lowercased() == "partly cloudy" {
            conditionString = "partly_cloudy_animation"
        } else if condition.lowercased() == "clear" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let currentTime = Date()
            let localTimeString = weatherData.location.localtime
            let localTime = dateFormatter.date(from: localTimeString) ?? currentTime

            dateFormatter.dateFormat = "HH:mm"
            let localHour = dateFormatter.string(from: localTime)

            if localHour < "21:00" {
                conditionString = "sunny_animation"
            } else {
                conditionString = "night_animation"
            }
        }

        setupCurrent = (
            parseData(dateString: weatherData.location.localtime),
            weatherData.current.condition.text,
            String(describing: weatherData.current.wind_kph),
            String(describing: weatherData.current.temp_c),
            String(describing: weatherData.current.precip_mm),
            conditionString
        )
    }

    private func setupForecastData(forecastData: WeatherResponse) {
        setupForecast = getRemainingHoursWeatherData(weatherResponse: forecastData)
    }

    private func getRemainingHoursWeatherData(weatherResponse: WeatherResponse) -> [(String, Double, String)] {
        // Get the current system date and time
        let currentDate = Date()

        // Get the forecast for the current day
        guard let currentDayForecast = weatherResponse.forecast.forecastday.first else {
            return []
        }

        // Find the index of the current hour in the hourly forecast array
        let currentHourIndex = currentDayForecast.hour.firstIndex { hourForecast in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let hourDate = dateFormatter.date(from: hourForecast.time)
            return hourDate ?? Date() > currentDate
        } ?? currentDayForecast.hour.count - 1

        // Calculate the remaining hours for the current day
        let remainingHours = currentDayForecast.hour.count - currentHourIndex

        // Calculate the number of hourly intervals to divide the remaining hours by 4
        let interval = max(1, remainingHours / 4)

        // Get the hourly weather data for the remaining hours divided by 4
        var hourlyWeatherData: [(String, Double, String)] = []
        let iterationCount = min(4, remainingHours) // Limit the iteration to 4 or the remaining hours, whichever is smaller
        for index in stride(from: currentHourIndex + 1, to: currentHourIndex + 1 + (interval * iterationCount), by: interval) {
            let hourForecast = currentDayForecast.hour[index]
            let hour = hourForecast.time.suffix(5)
            let temperature = hourForecast.temp_c
            let condition = hourForecast.condition.text ?? ""

            var conditionString = ""
            if String(hour) > "21:00" {
                conditionString = "night_animation"
            } else if condition.lowercased() == "sunny" {
                conditionString = "sunny_animation"
            } else if condition.lowercased() == "partly cloudy" {
                conditionString = "partly_cloudy_animation"
            } else if condition.lowercased() == "clear" {
                if String(hour) < "21:00" {
                    conditionString = "sunny_animation"
                } else {
                    conditionString = "night_animation"
                }
            }

            hourlyWeatherData.append((String(hour), temperature, conditionString))
        }

        return hourlyWeatherData
    }

    /// Parses the data format from YYYY-MM-dd to desired format
    private func parseData(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        // Parse the date string into a Date object
        if let date = dateFormatter.date(from: dateString) {
            // Create a new date formatter for the desired output format
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "en_US")
            outputFormatter.dateFormat = "d MMMM"

            // Format the date to the desired output format
            let outputString = outputFormatter.string(from: date)

            return outputString
        }
        return ""
    }

    private func getRequestEntity() -> RequestEntity {
        return RequestEntity(path: "/v1/forecast.json", queryItems: [URLQueryItem(name: "q", value: "Chisinau"), URLQueryItem(name: "days", value: "1"), URLQueryItem(name: "key", value: "7dffc24f4cd343bca9c83604230606")], htttpMethod: .get)
    }
}
