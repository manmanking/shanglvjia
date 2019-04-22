//
//  OrderDetailModel.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/9.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class OrderDetailModel: NSObject ,ALSwiftyJSONAble{
    
    //订单号
//    var orderNo : String!
    var orderTime : String!
    var peopleArr : AnyObject!
    var insure : String!
    var conactPeople : AnyObject!
    
    //是否违背差旅政策1是0否
    var accordPolicy : String = ""
    var id : String = ""
    //审批信息
    var approves:[approve] = Array()
    
    class approve : NSObject,ALSwiftyJSONAble {
        //审批意见
        var approveComment :String = ""
        var approveTime : String = ""
        //审批级别
        var apverLevel : String = ""
        var apverName : String = ""
        var statusCH :String = ""
        
        override init() {
            
        }
        required init?(jsonData: JSON) {
            self.approveComment = jsonData["approveComment"].stringValue
            self.approveTime = jsonData["approveTime"].stringValue
            self.apverLevel = jsonData["apverLevel"].stringValue
            self.apverName = jsonData["apverName"].stringValue
            self.statusCH = jsonData["statusCH"].stringValue
        }
        
    }
    var passengers:[passenger] = Array()
    class passenger : NSObject, ALSwiftyJSONAble {
        // 乘客姓名
        var psgName :String = ""
        //证件类型1：二代身份证，2：护照
        var certType : String = ""
        var certNo : String = ""
        
        //酒店 特殊要求
        var special : String = ""
        
        //火车 次卧04车厢,47座下铺
        var siteCodeCH : String = ""
        var siteInfo : String = ""
        
        var money : String = ""
        //退票状态
        var refundAmount : String = ""
        var refundStatus : String = ""
        var poundage : String = ""
        
        var type : String = ""
        var unitFare :String = ""
        var ocTax : String = ""
        var tcTax : String = ""
        var refund : Refund?
        
        class Refund :NSObject, ALSwiftyJSONAble {
            var extraPrice :String = ""
            
            override init() {
                
            }
            required init?(jsonData: JSON) {
                self.extraPrice = jsonData["extraPrice"].stringValue
            }
            
        }
        var surances:[surance] = Array()
        
        class surance :NSObject,ALSwiftyJSONAble {
            ///保险名字
            var suranceName : String = ""
            ///保单号
            var suranceNo : String = ""
            ///被保人
            var cusName : String = ""
            //// 保险开始时间
            var suranceStart : String = ""
            ///保险结束时间
            var suranceEnd : String = ""
            /// 保险公司
            var suranceCompany : String = ""
            ///保险状态中文
            var suranceStatusCH : String = ""
            ///保险价格
            var price : String = ""
            var first :Bool = true
            
            override init() {
                
            }
            
            required init?(jsonData: JSON) {
                self.suranceName = jsonData["suranceName"].stringValue
                self.suranceNo = jsonData["suranceNo"].stringValue
                self.cusName = jsonData["cusName"].stringValue
                self.suranceStart = jsonData["suranceStart"].stringValue
                self.suranceEnd = jsonData["suranceEnd"].stringValue
                self.suranceCompany = jsonData["suranceCompany"].stringValue
                self.suranceStatusCH = jsonData["suranceStatusCH"].stringValue
                self.price = jsonData["price"].stringValue
                self.first = jsonData["first"].boolValue
            }
            
            
        }
        var alters:[alter] = Array()
        class alter :NSObject,ALSwiftyJSONAble {
            var tcFare : String = ""
            var extraTotal : String = ""
            var tcTotalTax : String = ""
            var tcAirportTax : String = ""
            
            
            var segments:[segment] = Array()
            class segment : NSObject,ALSwiftyJSONAble {
                //
                var arriveCity :String = ""
                var flyDays : String = ""
                //
                var marketAirlineCH : String = ""
                var marketFlightNo : String = ""
                var marketAirline :String = ""
                var stopOver :String = ""
                var stopoverCity :String = ""
                var share :Bool = true
                var ei : String = ""
                
                var arriveAirport :String = ""
                var arriveTime :String = ""
                var takeoffAirport :String = ""
                var takeoffCity :String = ""
                var takeoffTime :String = ""
                var takeoffTerminal :String = ""
                var arriveTerminal :String = ""
                
                override init() {
                    
                }
                required init?(jsonData: JSON) {
                    self.arriveCity = jsonData["arriveCity"].stringValue
                    self.flyDays = jsonData["flyDays"].stringValue
                    self.marketAirlineCH = jsonData["marketAirlineCH"].stringValue
                    self.marketFlightNo = jsonData["marketFlightNo"].stringValue
                    self.marketAirline = jsonData["marketAirline"].stringValue
                    self.stopOver = jsonData["stopOver"].stringValue
                    self.stopoverCity = jsonData["stopoverCity"].stringValue
                    self.share = jsonData["share"].boolValue
                    self.ei = jsonData["ei"].stringValue
                    
                    self.arriveAirport = jsonData["arriveAirport"].stringValue
                    self.arriveTime = jsonData["arriveTime"].stringValue
                    self.takeoffAirport = jsonData["takeoffAirport"].stringValue
                    self.takeoffCity = jsonData["takeoffCity"].stringValue
                    self.takeoffTime = jsonData["takeoffTime"].stringValue
                    self.takeoffTerminal = jsonData["takeoffTerminal"].stringValue
                    self.arriveTerminal = jsonData["arriveTerminal"].stringValue
                }
                
            }
            override init() {
                
            }
            required init?(jsonData: JSON) {
                self.tcFare = jsonData["tcFare"].stringValue
                self.extraTotal = jsonData["extraTotal"].stringValue
                self.tcTotalTax = jsonData["tcTotalTax"].stringValue
                self.tcAirportTax = jsonData["tcAirportTax"].stringValue
                
                 self.segments = jsonData["segments"].arrayValue.map{ segment(jsonData: $0)! }
            }
            
        }
        
        override init() {
            
        }
        required init?(jsonData: JSON) {
            self.psgName = jsonData["psgName"].stringValue
            self.certType = jsonData["certType"].stringValue
            self.certNo = jsonData["certNo"].stringValue
            
            self.special=jsonData["special"].stringValue
            
            self.siteCodeCH = jsonData["siteCodeCH"].stringValue
            self.siteInfo = jsonData["siteInfo"].stringValue
            
            self.money = jsonData["money"].stringValue
            self.refundAmount = jsonData["refundAmount"].stringValue
            self.refundStatus = jsonData["refundStatus"].stringValue
            self.poundage = jsonData["poundage"].stringValue
            self.type = jsonData["type"].stringValue
            self.unitFare = jsonData["unitFare"].stringValue
            self.ocTax = jsonData["ocTax"].stringValue
            self.tcTax = jsonData["tcTax"].stringValue
            
             self.refund = Refund(jsonData: jsonData["refund"])!
            
            self.surances = jsonData["surances"].arrayValue.map{ surance(jsonData: $0)! }
            self.alters = jsonData["alters"].arrayValue.map{ alter(jsonData: $0)! }
        }
        
    }
    
    var segments:[segment] = Array()
    class segment : NSObject,ALSwiftyJSONAble {
        //
        var arriveCity :String = ""
        var flyDays : String = ""
        //
        var marketAirlineCH : String = ""
        var marketFlightNo : String = ""
        var marketAirline :String = ""
        var stopOver :String = ""
        var stopoverCity :String = ""
        var share :Bool = true
        var ei : String = ""
        var arriveTerminal : String = ""
        var takeoffTerminal : String = ""
        var arriveAirport : String = ""
        var takeoffAirport : String = ""
        
        override init() {
            
        }
        required init?(jsonData: JSON) {
            self.arriveCity = jsonData["arriveCity"].stringValue
            self.flyDays = jsonData["flyDays"].stringValue
            self.marketAirlineCH = jsonData["marketAirlineCH"].stringValue
            self.marketFlightNo = jsonData["marketFlightNo"].stringValue
            self.marketAirline = jsonData["marketAirline"].stringValue
            self.stopOver = jsonData["stopOver"].stringValue
            self.stopoverCity = jsonData["stopoverCity"].stringValue
            self.share = jsonData["share"].boolValue
            self.ei = jsonData["ei"].stringValue
            self.arriveTerminal = jsonData["arriveTerminal"].stringValue
            self.takeoffTerminal = jsonData["takeoffTerminal"].stringValue
            self.arriveAirport = jsonData["arriveAirport"].stringValue
            self.takeoffAirport = jsonData["takeoffAirport"].stringValue
        }
        
    }
    
    var requires:[require] = Array()
    class require:NSObject,ALSwiftyJSONAble {
        var handleTime : String = ""
        var statusCH : String = ""
        var status : String = ""
        var typeCH : String = ""
        var type : String = ""
        
        override init() {
            
        }
        required init?(jsonData: JSON) {
            self.handleTime = jsonData["handleTime"].stringValue
            self.statusCH = jsonData["statusCH"].stringValue
            self.status = jsonData["status"].stringValue
            self.typeCH = jsonData["typeCH"].stringValue
            self.type = jsonData["type"].stringValue
        }
        
        
    }
    var travel:Travel?
    
   
    var arriveAirport : String = ""
    var arriveTime : String = ""
    var contactEmail : String = ""
    var contactName : String = ""
    var contactPhone : String = ""
    var costCenter : String = ""
    var createTime : String = ""
    //违背差旅政策原因
    var disPolicyReason : String = ""
    var money : String = ""
    var orderEmail : String = ""
    var orderName : String = ""
    var orderNo : String = ""
    var pnr : String = ""
    
    
    //订单备注
    var remarks : String = ""
    var status : String = ""
    var statusCH : String = ""
    var takeoffAirport : String = ""
    var takeoffTime : String = ""
    var arriveTerminal : String = ""
    var takeoffTerminal : String = ""
    // tc备注
    var tcRemarks : String = ""
    
    //  专车
    var carTypeCH :String = ""
    var startAddress :String = ""
    var endAddress :String = ""
    //用车类型
    var orderTypeCH : String = ""
    var startTime : String = ""
    var carNumber : String = ""
    var driverName : String = ""
    var driverPhone : String = ""
    var useStatus : String = ""//用车状态0未分配1已分配2已用车 ,
    var actPrice : String = ""
    
    //酒店
    var hotelName : String = ""
    var roomType : String = ""
    var roomCount : String = ""
    var priceDetail : String = ""
    var meal : String = ""
    var date : String = ""
    var memberRate : String = ""
    //入住日
    var tripStart : String = ""
    //离店日
    var tripEnd : String = ""
    var psgName : String = ""
    //最晚到店时间
    var latestArrivalTime : String = ""
    
    //火车
    var startStationName : String = ""
    var endStationName : String = ""
    var trainCode : String = ""
    var trainDay : String = ""
    var runTime : String = ""
    
    
    
    
    override init() {
        
    }
    required init?(jsonData: JSON) {
        self.accordPolicy = jsonData["accordPolicy"].stringValue
        self.arriveAirport = jsonData["arriveAirport"].stringValue
        self.arriveTime = jsonData["arriveTime"].stringValue
        self.contactEmail = jsonData["contactEmail"].stringValue
        self.arriveAirport = jsonData["arriveAirport"].stringValue
        self.contactName = jsonData["contactName"].stringValue
        self.contactPhone = jsonData["contactPhone"].stringValue
        self.costCenter = jsonData["costCenter"].stringValue
        self.createTime = jsonData["createTime"].stringValue
        self.disPolicyReason = jsonData["disPolicyReason"].stringValue
        self.money = jsonData["money"].stringValue
        self.orderEmail = jsonData["orderEmail"].stringValue
        self.orderName = jsonData["orderName"].stringValue
        self.orderNo = jsonData["orderNo"].stringValue
        self.pnr = jsonData["pnr"].stringValue
        self.remarks = jsonData["remarks"].stringValue
        self.status = jsonData["status"].stringValue
        self.statusCH = jsonData["statusCH"].stringValue
        self.takeoffAirport = jsonData["takeoffAirport"].stringValue
        self.takeoffTime = jsonData["takeoffTime"].stringValue
        self.takeoffTerminal = jsonData["takeoffTerminal"].stringValue
        self.arriveTerminal = jsonData["arriveTerminal"].stringValue
        self.tcRemarks = jsonData["tcRemarks"].stringValue
        self.id = jsonData["id"].stringValue
        self.priceDetail = jsonData["priceDetail"].stringValue
        self.meal = jsonData["meal"].stringValue
        self.date = jsonData["date"].stringValue
        self.memberRate = jsonData["memberRate"].stringValue
        
        self.approves = jsonData["approves"].arrayValue.map{ approve(jsonData: $0)! }
        self.passengers = jsonData["passengers"].arrayValue.map{ passenger(jsonData: $0)! }
        self.segments = jsonData["segments"].arrayValue.map{ segment(jsonData: $0)! }
        self.requires = jsonData["requires"].arrayValue.map{ require(jsonData: $0)! }
        
        self.travel = Travel(jsonData: jsonData["travel"])!

        //专车
        self.carTypeCH = jsonData["carTypeCH"].stringValue
        self.startAddress = jsonData["startAddress"].stringValue
        self.endAddress = jsonData["endAddress"].stringValue
        self.orderTypeCH = jsonData["orderTypeCH"].stringValue
        self.startTime = jsonData["startTime"].stringValue
        self.carNumber = jsonData["carNumber"].stringValue
        self.driverName = jsonData["driverName"].stringValue
        self.driverPhone = jsonData["driverPhone"].stringValue
        self.useStatus = jsonData["useStatus"].stringValue
        self.actPrice = jsonData["actPrice"].stringValue
        
        
        //酒店
        self.hotelName = jsonData["hotelName"].stringValue
        self.roomType = jsonData["roomType"].stringValue
        self.roomCount = jsonData["roomCount"].stringValue
        self.tripStart = jsonData["tripStart"].stringValue
        self.tripEnd = jsonData["tripEnd"].stringValue
        self.psgName = jsonData["psgName"].stringValue
        self.latestArrivalTime = jsonData["latestArrivalTime"].stringValue
        
        //火车
        self.startStationName = jsonData["startStationName"].stringValue
        self.endStationName = jsonData["endStationName"].stringValue
        self.trainDay = jsonData["trainDay"].stringValue
        self.trainCode = jsonData["trainCode"].stringValue
        self.runTime = jsonData["runTime"].stringValue
       

    }
    

    class Travel :NSObject, ALSwiftyJSONAble {
        var address :String = ""
        var endTime :String = ""
        var reason :String = ""
        var startTime :String = ""
        var target :String = ""
        override init() {
            
        }
        required init?(jsonData: JSON) {
            self.address = jsonData["address"].stringValue
            self.endTime = jsonData["endTime"].stringValue
            self.reason = jsonData["reason"].stringValue
            self.startTime = jsonData["startTime"].stringValue
            self.target = jsonData["target"].stringValue
        }
        
    }
    
    
    
}
