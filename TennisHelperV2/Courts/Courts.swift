import CoreLocation
import Foundation
import SwiftUI

struct Court: Codable, Identifiable {
    let id = UUID()
    var name: String
    var type: String
    var count: String
    var clay: String
    var wall: String
    var grass: String
    var indoor: String
    var lights: String
    var proshop: String
    var coordinate: Coordinate

    init(raw: [String]) {
        name = raw[1]
        type = raw[2]
        count = raw[3]
        clay = raw[4]
        wall = raw[5]
        grass = raw[6]
        indoor = raw[7]
        lights = raw[8]
        proshop = raw[9]
        coordinate = Coordinate(latitude: (raw[10] as NSString).doubleValue, longitude: (raw[11] as NSString).doubleValue)
    }
}

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double

    func locationCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude,
                                      longitude: longitude)
    }
}

func loadCSV(miles: Double?, viewModel: MapViewModel?) -> [Court] {
    var csvToStruct = [Court]()



    // locate the csv file
    guard let filePath = Bundle.main.path(forResource: "Courts", ofType: "csv") else {
        return []
    }

    // convert the contents of the file into one very long string
    var data = ""
    do {
        data = try String(contentsOfFile: filePath)
    } catch {
        print(error)
        return []
    }

    // split the long string into an array of "rows of data. Each row is a string
    // detect "/n" carriage return, then split
    var rows = data.components(separatedBy: "\n")

    // remove header rows
    rows.removeFirst()

    // now loop around each row and split into columns
    for row in rows[..<(rows.count - 1)] {
        let csvColumns = row.components(separatedBy: ",")
        var teamStruct = Court(raw: csvColumns)
        teamStruct.name = teamStruct.name.replacingOccurrences(of: "\"", with: "")


        if let miles = miles {
            if let viewModel = viewModel {
                let user = CLLocation(latitude: viewModel.region.center.latitude, longitude: viewModel.region.center.longitude)
                let courtLocation = CLLocation(latitude: teamStruct.coordinate.latitude, longitude: teamStruct.coordinate.longitude)
                let distance = user.distance(from: courtLocation)

                if distance <= (miles * 1609.34) {
                    csvToStruct.append(teamStruct)
                }
            }
        } else {
            csvToStruct.append(teamStruct)
        }

    }

    return csvToStruct
}
