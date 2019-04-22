//
//  PSepcailFlightCabinModel.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/6.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class PSepcailFlightCabinModel: NSObject ,ALSwiftyJSONAble{
    
    var responsesList:[String:JSON] = [String:JSON]()
    var deaprtureDatesList:[String] = Array()
    override init() {
    }

    required init?(jsonData: JSON) {
        
        deaprtureDatesList = jsonData["deaprtureDates"].arrayValue.map{$0.stringValue}

        responsesList = jsonData["responses"].dictionaryValue
    }
    
    class ResponsesListVo: NSObject ,ALSwiftyJSONAble{
        
        ///仓位列表
        var cabinInfos:[CabinInfosList] = Array()
        
        var flightCacheId:String = ""
        
        /// 是否是国际 0 国内 1 国际
        var flightNation:String = ""
        
        /// 航班 单程 往返 ///行程类型（0：单程，1：往返）
        var flightTripType:String = ""
        
        /// 机票库存
        var remainTicket:NSNumber = 0
        
        ///离开时间
        var deaprtureDate:String = ""
        /// 选中的仓位信息
        var selectedCabinIndex:NSInteger?
        ///
        var id:String = ""
        ///返回时间
        var returnDate:String = ""
        var segmentD:[Segments]
        var segmentR:[Segments]
        ///往返／单程
        var tripType:String = ""
        
        required init?(jsonData: JSON) {
            cabinInfos =  jsonData["cabinInfos"].arrayValue.map{CabinInfosList.init(jsonData: $0)!}
            deaprtureDate = jsonData["deaprtureDate"].stringValue
            flightCacheId = jsonData["flightCacheId"].stringValue
            
            id = jsonData["id"].stringValue
            returnDate = jsonData["returnDate"].stringValue
            tripType = jsonData["tripType"].stringValue
          
//            segmentD = Segments(jsonData: jsonData["segmentD"])!
//            segmentR = Segments(jsonData: jsonData["segmentR"])!
            segmentD =  jsonData["segmentD"].arrayValue.map{Segments.init(jsonData: $0)!}
            segmentR =  jsonData["segmentR"].arrayValue.map{Segments.init(jsonData: $0)!}
        }
        
        
    }
    class CabinInfosList :NSObject ,ALSwiftyJSONAble{
        ///经济舱婴儿
        var cabin:String = ""
        ///仓位价格
        var cabinPrice:Float = 0
        
        var cabinCacheId:String = ""
        var cabinCode:String = ""
        var cabinEi:String = ""
        
        ///  舱位库存
        var stock:NSNumber = 0
        
        required init?(jsonData: JSON) {
            cabin = jsonData["cabin"].stringValue
            cabinCacheId = jsonData["cabinCacheId"].stringValue
            cabinCode = jsonData["cabinCode"].stringValue
            cabinEi = jsonData["cabinEi"].stringValue
            cabinPrice = jsonData["cabinPrice"].floatValue
            stock = jsonData["stock"].numberValue
        }
    }
    
    class  Segments:ALSwiftyJSONAble{
        ///到达时间
        var arriveTime:String = ""
        ///山东航空
        var company:String = ""
        ///公司代码
        var companyCode:String = ""
        ///
        var crafttype:String = ""
        
        var crafttypeCH:String = ""
        ///出发城市
        var departure:String = ""
        ///到达城市
        var destination:String = ""
        ///航班号
        var flightno:String = ""
        ///经停机场
        var stopAirport:String = ""
        ///出发时间
        var takeOffTime:String = ""
        
        var flightTime:String = ""
        
        required init?(jsonData: JSON) {
            arriveTime = jsonData["arriveTime"].stringValue
            company = jsonData["company"].stringValue
            companyCode = jsonData["companyCode"].stringValue
            crafttype = jsonData["crafttype"].stringValue
            crafttypeCH = jsonData["crafttypeCH"].stringValue
            departure = jsonData["departure"].stringValue
            destination = jsonData["destination"].stringValue
            flightno = jsonData["flightno"].stringValue
            stopAirport = jsonData["stopAirport"].stringValue
            takeOffTime = jsonData["takeOffTime"].stringValue
            flightTime = jsonData["flightTime"].stringValue
        }
    }
    

}
