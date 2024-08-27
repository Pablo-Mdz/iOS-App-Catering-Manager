//
//  WeatherRepository.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 25/07/2024.
//

import Foundation

struct WeatherRepository {
    private let apiKey = apiKeyWeather
    private let baseURL = "https://api.openweathermap.org/data/3.0/onecall"

    func fetchWeather(for latitude: Double, longitude: Double) -> WeatherResponse? {
        guard var urlComponents = URLComponents(string: baseURL) else {
            print("Invalid URL components")
            return nil
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "exclude", value: "minutely,hourly"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey)
        ]

        guard let url = urlComponents.url else {
            print("Invalid URL")
            return nil
        }

        do {
            let data = try Data(contentsOf: url, options: .alwaysMapped)
            let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            return weatherResponse
        } catch {
            print("Error fetching or decoding weather data: \(error)")
            return nil
        }
    }
}
