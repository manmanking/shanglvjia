//
//  PTravelIndependentDetailModel.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/14.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class PTravelIndependentDetailModel: NSObject ,ALSwiftyJSONAble{

    /// 出发地 ,
    var dept:String = ""
    
    ///  出发地中文 ,
    var deptCN:String = ""
    var id:String = ""
    var minPrice:String = ""
    
    /// 商品名称 ,
    var name:String = ""
    
    /// 总库存 ,
    var stockCount:NSInteger = 0
    
    ///需要二次确认
    var needTcConfirm:String = ""
    
    ///  类型0目的游1跟团游2自由行
    var type:String = ""
    
    var products:[IndependentProductResponse] = Array()
    
    var surances:[SuranceResponse] = Array()
    
    var invoices:[InvoicesModel] = Array()
    
    var remind:String = ""
    ///是否国际  0国内1国际 ,
    var international:Bool = false
    ///需要出境
    var needExit:Bool = false
    
    override init() {
        
    }
    
    
    required init?(jsonData: JSON) {
        dept = jsonData["dept"].stringValue
        deptCN = jsonData["deptCN"].stringValue
        id = jsonData["id"].stringValue
        minPrice = jsonData["minPrice"].stringValue
        name = jsonData["name"].stringValue
        stockCount = jsonData["stockCount"].intValue
        type = jsonData["type"].stringValue
        needTcConfirm = jsonData["needTcConfirm"].stringValue
        products = jsonData["products"].arrayValue.map{IndependentProductResponse.init(jsonData: $0)!}
        invoices = jsonData["invoices"].arrayValue.map{InvoicesModel.init(jsonData: $0)!}
        remind = jsonData["remind"].stringValue
        international = jsonData["international"].boolValue
        needExit = jsonData["needExit"].boolValue
        surances = jsonData["surances"].arrayValue.map{SuranceResponse.init(jsonData: $0)!}
    }
    
    class IndependentProductResponse:NSObject,ALSwiftyJSONAble{
        var count : String = ""
//        costRate (number, optional): 成本价 ,
        var costRate:String = ""
//        id (integer, optional): id ,
        var id:String = ""
//        nightNum (integer, optional): 夜间数 ,
        var childNum:String = ""
        var nightNum:String = ""
//        personNum (integer, optional): 每间房人数 ,
        var personNum:String = ""
//        productName (string, optional): 名称 ,
        var productName:String = ""
//        productType (integer, optional): 1机票2酒店3签证4用车5目的地旅游 ,
        var productType:String = ""
//        profits (number, optional): 利润 ,
        var profits:String = ""
//        roomRate (number, optional): 房费 ,
        var roomRate:String = ""
//        saleRate (number, optional): 销售价 ,
        var saleRate:String = ""
//        supplier (string, optional): 供应商 ,
        var supplier:String = ""
//        supplierName (string, optional): 供应商中文 ,
        var supplierName:String = ""
//        type (integer, optional): 类型0普通1附加
        var type:String = ""
        ///productNo
        var productNo:String = ""
        ///币种
        var currency:String = ""
        
        required init?(jsonData: JSON) {
            count = jsonData["count"].stringValue
            costRate = jsonData["costRate"].stringValue
            nightNum = jsonData["nightNum"].stringValue
            childNum = jsonData["childNum"].stringValue
            id = jsonData["id"].stringValue
            personNum = jsonData["personNum"].stringValue
            productName = jsonData["productName"].stringValue
            productType = jsonData["productType"].stringValue
            profits = jsonData["profits"].stringValue
            type = jsonData["type"].stringValue
            roomRate = jsonData["roomRate"].stringValue
            saleRate = jsonData["saleRate"].stringValue
            supplier = jsonData["supplier"].stringValue
            supplierName = jsonData["supplierName"].stringValue
            productNo = jsonData["productNo"].stringValue
            currency = jsonData["currency"].stringValue
        }
        
        
    }
    class SuranceResponse: NSObject,ALSwiftyJSONAble {
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
