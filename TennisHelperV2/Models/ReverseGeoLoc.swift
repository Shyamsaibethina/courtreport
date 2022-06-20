//
//  ReverseGeoLoc.swift
//  TennisHelperV2
//
//  Created by Shyamsai Bethina on 5/30/22.
//

import Foundation
import MapKit

struct Address: Codable {
    let data: [Data]
}

struct Data: Codable {
    let latitude, longitude: Double
    let name: String?
}

class MapAPI: ObservableObject {
    private let BASE_URL = "http://api.positionstack.com/v1/forward"
    private let API_KEY = "572efa17c6c7921ab7d7d0bb9ddc27e7"

    @Published var coordinates = []

    init() {}

    func getLocation(address: String) {
        let pAddress = address.replacingOccurrences(of: " ", with: "%20")
        let url_string = "\(BASE_URL)?access_key=\(API_KEY)&query=\(pAddress)"

        guard let url = URL(string: url_string) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error!.localizedDescription)
                return
            }

            guard let newCoordinates = try? JSONDecoder().decode(Address.self, from: data) else { return }

            if newCoordinates.data.isEmpty {
                print("Could not find the address")
                return
            }

            DispatchQueue.main.async {
                let details = newCoordinates.data[0]
                let lat = details.latitude
                let lon = details.longitude

                self.coordinates = [lat, lon]

                // print(self.coordinates)
            }
        }
        .resume()
    }
}
