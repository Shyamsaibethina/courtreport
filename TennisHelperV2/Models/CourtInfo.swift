//
//  SwiftUIView.swift
//  TennisHelperV2
//
//  Created by Shyamsai Bethina on 2/20/22.
//

import SwiftUI
import MapKit

struct CourtInfo: View {
    enum ScreenBounds{
        static let width = UIScreen.main.bounds.width
        static let height = UIScreen.main.bounds.height
    }
    
    @State var court: Court
    
    @ScaledMetric var offsetForMap: CGFloat = -60
    @ScaledMetric var offsetForIcons: CGFloat = 10
    @ScaledMetric var offsetForDivider: CGFloat = 10
    @ScaledMetric var offsetForTime: CGFloat = -5
    @ScaledMetric var scale: CGFloat = 1
    
    @StateObject private var viewModel = MapViewModel()
    @StateObject var locationManager = LocationManager()
    @State var weatherService = WeatherService()
    @State var weather: ResponseBody?
    @State var forecast: ForecastBody?

    
    @State var timeText = 0
    var weatherAltered = ["Clouds":"Cloudy",
                          "Clear":"Clear",
                          "Thunderstorm":"Thundering",
                          "Drizzle":"Drizzling",
                          "Rain":"Raining",
                          "Snow":"Snowing",
                          "Atmosphere":"Foggy"]
    
