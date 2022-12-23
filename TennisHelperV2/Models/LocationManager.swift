import MapKit
import SwiftUI

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
}

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation? = nil

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func getUserCoordinates() -> CLLocationCoordinate2D {
        locationManager.location!.coordinate
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(manager _: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
    }

    func locationManager(manager _: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }

        self.location = location
    }
}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(
        center: MapDetails.startingLocation,
        span:
            MapDetails.defaultSpan
    )

    var locationManager: CLLocationManager?

    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingHeading()
            locationManager?.startUpdatingLocation()
            locationManager?.delegate = self
        }
    }

    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }

        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted")
        case .denied:
            print("You've denied location permission")
        case .authorizedAlways, .authorizedWhenInUse:
            withAnimation {
                self.region = MKCoordinateRegion(center: locationManager.location!.coordinate,
                                                 span: MapDetails.defaultSpan)
            }

        @unknown default:
            break
        }
    }

    func changeLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        withAnimation {
            self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MapDetails.defaultSpan)

        }
    }

    func locationManagerDidChangeAuthorization(_: CLLocationManager) {
        checkLocationAuthorization()
    }
}
