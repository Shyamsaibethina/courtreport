import SwiftSoup
import Foundation
import SwiftUI
import CoreLocation

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
        return CLLocationCoordinate2D(latitude: self.latitude,
                                      longitude: self.longitude)
    }
}

func loadCSV(from csvName: String) -> [Court] {
    var csvToStruct = [Court]()

    //locat the csv file
    guard let filePath = Bundle.main.path(forResource: csvName, ofType: "csv") else {
        return []
    }

    //convert the contents of the file into one very long string
    var data = ""
    do {
        data = try String(contentsOfFile: filePath)
    } catch{
        print(error)
        return []
    }

    //split the long string into an array of "rows of data. Each row is a string
    //detect "/n" carriage return, then split
    var rows = data.components(separatedBy: "\n")

    //remove header rows
    rows.removeFirst()

    print(rows)

    //now loop around each row and split into columns
    for row in rows[..<(rows.count-1)] {
        let csvColumns = row.components(separatedBy: ",")
        let teamStruct = Court.init(raw:csvColumns)
        csvToStruct.append(teamStruct)
        print(teamStruct)
    }

    return csvToStruct
}
