//
//  WeatherModels.swift
//  Weather-Swipe
//
//  Created by Mario Krajačić on 25.11.2023..
//

import Foundation

struct WeatherDay {
    let dayOfWeek: String
    let imageName: String
    let temperature: Int
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

struct MainWeather: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Rain: Codable {
    let oneHour: Double

    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
    }
}

struct Clouds: Codable {
    let all: Int
}

struct Sys: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct WeatherCurrent: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct WeatherResponse: Codable {
    let coord: Coord
    let weather: [WeatherCurrent]
    let base: String
    let main: MainWeather
    let visibility: Int
    let wind: Wind
    let rain: Rain?
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

