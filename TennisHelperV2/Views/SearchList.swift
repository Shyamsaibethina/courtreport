//
//  SearchList.swift
//  TennisHelperV2
//
//  Created by Shyamsai Bethina on 10/19/22.
//

import SwiftUI

struct SearchList: View {
    @State var searchQuery = ""
    @State var courts = loadFullCSV()
    let fullCourts = loadFullCSV()
    @State var courtModels: [CourtModel] = []
    var body: some View {
//        List(courtModels) { court in
//            Text(court.name)
//                .foregroundColor(.white)
//        }
//        .onAppear {
//            courtModels = DB_Manager().getUsers()
//        }
        List(courts) { court in
            NavigationLink(destination: CourtInfo(court: court)) {
                Text(court.name)
            }
        }
        .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search By Court Name")
        .onSubmit(of: .search) {
            filterCourts()
        }
        .onChange(of: searchQuery) { _ in
            filterCourts()
        }
            
    }
    
    func filterCourts() {
        if searchQuery.isEmpty {
            courts = fullCourts
        } else {
            courts = fullCourts.filter {
                $0.name
                    .localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
}
