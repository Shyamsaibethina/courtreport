import SwiftUI

struct SearchView: View {
    @State var viewModel: MapViewModel
    @ObservedObject var radius: Radius
    var body: some View {
        NavigationView {
            SearchList(viewModel: viewModel, radius: radius)
                .navigationTitle("Search Courts")
        }
    }
}

