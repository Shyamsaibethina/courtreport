//
//  MapViewModel.swift
//  TennisHelperV2
//
//  Created by Shyamsai Bethina on 1/27/22.
//

import MapKit

enum MapDetails{
    static let startingLocation = CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
}

class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation? = nil
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(  manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
    }
    
    func locationManager(  manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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
            MapDetails.defaultSpan)

    var locationManagar: CLLocationManager?

    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManagar = CLLocationManager()
            locationManagar?.delegate = self

        } else{

        }
    }

     private func checkLocationAuthorization() {
        guard let locationManagar = locationManagar else { return }

        switch locationManagar.authorizationStatus {

            case .notDetermined:
                locationManagar.requestWhenInUseAuthorization()
            case .restricted:
                print("Your location is restricted")
            case .denied:
                print("You've denied location permission")
            case .authorizedAlways, .authorizedWhenInUse:
                region = MKCoordinateRegion(center: locationManagar.location!.coordinate,
                                        span: MapDetails.defaultSpan)
            @unknown default:
                break
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
