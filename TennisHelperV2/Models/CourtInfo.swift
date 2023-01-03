import MapKit
import SwiftUI

struct CourtInfo: View {
    enum ScreenBounds {
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
    var googleMaps = false
    @State private var showMapDialog = false
    @State private var didTap: Bool = false

    @State var timeText = 0
    var weatherAltered = ["Clouds": "Cloudy",
                          "Clear": "Clear",
                          "Thunderstorm": "Thundering",
                          "Drizzle": "Drizzling",
                          "Rain": "Raining",
                          "Snow": "Snowing",
                          "Atmosphere": "Foggy",
                          "Haze": "Hazy",
                          "Mist": "Misty"]

    var body: some View {
        ScrollView(showsIndicators: true) {
            VStack {
                ZStack(alignment: .bottom) {
                    Map(coordinateRegion: .constant(MKCoordinateRegion(center: court.coordinate.locationCoordinate(), span: MapDetails.defaultSpan)), showsUserLocation: true, annotationItems: [court])
                    {
                        court in
                        MapMarker(coordinate: court.coordinate.locationCoordinate())
                    }
                    Text("Click here for directions")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .underline()
                        .padding(.bottom, 5)
                }
                    .frame(width: ScreenBounds.width * 0.95, height: 175 * scale, alignment: .top)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .offset(y: offsetForMap)
                    .padding()
                    .confirmationDialog("Pick a map", isPresented: $showMapDialog) {
                    Button("Google Maps") {
                        let googleURL = URL(string: "comgooglemaps://?saddr=&daddr=\(court.coordinate.latitude),\(court.coordinate.longitude)&directionsmode=driving")
                        if UIApplication.shared.canOpenURL(googleURL!) {
                            UIApplication.shared.open(googleURL!, options: [:], completionHandler: nil)
                        } else {
                            print("Can't use comgooglemaps://")
                        }
                    }
                    Button("Apple Maps") {
                        let url = URL(string: "maps://?saddr=&daddr=\(court.coordinate.latitude),\(court.coordinate.longitude)")
                        if UIApplication.shared.canOpenURL(url!) {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        }
                    }
                }
                    .onTapGesture {
                    let googleURL = URL(string: "comgooglemaps://?saddr=&daddr=\(court.coordinate.latitude),\(court.coordinate.longitude)&directionsmode=driving")
                    if UIApplication.shared.canOpenURL(googleURL!) {
                        self.showMapDialog = true
                    } else {
                        let url = URL(string: "maps://?saddr=&daddr=\(court.coordinate.latitude),\(court.coordinate.longitude)")
                        if UIApplication.shared.canOpenURL(url!) {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        }
                    }
                }

                Text(court.name)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .offset(y: offsetForMap)
                    .minimumScaleFactor(0.7)
                    .frame(width: ScreenBounds.width * 0.95, height: 50)
                

                HStack(alignment: .center, spacing: 70) {
                    // DRIVE TIME
                    VStack {
                        Image(systemName: "car.fill")
                            .font(.system(size: 40.0))
                            .foregroundColor(.blue)
                            .offset(y: offsetForIcons)


                        Divider()
                            .frame(width: 120, height: 5)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .offset(y: offsetForDivider)

                        if (timeText / 60 > 59) {
                            Text("\(timeText / 60 / 60)")
                                .italic()
                                .font(.system(size: 50, weight: .bold, design: .rounded))
                                .offset(y: offsetForTime)
                            Text((timeText / 60 / 60 == 1) ? "hour" : "hours")
                                .offset(y: offsetForTime)
                        } else {
                            Text("\(timeText / 60)")
                                .italic()
                                .font(.system(size: 50, weight: .bold, design: .rounded))
                                .offset(y: offsetForTime)
                            Text((timeText / 60 == 1) ? "minute" : "minutes")
                                .offset(y: offsetForTime)
                        }

                    }
                        .overlay(RoundedRectangle(cornerRadius: 25)
                        .stroke(.blue, lineWidth: 5)
                        .frame(width: 160, height: 160))


                    // Number of COURTS
                    VStack {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 40.0))
                            .foregroundColor(.blue)
                            .offset(y: offsetForIcons - 1)

                        Divider()
                            .frame(width: 120, height: 5)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .offset(y: offsetForDivider - 6)


                        Text(court.count)
                            .italic()
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .offset(y: offsetForTime - 7)

                        Text((Int(court.count) == 1) ? "court" : "courts")
                            .offset(y: offsetForTime - 7)
                    }
                        .overlay(RoundedRectangle(cornerRadius: 25)
                        .stroke(.blue, lineWidth: 5)
                        .frame(width: 160, height: 160))
                }
                    .offset(y: offsetForMap + 20)




                HStack(alignment: .center, spacing: 70) {
                    // Indoor
                    VStack {
                        if #available(iOS 16.0, *) {
                            Image(systemName: "house.lodge")
                                .foregroundColor(court.indoor == "TRUE" ? .green:
                                .red)
                                .font(.system(size: 50))
                                .offset(y: offsetForIcons - 20)
                        } else {
                            Image(systemName: "house")
                                .foregroundColor(court.indoor == "TRUE" ? .green:
                                .red)
                                .font(.system(size: 50))
                                .offset(y: offsetForIcons - 20)
                        }


                        Divider()
                            .frame(width: 120, height: 5)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .offset(y: offsetForDivider - 20)

                        VStack(alignment: .center) {
                            Text("Indoor Courts: ")
                            Text(court.indoor == "TRUE" ? "Available" : "Not Available")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(court.indoor == "TRUE" ? .green : .red)
                                .padding(.bottom, 1)
                        }
                    }
                        .overlay(RoundedRectangle(cornerRadius: 25)
                        .stroke(court.indoor == "TRUE" ? .green : .red, lineWidth: 5)
                        .frame(width: 160, height: 160))
                        .onAppear {
                        getWaitTime(court, completion: { time in
                            timeText = time!
                        })
                    }

                    
                    // Lighting
                    VStack {
                        Image(systemName: court.lights == "TRUE" ? "lightbulb" : "lightbulb.slash")
                            .foregroundColor(court.lights == "TRUE" ? .green : .red)
                            .font(.system(size: 40))
                            .offset(y: offsetForIcons - 16)


                        Divider()
                            .frame(width: 120, height: 5)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .offset(y: offsetForDivider - 21)

                        VStack(alignment: .center) {
                            Text("Lighting:")
                            Text(court.lights == "TRUE" ? "Available" : "Not Available")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(court.lights == "TRUE" ? .green : .red)
                                .padding(.bottom, 1)
                        }
                            .padding(.bottom, 6)
                    }

                        .overlay(RoundedRectangle(cornerRadius: 25)
                        .stroke(court.lights == "TRUE" ? .green : .red, lineWidth: 5)
                        .frame(width: 160, height: 160))
                        .offset(x: court.lights == "TRUE" ? -9: -18)

                }
                .padding(.leading, court.lights == "TRUE" ? 0: 20)
                .padding(.bottom, 40)

