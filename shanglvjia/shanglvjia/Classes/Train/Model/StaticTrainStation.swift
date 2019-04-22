//
//  StaticTrainStation.swift
//  shanglvjia
//
//  Created by manman on 2018/4/11.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON


class StaticTrainStation: NSObject ,ALSwiftyJSONAble{
    
    var hotStation:String = ""
    var id:String = ""
    var stationCity:String = ""
    var stationCode:String = ""
    var stationName:String = ""
    var stationPy:String = ""
    
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        self.hotStation = jsonData["hotStation"].stringValue
        self.id = jsonData["id"].stringValue
        self.stationCity = jsonData["stationCity"].stringValue
        self.stationCode = jsonData["stationCode"].stringValue
        self.stationName = jsonData["stationName"].stringValue
        self.stationPy = jsonData["stationPy"].stringValue
    }

    
    func staticTrainStationConvertCityModel() ->City {
        let city:City = City.init(name: self.stationName, code: self.stationCode, spell: self.stationPy)
        return city
    }
    
    
    
    
    
}
