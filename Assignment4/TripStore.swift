//
//  TripStore.swift
//  Assignment4
//
//  Created by Maria Leticia Leoncio Barbosa
//  Created by Carolina Naoum Junqueira.
//

import UIKit
import Foundation

class TripStore {
    var tripArray : [Trip] = []
    let tripArchiveURL : URL = {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        print(documentDirectory)
        return documentDirectory.appendingPathComponent("trips.archive")
    }()
    
    init() {
        do {
            if let data = UserDefaults.standard.data(forKey: "SavedTrips") {
                let archivedTrips = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, Trip.self], from: data) as? [Trip]
                self.tripArray = archivedTrips!
            } else {
                print("data does not exist in defaults")
            }
        } catch {
            print("unarchiving failed")
        }
    }
    
    func saveChanges() -> Bool {
        var result : Bool = true
        print("Saving trips to \(tripArchiveURL.path)")
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: tripArray, requiringSecureCoding: true)
            try data.write(to: tripArchiveURL)
            UserDefaults.standard.set(data, forKey: "SavedTrips")
        } catch {
            result = false
            print("write failed")
        }
        return result
    }
}
