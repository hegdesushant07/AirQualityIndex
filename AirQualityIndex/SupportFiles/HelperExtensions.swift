//
//  HelperFunctions.swift
//  AirQualityIndex
//
//  Created by Sushant Hegde on 19/08/21.
//

import Foundation
import UIKit

typealias StringAnyDict = [String: Any]

extension String{
    
    func fromJSON(string: String) throws -> [StringAnyDict] {
        let data = string.data(using: .utf8)!
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject] else {
            throw NSError(domain: NSCocoaErrorDomain, code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON"])
        }
        return jsonObject.map { $0 as! StringAnyDict }
    }
    
    var parseData : [StringAnyDict]?{
        let arr = try? self.fromJSON(string: self)
        return arr
    }
    
}

extension Double {

    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIColor {
    
    static var aqiGoodColor: UIColor {
        UIColor(red: 106/255, green: 165/255, blue: 90/255, alpha: 1.0)
    }
    static var aqiSatisfactoryColor: UIColor {
        UIColor(red: 170/255, green: 198/255, blue: 100/255, alpha: 1.0)
    }
    static var aqiModerateColor: UIColor {
        UIColor(red: 255/255, green: 247/255, blue: 95/255, alpha: 1.0)
    }
    static var aqiPoorColor: UIColor {
        UIColor(red: 231/255, green: 159/255, blue: 74/255, alpha: 1.0)
    }
    static var aqiVpoorColor: UIColor {
        UIColor(red: 216/255, green: 77/255, blue: 62/255, alpha: 1.0)
    }
    static var aqiSevereColor: UIColor {
        UIColor(red: 161/255, green: 56/255, blue: 44/255, alpha: 1.0)
    }
    
}
