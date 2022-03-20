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

    
    @State var timeText = 0
    
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
}





