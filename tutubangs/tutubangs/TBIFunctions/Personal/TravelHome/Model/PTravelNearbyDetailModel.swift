//
//  PTravelNearbyDetailModel.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/14.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class PTravelNearbyDetailModel: NSObject,ALSwiftyJSONAble {
    /// 出发地 ,
    var dept:String = ""
    
    ///  出发地中文 ,
    var deptCN:String = ""
    var id:String = ""
    var minPrice:String = ""
    
    /// 商品名称 ,
    var name:String = ""
    ///是否二次确认
    var needTcConfirm:String = ""
    
    ///商品缩略图 ,
    var pic:String = ""
    
    /// 总库存 ,
    var stockCount:NSInteger = 0
    
    ///  类型0目的游1跟团游2自由行
    var type:String = ""
    
    var products:[NearbyProductResponse] = Array()
    
    var surances:[NearbySuranceResponse] = Array()
    var invoices:[InvoicesModel] = Array()
    ///预订须知
    var orderattention:String = ""
    ///是否国际  0国内1国际 ,
    var international:Bool = false
    
    override init() {
        
    }
    
    
    required init?(jsonData: JSON) {
        dept = jsonData["dept"].stringValue
        deptCN = jsonData["deptCN"].stringValue
        id = jsonData["id"].stringValue
        minPrice = jsonData["minPrice"].stringValue
        name = jsonData["name"].stringValue
        needTcConfirm = jsonData["needTcConfirm"].stringValue
        pic = jsonData["pic"].stringValue
        stockCount = jsonData["stockCount"].intValue
        type = jsonData["type"].stringValue
        products = jsonData["products"].arrayValue.map{NearbyProductResponse.init(jsonData: $0)!}
        orderattention = jsonData["orderattention"].stringValue
        international = jsonData["international"].boolValue
         surances = jsonData["surances"].arrayValue.map{NearbySuranceResponse.init(jsonData: $0)!}
          invoices = jsonData["invoices"].arrayValue.map{InvoicesModel.init(jsonData: $0)!}
    }
    class NearbyProductResponse:NSObject,ALSwiftyJSONAble{
        ///costRate (number, optional): 成本价 ,
        var costRate:String = ""
        ///id (integer, optional): id ,
        var id:String = ""
        ///productName (string, optional): 名称 ,
        var productName:String = ""
        var productNo:String = ""
        ///saleRate (number, optional): 销售价
        var saleRate:String = ""
        ///类型:1普通2附加
        var type:String = ""
        var count:String = ""
        ///币种
        var currency:String = ""
        //        supplier (string, optional): 供应商 ,
        var supplier:String = ""
        //        supplierName (string, optional): 供应商中文 ,
        var supplierName:String = ""
        
        required init?(jsonData: JSON) {
            costRate = jsonData["costRate"].stringValue
            id = jsonData["id"].stringValue
            productName = jsonData["productName"].stringValue
            saleRate = jsonData["saleRate"].stringValue
            type = jsonData["type"].stringValue
            count = jsonData["count"].stringValue
            productNo = jsonData["productNo"].stringValue
            currency = jsonData["currency"].stringValue
            supplier = jsonData["supplier"].stringValue
            supplierName = jsonData["supplierName"].stringValue
        }
        
    }
    
    class NearbySuranceResponse: NSObject,ALSwiftyJSONAble {
        var id:String = ""
        var suranceAgentPrice:String = ""
        //"suranceCompany":"保险公司",
        var suranceCompany:String = ""
        //"suranceDesc":"保险描述",
        var suranceDesc:String = ""
        //"suranceId":1,
        var suranceId:String = ""
        //保险名字,
        var suranceName:String = ""
        var suranceProductNo:String = ""
        var suranceSalePrice:String = ""
        var count:String = ""
        
        required init?(jsonData: JSON) {
            id = jsonData["id"].stringValue
            suranceAgentPrice = jsonData["suranceAgentPrice"].stringValue
            suranceCompany = jsonData["suranceCompany"].stringValue
            suranceDesc = jsonData["suranceDesc"].stringValue
            suranceId = jsonData["suranceId"].stringValue
            suranceName = jsonData["suranceName"].stringValue
            suranceProductNo = jsonData["suranceProductNo"].stringValue
            suranceSalePrice = jsonData["suranceSalePrice"].stringValue
            count = jsonData["count"].stringValue
        }
        
        
    }
    class InvoicesModel: NSObject,ALSwiftyJSONAble {
        var name:String = ""
        var value:String = ""
        required init?(jsonData: JSON) {
            name = jsonData["name"].stringValue
            value = jsonData["value"].stringValue
        }
    }
}
