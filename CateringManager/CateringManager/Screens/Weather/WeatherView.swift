//
//  WeatherView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 25/07/2024.
//

import SwiftUI

struct WeatherView: View {
    var weather: [DailyWeather]
    var date: Date
    var body: some View {
        VStack {
            if let dayWeather = weather.first(where: { Calendar.current.isDate(Date(timeIntervalSince1970: $0.dt), inSameDayAs: date) }) {
                ZStack {
                    // Background image based on weather condition
                    Image(getBackgroundImageName(for: dayWeather.weather.first?.icon ?? "01d"))
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Text("\(Int(dayWeather.temp.day))°C")
                            .font(.largeTitle)
                            .bold()
                        Text("\(date.formatted(date: .abbreviated, time: .omitted))")
                            .font(.title2)
                            .bold()
                        Text("\(dayWeather.weather.first?.description.capitalized ?? "N/A")")
                            .font(.title3)
                        Text("Max: \(Int(dayWeather.temp.max))°C Min: \(Int(dayWeather.temp.min))°C")
                            .font(.subheadline)
                    }
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                }
            } else {
                Text("No weather forecast available.")
                    .padding()
            }
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding()
    }

    func getBackgroundImageName(for icon: String) -> String {
        switch icon {
        case "01d", "01n":
            return "sunny"
        case "02d", "02n", "03d", "03n":
            return "cloudy"
        case "04d", "04n":
            return "overcast"
        case "09d", "09n", "10d", "10n":
            return "rainy"
        case "11d", "11n":
            return "stormy"
        case "13d", "13n":
            return "snowy"
        case "50d", "50n":
            return "foggy"
        default:
            return "defaultWeather"
        }
    }
}

extension DailyWeather {
    var dateString: String {
        let date = Date(timeIntervalSince1970: dt)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM"
        return formatter.string(from: date)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleWeather = [
            DailyWeather(dt: 1633035600, temp: Temperature(day: 18.0, min: 10.0, max: 20.0), weather: [Weather(description: "Clear sky", icon: "01d")]),
            DailyWeather(dt: 1633122000, temp: Temperature(day: 20.0, min: 12.0, max: 22.0), weather: [Weather(description: "Few clouds", icon: "02d")]),
            DailyWeather(dt: 1633208400, temp: Temperature(day: 22.0, min: 15.0, max: 25.0), weather: [Weather(description: "Scattered clouds", icon: "03d")])
        ]
        WeatherView(weather: sampleWeather, date: Date())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
