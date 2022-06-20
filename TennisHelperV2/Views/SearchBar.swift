//
//  SearchBar.swift
//  TennisHelperV2
//
//  Created by Shyamsai Bethina on 5/8/22.
//

import MapKit
import SwiftUI

struct SearchBar: View {
    @State var search = ""
    @StateObject var reverseGeo = MapAPI()
    var viewModel: MapViewModel
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(.gray)
                .frame(width: 370, height: 40)
                .opacity(0.3)
                .shadow(color: .gray, radius: 10)
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search Address", text: $search)
                    .onSubmit {
                        reverseGeo.getLocation(address: search)
                        print(viewModel.region)
                        if !reverseGeo.coordinates.isEmpty {
                            viewModel.changeLocation(latitude: reverseGeo.coordinates[0] as! CLLocationDegrees, longitude: reverseGeo.coordinates[1] as! CLLocationDegrees)
                        }
                    }
            }
            .padding()
        }
    }
}
