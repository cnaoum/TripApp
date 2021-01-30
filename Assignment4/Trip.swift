//
//  Trip.swift
//  Assignment4
//
//  Created by Maria Leticia Leoncio Barbosa
//  Created by Carolina Naoum Junqueira.
//

import Foundation

class Trip : NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        get {
            return true
        }
    }
    
    var origin : String
    var destination : String
    var gas : String
    
    override init() {
        origin = ""
        destination = ""
        gas = ""
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(origin, forKey: "origin")
        aCoder.encode(destination, forKey: "destination")
        aCoder.encode(gas, forKey: "gas")
    }
    
    required init(coder aDecoder: NSCoder) {
        origin = aDecoder.decodeObject(forKey: "origin") as! String
        destination = aDecoder.decodeObject(forKey: "destination") as! String
        gas = aDecoder.decodeObject(forKey: "gas") as! String
        
        super.init()
    }
    
    // function to convert gas unit from galons to liters
    func gasInLiters() -> String {
        if gas.count != 0 {
            let formatter = NumberFormatter()
            if let gasGallon = formatter.number(from: gas)?.doubleValue, gasGallon > 0, gasGallon < 2000 {
                let gasInGalons = Measurement(value: gasGallon, unit: UnitVolume.gallons)
                return gasInGalons.converted(to: UnitVolume.liters).value.toString()
            }
        }
        return "0"
        
    }
}
