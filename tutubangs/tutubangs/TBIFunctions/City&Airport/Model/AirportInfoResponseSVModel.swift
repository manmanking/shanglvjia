//
//  AirportInfoResponseSVModel.swift
//  shanglvjia
//
//  Created by manman on 2018/3/15.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON
import MJExtension


class AirportInfoResponse: NSObject,ALSwiftyJSONAble {
  
    
    var airportInfos:[AirportInfoResponseSVModel] = Array()
    override init() {
        
    }
    required init?(jsonData: JSON) {
        self.airportInfos = jsonData["airportInfos"].arrayValue.map{AirportInfoResponseSVModel(jsonData:$0)!}
    }
    
    
    /// 机场排序
    public func airportSort(airportArr:[AirportInfoResponseSVModel]) -> [AirportGroup] {
        var sortArr:[AirportGroup] = Array()
        airportArr.forEach { (element) in
            let firstCharacter:String = element.airportNameEn.first?.description ?? "#"
            //for elementGroup
            
            if let tmpAirportGroup = sortArr.first(where:{$0.firstCharacter.uppercased() == firstCharacter.uppercased()}){
                tmpAirportGroup.airportarr.append(element)
            }else{
                 sortArr.append(AirportGroup(firstCharacter: firstCharacter, airportArr: [element]))
            }
        }
        
        return sortArr.sorted{ $0.firstCharacter < $1.firstCharacter }.map{ group in
            group.airportarr = group.airportarr.sorted{ $0.airportPy < $1.airportPy }
            return group
        }
    }
    /// 城市转首字母排序格式格式
    ///
    /// - Parameter cities: 待排序城市
    /// - Returns: 排序后的城市组
    private func citiesToGroups(_ cities:[City]) -> [CityGroup]{
        var groups:[CityGroup] = []
        cities.forEach{ cityItem in
            //获取首字母
            let firstCode:String = cityItem.spell.characters.first?.description ?? "没有首字母"
            if let currentGroup = groups.first(where: {$0.code.uppercased() == firstCode.uppercased()}) {
                currentGroup.cities.append(cityItem)
            } else {
                //如果不存在该字母的项则创建
                groups.append(CityGroup(code: firstCode, cities: [cityItem]))
            }
        }
        //排序
        return  groups.sorted{ $0.code < $1.code}.map{ group in
            group.cities = group.cities.sorted{ $0.spell < $1.spell }
            return group
        }
    }
    
}


class AirportGroup: NSObject {
    var firstCharacter:String = ""
    var airportarr:[AirportInfoResponseSVModel] = Array()
    override init() {}
    init(firstCharacter:String,airportArr:[AirportInfoResponseSVModel]) {
        self.firstCharacter = firstCharacter
        self.airportarr = airportArr
    }
}

class AirportInfoResponseSVModel: NSObject,NSCoding,ALSwiftyJSONAble{
 

    var airportCode:String = ""
    
    var airportComment:String = ""
    var airportName:String = ""
    var airportNameEn:String = ""
    var airportPy:String = ""
    var airportTimeZone:String = ""
    var cityCode:String = ""
    var gmtCreate:String = ""
    var gmtModified:String = ""
    var id:NSInteger = 0
    var userCreate:NSInteger = 0
    var userModified:NSInteger = 0
    
    
    override required init() {
        super.init()
    }
    
    required init?(jsonData: JSON) {
        self.airportCode = jsonData["airportCode"].stringValue
        self.airportName = jsonData["airportName"].stringValue
        self.airportNameEn = jsonData["airportNameEn"].stringValue
        self.airportPy = jsonData["airportPy"].stringValue
        self.airportTimeZone = jsonData["airportTimeZone"].stringValue
        self.cityCode = jsonData["cityCode"].stringValue
        self.gmtCreate = jsonData["gmtCreate"].stringValue
        self.id = jsonData["id"].intValue
        self.userCreate = jsonData["userCreate"].intValue
        self.userModified = jsonData["userModified"].intValue
        
    }
    
    func encode(with aCoder: NSCoder) {
        self.mj_encode(aCoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.mj_decode(aDecoder)
    }
    
    
    
}
