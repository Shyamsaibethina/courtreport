//
//  SearchView.swift
//  TennisHelperV2
//
//  Created by Shyamsai Bethina on 10/19/22.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        NavigationView{
            SearchList()
                .navigationTitle("Search Courts")
        }
    }
}

