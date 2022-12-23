import SwiftUI

struct ContentView: View {
    @State var viewModel = MapViewModel()
    @StateObject var radius = Radius()
    var body: some View {
        TabView {
            CourtsView(viewModel: viewModel, radius: radius)
                .tabItem {
                Image(systemName: "location")
                Text("Courts")
            }
            SearchView(viewModel: viewModel, radius: radius)
                .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
        }
            .onAppear {
            viewModel.checkIfLocationServicesIsEnabled()
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