                HStack(spacing: 50) {
                    // PROSHOP
                    VStack {
                        Image(systemName: court.proshop == "TRUE" ?
                        "cart.badge.plus": "cart.badge.minus")
                            .foregroundColor(court.proshop == "TRUE" ? .green : .red)
                            .font(.system(size: 50))
                            .offset(x: -5, y: offsetForIcons - 10)


                        Divider()
                            .frame(width: 120, height: 5)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .offset(y: offsetForDivider - 15)

                        VStack(alignment: .center) {
                            Text("Proshop:")
                            Text(court.proshop == "TRUE" ? "Available" : "Not Available")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(court.proshop == "TRUE" ? .green : .red)
                                .padding(.bottom, 1)
                        }
                            .padding(.bottom)
                    }

                        .overlay(RoundedRectangle(cornerRadius: 25)
                        .stroke(court.proshop == "TRUE" ? .green : .red, lineWidth: 5)
                        .frame(width: 160, height: 160))
                        //.offset(x: -19)

                    // Types of Courts
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 23) {
                            Text("Clay:")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold, design: .rounded))

                            Text("Grass:")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold, design: .rounded))

                            Text("Backboard:")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                        }

                        VStack(alignment: .trailing, spacing: 15) {
                            Image(systemName: court.clay == "TRUE" ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(court.clay == "TRUE" ? .green : .red)
                                .font(.title)

                            Image(systemName: court.grass == "TRUE" ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(court.grass == "TRUE" ? .green : .red)
                                .font(.title)

                            Image(systemName: court.wall == "TRUE" ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(court.wall == "TRUE" ? .green : .red)
                                .font(.title)
                        }
                    }
                        .overlay(RoundedRectangle(cornerRadius: 25)
                        .stroke(LinearGradient(gradient: Gradient(stops: [.init(color: court.clay == "TRUE" ? .green : .red, location: 0.30), .init(color: court.grass == "TRUE" ? .green : .red, location: 0.60), .init(color: court.wall == "TRUE" ? .green : .red, location: 1.0)]), startPoint: .top, endPoint: .bottom), lineWidth: 5)
                        .frame(width: 160, height: 160))
                        //.padding(.trailing, -10)
                }
                


                // WEATHER VIEW
                VStack {
                    if let weather = weather {
                        VStack {
                            Text("It is currently")
                                .font(.title2)
                                .fontWeight(.semibold)

                            Text(weatherAltered[weather.weather[0].main] ?? "")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                            icon(weather.weather[0].main)
                        }
                            .padding(.top)

                        VStack(spacing: 40) {
                            HStack(spacing: 60) {
                                HStack(spacing: 10) {
                                    Image(systemName: "thermometer")
                                        .font(.system(size: 40))
                                        .foregroundColor(.teal)
                                    VStack(spacing: 10) {
                                        Text("Min Temp")
                                        Text("\(Int(weather.main.tempMin))°")
                                            .font(.system(size: 30))
                                            .fontWeight(.bold)
                                            .foregroundColor(.teal)
                                    }
                                        .offset(x: 11)
                                }

                                HStack(spacing: 10) {
                                    VStack(spacing: 10) {
                                        Text("Max Temp")
                                        Text("\(Int(weather.main.tempMax))°")
                                            .font(.system(size: 30))
                                            .fontWeight(.bold)
                                            .foregroundColor(.orange)
                                    }
                                    Image(systemName: "thermometer")
                                        .font(.system(size: 40))
                                        .foregroundColor(.orange)
                                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                        .offset(x: 6)
                                }
                            }

                            HStack(spacing: 50) {
                                HStack(spacing: 10) {
                                    Image(systemName: "wind")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                        .offset(x: 10)
                                    VStack(spacing: 10) {
                                        Text("Wind")
                                        Text("\(Int(weather.wind.speed)) m/s")
                                            .font(.system(size: 30))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                }

                                HStack(spacing: 10) {
                                    VStack(spacing: 10) {
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
                            do {
                                weather = try await weatherService.getCurrentWeather(latitude: court.coordinate.latitude, longitude: court.coordinate.longitude)
                            } catch {
                                print("Error getting weather: \(error)")
                            }
                        }
                    }
                }

                VStack {
                    if let forecast = forecast {
                        VStack(spacing: 20) {
                            Text("Forecasted weather in the next hour")
                                .font(.title2)
                                .fontWeight(.semibold)

                            VStack {
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

                            HStack(spacing: 50) {
                                VStack {
                                    Image(systemName: "cloud.rain.fill")
                                        .font(.system(size: 50))
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.gray, .blue)

                                    Text("\(Int(forecast.hourly[0].pop))%")
                                }

                                VStack {
                                    Image(systemName: "wind")
                                        .font(.system(size: 50))
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.gray)

                                    Text("\(Int(forecast.hourly[0].wind_speed)) m/s")
                                }
                            }
                        }
                            .padding(.top)
                        Spacer()
                    } else {
                        Text("")
                            .task {
                            do {
                                forecast = try await weatherService.getForecastWeather(latitude: court.coordinate.latitude, longitude: court.coordinate.longitude)
                            } catch {
                                print("Error getting forecast: \(error)")
                            }
                        }
                    }
                }
                    .padding(.top)
            }
                .padding(.bottom, 10)
        }
            .background(
            LinearGradient(gradient: Gradient(stops: [.init(color: .black, location: 0.5), .init(color: .gray, location: 1.0)]), startPoint: .top, endPoint: .bottom)
        )
    }

    func getWaitTime(_ court: Court, completion: @escaping (Int?) -> Void) {
        let location = locationManager.getUserCoordinates()
        let source = MKPlacemark(coordinate: location)
        let destination = MKPlacemark(coordinate: court.coordinate.locationCoordinate())

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { response, _ in
            guard let route = response?.routes.first else { return }
            completion(Int(route.expectedTravelTime))
        }
    }

    @ViewBuilder
    func icon(_ weatherMain: String) -> some View {
        switch weatherMain {
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
        case "Haze":
            Image(systemName: "sun.haze.fill")
                .font(.system(size: 70))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.gray, .yellow)
        case "Mist":
            Image(systemName: "cloud.fill")
                .font(.system(size: 70))
                .foregroundColor(.cyan)


        default:
            Image(systemName: "questionmark")
                .font(.system(size: 70))
                .foregroundColor(.red)
        }
    }
}

