//
//  MapViewV2.swift
//  TennisHelperV2
//
//  Created by Shyamsai Bethina on 2/2/22.
//

import SwiftUI
import MapKit
import Foundation
import CoreLocation

struct MapView: View {
    
    
    @StateObject private var viewModel = MapViewModel()
    
    

    
    func addAnnotationInRadius(radius: Double, courts: [Court]) -> [Court]{
        let user = CLLocation(latitude: viewModel.region.center.latitude, longitude: viewModel.region.center.longitude)
        
        var filterCourts = [Court]()
        
        for court in courts {
            let courtLocation = CLLocation(latitude: court.coordinate.latitude, longitude: court.coordinate.longitude)
            
            let distance = user.distance(from: courtLocation)
            
            if distance <= radius{
                filterCourts.append(court)
            }
        
        }
        return filterCourts
    }
    
    
        
    
    
    
    var body: some View {
        let courts = loadCSV(from: "Courts", miles: 10, viewModel: viewModel)
        
        
        Map(coordinateRegion: .constant(viewModel.region), showsUserLocation: true, annotationItems: courts){
            court in
            MapAnnotation(coordinate: court.coordinate.locationCoordinate()) {
               Image("Court icon")
                   .resizable()
                   .frame(width: 32, height: 32)
           }
        }
        .onAppear{
            viewModel.checkIfLocationServicesIsEnabled()
        }
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}



