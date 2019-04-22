//
//  PSpecialFlightListModel.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/3.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class PSpecialFlightListModel: NSObject,ALSwiftyJSONAble {

    
    var responsesList:[BaseFlightProductListVo] = Array()
    
    var companyMap:[BaseCompanyInfoVo] = Array()
    
    
    override init() {
    }
    
    required init?(jsonData: JSON) {
        responsesList = jsonData["responses"].arrayValue.map{BaseFlightProductListVo.init(jsonData: $0)!}
        companyMap = jsonData["companyMap"].arrayValue.map{BaseCompanyInfoVo.init(jsonData: $0)!}
    }
    
    class BaseFlightProductListVo: NSObject ,ALSwiftyJSONAble{
        ///出发地
        var departure:String = ""
        ///目的地 ,
        var destination:String = ""
        ///退改规则
        var eiRule:String = ""
        ///商品ID
        var id:String = ""
        
        //机票类型： 0：国内机票，1：国际机票 ,
        var flightType:String = ""
        
        ///机票产品类型 A:定投机票 F:特价机票 ,
        var productType:String = ""
        /// 售卖结束时间
        var saleEndTime:String = ""
        ///售价
        var saleRate:Float = 0
        ///售卖开始时间 ,
        var saleStartTime:String = ""
        /// 库存
        var stock:NSNumber = 0
        ///行程类型（0：单程，1：往返）
        var tripType:String = ""
        
        var companyCode:String = ""
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            departure = jsonData["departure"].stringValue
            destination = jsonData["destination"].stringValue
            eiRule = jsonData["eiRule"].stringValue
            id = jsonData["id"].stringValue
            flightType = jsonData["flightType"].stringValue
            productType = jsonData["productType"].stringValue
            saleEndTime = jsonData["saleEndTime"].stringValue
            saleRate = jsonData["saleRate"].floatValue
            saleStartTime = jsonData["saleStartTime"].stringValue
            stock = jsonData["stock"].numberValue
            tripType = jsonData["tripType"].stringValue
            companyCode = jsonData["companyCode"].stringValue
            
        }
       
    }
    
    class BaseCompanyInfoVo:NSObject ,ALSwiftyJSONAble  {
        
        ///  航司 ,
        var company:String = ""
        
        /// 航司编码
        var companyCode:String = ""
        
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            company = jsonData["company"].stringValue
            companyCode = jsonData["companyCode"].stringValue
        }
    }
    
    
}
