//
//  ContentView.swift
//  TennisHelperV2
//
//  Created by Shyamsai Bethina on 1/26/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            MapView()
                .navigationTitle("Courts Near You")
        }
        //CourtsView()
//        TabView{
//            CourtsView()
//                .tabItem{
//                    Image(systemName: "location")
//                    Text("Courts")
//                }
//            LogView()
//                .tabItem {
//                    Image(systemName: "note.text")
//                    Text("Logs")
//                }
//        }
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
    }
}
