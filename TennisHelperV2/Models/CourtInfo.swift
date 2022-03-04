//
//  SwiftUIView.swift
//  TennisHelperV2
//
//  Created by Shyamsai Bethina on 2/20/22.
//

import SwiftUI
import MapKit

struct CourtInfo: View {    
    @State var court: Court
    @ScaledMetric var offset: CGFloat = -60
    @StateObject private var viewModel = MapViewModel()
    @StateObject var locationManager = LocationManager()
    @State var timeText = ""
    
    var body: some View {

        VStack{
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: court.coordinate.locationCoordinate(), span: MapDetails.defaultSpan)), showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: [court])
            {
                court in
                MapMarker(coordinate: court.coordinate.locationCoordinate())
            }
            .frame(width: UIScreen.main.bounds.width * 0.95, height: 175, alignment: .top)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .offset(y:offset)
            .padding()
            Text(court.name)
            Text("Number of Courts: "+court.count)
            Text("Indoor: "+court.indoor)
            Text(timeText)
            Text("Coordinates \(court.coordinate.latitude),\(court.coordinate.longitude)")
            Spacer()
        }.onAppear{
            getWaitTime(court, completion: { time in
                timeText = String(time!)
            })
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





