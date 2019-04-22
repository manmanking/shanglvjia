//
//  PSpecialOrderDetails.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/7/10.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import HandyJSON
import SwiftDate
import SwiftyJSON
import Moya_SwiftyJSONMapper
/*
 Response Body:
 
 {
 "code": 100,
 "message": "成功",
 "content": {
 "orderId": "13713",
 "orderNo": "520170708103880",
 "totalAmount": 2999,
 "adultPrice": 2999,
 "childBedPrice": 499,
 "childNobedPrice": 0,
 "singleRoomDifference": 0,
 "adultNum": 1,
 "childBedNum": 0,
 "childNobedNum": 0,
 "roomNum": 0,
 "specialProductName": "安徽  黄山日出+翡翠谷+宏村 高铁4日跟团游<五星酒店，徽菜美食， VIP观光缆车，纯玩无购物，日出黄山，联合假期>(北京出发)",
 "specialProductType": "8",
 "specialCategoryName": "安徽  黄山日出+翡翠谷+宏村 高铁4日跟团游",
 "startDate": "2017-07-13",
 "createDate": "2017-07-08 14:39:35",
 "orderSpecialStatus": "2",
 "invoiceTitle": null,
 "invoiceType": null,
 "logisticsAddress": null,
 "logisticsPhone": null,
 "logisticsName": null,
 "contactName": "来看看",
 "contactPhone": "13602079353",
 "orderSpecialPersonInfoList": [
 {
 "personNameCn": "齐",
 "personNameEn": null,
 "personSex": "0",
 "personPhone": "13211111111",
 "personType": "0",
 "personPassport": null,
 "personIdCard": "120103198704281116",
 "personNationality": null,
 "personBirthDay": ""
 }
 ]
 }
 }
 
 */


//个人版的旅游订单详情

struct PSpecialOrderDetails:HandyJSON
{

    var orderId:String! // (string): 订单id ,
    var orderNo:String! // (string): 订单号 ,
    var totalAmount:Double! // (number): 总价格 ,
    var adultPrice :Double! //(number): 成人价格 ,
    var childBedPrice:Double! // (number): 儿童含床价格 ,
    var childNobedPrice:Double! // (number): 儿童不含床价格 ,
    var singleRoomDifference:Double! // (number): 单房差 ,
    var adultNum:Int! // (integer): 成人数量 ,
    var childBedNum:Int! // (integer): 儿童（含床）数量 ,
    var childNobedNum:Int! // (integer): 儿童（不含床）数量 ,
    var roomNum:Int! // (integer): 单房差数量 ,
    var specialProductName:String! // (string): 特价产品名称 ,
    var specialProductType:String! // (string): 特价产品类型 ,
    var specialCategoryName:String! // (string): 特价产品类别名称 ,
    var startDate:String! // (string): 出发日期 ,
    var createDate:String! // (string): 下单时间 ,
    var orderSpecialStatus:String! // (string): 订单状态 ,
    var invoiceTitle:String! // (string): 发票抬头 ,
    var invoiceType:String! // (string): 发票类型 ,
    var logisticsAddress:String! // (string): 收件人地址 ,
    var logisticsPhone:String! // (string): 收件人电话 ,
    var logisticsName:String! // (string): 收件人姓名 ,
    var contactName:String! // (string): 联系人姓名 ,
    var contactPhone:String! // (string): 联系人电话 ,
    var orderSpecialPersonInfoList:[OrderSpecialPersonInfo]! // (Array[OrderSpecialPersonInfo]): 人员信息列表
    var timeRemaining:NSInteger = 0 // (string): 联系人姓名 ,
    var paymentDeadline:NSInteger = 0 // (string): 联系人电话 ,
    //"timeRemaining": 0,
    //"paymentDeadline": 1506049033000
    
    struct OrderSpecialPersonInfo:HandyJSON
    {
        var personNameCn:String! // (string, optional): 出行人中文姓名 ,
        var personNameEn:String! // (string, optional): 出行人英文姓名 ,
        var personSex:String! // (string, optional): 出行人性别 ,
        var personPhone:String! // (string, optional): 出行人手机号码 ,
        var personType:String! // (string, optional): 出行人类型，成人/儿童占床/儿童不占床 ,
        var personPassport:String! // (string, optional): 出行人护照 ,
        var personIdCard:String! // (string, optional): 出行人身份证 ,
        var personNationality:String! // (string, optional): 出行人国籍 ,
        var personBirthDay:String! // (string, optional): 出生日期
        
        
        //计算属性。
        var personTypeEnum:PersonType
        {
            if self.personType == nil {
                return PSpecialOrderDetails.PersonType(rawValue: 1)!
            }
            return PersonType(rawValue: Int(self.personType) ?? -1)!
        }
    }
}

extension PSpecialOrderDetails:ALSwiftyJSONAble
{
    func getNewInstance(jsonStr:String)->PSpecialOrderDetails?
    {
        let myInstance = PSpecialOrderDetails.deserialize(from: jsonStr)
        
        return myInstance
    }
    
    init?(jsonData: JSON)
    {
        let jsonStr = jsonData.description
        self = getNewInstance(jsonStr: jsonStr)!
    }
}

extension PSpecialOrderDetails
{
    //旅游订单当前的状态
    var orderSpecialStatusEnum:TravelOrderStatus
    {
        return TravelOrderStatus(rawValue: Int(self.orderSpecialStatus) ?? -1)!
    }
    
    //旅游订单的发票类型
    var invoiceTypeEnum:InvoiceType
    {
        return InvoiceType(rawValue: Int(self.invoiceType ?? "-1") ?? -1)!
    }
    
    enum InvoiceType:Int
    {
        case company = 0
        case person = 1
        case unknow = -1
        
        var description:String
        {
            switch self
            {
            case .company:
                return "公司"
            case .person:
                return "个人"
                
            case .unknow:
                return "未知"
            }
        }
    }
    
    /**特价产品订单状态，
    1--抢购中(需确认库存和价格产品)，
    2--待支付，
    3--已取消（支付之前用户取消），
    4--抢购失败，
    5--已支付，
    6--预定成功，
    7--转线下（含退票、退款内容，TC加备注）
     */
    enum TravelOrderStatus:Int
    {
        case busyBuying = 1
        case waitPay = 2
        case canceled = 3
        case busyBuyFailure = 4
        case payed = 5
        case reservedSuccess = 6
        case offline = 7
        case unknow = -1
        
        var description:String
        {
            switch self
            {
            case .busyBuying:
                return "抢购中"
            case .waitPay:
                return "待支付"
            case .canceled:
                return "已取消"
            
            case .busyBuyFailure:
                return "抢购失败"
            case .payed:
                return "已支付"
            case .reservedSuccess:
                return "预定成功"
                
            case .offline:
                return "转线下"
            case .unknow:
                return "未知状态"
            }
        }
    }
    
    /** PSpecialOrderDetails.OrderSpecialPersonInfo
     0--成人，
     1—儿童（儿童占床），
     2—儿童不占床
    */
    enum PersonType:Int
    {
        case adult = 0
        case childHasBed = 1
        case childNoBed = 2
        case unknow = -1
        
        var description:String
        {
            switch self
            {
            case .adult:
                return "成人"
            case .childHasBed:
                return "儿童(占床)"
            case .childNoBed:
                return "儿童(不占床)"
                
            case .unknow:
                return "未知状态"
            }
        }
    }
    
}











