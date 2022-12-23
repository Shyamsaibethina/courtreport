import MapKit
import SwiftUI

struct CourtsView: View {
    @State var viewModel: MapViewModel
    @ObservedObject var radius: Radius
    var body: some View {
        NavigationView {
            MapView(viewModel: viewModel, radius: radius)
                .navigationTitle("Courts Near You")
        }
    }
}

struct CourtsView_Previews: PreviewProvider {
    static var previews: some View {
        CourtsView(viewModel: MapViewModel(), radius: Radius())
    }
}
