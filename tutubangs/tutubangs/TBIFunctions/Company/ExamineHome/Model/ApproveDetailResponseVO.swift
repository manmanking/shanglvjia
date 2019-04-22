//
//  ApproveDetailResponseVO.swift
//  shanglvjia
//
//  Created by manman on 2018/5/18.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya_SwiftyJSONMapper

class ApproveDetailResponseVO: NSObject,ALSwiftyJSONAble{

    
    /// (Array[审批记录], optional),
    var approveHistoryInfos:[ApprovalResponse]?
    
    /// (Array[专车信息], optional),
    var carResponses:[ApprovalOrderDetail]?
    
    /// (Array[机票信息], optional),
    var flightResponses:[ApprovalOrderDetail]?
    
    ///  (Array[HotelResponse], optional),
    var hotelResponses:[ApprovalOrderDetail]?
    
    ///  (Array[火车票信息], optional)
    var trainResponses:[ApprovalOrderDetail]?
    
    
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        if jsonData["approveHistoryInfos"].arrayValue.count > 0 {
            approveHistoryInfos = jsonData["approveHistoryInfos"].arrayValue.map{ ApprovalResponse.init(jsonData: $0)!}
        }
        
        if jsonData["carResponses"].arrayValue.count > 0 {
            carResponses = jsonData["carResponses"].arrayValue.map{ ApprovalOrderDetail.init(jsonData: $0)!}
        }
        
        if jsonData["flightResponses"].arrayValue.count > 0 {
            flightResponses = jsonData["flightResponses"].arrayValue.map{ ApprovalOrderDetail.init(jsonData: $0)!}
        }
        
        if jsonData["hotelResponses"].arrayValue.count > 0 {
            hotelResponses = jsonData["hotelResponses"].arrayValue.map{ ApprovalOrderDetail.init(jsonData: $0)!}
            
            
            
        }
        
