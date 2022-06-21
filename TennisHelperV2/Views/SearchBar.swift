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
    @State var isSearching = false
    @StateObject var reverseGeo = MapAPI()
    var viewModel: MapViewModel
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(.gray)
                // .frame(width: 370, height: 40)
                .opacity(0.3)
                .shadow(color: .gray, radius: 10)
                .padding(.horizontal, 10)
                .padding(.vertical, 30)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search Address", text: $search, onCommit: {
                            //                    reverseGeo.getLocation(address: search)
                            //                    print(viewModel.region)
                            //                    if !reverseGeo.coordinates.isEmpty {
                            //                        viewModel.changeLocation(latitude: reverseGeo.coordinates[0] as! CLLocationDegrees, longitude: reverseGeo.coordinates[1] as! CLLocationDegrees)
                            //                    }
                        })
                        if isSearching {
                            Button(action: { search = "" }, label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 2)
                                    .padding(.trailing, -5)
                            })
                        }
                    }
                    .onTapGesture {
                        isSearching = true
                    }
                    .padding(.horizontal, 32)
                )
                .transition(.move(edge: .trailing))

            if isSearching {
                Button(action: {
                    isSearching = false
                    search = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                }, label: {
                    Text("Cancel")
                        .padding(.trailing)
                        .padding(.leading, 0)
                })
                .transition(.move(edge: .trailing))
            }
        }
    }
}