    var body: some View {

        ScrollView(showsIndicators: true){
            VStack{
                Map(coordinateRegion: .constant(MKCoordinateRegion(center: court.coordinate.locationCoordinate(), span: MapDetails.defaultSpan)), showsUserLocation: true, annotationItems: [court])
                {
                    court in
                    MapMarker(coordinate: court.coordinate.locationCoordinate())
                }
                .frame(width: ScreenBounds.width * 0.95, height: 175 * scale, alignment: .top)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .offset(y: offsetForMap)
                .padding()
                
                Text(court.name)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .offset(y: offsetForMap)
                    .minimumScaleFactor(0.7)
                    .frame(width: ScreenBounds.width * 0.95, height: 50)
                    
                HStack(alignment: .center, spacing: 70){
                    //DRIVE TIME
                    VStack(){
                        Image(systemName: "car.fill")
                            .font(.system(size:40.0))
                            .foregroundColor(.blue)
                            .background(.black)
                            .offset(y: offsetForIcons)
                        
                        Divider()
                            .frame(width: 120, height: 5)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .offset(y: offsetForDivider)
                                                
                        Text("\(timeText/60)")
                            .italic()
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .offset(y: offsetForTime)
                        Text((timeText/60 == 1) ? "minute" : "minutes")
                            .offset(y: offsetForTime)
                
                    }
                    .overlay(RoundedRectangle(cornerRadius: 25)
                                .stroke(.blue, lineWidth: 5)
                                .frame(width: 160, height: 160))
                    .onTapGesture {
                        let url = URL(string: "maps://?saddr=&daddr=\(court.coordinate.latitude),\(court.coordinate.longitude)")
                        if UIApplication.shared.canOpenURL(url!){
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        }
                    }
                              
                    //LIGHTS AND COURTS
                    VStack(){
                        Image(systemName: court.lights=="TRUE" ? "lightbulb": "lightbulb.slash")
                            .font(.system(size:40.0))
                            .foregroundColor(court.lights=="TRUE" ? .green : .red)
                            .offset(y: offsetForIcons)
                        
                        Divider()
                            .frame(width: 120, height: 5)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .offset(y: offsetForDivider-6)
                        
                        Text(court.count)
                            .italic()
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .offset(y: offsetForTime-7)
                        
                        Text("courts")
                            .offset(y: offsetForTime-7)
                    }
                    .overlay(RoundedRectangle(cornerRadius: 25)
                                .stroke(court.lights=="TRUE" ? .green : .red, lineWidth: 5)
                                .frame(width: 160, height: 160))
                    
                }
                .offset(y: offsetForMap+20)
                
                //TYPE OF COURTS
                HStack(alignment: .center, spacing: 70){
                    HStack(spacing: 0){
                        VStack(alignment: .leading, spacing: 10){
                            Text("Clay:")
                                .foregroundColor(.white)
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                
                            
                            Text("Grass:")
                                .foregroundColor(.white)
                                .font(.system(size: 30, weight: .bold, design: .rounded))

                            
                            Text("Backboard:")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .offset(y: 10)

                        }
                        .offset(y: -8)
                        
                        VStack(alignment: .trailing, spacing: 15){
                            Image(systemName: court.clay=="TRUE" ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(court.clay=="TRUE" ? .green : .red)
                                .font(.title)
                            
                            Image(systemName: court.grass=="TRUE" ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(court.grass=="TRUE" ? .green : .red)
                                .font(.title)
                            
                            Image(systemName: court.wall=="TRUE" ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(court.wall=="TRUE" ? .green : .red)
                                .font(.title)
                        }
                    }
                    .overlay(RoundedRectangle(cornerRadius: 25)
                                .stroke(.indigo, lineWidth: 5)
                                .frame(width: 160, height: 160))
                    .offset(x: 10)
                    
                    
                    //INDOOR and PROSHOP
                    VStack{
                        HStack{
                            Text("Indoor:")
                                .foregroundColor(.white)
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .offset(y: -2)
                            
                            Image(systemName: court.indoor=="TRUE" ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(court.indoor=="TRUE" ? .green : .red)
                                .font(.title)
                        }
                        
                        Divider()
                            .frame(width: 120, height: 5)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .offset(y: offsetForDivider-20)
                        
                        VStack{
                            Image(systemName: "cart.fill")
                                .foregroundColor(court.proshop=="TRUE" ? .green : .red)
                                .font(.system(size: 50))
                                .offset(y: -8)
                            
                            Text("Proshop: ")
                                .font(.caption) +
                            Text(court.proshop=="TRUE" ? "Available" : "Not Available")
                                .font(.caption)
                        }
                        
                    }
                    .overlay(RoundedRectangle(cornerRadius: 25)
                                .stroke(.orange, lineWidth: 5)
                                .frame(width: 160, height: 160))
                    .offset(x: -12)
                }
                //Spacer()
            }.onAppear{
                getWaitTime(court, completion: { time in
                    timeText = time!
                })
            }
            .padding(.bottom)
            
            //WEATHER VIEW
            VStack{
                if let weather = weather {
                    VStack{
                        Text("It is currently")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                            Text(weatherAltered[weather.weather[0].main] ?? "")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .padding(.top, 5)
                        icon(weather.weather[0].main)
                    }
                    .padding(.top)
                    
                    
                        VStack(spacing: 40){
                            HStack(spacing: 60){
                                HStack(spacing: 10){
                                    Image(systemName: "thermometer")
                                        .font(.system(size: 40))
                                        .foregroundColor(.teal)
                                    VStack(spacing: 10){
                                        Text("Min Temp")
                                        Text("\(Int(weather.main.tempMin))°")
                                            .font(.system(size: 30))
                                            .fontWeight(.bold)
                                            .foregroundColor(.teal)
                                        
                                    }
                                    .offset(x:11)
                                }
                                
                                HStack(spacing: 10){
                                    VStack(spacing: 10){
                                        Text("Max Temp")
                                        Text("\(Int(weather.main.tempMax))°")
                                            .font(.system(size: 30))
                                            .fontWeight(.bold)
                                            .foregroundColor(.orange)
                                    }
                                    Image(systemName: "thermometer")
                                        .font(.system(size: 40))
                                        .foregroundColor(.orange)
                                        .rotation3DEffect(.degrees(180), axis: (x:0, y:1, z:0))
                                        .offset(x:6)
                                }
                            }
                            
                            
                            HStack(spacing: 50){
                                HStack(spacing: 10){
                                    Image(systemName: "wind")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                        .offset(x: 10)
                                    VStack(spacing: 10){
                                        Text("Wind")
                                        Text("\(Int(weather.wind.speed)) m/s")
                                            .font(.system(size: 30))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        
                                    }
                                }
                                
                                HStack(spacing: 10){
                                    VStack(spacing: 10){
                                        Text("Humidity")
                                        Text("\(Int(weather.main.humidity))%")
                                            .font(.system(size: 30))
                                            .fontWeight(.bold)
                                            .foregroundColor(.blue)
                                            
                                    }
                                    Image(systemName: "humidity.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .padding(.top, 20)

                    Spacer()
                } else {
                    Text("Fetching weather data")
                        .task {
                            do{
                                weather = try await weatherService.getCurrentWeather(latitude: court.coordinate.latitude, longitude: court.coordinate.longitude)
                            }
                            catch {
                                print("Error getting weather: \(error)")
                            }
                        }
                }
            }
            
            VStack{
                if let forecast = forecast {
                    VStack(spacing:20){
                        Text("Forecasted weather in the next hour")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        VStack{
                            Text("It will be")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text(weatherAltered[forecast.hourly[0].weather[0].main] ?? "")
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                    .padding(.top, 5)
                            icon(forecast.hourly[0].weather[0].main)
                        }
                        .padding(.top)
                        
                        HStack(spacing:50){
                            VStack{
                                Image(systemName: "cloud.rain.fill")
                                    .font(.system(size: 50))
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.gray, .blue)
                                    
                                
                                Text("\(Int(forecast.hourly[0].pop))%")
                            }
                            
                            VStack{
                                Image(systemName: "wind")
                                    .font(.system(size: 50))
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.gray)
                                
                                Text("\(Int(forecast.hourly[0].wind_speed))m/s")
                            }

                        }
                        
                    }
                    .padding(.top)
                    Spacer()
                } else {
                    Text("")
                        .task {
                            do{
                                forecast = try await weatherService.getForecastWeather(latitude: court.coordinate.latitude, longitude: court.coordinate.longitude)
                            }
                            catch {
                                print("Error getting forecast: \(error)")
                            }
                        }
                }
            }
            .padding(.top)
        }
    }
    
    
    func getWaitTime(_ court: Court, completion: @escaping (Int?)-> Void){
                
        let location = locationManager.getUserCoordinates()
        let source = MKPlacemark(coordinate: location)
        let destination = MKPlacemark(coordinate: court.coordinate.locationCoordinate())
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            //print(Int(route.expectedTravelTime))
            completion(Int(route.expectedTravelTime))
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
                .symbolRenderingMode(.palette)
                .foregroundStyle(.gray, .yellow)
            
        case "Drizzle":
            Image(systemName: "cloud.drizzle.fill")
                .font(.system(size: 70))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.gray, .blue)
            
        case "Rain":
            Image(systemName: "cloud.rain.fill")
                .font(.system(size: 70))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.gray, .blue)
                
            
        case "Snow":
            Image(systemName: "cloud.snow.fill")
                .font(.system(size: 70))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.gray, .white)
            
        case "Atmosphere":
            Image(systemName: "cloud.fog.fill")
                .font(.system(size: 70))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.gray, .gray)
            
        default:
            Image(systemName: "questionmark")
                .font(.system(size: 70))
                .foregroundColor(.red)
        }
    }
}

