//
//  CoPointAddressModel.swift
//  shop
//
//  Created by TBI on 2018/1/24.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class CoPointAddressModel {

    ///poi的id
    var uid:String = ""
    /// 城市名称
    var city:String = ""
    /// Point 名称
    var name:String = ""
    //  目的地地址
    var address = ""
    /// 区域编码
    var adcode:String = ""
    /// 纬度
    var latitude: NSNumber = 0
    /// 经度
    var longitude: NSNumber = 0

    class func localTip(tip:AMapTip,city:String) ->CoPointAddressModel {
        guard tip.uid.isEmpty == false && tip.location != nil && tip.address.isEmpty == false else {
            return CoPointAddressModel()
        }
        let  location:CoPointAddressModel = CoPointAddressModel()
        location.name = tip.name
        location.latitude = NSNumber.init(value: Double(tip.location.latitude))
        location.longitude = NSNumber.init(value: Double(tip.location.longitude))
        location.uid = tip.uid
        location.city = city
        location.adcode = tip.adcode
        location.address = tip.address
        return location
    }
    
    class func localPOI(poi:AMapPOI,city:String) ->CoPointAddressModel {
        guard poi.uid.isEmpty == false && poi.location != nil && poi.address.isEmpty == false else {
            return CoPointAddressModel()
        }
        let  location:CoPointAddressModel = CoPointAddressModel()
        location.name = poi.name
        location.latitude = NSNumber.init(value: Double(poi.location.latitude))
        location.longitude = NSNumber.init(value: Double(poi.location.longitude))
        location.uid = poi.uid
        location.city = poi.city
        location.adcode = poi.adcode
        location.address = poi.city + poi.district + poi.address
        return location
    }
    
}