        if jsonData["trainResponses"].arrayValue.count > 0 {
            trainResponses = jsonData["trainResponses"].arrayValue.map{ ApprovalOrderDetail.init(jsonData: $0)!}
        }
        
        
    }
    
    
    
    
    class ApprovalResponse: NSObject ,ALSwiftyJSONAble{
        
        ///  (string, optional): 审批意见 ,
        var approveComment:String = ""
        
        ///  (integer, optional): 审批时间 ,
        var approveTime:NSInteger = 0
        
        ///  (string, optional): 审批级别 ,
        var apverLevel:String = ""
        
        ///  (string, optional): 审批人 ,
        var apverName:String = ""
        
        ///  (string, optional): 状态中文
        var statusCH:String = ""
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            approveComment = jsonData["approveComment"].stringValue
            approveTime = jsonData["approveTime"].intValue
            apverLevel = jsonData["apverLevel"].stringValue
            apverName = jsonData["apverName"].stringValue
            statusCH = jsonData["statusCH"].stringValue
        }
        
    }
    
    
    class ApprovalOrderDetail: NSObject,ALSwiftyJSONAble {
        
        ///  (string, optional): 是否违背差旅政策1是0否
        var accordPolicy:String = ""
        
        ///  (string, optional): 违背差旅政策原因 ,
        var disPolicyReason:String = ""
        
        ///  (number, optional): 实际费用 ,
        var actPrice:NSInteger = 0
        
        ///  (Array[审批记录], optional): 审批信息 ,
        var approves:[ApprovalResponse] = Array()
        
        ///  (string, optional): 车牌号 ,
        var carNumber:String = ""
        
        ///  (integer, optional): 车型1五人2七人 ,
        var carType:String = ""
        
        ///  (string, optional): 车型中文 ,
        var carTypeCH:String = ""
        
        ///订单总额 ,
        var money:String = ""
        
        ///  (string, optional): 联系人邮箱 ,
        var contactEmail:String = ""
        
        ///  (string, optional): 联系人姓名 ,
        var contactName:String = ""
        
        ///  (string, optional): 联系人电话 ,
        var contactPhone:String = ""
        
        ///  (string, optional): 成本中心 ,
        var costCenter:String = ""
        
        ///  (string, optional): 创建时间 ,
        var createTime:String = ""
        
        ///  (string, optional): 司机姓名 ,
        var driverName:String = ""
        
        ///  (string, optional): 司机手机号 ,
        var driverPhone:String = ""
        
        ///  (string, optional): 目的地 ,
        var endAddress:String = ""
        
        ///  (string, optional): 目的城市 ,
        var endCity:String = ""
        
        ///  (string, optional): 结束时间 ,
        var endTime:String = ""
        
        ///  (number, optional): 额外费用 ,
        var extraPrice:String = ""
        var id:String = ""
        
        ///  (string, optional): 预订人 ,
        var orderName:String = ""
        
        ///  (string, optional): 订单号 ,
        var orderNo:String = ""
        
        ///  (integer, optional): 用车类型1接机2送机99其他 ,
        var orderType:String = ""
        
        ///  (string, optional): 用车类型中文 ,
        var orderTypeCH:String = ""
        
        ///  (number, optional): 个人费用 ,
        var personPrice:String = ""
        
        ///  (string, optional): 乘客姓名 ,
        var psgName:String = ""
        
        ///  (string, optional): 订单备注 ,
        var remark:String = ""
        
        ///  (Array[申请记录], optional): 申请信息 ,
        var requires:String = ""
        
        ///  (string, optional): 起始地 ,
        var startAddress:String = ""
        
        ///  (string, optional): 起始城市 ,
        var startCity:String = ""
        
        ///  (string, optional): 用车时间 ,
        var startTime:String = ""
        
        ///  (string, optional): 订单状态201计划中202待订妥203已订妥204已取消 ,
        var status:String = ""
        
        ///  (string, optional): 订单状态中文 ,
        var statusCH:String = ""
        
        ///  (string, optional): tc备注 ,
        var tcRemark:String = ""
        
        ///  (number, optional): 总费用 ,
        var totalPrice:String = ""
        
        ///  (出差单详情, optional): 出差单 ,
        var travel:TravelOrder = TravelOrder()
        
        var passengers:[PassengerResponse] = Array()
        
        /// (string, optional): 用车状态0未分配1已分配2已用车 ,
        var useStatus:String = ""
        
        
        
        // 机票航段信息 (Array[], optional): 航段信息 ,
        var segments:[FlightSegmentResponse] = Array()
        
        
        
        // 火车票 必备
        var arriveTime:String = ""//:"2018-06-01 12:40",
        
//        var startTime:String = "" //:"2018-06-01 06:43",
        
        var endStationName:String = ""//:"上海虹桥",
        
        var trainCode:String = ""//:"G101",
        var trainDay:String = "" //:0,
        var runTime:String = ""
        
        var startStationName:String = ""//:"北京南",
        
        
        var trainStartDate:String = "" //:"2018-06-01",
        
        
        // 酒店必备信息
        var hotelName:String = ""

        
        ///  //房型 ,
        var roomType:String = ""

        ///  (string, optional): 离店日 ,
        var tripEnd:String = ""
        
        ///  (string, optional): 入住日 ,
        var tripStart:String = ""
        
        /// 最晚到店时间
        var latestArrivalTime:String = ""
        
        var meal:String = ""
        
        
        ///  (string, optional): 价格明细 ,
        var priceDetail:[HotelDetailResult.NightRate] = Array()
        
        var priceDetailStr:String = ""
        
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            
            accordPolicy = jsonData["accordPolicy"].stringValue
            disPolicyReason = jsonData["disPolicyReason"].stringValue
            actPrice = jsonData["actPrice"].intValue
            approves = jsonData["approves"].arrayValue.map{ApprovalResponse.init(jsonData: $0)!}
            carNumber = jsonData["carNumber"].stringValue
            carType = jsonData["carType"].stringValue
            carTypeCH = jsonData["carTypeCH"].stringValue
            money = jsonData["money"].stringValue
            contactEmail = jsonData["contactEmail"].stringValue
            contactName = jsonData["contactName"].stringValue
            contactPhone = jsonData["contactPhone"].stringValue
            costCenter = jsonData["costCenter"].stringValue
            createTime = jsonData["createTime"].stringValue
            driverName = jsonData["driverName"].stringValue
            driverPhone = jsonData["driverPhone"].stringValue
            startAddress = jsonData["startAddress"].stringValue
            endAddress = jsonData["endAddress"].stringValue
            endCity = jsonData["endCity"].stringValue
            endTime = jsonData["endTime"].stringValue
            extraPrice = jsonData["extraPrice"].stringValue
            id = jsonData["id"].stringValue
            orderName = jsonData["orderName"].stringValue
            orderNo = jsonData["orderNo"].stringValue
            orderType = jsonData["orderType"].stringValue
            orderTypeCH = jsonData["orderTypeCH"].stringValue
            personPrice = jsonData["personPrice"].stringValue
            psgName = jsonData["psgName"].stringValue
            remark = jsonData["remark"].stringValue
            requires = jsonData["requires"].stringValue
            startCity = jsonData["startCity"].stringValue
            startTime = jsonData["startTime"].stringValue
            status = jsonData["status"].stringValue
            statusCH = jsonData["apverName"].stringValue
            tcRemark = jsonData["tcRemark"].stringValue
            totalPrice = jsonData["totalPrice"].stringValue
            travel = TravelOrder.init(jsonData:jsonData["travel"])!
            useStatus = jsonData["useStatus"].stringValue
            passengers = jsonData["passengers"].arrayValue.map{PassengerResponse.init(jsonData: $0)!}
            segments = jsonData["segments"].arrayValue.map{FlightSegmentResponse.init(jsonData: $0)!}
            
            arriveTime = jsonData["arriveTime"].stringValue
            endStationName = jsonData["endStationName"].stringValue
            trainCode = jsonData["trainCode"].stringValue
            trainDay = jsonData["trainDay"].stringValue
            startStationName = jsonData["startStationName"].stringValue
            trainStartDate = jsonData["trainStartDate"].stringValue
            runTime = jsonData["runTime"].stringValue
            hotelName = jsonData["hotelName"].stringValue
            meal  = jsonData["meal"].stringValue
            roomType = jsonData["roomType"].stringValue
            tripEnd = jsonData["tripEnd"].stringValue
            tripStart = jsonData["tripStart"].stringValue
            latestArrivalTime = jsonData["latestArrivalTime"].stringValue
            priceDetail = JSON.init(parseJSON:jsonData["priceDetail"].stringValue).arrayValue.map{HotelDetailResult.NightRate.init(jsonData: $0)!}
            
        }
    }
    
    
    class ApplyRecod: NSObject,ALSwiftyJSONAble {
        
        ///  (string, optional): 申请详情 ,
        var detail:String = ""
        
        ///  (string, optional): 处理人 ,
        var handleName:String = ""
        
        ///  (string, optional): 处理时间 ,
        var handleTime:String = ""
        
        ///  (integer, optional),
        var id:String = ""
        
        ///  (string, optional): 申请人 ,
        var name:String = ""
        
        ///  (integer, optional): 订单id ,
        var orderId:String = ""
        
        ///  (string, optional): 订单类型 ,
        var orderType:String = ""
        
        ///  (string, optional): 联系电话 ,
        var phone:String = ""
        
        ///  (string, optional): 申请时间 ,
        var requireTime:String = ""
        
        ///  (string, optional): 状态0未处理1已处理2已驳回 ,
        var status:String = ""
        
        ///  (string, optional): 状态中文 ,
        var statusCH:String = ""
        
        ///  (string, optional): 类型0取消1退票2改签 ,
        var type:String = ""
        
        ///  (string, optional): 类型中文
        var typeCH:String = ""
        
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            detail = jsonData["detail"].stringValue
            handleName = jsonData["handleName"].stringValue
            handleTime = jsonData["handleTime"].stringValue
            id = jsonData["id"].stringValue
            name = jsonData["name"].stringValue
            orderId = jsonData["orderId"].stringValue
            orderType = jsonData["orderType"].stringValue
            phone = jsonData["phone"].stringValue
            requireTime = jsonData["requireTime"].stringValue
            status = jsonData["status"].stringValue
            statusCH = jsonData["statusCH"].stringValue
            type = jsonData["type"].stringValue
            typeCH = jsonData["typeCH"].stringValue
        }
        
        
    }
    
    class TravelOrder: NSObject,ALSwiftyJSONAble {
        
        ///  (string, optional): 出差地点 ,
        var address:String = ""
        
        ///  (string, optional): 结束时间 ,
        var endTime:String = ""
        
        ///  (string, optional): 出差原因 ,
        var reason:String = ""
        
        ///  (string, optional): 开始时间 ,
        var startTime:String = ""
        
        ///  (string, optional): 出差事由
        var target:String = ""
        
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            address = jsonData["address"].stringValue
            endTime = jsonData["endTime"].stringValue
            reason = jsonData["reason"].stringValue
            startTime = jsonData["startTime"].stringValue
            target = jsonData["target"].stringValue
        }
        
    }
    
    class PassengerResponse: NSObject,ALSwiftyJSONAble {
    
        ///  (Array[], optional): 改签信息 ,
        var alters:[FlightAlterResponse] = Array()
        
        ///  (string, optional): 生日 ,
        var birthday:String = ""
        
        ///  (string, optional): 证件号 ,
        var certNo:String = ""
        
        ///  (string, optional): 证件类型1：二代身份证，2：护照 ,
        var certType:String = ""
        
        ///  (integer, optional): 公司ID ,
        var corpId:String = ""
        
        ///  (string, optional): 邮箱 ,
        var email:String = ""
        
        ///  (string, optional): 性别1：男，2：女 ,
        var gender:String = ""
        
        var id:String = ""
        
        ///  (number, optional): 机建税 ,
        var ocTax:String = ""
        
        ///  (string, optional): 乘客姓名 ,
        var psgName:String = ""
        
        ///  (string, optional): 乘客ID ,
        var psgParId:String = ""
        
        ///  (string, optional): 乘客类型1：成人，2：儿童 ,
        var psgType:String = ""
        
        /// , optional): 退票信息 ,
        var refund:FlightRefundResponse = FlightRefundResponse()
        
        ///  (Array[], optional): 保险信息 ,
        var surances:[FlightSuranceResponse] = Array()
        
        ///  (number, optional): 出票价 ,
        var tcFare:String = ""
        
        ///  (number, optional): 燃油税 ,
        var tcTax:String = ""
    
        ///  (string, optional): 票号 ,
        var ticketNo:String = ""
        
        ///  (number, optional): 总金额 ,
        var total:String = ""
        
        ///  (integer, optional): 0普通1退票单2改签单3改签退票单4取消单 ,
        var type:String = ""
        
        ///  (number, optional): 票价 ,
        var unitFare:String = ""
        
        ///  (number, optional): 总税
        var unitTax:String = ""
        
        
        /// 火车票 必备信息
        ///  (string, optional): 座位类型中文 ,
        var siteCodeCH:String = ""
        //座位信息
        var siteInfo:String = ""
        //订单金额
        var money:String = ""
        
        //酒店
        var infos:[String] = Array()
        var mealCount:String = ""
        var passengerName:String = ""
        var special:String = ""
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
        
            alters = jsonData["alters"].arrayValue.map{FlightAlterResponse.init(jsonData: $0)!}
            birthday = jsonData["birthday"].stringValue
            certNo = jsonData["certNo"].stringValue
            certType = jsonData["certType"].stringValue
            corpId = jsonData["corpId"].stringValue
            email = jsonData["email"].stringValue
            gender = jsonData["gender"].stringValue
            id = jsonData["id"].stringValue
            infos = jsonData["infos"].arrayValue.map{$0.stringValue}
            mealCount = jsonData["mealCount"].stringValue
            passengerName = jsonData["passengerName"].stringValue
            special = jsonData["special"].stringValue
            ocTax = jsonData["ocTax"].stringValue
            psgName = jsonData["psgName"].stringValue
            psgParId = jsonData["psgParId"].stringValue
            psgType = jsonData["psgType"].stringValue
            refund = FlightRefundResponse.init(jsonData:jsonData["refund"] )!
            surances = jsonData["surances"].arrayValue.map{FlightSuranceResponse.init(jsonData: $0)!}
            tcFare = jsonData["tcFare"].stringValue
            tcTax = jsonData["tcTax"].stringValue
            ticketNo = jsonData["ticketNo"].stringValue
            total = jsonData["total"].stringValue
            type = jsonData["type"].stringValue
            unitFare = jsonData["unitFare"].stringValue
            unitTax = jsonData["unitTax"].stringValue
            siteCodeCH = jsonData["siteCodeCH"].stringValue
            siteInfo = jsonData["siteInfo"].stringValue
            money = jsonData["money"].stringValue
        }
        
    }
    class FlightSegmentResponse :NSObject,ALSwiftyJSONAble  {
        
        ///  (string, optional): 降落机场 ,
        var arriveAirport:String = ""
        
        ///  (string, optional): 降落城市 ,
        var arriveCity:String = ""
        
        ///  (string, optional): 到达航站楼 ,
        var arriveTerminal:String = ""
        
        ///  (string, optional): 降落时间 ,
        var arriveTime:String = ""
        
        ///  (string, optional): 仓等 ,
        var cabin:String = ""
        
        ///  (string, optional): 退改签规则 ,
        var ei:String = ""
        
        ///  (integer, optional): 天数 ,
        var flyDays:NSInteger = 0
        
        ///  (integer, optional),
        var id:String = ""
        
        ///  (string, optional): 航司 ,
        var marketAirline:String = ""
        
        ///  (string, optional): 航司中文 ,
        var marketAirlineCH:String = ""
        
        ///  (string, optional): 航班号 ,
        var marketFlightNo:String = ""
        
        ///  (boolean, optional): 是否为共享航班 ,
        var share:Bool = false
        
        ///  (string, optional): 仓位 ,
        var shipping:String = ""
        
        ///  (boolean, optional): 是否经停 ,
        var stopOver:Bool = false
        
        ///  (string, optional): 经停城市 ,
        var stopoverCity:String = ""
        
        ///  (string, optional): 经停时间 ,
        var stopoverTime:String = ""
        
        ///  (string, optional): 起飞机场 ,
        var takeoffAirport:String = ""
        
        ///  (string, optional): 起飞机场 ,
        var takeoffCity:String = ""
        
        ///  (string, optional): 起飞航站楼 ,
        var takeoffTerminal:String = ""
        
        ///  (string, optional): 起飞时间
        var takeoffTime:String = ""
        
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            
            arriveAirport = jsonData["arriveAirport"].stringValue
            arriveCity = jsonData["arriveCity"].stringValue
            arriveTerminal = jsonData["arriveTerminal"].stringValue
            arriveTime = jsonData["arriveTime"].stringValue
            cabin = jsonData["cabin"].stringValue
            ei = jsonData["ei"].stringValue
            flyDays = jsonData["flyDays"].intValue
            id = jsonData["id"].stringValue
            marketAirline = jsonData["marketAirline"].stringValue
            marketAirlineCH = jsonData["marketAirlineCH"].stringValue
            marketFlightNo = jsonData["marketFlightNo"].stringValue
            share = jsonData["share"].boolValue
            shipping = jsonData["shipping"].stringValue
            stopOver = jsonData["stopOver"].boolValue
            stopoverCity = jsonData["stopoverCity"].stringValue
            stopoverTime = jsonData["stopoverTime"].stringValue
            takeoffAirport = jsonData["takeoffAirport"].stringValue
            id = jsonData["id"].stringValue
            takeoffCity = jsonData["takeoffCity"].stringValue
            takeoffTerminal = jsonData["takeoffTerminal"].stringValue
            takeoffTime = jsonData["takeoffTime"].stringValue
        }
        
    }
    
    class HotelPassengerResponse:NSObject,ALSwiftyJSONAble  {
        
        ///  (integer, optional),
        var id:String = ""
        var infos:[String] = Array()
        var mealCount:String = ""
        var passengerName:String = ""
        var special:String = ""
        
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            id = jsonData["id"].stringValue
            infos = jsonData["infos"].arrayValue.map{$0.stringValue }
            mealCount = jsonData["mealCount"].stringValue
            passengerName = jsonData["passengerName"].stringValue
            special = jsonData["special"].stringValue
        }
        
    }
    
