//
//  PersonalSpecialFlightInfoListResponse.swift
//  shanglvjia
//
//  Created by manman on 2018/9/7.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class PersonalSpecialFlightInfoListResponse: NSObject ,ALSwiftyJSONAble{

    
    /// 有效日期集合 ,
    var deaprtureDates:[String] = Array()
    
    /// 航程信息
    var responses:[BaseFlightAndReturnInfoVo] = Array()
    
    
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        deaprtureDates = jsonData["deaprtureDates"].arrayValue.map{$0.stringValue}
        responses = jsonData["responses"].arrayValue.map{BaseFlightAndReturnInfoVo.init(jsonData: $0)!}
    }
    
    
    
    
    class BaseFlightAndReturnInfoVo: NSObject,ALSwiftyJSONAble {
         ///舱位价格信息 ,
        var cabinInfos:[PSepcailFlightCabinModel.CabinInfosList] = Array()
        
        ///  cashID ,
        var flightCacheId:String = ""
        
        ///  商品ID ,
        var id:String = ""
        
        
        /// 0 国内 1 国际
        var flightNation:String = ""
        
        
        /// 返程可选时间 ,
        var returnDateList:[String] = Array()
        
        ///  航程信息
        var segment:[PSepcailFlightCabinModel.Segments] = Array()
        
        /// 行程类型（0：单程，1：往返)
        var tripType:String = ""
        
        var selectedCabinsIndex:NSInteger = 0
        
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            cabinInfos = jsonData["cabinInfos"].arrayValue.map{PSepcailFlightCabinModel.CabinInfosList.init(jsonData: $0)!}
            flightCacheId = jsonData["flightCacheId"].stringValue
            id = jsonData["id"].stringValue
            returnDateList = jsonData["returnDateList"].arrayValue.map{$0.stringValue}
            segment = jsonData["segment"].arrayValue.map{PSepcailFlightCabinModel.Segments.init(jsonData: $0)!}
            tripType = jsonData["tripType"].stringValue
        }
   
    }
    
    
    
}
