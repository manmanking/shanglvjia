//
//  ObtCarOrderVO.swift
//  shanglvjia
//
//  Created by manman on 2018/4/8.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya_SwiftyJSONMapper

class ObtCarOrderVO: NSObject,ALSwiftyJSONAble {

    var accountId:String = ""
    var carContact:CarContact = CarContact()
    var carPassengerList:[CarPassenger] = Array()
    var carVO:CarVO = CarVO()
    var corpCode:String = ""
    var orderVO:OrderVO = OrderVO()
    
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        self.accountId = jsonData["accountId"].stringValue
        self.carContact = CarContact(jsonData:jsonData["carContact"])!
        self.carPassengerList = jsonData["carPassengerList"].arrayValue.map{CarPassenger(jsonData:$0)!}
        self.carVO = CarVO(jsonData:jsonData["carVO"])!
        self.corpCode = jsonData["corpCode"].stringValue
        self.orderVO = OrderVO(jsonData:jsonData["orderVO"])!
    }
    
    
    
    class CarContact: NSObject,ALSwiftyJSONAble {
        var cardNo:String = ""
        var cardType:String = ""
        var email:String = ""
        var name:String = ""
        var parId:String = ""
        var phone:String = ""
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            self.cardNo = jsonData["cardNo"].stringValue
            self.cardType = jsonData["cardType"].stringValue
            self.email = jsonData["email"].stringValue
            self.name = jsonData["name"].stringValue
            self.parId = jsonData["parId"].stringValue
            self.phone = jsonData["phone"].stringValue
            
            
        }
    }
    
    class CarPassenger: NSObject,ALSwiftyJSONAble{
        var cardNo:String = ""
        
        ///  (integer, optional): 证件类型 ,
        var cardType:String = ""
        
        ///  (string, optional): 邮件地址 ,
        var email:String = ""
        
        ///  (string, optional): 名称 ,
        var name:String = ""
        
        ///  (string, optional): parId ,
        var parId:String = ""
        
        ///  (string, optional): 电话
        var phone:String = ""
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            self.cardNo = jsonData["cardNo"].stringValue
            self.cardType = jsonData["cardType"].stringValue
            self.email = jsonData["email"].stringValue
            self.name = jsonData["name"].stringValue
            self.parId = jsonData["parId"].stringValue
            self.phone = jsonData["phone"].stringValue
        }
        
    }
    
    class CarVO: NSObject,ALSwiftyJSONAble {
        
        ///  (string, optional): 主用车类型：1.接机；2.送机；3.预约用车 ,
        var carType:String = ""
        
        ///  (string, optional): 车型id ,
        var carTypeId:String = ""
        
        ///  (string, optional): 到达地点 ,
        var endAddress:String = ""
        
        ///  (string, optional): 到达城市 ,
        var endCityName:String = ""
        
        /// (string, optional): 到达地点纬度 ,
        var endLatitude:String = ""
        
        ///  (string, optional): 到达地点经度 ,
        var endLongitude:String = ""
        
        ///  (string, optional): 预订到达时间 ,
        var endTime:String = ""
        
        ///  (string, optional): 报销人成本中心id ,
        var expenseCostcenterid:String = ""
        
        ///  (string, optional): 报销人成本中心名称 ,
        var expenseCostcentername:String = ""
        
        ///  (string, optional): 报销人名称 ,
        var expenseName:String = ""
        
        ///  (string, optional): 报销人parid ,
        var expenseParid:String = ""
        
        ///  (string, optional): 起始地点 ,
        var startAddress:String = ""
        
        ///  (string, optional): 出发城市 ,
        var startCityName:String = ""
        
        ///  (string, optional): 起始地点纬度 ,
        var startLatitude:String = ""
        
        ///  (string, optional): 起始时间 ,
        var startTime:String = ""
        
        ///  (string, optional): 起始地点经度
        var stratLongitude:String = ""
        
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            self.carType = jsonData["carType"].stringValue
            self.carTypeId = jsonData["carTypeId"].stringValue
            self.endAddress = jsonData["endAddress"].stringValue
            self.endCityName = jsonData["endCityName"].stringValue
            self.endLatitude = jsonData["endLatitude"].stringValue
            self.endLongitude = jsonData["endLongitude"].stringValue
            self.endTime = jsonData["endTime"].stringValue
            self.expenseCostcenterid = jsonData["expenseCostcenterid"].stringValue
            self.expenseCostcentername = jsonData["expenseCostcentername"].stringValue
            self.expenseName = jsonData["expenseName"].stringValue
            self.expenseParid = jsonData["expenseParid"].stringValue
            self.startAddress = jsonData["startAddress"].stringValue
            self.startCityName = jsonData["startCityName"].stringValue
            self.startLatitude = jsonData["startLatitude"].stringValue
            self.startTime = jsonData["startTime"].stringValue
            self.stratLongitude = jsonData["stratLongitude"].stringValue
        }
        
    }
    class OrderVO: NSObject,ALSwiftyJSONAble {
        
        /// (string, optional): 结束时间:yyyy-MM-dd ,
        var endDate:String = ""
        
        ///  (integer, optional): 订单来源 ,
        var orderSource:NSInteger = 0
        
        ///  (string, optional): 开始时间:yyyy-MM-dd ,
        var startDate:String = ""
        
        ///  (string, optional): 出差地 ,
        var travelDestination:String = ""
        
        ///  (string, optional): 出差单id ,
        var travelOrderNo:String = ""
        
        ///  (string, optional): 出差目的 ,
        var travelPurposen:String = ""
        
        ///  (string, optional): 出差理由
        var travelReason:String = ""
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            self.endDate = jsonData["endDate"].stringValue
            self.orderSource = jsonData["orderSource"].intValue
            self.startDate = jsonData["startDate"].stringValue
            self.travelDestination = jsonData["travelDestination"].stringValue
            self.travelOrderNo = jsonData["travelOrderNo"].stringValue
            self.travelPurposen = jsonData["travelPurposen"].stringValue
            self.travelReason = jsonData["travelReason"].stringValue
        }
        
        
    }
    
    final class func CoCarFormConvertObtCarOrderVO(model:CoCarForm)->ObtCarOrderVO{
        let carOrderVO = ObtCarOrderVO()
        carOrderVO.accountId = model.accountId
        //carOrderVO.carContact.cardNo = model.
        carOrderVO.carContact.email = model.carContact.email
        carOrderVO.carContact.phone = model.carContact.phone
        carOrderVO.carContact.parId = model.accountId
        carOrderVO.carContact.name = model.carContact.name
        for element in model.carPassengerList {
            let tmp:CarPassenger = CarPassenger()
            tmp.cardNo = element.cardNo
            tmp.cardType = element.cardType.description
            tmp.email = element.email
            tmp.name = element.name
            tmp.parId = element.parId
            tmp.phone = element.phone.value
            carOrderVO.carPassengerList.append(tmp)
        }
        carOrderVO.carVO.carType = model.carVO.carType
        carOrderVO.carVO.carTypeId = model.carVO.carTypeId
        carOrderVO.carVO.endAddress = model.carVO.endAddress
        carOrderVO.carVO.endCityName = model.carVO.endCityName
        carOrderVO.carVO.endLatitude = model.carVO.endLatitude
        carOrderVO.carVO.endLongitude = model.carVO.endLongitude
        carOrderVO.carVO.endTime = model.carVO.endTime
        carOrderVO.carVO.expenseCostcenterid = model.carVO.expenseCostcenterid
        carOrderVO.carVO.expenseCostcentername = model.carVO.expenseCostcentername
        carOrderVO.carVO.expenseName = model.carVO.expenseName
        carOrderVO.carVO.expenseParid = model.carVO.expenseParid
        carOrderVO.carVO.startAddress = model.carVO.startAddress
        carOrderVO.carVO.startCityName = model.carVO.startCityName
        carOrderVO.carVO.startLatitude = model.carVO.startTime
        carOrderVO.carVO.stratLongitude = model.carVO.stratLongitude
        carOrderVO.corpCode = model.corpCode
        carOrderVO.orderVO.endDate = model.orderVO.endDate
        carOrderVO.orderVO.orderSource = 1//model.orderVO.
        carOrderVO.orderVO.startDate = model.orderVO.startDate
        carOrderVO.orderVO.travelDestination = model.orderVO.travelDestination
        carOrderVO.orderVO.travelOrderNo = model.orderVO.travelOrderNo
        carOrderVO.orderVO.travelPurposen = model.orderVO.travelPurposen
        carOrderVO.orderVO.travelReason = model.orderVO.travelReason
        
        
        return carOrderVO
    }
    
    
    
    
}