//    
//    class PassengerResponse: NSObject,ALSwiftyJSONAble {
//        
//    ///  (string, optional): 证件号 ,
//    var certNo:String = ""
//    
//    ///  (string, optional): 证件类型 ,
//    var certType:String = ""
//    
//    ///  (integer, optional): id ,
//    var id:String = ""
//    
//    ///  (number, optional): 订单金额 ,
//    var money:String = ""
//    
//    ///  (number, optional): 手续费 ,
//    var poundage:String = ""
//    
//    ///  (string, optional): 乘客姓名 ,
//    var psgName:String = ""
//        
//        ///  (string, optional): 乘客ID ,
//        var psgParId:String = ""
//        
//        ///  (string, optional): 乘客类型1：成人，2：儿童 ,
//        var psgType:String = ""
//        
//        ///  (number, optional): 退款金额 ,
//        var refundAmount:String = ""
//        
//        ///  (string, optional): 退票状态 ,
//        var refundStatus:String = ""
//        
//        ///  (string, optional): 座位类型 ,
//        var siteCode:String = ""
//        
//        ///  (string, optional): 座位类型中文 ,
//        var siteCodeCH:String = ""
//        
//        ///  (string, optional): 座位信息 ,
//        var siteInfo:String = ""
//        
//        ///  (string, optional): 票号
//        var ticketNo:String = ""
//        
//        override init() {
//            
//        }
//        
//        required init?(jsonData: JSON) {
//           
//            certNo = jsonData["certNo"].stringValue
//            certType = jsonData["certType"].stringValue
//            id = jsonData["id"].stringValue
//            money = jsonData["money"].stringValue
//            poundage = jsonData["poundage"].stringValue
//            psgName = jsonData["psgName"].stringValue
//            psgParId = jsonData["psgParId"].stringValue
//            psgType = jsonData["psgType"].stringValue
//            refundAmount = jsonData["refundAmount"].stringValue
//            refundStatus = jsonData["refundStatus"].stringValue
//            siteCode = jsonData["siteCode"].stringValue
//            siteCodeCH = jsonData["siteCodeCH"].stringValue
//            siteInfo = jsonData["siteInfo"].stringValue
//            ticketNo = jsonData["ticketNo"].stringValue
//        }
//        
//    }
    
    class FlightAlterResponse:NSObject,ALSwiftyJSONAble  {
        
        ///  (string, optional): 个人费用描述 ,
        var caseDesc:String = ""
        
        ///  (string, optional): 改签费用描述 ,
        var extraDesc:String = ""
        
        ///  (number, optional): 改签费 ,
        var extraTotal:String = ""
        
        ///  (integer, optional),
        var id:String = ""
        
        ///  (number, optional): 个人费用 ,
        var personPrice:String = ""
        
        ///  (string, optional): pnr ,
        var pnr:String = ""
        
        ///  (Array[], optional): 航段信息 ,
        var segments:[FlightSegmentResponse] = Array()
        var tcAirportTax:String = ""
        
        ///  (number, optional): 机票单价 ,
        var tcFare:String = ""
        
        ///  (number, optional),
        var tcOilTax:String = ""
        
        ///  (number, optional): 总价 ,
        var tcTotal:String = ""
        
        ///  (number, optional): 总税 ,
        var tcTotalTax:String = ""
        
        ///  (string, optional): 改签票号
        var ticketNo:String = ""
        
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
         
            caseDesc = jsonData["caseDesc"].stringValue
            extraDesc = jsonData["extraDesc"].stringValue
            extraTotal = jsonData["extraTotal"].stringValue
            id = jsonData["id"].stringValue
            personPrice = jsonData["personPrice"].stringValue
            pnr = jsonData["pnr"].stringValue
            segments = jsonData["segments"].arrayValue.map{FlightSegmentResponse.init(jsonData: $0)!}
            tcAirportTax = jsonData["tcAirportTax"].stringValue
            tcFare = jsonData["tcFare"].stringValue
            tcOilTax = jsonData["tcOilTax"].stringValue
            tcTotalTax = jsonData["tcTotalTax"].stringValue
            ticketNo = jsonData["ticketNo"].stringValue
        }
        
    }
    
    class FlightRefundResponse: NSObject,ALSwiftyJSONAble {
        var extraPrice:String = ""
        var extraPriceDesc:String = ""
        var id:String = ""
        var personPrice:String = ""
        var priceCaseDesc:String = ""
        
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            extraPrice = jsonData["extraPrice"].stringValue
            extraPriceDesc = jsonData["extraPriceDesc"].stringValue
            id = jsonData["id"].stringValue
            personPrice = jsonData["personPrice"].stringValue
            priceCaseDesc = jsonData["priceCaseDesc"].stringValue
        }
        
    }
    
    
    class FlightSuranceResponse:NSObject,ALSwiftyJSONAble  {
        
        
    ///  (string, optional): 被保人 ,
    var cusName:String = ""
    
    ///  (string, optional): 被保人ID ,
    var cusParId:String = ""
    
    ///  (boolean, optional),
    var first:Bool = false
    
    ///  (integer, optional): ID ,
    var id:String = ""
    
    ///  (string, optional): 订单号 ,
    var orderNo:String = ""
    
    ///  (number, optional): 保险费用 ,
    var price:String = ""
    
    ///  (string, optional): 保险公司 ,
    var suranceCompany:String = ""
    
    ///  (string, optional): 保险天数 ,
    var suranceDay:String = ""
    
    ///  (string, optional): 保险结束时间 ,
    var suranceEnd:String = ""
    
    ///  (string, optional): 保险结束时间星期 ,
    var suranceEndWeek:String = ""
    
    ///  (string, optional): 保险名称 ,
    var suranceName:String = ""
    
    ///  (string, optional): 保单号 ,
    var suranceNo:String = ""
    
    ///  (string, optional): 保险开始时间 ,
    var suranceStart:String = ""
    
    ///  (string, optional): 保险开始时间星期 ,
    var suranceStartWeek:String = ""
    
    ///  (string, optional): 保险状态1未生效2已生效3生效失败4退保成功5退保失败 ,
    var suranceStatus:String = ""
    
    /// (string, optional): 保险状态中文
    var suranceStatusCH:String = ""
    
    
    override init() {
        
    }
    
    required init?(jsonData: JSON) {

        cusName = jsonData["cusName"].stringValue
        cusParId = jsonData["cusParId"].stringValue
        first = jsonData["first"].boolValue
        id = jsonData["id"].stringValue
        orderNo = jsonData["orderNo"].stringValue
        price = jsonData["price"].stringValue
        suranceCompany = jsonData["suranceCompany"].stringValue
        suranceDay = jsonData["suranceDay"].stringValue
        suranceEnd = jsonData["suranceEnd"].stringValue
        suranceEndWeek = jsonData["suranceEndWeek"].stringValue
        suranceName = jsonData["suranceName"].stringValue
        suranceNo = jsonData["suranceNo"].stringValue
        suranceStart = jsonData["suranceStart"].stringValue
        suranceStartWeek = jsonData["suranceStartWeek"].stringValue
        suranceStatus = jsonData["suranceStatus"].stringValue
        suranceStatusCH = jsonData["suranceStatusCH"].stringValue
    }
        
    }
    
}
