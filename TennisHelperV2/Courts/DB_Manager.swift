//
//  DB_Manager.swift
//  TennisHelperV2
//
//  Created by Shyamsai Bethina on 10/24/22.
//

import Foundation
import SQLite

class DB_Manager {
    private var db: Connection!
    
    private var courts: Table!
    public var id: Expression<Int64>!
    public var name: Expression<String>!
    public var type: Expression<String>!
    public var count: Expression<String>!
    public var clay: Expression<String>!
    public var wall: Expression<String>!
    public var grass: Expression<String>!
    public var indoor: Expression<String>!
    public var lights: Expression<String>!
    public var proshop: Expression<String>!
    public var latitude: Expression<String>!
    public var longitude: Expression<String>!
    
    
    init () {
        do {
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            
            db = try Connection("\(path)/Courts.sqlite3")
            courts = Table("Courts.sqlite3")
            
            //id = Expression<Int64>("id")
            name = Expression<String>("name")
            type = Expression<String>("type")
            count = Expression<String>("count")
            clay = Expression<String>("clay")
            wall = Expression<String>("wall")
            grass = Expression<String>("grass")
            indoor = Expression<String>("indoor")
            lights = Expression<String>("lights")
            proshop = Expression<String>("proshop")
            latitude = Expression<String>("latitude")
            longitude = Expression<String>("longitude")
            
//            if (!UserDefaults.standard.bool(forKey: "is_db_created")) {
//
//                // if not, then create the table
//                try db.run(courts.create { (t) in
//                    t.column(name)
//                    t.column(type)
//                    t.column(count)
//                    t.column(clay)
//                    t.column(wall)
//                    t.column(grass)
//                    t.column(indoor)
//                    t.column(lights)
//                    t.column(proshop)
//                    t.column(latitude)
//                    t.column(longitude)
//                })
//
//                // set the value to true, so it will not attempt to create the table again
//                UserDefaults.standard.set(true, forKey: "is_db_created")
//            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func getUsers() -> [CourtModel] {
        var courtModels: [CourtModel] = []
        
        do {
            // loop through all users
            print("For loop before")
            for court in try db.prepare(courts) {
                print("For loop working")
                
                // create new model in each loop iteration
                let courtModel: CourtModel = CourtModel()
         
                // set values in model from database
                //courtModel.id = court[id]
                courtModel.name = court[name]
                courtModel.type = court[type]
                courtModel.count = court[count]
                courtModel.clay = court[clay]
                courtModel.wall = court[wall]
                courtModel.grass = court[grass]
                courtModel.indoor = court[indoor]
                courtModel.lights = court[lights]
                courtModel.proshop = court[proshop]
                courtModel.latitude = court[latitude]
                courtModel.longitude = court[longitude]
                // append in new array
                courtModels.append(courtModel)
            }
        } catch {
            print(error.localizedDescription)
        }
         
        // return array
        return courtModels
    }
    
}
