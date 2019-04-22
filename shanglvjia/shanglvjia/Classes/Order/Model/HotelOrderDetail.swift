//
//  HotelOrderDetail.swift
//  shop
//
//  Created by akrio on 2017/6/30.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import SwiftDate
import SwiftyJSON
import Moya_SwiftyJSONMapper

struct HotelOrderDetail: ALSwiftyJSONAble{
    /// 订单id
    let orderId:String
    /// 订单号
    let orderNo:String
    /// 酒店名称
    let hotelName:String
    /// 酒店电话 2017.7.23日新增字段
    let hotelPhone:String
    /// 房型
    let roomName:String
    /// 面积
    let roomArea:String
    /// 床型
    let roomBedType:String
    /// 产品名称
    let productName:String
    /// 早饭
    let productBreakfast:String
    /// 宽带
    let productBroadnet:String
    /// 入住日期
    let arrivalDate:DateInRegion
    /// 离店日期
    let departureDate:DateInRegion
    /// 夜间数
    let nightDay:Int
    /// 下单时间
    let createDate:DateInRegion
    /// 订单状态
    let orderHotelStatus:HotelStatus
    /// 总金额
    let orderTotalAmount:Double
    /// 发票抬头
    let invoiceTitle:String
    /// 发票类型
    let invoiceType:PersonalInvoiceType
    /// 发票名称
    let invoiceName:String
    /// 物流名称
    let logisticsName:String
    /// 发票邮寄地址
    let logisticsAddress:String
    /// 联系电话
    let logisticsPhone:String
    /// 联系人姓名
    let contactName:String
    /// 联系信息
    let contactPhone:String
    /// 房间数
    let numberOfRooms:Int
    /// 住客姓名
    let customerName:String
    /// 特殊要求
    let noteToHotel:String
    /// 是否担保（0：不担保；1：担保）
    let isGuarantee:Bool
    /// 成本价格列表
    let costList:[(String,Double)]
    /// 酒店地址
    let hotelAddress:String
    /// 最晚到店时间
    let latestArrlivalTime:DateInRegion
    init?(jsonData: JSON) {
        self.orderId = jsonData["orderId"].stringValue
        self.orderNo = jsonData["orderNo"].stringValue
        self.hotelName = jsonData["hotelName"].stringValue
        self.hotelPhone = jsonData["hotelPhone"].stringValue
        self.roomName = jsonData["roomName"].stringValue
        self.roomArea = jsonData["roomArea"].stringValue
        self.roomBedType = jsonData["roomBedType"].stringValue
        self.productName = jsonData["productName"].stringValue
        self.productBreakfast = jsonData["productBreakfast"].stringValue
        self.productBroadnet = jsonData["productBroadnet"].stringValue
        self.arrivalDate = jsonData["arrivalDate"].dateFormat(.custom("yyyy-MM-dd HH:mm:ss.0"))
        self.departureDate = jsonData["departureDate"].dateFormat(.custom("yyyy-MM-dd HH:mm:ss.0"))
        self.nightDay = jsonData["nightDay"].intValue
        self.createDate = jsonData["createDate"].dateFormat(.custom("yyyy-MM-dd HH:mm:ss.0"))
        self.orderHotelStatus = HotelOrderDetail.HotelStatus(rawValue: jsonData["orderHotelStatus"].intValue) ?? .unknow
        self.orderTotalAmount = jsonData["orderTotalAmount"].doubleValue
        self.invoiceTitle = jsonData["invoiceTitle"].stringValue
        self.invoiceType = PersonalInvoiceType(rawValue: jsonData["invoiceType"].stringValue) ?? .unknow
        self.invoiceName = jsonData["invoiceName"].stringValue
        self.logisticsName = jsonData["logisticsName"].stringValue
        self.logisticsAddress = jsonData["logisticsAddress"].stringValue
        self.logisticsPhone = jsonData["logisticsPhone"].stringValue
        self.contactName = jsonData["contactName"].stringValue
        self.contactPhone = jsonData["contactPhone"].stringValue
        self.numberOfRooms = jsonData["numberOfRooms"].intValue
        self.customerName = jsonData["customerName"].stringValue
        self.noteToHotel = jsonData["noteToHotel"].stringValue
        self.isGuarantee = jsonData["isGuarantee"].intValue == 1
        self.costList = JSON(parseJSON: jsonData["costList"].stringValue).map{ ($0.0,$0.1.doubleValue) }
        self.hotelAddress = jsonData["hotelAddress"].stringValue
        self.latestArrlivalTime = jsonData["latestArrlivalTime"].dateFormat(.custom("yyyy-MM-dd HH:mm:ss.0"))
    }

    /// 酒店订单状态
    ///
    /// - waitConfirm:  	待确认
    /// - payed:  	已支付
    /// - haveRoom:  	确认有房
    /// - noRoom:  	确认无房
    /// - comfirm:  	已确认
    /// - cancel:  	已取消
    /// - offLine:  	转线下
    /// - commitEnsure: 已提交需要担保
    /// - commitNoConfirm:  	已提交非及时确认订单
    /// - exception:  	异常订单
    /// - commit: 已提交
    /// - unknow: 未知
    enum HotelStatus:Int {
        case waitConfirm = 1
        case payed = 2
        case haveRoom = 3
        case noRoom = 4
        case comfirm = 5
        case cancel = 6
        case offLine = 7
        case commitEnsure = 8
        case commitNoConfirm = 9
        case exception = 10
        case commit = 11
        case unknow = 999
    }
}
extension HotelOrderDetail.HotelStatus : CustomStringConvertible {
    var description: String {
        switch self {
        case .waitConfirm:
            return "待确认"
        case .payed:
            return "已支付"
        case .haveRoom:
            return "确认有房"
        case .noRoom:
            return "确认无房"
        case .comfirm:
            return "已确认"
        case .cancel:
            return "已取消"
        case .offLine:
            return "转线下"
        case .commitEnsure:
            return "已提交需要担保"
        case .commitNoConfirm:
            return "已提交非及时确认订单"
        case .exception:
            return "异常订单"
        case .commit:
            return "已提交"
        case .unknow:
            return "未知"
        }
    }
}
