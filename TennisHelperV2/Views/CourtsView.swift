//
//  CourtsView.swift
//  TennisHelperV2
//
//  Created by Shyamsai Bethina on 1/27/22.
//

import SwiftUI
import MapKit

struct CourtsView: View {
        
    var body: some View {
        NavigationView {
            MapView()
            .navigationTitle("Courts Near You")
        }
    }
}

struct CourtsView_Previews: PreviewProvider {
    static var previews: some View {
        CourtsView()
    }
}
