//
//  ContentView.swift
//  TennisHelperV2
//
//  Created by Shyamsai Bethina on 1/26/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            CourtsView()
                .tabItem {
                    Image(systemName: "location")
                    Text("Courts")
                }
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
        }
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
    }
}
