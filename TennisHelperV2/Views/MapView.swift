//
//  MapViewV2.swift
//  TennisHelperV2
//
//  Created by Shyamsai Bethina on 2/2/22.
//

import SwiftUI
import MapKit
import Foundation
import CoreLocationUI

struct MapView: View {

    @StateObject private var viewModel = MapViewModel()
    @State private var count = 0

    var body: some View {
        let courts = loadCSV(miles: 20, viewModel: viewModel)
        //ADD ANIMATION
        ZStack(alignment: .topTrailing){
            Map(coordinateRegion: .constant(viewModel.region), showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: courts){
                court in
                MapAnnotation(coordinate: court.coordinate.locationCoordinate()) {
                    NavigationLink(destination: CourtInfo(court: court), label: {
                                    ZStack{
                                        Circle()
                                            .foregroundColor(.white)
                                            .frame(width: 35, height: 35)
                                        
                                        Image("Court icon")
                                            .resizable()
                                            .offset(y:3)
                                    }
                                    .frame(width: 70, height: 70)
                                })
                }
            }.onAppear{
                if count==0{
                    viewModel.checkIfLocationServicesIsEnabled()
                    count+=1
                }
            }

            LocationButton(.currentLocation) {
                viewModel.checkIfLocationServicesIsEnabled()
            }
            .foregroundColor(.white)
            .cornerRadius(8)
            .labelStyle(.iconOnly)
            .symbolVariant(.fill)
            .padding(10)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}



