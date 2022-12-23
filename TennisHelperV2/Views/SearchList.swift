import SwiftUI
import CoreLocationUI

struct SearchList: View {
    @State var searchQuery = ""
    @State var viewModel: MapViewModel
    @State var courts: [Court] = []
    @State var fullCourts: [Court] = []
    @State var count = 0
    @ObservedObject var radius: Radius
    var body: some View {

        List(courts) { court in
            NavigationLink(destination: CourtInfo(court: court)) {
                Text(court.name)
            }
        }
            .onAppear {
            courts = loadCSV(miles: radius.radius, viewModel: viewModel)
            fullCourts = loadCSV(miles: radius.radius, viewModel: viewModel)

        }
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search By Court Name")
            .onSubmit(of: .search) {
            filterCourts(courts, fullCourts)
        }
            .onChange(of: searchQuery) { _ in
            filterCourts(courts, fullCourts)
        }
    }

    func filterCourts(_ courts: [Court], _ fullCourts: [Court]) {
        if searchQuery.isEmpty {
            self.courts = fullCourts
        } else {
            self.courts = fullCourts.filter {
                $0.name
                    .localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
}
