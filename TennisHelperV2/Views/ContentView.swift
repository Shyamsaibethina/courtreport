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
            BracketView()
                .tabItem {
                    Image(systemName: "play")
                    Text("Bracket")
                }
            CourtsView()
                .tabItem{
                    Image(systemName: "location")
                    Text("Courts")
                }
        }
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
