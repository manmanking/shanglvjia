//
//  FlightOrderDetail.swift
//  shop
//
//  Created by akrio on 2017/6/30.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON
import SwiftDate

struct FlightOrderDetail: ALSwiftyJSONAble{
    /// 航班信息
    var flightList:[FlightDetail] = []
    /// 价格明细
    var detailsOfCharges:DetailsOfCharges
    var charges:Charges
    /// 联系人信息
    var contact:Contact
    /// 发票信息
    var invoiceInformation:InvoiceInformation
    /// 操作记录
    var operateMsgs:[OperateMsg]
    var timeRemaining:NSInteger = 0 // (string): 联系人姓名 ,
    var paymentDeadline:NSInteger = 0 // (string): 联系人电话 ,
//    "timeRemaining": 0,
//    "paymentDeadline": 1505890285000
    
    /// 订单状态
    var orderStatus:FlightOrderState {
        return self.flightList.first?.state ?? .unkonw
    }
    /// 下单日期
    var orderTime:DateInRegion
    init(jsonData: JSON) {
        var goFlight = FlightDetail(jsonData: jsonData["flightOrderDetail"])
        goFlight.guestList = jsonData["guestsGo"].arrayValue.map{ Guest(jsonData: $0) }
        flightList.append(goFlight)
        self.charges = Charges(jsonData: jsonData["detailsOfCharges"])
        if jsonData["flightOrderDetailBack"]["fltNo"].string != nil {
            var backFlight = FlightDetail(jsonData: jsonData["flightOrderDetailBack"])
            backFlight.guestList = jsonData["guestsBack"].arrayValue.map{ Guest(jsonData: $0) }
            flightList.append(backFlight)
            self.charges.backCharges = DetailsOfCharges(jsonData: jsonData["detailsOfChargesBack"])
        }
        self.detailsOfCharges = DetailsOfCharges(jsonData: jsonData["detailsOfCharges"])
        self.contact = Contact(jsonData: jsonData["contact"])
        self.invoiceInformation = InvoiceInformation(jsonData: jsonData["invoiceInformation"])
        self.operateMsgs = jsonData["operateMsgs"].arrayValue.map{ OperateMsg(jsonData: $0) }
        self.orderTime = jsonData["tail"]["orderTime"].dateFormat(.custom("yyyy-MM-dd HH:mm:ss"))
        self.timeRemaining = jsonData["timeRemaining"].intValue
        self.paymentDeadline = jsonData["paymentDeadline"].intValue
        
        
    }
    enum FlightOrderState:Int {
        case waitpay = 1
        case payed = 2
        case canceled = 3
        case finished = 4
        case exit = 5
        case applyExit = 6
        case fk = 7
        case line = 8
        case unkonw = 999
    }
    
