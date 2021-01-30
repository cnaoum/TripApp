//
//  Util.swift
//  Assignment4
//
//   Created by Maria Leticia Leoncio Barbosa
//   Created by Carolina Naoum Junqueira.
//

import Foundation
import UIKit


class Util{
    
    static var errors : String?
}

extension String {
    
    func containsNumbers() -> Bool {
        let range = self.rangeOfCharacter(from: NSCharacterSet.decimalDigits)
        if let _ = range {
            return true
        } else {
            return false
        }
    }
    
    func containsSymbols() -> Bool {
        let range = self.rangeOfCharacter(from: NSCharacterSet.symbols)
        if let _ = range {
            return true
        } else {
            return false
        }
    }
    
    func toDouble(minimumFractionDigits: Int, maximumFractionDigits: Int) -> Double {
        let nf = NumberFormatter()
        nf.minimumFractionDigits = minimumFractionDigits
        nf.maximumFractionDigits = maximumFractionDigits
        return nf.number(from: self)!.doubleValue
    }
    
    func toDouble() -> Double {
        return self.toDouble(minimumFractionDigits: 0, maximumFractionDigits: 2)
    }
}

extension Double {
    
    func toString(minimumFractionDigits: Int, maximumFractionDigits: Int) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = minimumFractionDigits
        nf.maximumFractionDigits = maximumFractionDigits
        return nf.string(from: NSNumber(value: self))!
    }
    
    func toString() -> String {
        return self.toString(minimumFractionDigits: 0, maximumFractionDigits: 2)
    }
}
