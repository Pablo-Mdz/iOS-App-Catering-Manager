//
//  WeatherService.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 25/07/2024.
//

import Foundation

struct WeatherResponse: Codable {
    let daily: [DailyWeather]
}

struct DailyWeather: Codable, Identifiable {
    let dt: TimeInterval // swiftlint:disable:this identifier_name
    let temp: Temperature
    let weather: [Weather]
    var id: TimeInterval { dt }
}

struct Temperature: Codable {
    let day: Double
    let min: Double
    let max: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}
