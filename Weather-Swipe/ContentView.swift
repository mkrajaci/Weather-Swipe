//
//  ContentView.swift
//  Weather-Swipe
//
//  Created by Mario Krajačić on 25.11.2023..
//

import SwiftUI

struct ContentView: View {
    @State private var isNight = false
    @State private var weather: WeatherResponse?
    var body: some View {
        let weatherData = WeatherDay(dayOfWeek: "TUE", imageName: "cloud.sun.fill", temperature: 7)
        ZStack {
            BackgroundView(isNight: isNight)
            VStack {
                CityTextView(cityName: weather?.name ?? "City name")
                MainWeatherStatusView(imageName: isNight ? "moon.stars.fill" : "cloud.sun.fill", temperature: 12)
                HStack(spacing:20) {
                    WeatherDayView(weatherDay: weatherData)
                }
                Spacer()
                
                Button {
                    isNight.toggle()
                } label: {
                    WeatherButton(title: "Change Day Time", textColor: Color.blue, backgroundColor: Color.white)
                }
                Spacer()
            }
        }
        .task {
            do {
                weather = try await getWeatherResponse()
            } catch WRError.invalidURL {
                print("Invalid URL")
            } catch WRError.invalidResponse {
                print("Invalid Response")
            } catch WRError.invalidData {
                print("Invalid Data")
            } catch WRError.apiKeyMissing {
                print("Api key missing")
            } catch {
                print("Unexpected error")
            }
        }
    }
    func getWeatherResponse() async throws -> WeatherResponse {
        var apiKey: String
        
        if let storedApiKey = ProcessInfo.processInfo.environment["apiKey"] {
            apiKey = storedApiKey
        } else {
            print("Environment variable 'API_KEY' not set.")
            throw WRError.apiKeyMissing
        }
        
        let endpoint = "https://api.openweathermap.org/data/2.5/weather?lat=45.815399&lon=15.966568&appid=\(apiKey)"
        guard let url = URL(string: endpoint) else { throw WRError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw WRError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(WeatherResponse.self, from: data)
        } catch {
            throw WRError.invalidData
        }
    }
}

#Preview {
    ContentView()
}

struct WeatherDayView: View {
    
    var weatherDay: WeatherDay
    
    var body: some View {
        VStack{
            Text(weatherDay.dayOfWeek)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundStyle(Color.white)
            
            Image(systemName: weatherDay.imageName)
                .symbolRenderingMode(.multicolor)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            Text("\(weatherDay.temperature)°")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(Color.white)
        }
    }
}

struct BackgroundView: View {
    var isNight: Bool
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [
            isNight ? Color.black : Color.blue,
            isNight ? Color.gray : Color.purple]),
                       startPoint: .topLeading,
                       endPoint: .bottomLeading)
        .ignoresSafeArea()
    }
}

struct CityTextView: View {
    var cityName: String
    var body: some View {
        Text(cityName)
            .font(.system(size: 32, weight: .medium, design: .monospaced))
            .foregroundStyle(Color.white)
            .padding()
    }
}

struct MainWeatherStatusView: View {
    var imageName: String
    var temperature: Int
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            
            Text("\(temperature)°")
                .font(.system(size: 70, weight: .medium))
                .foregroundStyle(Color.white)
        }
        .padding(.bottom, 40)
    }
}


enum WRError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case apiKeyMissing
}
//Chalenges
//* Swipe days like modern social networks, up and down
//* Get real data from weather API
//* Finish implementing day/night mode
//* Implement GPS location
//* Implement change location
//* Implement two days free, and other days are available for premium users
//* Implement heavy weather notification, available only for paid users
//*

