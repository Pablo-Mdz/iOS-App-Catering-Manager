//
//  WeatherViewModel.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 25/07/2024.
//

import Foundation

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    private var weatherRepository = WeatherRepository()

    func fetchWeather(for latitude: Double, longitude: Double) {
        DispatchQueue.global(qos: .background).async {
            if let weatherResponse = self.weatherRepository.fetchWeather(for: latitude, longitude: longitude) {
                DispatchQueue.main.async {
                    self.weather = weatherResponse
                }
            } else {
                print("Error fetching weather data")
            }
        }
    }
}
