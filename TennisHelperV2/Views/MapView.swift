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
    //@StateObject private var regionWrapper = RegionWrapper()

    var body: some View {
        let courts = loadCSV(from: "Courts", miles: 20, viewModel: viewModel)
        
        ZStack(alignment: .topTrailing){
            Map(coordinateRegion: .constant(viewModel.region), showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: courts){
                court in
                MapAnnotation(coordinate: court.coordinate.locationCoordinate()) {
                    NavigationLink(destination: CourtInfo(court: court), label: {
                                    ZStack{
                                        Circle()
                                            .foregroundColor(court.indoor=="TRUE" ? .orange : .white)
                                            .frame(width: 35, height: 35)
                                        
                                        Image("Court icon")
                                            .resizable()
                                            .offset(y:3)
                                    }
                                    .frame(width: 75, height: 75)
                                })
                        
                }
            }.onAppear{
                if count==0{
                    viewModel.checkIfLocationServicesIsEnabled()
                    count+=1
                }
                //updateRegion(newRegion: viewModel.region)
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

//    func updateRegion(newRegion: MKCoordinateRegion) {
//        withAnimation{
//            regionWrapper.region.wrappedValue = newRegion
//            regionWrapper.flag.toggle()
//        }
//    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

//class RegionWrapper: ObservableObject {
//
//
//
//    var _region: MKCoordinateRegion = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
//
//    var region: Binding<MKCoordinateRegion> {
//        Binding(
//            get: { self._region },
//            set: { self._region = $0 }
//        )
//    }
//
//    @Published var flag = false
//}



