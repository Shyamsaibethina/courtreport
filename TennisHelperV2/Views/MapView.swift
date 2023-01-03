import CoreLocationUI
import Foundation
import MapKit
import SwiftUI

struct MapView: View {
    @StateObject public var viewModel: MapViewModel
    @State private var reverseGeo = MapAPI()
    @State private var count = 0
    @ObservedObject var radius: Radius

    var body: some View {
        let courts = loadCSV(miles: radius.radius, viewModel: viewModel)

        ZStack(alignment: .topTrailing) {
            Map(coordinateRegion: .constant(viewModel.region), showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: courts) {
                court in
                MapAnnotation(coordinate: court.coordinate.locationCoordinate()) {
                    NavigationLink(destination: CourtInfo(court: court)) {
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 35, height: 35)

                            Image("Court icon")
                                .resizable()
                                .offset(y: 3)
                        }
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .frame(width: 35, height: 35)
                            .contextMenu {
                            Button(action: {
                                let url = URL(string: "maps://?saddr=&daddr=\(court.coordinate.latitude),\(court.coordinate.longitude)")
                                if UIApplication.shared.canOpenURL(url!) {
                                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                }
                            }) {
                                Text(court.name)
                                Image(systemName: "car.fill")
                            }
                        }
                    }
                }
            }
                .onAppear {
                if count == 0 {
                    viewModel.checkIfLocationServicesIsEnabled()
                    count += 1
                }
            }
                .ignoresSafeArea(.keyboard)

            VStack(alignment: .trailing) {
                LocationButton(.currentLocation) {
                    viewModel.checkIfLocationServicesIsEnabled()
                }
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .labelStyle(.iconOnly)
                    .symbolVariant(.fill)
                    .tint(.blue)
                    .padding(10)

                Spacer()

                Rectangle()
                    .fill(.black)
                    .frame(height: 70)
                    .overlay(
                    HStack {
                        Button {
                            if (radius.radius > 10) {
                                radius.radius -= 10
                            } else if (radius.radius > 5) {
                                radius.radius -= 5
                            }
                        } label: {
                            Image(systemName: "minus.circle")
                        }
                            .foregroundStyle(.red)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .padding(.bottom)
                        VStack {
                            Text("\(Int(radius.radius))")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                            Text("mile radius")
                        }

                        Button {
                            if (radius.radius < 100) {
                                if (radius.radius < 10) {
                                    radius.radius += 5
                                } else {
                                    radius.radius += 10
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                            .foregroundStyle(.green)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .padding(.bottom)
                    }
//                    VStack(spacing: 0) {
//                        Text("Courts in a ") +
//                            Text("\(Int(radius.radius))")
//                            .foregroundColor(.green) +
//                            Text(" mile radius")
//                        HStack {
//                            Image(systemName: "minus")
//                                .foregroundColor(.red)
//                            Slider(value: $radius.radius, in: 20...100, step: 10)
//                                .tint(.white)
//                            Image(systemName: "plus")
//                                .foregroundColor(.green)
//                        }
//                            .frame(width: UIScreen.main.bounds.width * 0.9)
//                    }
                )
            }

        }
    }
}
