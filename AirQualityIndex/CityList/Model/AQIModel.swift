//
//  AQIModel.swift
//  AirQualityIndex
//
//  Created by Sushant Hegde on 19/08/21.
//

import Foundation
import UIKit


struct AQICity: Hashable{
    var name : String
    
    init(name:String) {
        self.name = name
    }
}

struct CityAQIDetails{
    var city : AQICity
    var aqi : Double
    
    init(city:AQICity,aqi:Double) {
        self.city = city
        self.aqi = aqi
    }
}

extension CityAQIDetails{
    
    var aqiUpto2Decimal : Double{
        return aqi.rounded(toPlaces: 2)
    }
    
}

