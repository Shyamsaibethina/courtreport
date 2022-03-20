//
//  BracketView.swift
//  TennisHelper
//
//  Created by Shyamsai Bethina on 1/26/22.
//

import SwiftUI 

struct HomeView: View {
    @StateObject private var locationManager = LocationManager()
    @State var weatherService = WeatherService()
    @State var weather: ResponseBody?
    var weatherAltered = ["Clouds":"Cloudy",
                          "Clear":"Clear",
                          "Thunderstorm":"Thundering",
                          "Drizzle":"Drizzling",
                          "Rain":"Raining",
                          "Snow":"Snowing",
                          "Atmosphere":"Foggy"]
    
    
    var body: some View {
        VStack{
            if let weather = weather {
                Text("It is currently")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Text(weatherAltered[weather.weather[0].main]!)
                    .font(.title)
                    .fontWeight(.heavy)
                icon(weather.weather[0].main)
                Text("near you")
                
                Spacer()
            } else {
                Text("Fetching weather data")
                    .task {
                        do{
                            weather = try await weatherService.getCurrentWeather(latitude: locationManager.getUserCoordinates().latitude,
                                                                                 longitude: locationManager.getUserCoordinates().longitude)
                            
                        }
                        catch {
                            print("Error getting weather: \(error)")
                        }
                    }
            }
            
        }
    }
    
    @ViewBuilder
    func icon(_ weatherMain: String) -> some View {
        switch weatherMain{
        case "Clouds":
            Image(systemName: "cloud.fill")
                .font(.system(size: 70))
                .foregroundColor(.gray)
            
        case "Clear":
            Image(systemName: "sun.max.fill")
                .font(.system(size: 70))
                .foregroundColor(.yellow)
            
        case "Thunderstorm":
            Image(systemName: "cloud.bolt.fill")
                .font(.system(size: 70))
                .foregroundColor(.gray)
                .background(.yellow)
            
        case "Drizzle":
            Image(systemName: "cloud.drizzle.fill")
                .font(.system(size: 70))
                .foregroundColor(.gray)
                .background(.blue)
            
        case "Rain":
            Image(systemName: "cloud.rain.fill")
                .font(.system(size: 70))
                .foregroundColor(.gray)
                .background(.blue)
            
        case "Snow":
            Image(systemName: "cloud.snow.fill")
                .font(.system(size: 70))
                .foregroundColor(.gray)
                .background(.white)
            
        case "Atmosphere":
            Image(systemName: "cloud.fog.fill")
                .font(.system(size: 70))
                .foregroundColor(.gray)
                .background(.gray)
            
        default :
            Image(systemName: "questionmark")
                .font(.system(size: 70))
                .foregroundColor(.red)
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
