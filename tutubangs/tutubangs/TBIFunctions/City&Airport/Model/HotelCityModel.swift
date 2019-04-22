//
//  CityModel.swift
//  shanglvjia
//
//  Created by manman on 2018/4/23.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class HotelCityModel: NSObject,ALSwiftyJSONAble,NSCoding {

    var  cityCode:String = ""
    var  cnName:String = ""
    var  countryCode:String = ""
    var  countryName:String = ""
    var  elongId:String = ""
    var  enName:String = ""
    var  gmtCreate:String = ""
    var  gmtModified:String = ""
    var  id:String = ""
    var  userCreate:String = ""
    var  userModified:String = ""
    var  regionType:String = ""
    
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        self.cityCode = jsonData["cityCode"].stringValue
        self.cnName = jsonData["cnName"].stringValue
        self.countryCode = jsonData["countryCode"].stringValue
        self.countryName = jsonData["countryName"].stringValue
        self.elongId = jsonData["elongId"].stringValue
        self.enName = jsonData["enName"].stringValue
        self.gmtCreate = jsonData["gmtCreate"].stringValue
        self.gmtModified = jsonData["gmtModified"].stringValue
        self.id = jsonData["id"].stringValue
        self.userCreate = jsonData["userCreate"].stringValue
        self.userModified = jsonData["userModified"].stringValue
        self.regionType = jsonData["regionType"].stringValue
    }
    
    func encode(with aCoder: NSCoder) {
        self.mj_encode(aCoder)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.mj_decode(aDecoder)
    }
    
    
}


/// 城市分组实体
class HotelCityGroup :NSObject,DictionaryAble{
    /// 城市拼音缩写首字母
    let firstCharacter:String
    var cities:[HotelCityModel] = []
    init(firstCharacter:String,cities:[HotelCityModel]) {
        self.firstCharacter = firstCharacter.uppercased()
        self.cities = cities
    }
}

class CityCategoryRegionModel:NSObject,ALSwiftyJSONAble {
    
    var travelpolicyLimit:String = ""
    var commericalRegion:[RegionModel] = Array()
    var districtRegion:[RegionModel] = Array()
    var landmarkRegion:[RegionModel] = Array()
    var cityBrandInfos:CityBrandInfos?
    
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        self.travelpolicyLimit = jsonData["travelpolicyLimit"].stringValue
        self.commericalRegion = jsonData["commerical"].arrayValue.map{CityCategoryRegionModel.RegionModel.init(jsonData: $0)!}
        self.districtRegion = jsonData["district"].arrayValue.map{CityCategoryRegionModel.RegionModel.init(jsonData: $0)!}
        self.landmarkRegion = jsonData["landmark"].arrayValue.map{CityCategoryRegionModel.RegionModel.init(jsonData: $0)!}
        self.cityBrandInfos = CityBrandInfos.init(jsonData:jsonData["cityBrandInfos"])
        
    }
    
    
    
    class RegionModel: NSObject ,ALSwiftyJSONAble{
        var name:String = ""
        var id:String = ""
        
        
        override init() {
            
        }
        required init?(jsonData: JSON) {
            self.name = jsonData["name"].stringValue
            self.id = jsonData["id"].stringValue
        }
    }
   
    
    class CityBrandInfos: NSObject,ALSwiftyJSONAble{
        var firstClass:[HotelBrandInfos]?
        var secondClass:[HotelBrandInfos]?
        var thirdClass:[HotelBrandInfos]?
        var forthClass:[HotelBrandInfos]?
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            if jsonData["1"].arrayValue.count > 0 {
                firstClass = jsonData["1"].arrayValue.map{HotelBrandInfos.init(jsonData: $0)!}
            }
            if jsonData["2"].arrayValue.count > 0 {
                secondClass = jsonData["2"].arrayValue.map{HotelBrandInfos.init(jsonData: $0)!}
            }
            if jsonData["3"].arrayValue.count > 0 {
                thirdClass = jsonData["3"].arrayValue.map{HotelBrandInfos.init(jsonData: $0)!}
            }
            if jsonData["4"].arrayValue.count > 0 {
                forthClass = jsonData["4"].arrayValue.map{HotelBrandInfos.init(jsonData: $0)!}
            }
        }
        
    }
    
    
    class HotelBrandInfos:NSObject,ALSwiftyJSONAble{
        var brandElongId:String = ""
        var brandName:String = ""
        var brandType:String = ""
        var cityElongId:String = ""
        var id:String = ""
        
        override init() {
            
        }
        
        
        required init?(jsonData: JSON) {
            self.brandElongId = jsonData["brandElongId"].stringValue
            self.brandName = jsonData["brandName"].stringValue
            self.brandType = jsonData["brandType"].stringValue
            self.cityElongId = jsonData["cityElongId"].stringValue
            self.id = jsonData["id"].stringValue
        }
        
    }
}





