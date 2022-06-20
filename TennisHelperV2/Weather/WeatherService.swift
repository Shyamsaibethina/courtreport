//
//  WeatherService.swift
//  TennisHelperV2
//
//  Created by Shyamsai Bethina on 3/18/22.
//

import CoreLocation
import Foundation

class WeatherService {
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=88dce22caf207b82fdf1441b71968359&units=imperial") else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }

        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)

        return decodedData
    }

    func getForecastWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ForecastBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=current,minutely,daily,alerts&appid=88dce22caf207b82fdf1441b71968359&units=imperial") else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }

        let decodedData = try JSONDecoder().decode(ForecastBody.self, from: data)

        return decodedData
    }
}

struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse

    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }

    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }

    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }

    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

struct ForecastBody: Decodable {
    var hourly: [HourlyResponse]

    struct HourlyResponse: Decodable {
        var weather: [WeatherResponse]
        var wind_speed: Double
        var wind_deg: Double
        var pop: Double

        struct WeatherResponse: Decodable {
            var id: Double
            var main: String
            var description: String
            var icon: String
        }
    }
}

extension ResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}