    /// 航班信息
    struct FlightDetail: ALSwiftyJSONAble {
        /// 订单号
        var orderNo:String
        /// 订单状态
        var state:FlightOrderState
        /// 航空公司名称
        var airlineName:String
        /// 航空公司代码
        var airlineCode:String
        /// 飞行时间
        var flyTime:String
        /// 退改签规则
        var fareConditions:String
        /// 是否经停城市：1-是 0-否
        var stopOver:Bool
        /// 航段信息 单航段1条 多航段多条
        var legs:[Leg] = []
        /// 旅客信息
        var guestList:[Guest] = []
        struct Leg {
            /// 航班号
            var flightNo:String
            /// 起飞机场
            var takeOffAirline:String
            /// 到达机场
            var arriveAirline:String
            /// 起飞航站楼
            var takeOffTerm:String
            /// 到达航站楼
            var arriveTerm:String
            /// 起飞时间
            var takeOffTime:DateInRegion
            /// 到达时间
            var arriveTime:DateInRegion
            /// 舱位
            var cabinType:String
            /// 出发城市
            var takeOffCity:String
            /// 到达城市
            var arriveCity:String
            init(jsonData: JSON,sub:Bool = false) {
                if !sub {
                    self.flightNo = jsonData["fltNo"].stringValue
                    self.takeOffAirline = jsonData["takeOffAirline"].stringValue
                    self.arriveAirline = jsonData["arriveAirline"].stringValue
                    self.takeOffTerm = jsonData["takeOffTerm"].stringValue
                    self.arriveTerm = jsonData["arriveTerm"].stringValue
                    self.takeOffTime = jsonData["takeOffTime"].dateFormat(.custom("yyyy-MM-dd HH:mm:ss.0"))
                    self.arriveTime = jsonData["arriveTime"].dateFormat(.custom("yyyy-MM-dd HH:mm:ss.0"))
                    self.cabinType = jsonData["cabinType"].stringValue
                    self.takeOffCity = jsonData["takeOffCity"].stringValue
                    self.arriveCity = jsonData["arriveCity"].stringValue
                }else {
                    self.flightNo = jsonData["subFlightNo"].stringValue
                    self.takeOffAirline = jsonData["subTakeOffAirline"].stringValue
                    self.arriveAirline = jsonData["subArriveAirline"].stringValue
                    self.takeOffTerm = jsonData["subTakeOffTerm"].stringValue
                    self.arriveTerm = jsonData["subArriveTerm"].stringValue
                    self.takeOffTime = jsonData["subTakeOffTime"].dateFormat(.custom("yyyy-MM-dd HH:mm:ss.0"))
                    self.arriveTime = jsonData["subArriveTime"].dateFormat(.custom("yyyy-MM-dd HH:mm:ss.0"))
                    self.cabinType = jsonData["subCabinType"].stringValue
                    self.takeOffCity = jsonData["subTakeOffCity"].stringValue
                    self.arriveCity = jsonData["subArriveCity"].stringValue
                    
                    
                }
            }
        }
        init(jsonData: JSON) {
            self.orderNo = jsonData["orderNo"].stringValue
            self.airlineName = jsonData["airlineName"].stringValue
            self.airlineCode = jsonData["airlineCode"].stringValue
            self.flyTime = jsonData["flyTime"].stringValue
            self.fareConditions = jsonData["fareConditions"].stringValue
            self.stopOver = jsonData["flyTime"].stringValue == "1"
            self.state = FlightOrderState(rawValue: jsonData["orderStatusNo"].intValue) ?? .unkonw
            legs.append(Leg(jsonData:jsonData))
            if jsonData["subFlightNo"].string != nil {
                legs.append(Leg(jsonData:jsonData,sub:true))
            }
        }
    }
    /// 乘客信息
    struct Guest: ALSwiftyJSONAble {
        /// 姓名
        var guestName:String
        /// 身份证
        var guestCardID:String
        /// 常旅卡
        var guestTravelID:String
        /// 票号
        var flightNumber:String
        init(jsonData: JSON) {
            self.guestName = jsonData["guestName"].stringValue
            self.guestCardID = jsonData["guestCardID"].stringValue
            self.guestTravelID = jsonData["guestTravelID"].stringValue
            self.flightNumber = jsonData["flightNumber"].stringValue
        }
    }
    /// 联系人信息
    struct Contact: ALSwiftyJSONAble {
        /// 姓名
        var contactName:String
        /// 电话
        var contactPhone:String
        init(jsonData: JSON) {
            self.contactName = jsonData["contactName"].stringValue
            self.contactPhone = jsonData["contactPhone"].stringValue
        }
    }
    /// 价格明细
    struct Charges {
        /// 去程价格
        var goCharges:DetailsOfCharges
        /// 回程价格
        var backCharges:DetailsOfCharges?
        /// 邮费
        var expressCharge:Double
        /// 总价
        var totalPrice:Double
        init(jsonData: JSON) {
            self.goCharges = DetailsOfCharges(jsonData: jsonData)
            self.totalPrice = jsonData["totalOrder"].doubleValue
            self.expressCharge = jsonData["expressCharge"].doubleValue
        }
    }
    /// 价格明细
    struct DetailsOfCharges:ALSwiftyJSONAble {
        /// 机票价格
        var airTicketPrice:Double
        /// 税费
        var taxation:Double
        /// 保险费用
        var insuranceCost:Double
        /// 快递费
        var expressCharge:Double
        /// 总价
        var totalOrder:Double
        init(jsonData: JSON) {
            self.airTicketPrice = jsonData["airTicketPrice"].doubleValue
            self.taxation = jsonData["taxation"].doubleValue
            self.insuranceCost = jsonData["insuranceCost"].doubleValue
            self.expressCharge = jsonData["expressCharge"].doubleValue
            self.totalOrder = jsonData["totalOrder"].doubleValue
        }
    }
    /// 发票信息
    struct InvoiceInformation:ALSwiftyJSONAble {
        /// 收件人
        var addressee:String
        /// 联系电话
        var phone:String
        /// 发票抬头
        var invoiceHeader:String
        /// 地址
        var address:String
        /// 发票类型
        var invoiceType:PersonalInvoiceType
        /// 发票价格
        var expressPrice:Double
        init(jsonData: JSON) {
            self.addressee = jsonData["addressee"].stringValue
            self.phone = jsonData["phone"].stringValue
            self.invoiceHeader = jsonData["invoiceHeader"].stringValue
            self.address = jsonData["address"].stringValue
            self.expressPrice = jsonData["expressPrice"].doubleValue
            self.invoiceType = PersonalInvoiceType(rawValue: jsonData["invoiceType"].stringValue) ?? .unknow
        }
    }
    /// 操作记录
    struct OperateMsg:ALSwiftyJSONAble {
        /// 操作类型
        var operateType:OperateType
        /// 创建日期(改签时间)
        var createDate:DateInRegion
        /// 旧票号
        var oldFlightNumber:String
        /// 新票号
        var newFlightNumber:String
        /// 操作类型
        ///
        /// - fade: 退
        /// - modify: 改
        enum OperateType:String{
            case fade = "1"
            case modify = "2"
            case unknow = "999"
        }
        init(jsonData: JSON) {
            self.operateType = OperateType(rawValue: jsonData["operateType"].stringValue) ?? .unknow
            self.createDate = jsonData["createDate"].dateFormat(.custom("yyyy-MM-dd HH:mm:ss.0"))
            self.oldFlightNumber = jsonData["oldFlightNumber"].stringValue
            self.newFlightNumber = jsonData["newFlightNumber"].stringValue
        }
    }
}
/// 个人发票类型
///
/// - fullPrice: 全额发票
/// - flightBalance: 机票发票 + 差额发票
enum PersonalInvoiceType:String {
    case fullPrice = "1"
    case flightBalance = "2"
    case unknow = "999"
}
// MARK: - 添加Print输出
extension PersonalInvoiceType:CustomStringConvertible{
    var description: String {
        switch self {
        case .fullPrice:
            return "全额发票"
        case .flightBalance:
            return "机票行程单+差额发票"
        case .unknow:
            return "未知发票类型"
        }
    }
}
// MARK: - 添加Print输出
extension FlightOrderDetail.OperateMsg.OperateType:CustomStringConvertible{
    var description: String {
        switch self {
        case .fade:
            return "退"
        case .modify:
            return "改"
        case .unknow:
            return "未知发票类型"
        }
    }
}
extension FlightOrderDetail.FlightOrderState:CustomStringConvertible {
    var description: String {
        switch self {
        case .waitpay:
            return "待支付"
        case .payed:
            return "已支付"
        case .canceled:
            return "已取消"
        case .finished:
            return "已改签"
        case .exit:
            return "已退票"
        case .applyExit:
            return"申请退订"
        case .fk:
            return "已反馈"
        case .line:
            return "已订妥"
        case .unkonw:
            return "未知状态"
        }
    }
}
