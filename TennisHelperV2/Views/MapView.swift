//
//  MapViewV2.swift
//  TennisHelperV2
//
//  Created by Shyamsai Bethina on 2/2/22.
//

import SwiftUI
import MapKit
import Foundation

struct MapView: View {
    var courts = loadCSV(from: "Courts")
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.808208, longitude: -122.415802), latitudinalMeters: 5000, longitudinalMeters: 5000)
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: courts) { court in
            MapAnnotation(coordinate: court.coordinate.locationCoordinate()) {
                Image("Court icon")
                    .resizable()
                    .frame(width: 32, height: 32)
                    
            }
        }
        
//        Map(coordinateRegion: $region, showsUserLocation: true)
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
