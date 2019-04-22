//
//  CoNewOrderDetail.swift
//  shop
//
//  Created by akrio on 2017/5/15.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import SwiftDate
import SwiftyJSON
import Moya_SwiftyJSONMapper

/// 企业新版出差单详情
struct CoNewOrderDetail :ALSwiftyJSONAble,Validator{
    /// 出差单号
    let orderNo:String
    /// 创建人姓名
    let createPsgName:String
    /// 旅客详细信息
    let psgInfos:[PsgInfo]
    /// 创建时间
    let createTime:DateInRegion
    /// 出差旅客
    let psgNames:[String]
    /// 出差地
    let destinations:[String]
    /// 出发时间
    let startDate:DateInRegion?
    /// 到达时间
    let endDate:DateInRegion?
    /// 成本中心
    let costCenterNames:[String]
    /// 出差目的
    let purpose:String
    /// 出差事由
    let reason:String
    /// 订单状态
    let orderState:CoOrderState
    /// 送审方式
    var approvalType:CoOrderSubmitType
    /// 机票小订单
    let flightItems:[FlightVo]
    /// 酒店小订单
    let hotelItems:[HotelVo]
    /// 火车票小订单
    let trainItems:[TrainVo]
    /// 专车小订单
    let carItems:[CarVo]
    /// 保险小订单
    let suranceItems:[SuranceVo]
    /// 自定义字段
    let customFields:[CustomText]
    /// 历史订单变化
    let historyInfos:[HistoryInfo]
    /// 历史订单变化
    let historyApprovalInfos:[HistoryApprovalInfo]
    
    /// 当前审批级别
    let currentApvLevel:Int
    /// 通过计算获取当前审批人Id
    var currentApvId:String
    /// 通过历史审批记录 计算是否需要审批
    let hideApproval:Bool
    
    // 只有修改所需字段
    
    /// 审批规则id
    let apvRuleId:String
    /// 成本中心 id
    let costCenterIds:[String]
    /// 旅客信息
    struct PsgInfo:ALSwiftyJSONAble {
        /// 旅客姓名
        let name:String
        /// 邮箱
        let emails:[String]
        /// 唯一标示
        let id:String
        init(jsonData: JSON) {
            self.name = jsonData["name"].stringValue
            self.emails = jsonData["emails"].array?.flatMap{ $0.stringValue } ?? []
            self.id = jsonData["uid"].stringValue
        }
    }
    /// 自定义字段
    struct CustomText :ALSwiftyJSONAble {
        /// 唯一标识
        let id:(id:String,resultId:String)
        /// 自定义字段标题
        let title:String
        /// 自定义字段值
        let values:[String]
        /// 自定义字段类型
        let type:CoNewOrderCustomConfig.CustomField.CustomType
        init(jsonData: JSON) {
            self.id = (id:jsonData["id"].stringValue,resultId:jsonData["resultId"].stringValue)
            self.title = jsonData["name"].stringValue
            self.values = jsonData["selectValue"].arrayValue.map{ $0.stringValue }
            self.type = CoNewOrderCustomConfig.CustomField.CustomType(rawValue: jsonData["type"].intValue) ?? .text
        }
    }
    
    init(jsonData:JSON) {
        self.orderNo = jsonData["orderNo"].stringValue
        self.createPsgName = jsonData["bookerName"].stringValue
        self.createTime = jsonData["createTime"].dateFormat(.unix)
        self.psgNames = jsonData["orderPsgNames"].arrayValue.map{ $0.stringValue}
        self.psgInfos = jsonData["orderPsgs"].arrayValue.map{ PsgInfo(jsonData: $0) }
        self.destinations = jsonData["destinations"].arrayValue.map{ $0.stringValue}
        self.startDate = jsonData["startTime"].dateFormat(.unix)
        self.endDate = jsonData["endTime"].dateFormat(.unix)
        self.costCenterNames = jsonData["costCenterNames"].arrayValue.map{$0.stringValue}
        self.purpose = jsonData["purpose"].stringValue
        self.reason = jsonData["reason"].stringValue
        self.orderState = CoOrderState(rawValue: jsonData["orderState"].stringValue) ?? .unknow
        self.flightItems = jsonData["flightOrderItems"].arrayValue.map{ FlightVo(jsonData: $0) }
        self.hotelItems = jsonData["hotelOrderItems"].arrayValue.map{ HotelVo(jsonData: $0) }
        self.trainItems = jsonData["trainOrderItems"].arrayValue.map{ TrainVo(jsonData: $0) }
        self.carItems = jsonData["carOrderItems"].arrayValue.map{ CarVo(jsonData: $0) }
        self.suranceItems = jsonData["suranceOrderItems"].arrayValue.map{ SuranceVo(jsonData: $0) }
        self.customFields = jsonData["orderCustomFields"].arrayValue.map{ CustomText(jsonData: $0) }
        self.historyInfos = jsonData["orderHistoryInfos"].arrayValue.map{ HistoryInfo(jsonData: $0) }
        self.historyApprovalInfos = jsonData["orderApprovalRecords"].arrayValue.filter{ $0["apvResult"].string != nil }
            .sorted{ $0["apverLevel"].intValue < $1["apverLevel"].intValue }.map { HistoryApprovalInfo(jsonData:$0) }
        if let hightestApvLevel = jsonData["hightestApvLevel"].int{
            //最高审批级别为0 说明无需送审
            if hightestApvLevel == 0 {
                self.approvalType = .noApproval
            }else {
                self.approvalType = .approval
            }
        }else {
            self.approvalType = .unknow
        }
        self.currentApvLevel = jsonData["currentApvLevel"].intValue
        self.currentApvId = jsonData["orderApprovalRecords"].arrayValue.filter{ $0["apvResult"].string == nil && jsonData["currentApvLevel"].intValue == $0["apverLevel"].intValue }.last?["apverUid"].stringValue ?? ""
        //判断是否存在无需送审权限
        let hasOA = UserService.sharedInstance.userDetail()?.companyUser?.permissions.contains(.oaApproval) ?? false
        if hasOA {
            self.approvalType = .noApproval
        }
        self.apvRuleId = jsonData["apvRuleId"].stringValue
        self.costCenterIds = jsonData["costCenterIds"].arrayValue.map{ $0.stringValue }
        //判断当前审批人是否需要审批
        let lastApproval = jsonData["orderApprovalRecords"].arrayValue.filter{ $0["apverLevel"].intValue == jsonData["currentApvLevel"].intValue }.last
        if let lastApproval = lastApproval {
                    self.hideApproval = lastApproval["apvState"].intValue != 0 || lastApproval["apverUid"].stringValue != (UserService.sharedInstance.userDetail()?.companyUser?.parId ?? "unknow")
        }else {
            self.hideApproval = false
        }
    }
    /// 获取订单流转状态
    ///
    /// - Returns: 当前状态在流转状态的位置 订单流转状态
    /// - Throws: 出现非符合条件的流转状态
    func getStates() throws -> (currentIndex:Int,states:[CoOrderState]) {
        let states = try self.getOrderStates()
        let currentStateIndex = states.index(of: self.orderState)!
        return (currentStateIndex,states)
    }
    /// 获取订单流转状态
    ///
    /// - Returns: 订单流转状态
    /// - Throws: 出现非符合条件的流转状态
    private func getOrderStates() throws -> [CoOrderState]{
        
        //丰田销售定制化  无审批中状态
        // add by manman
        let userInfo = UserService.sharedInstance.userDetail()
        var companyCodeToyota:String = ""
        if userInfo?.companyUser?.companyCode?.uppercased() == Toyota {
            companyCodeToyota = Toyota
            
        }
        
        
        
        // end of line
        
        
        
        switch self.orderState {
        case .cancel:
            let pre = historyInfos.last?.stateBefore
            guard let preState = pre else {
                throw validateMessage("当前状态为已取消，获取前一个状态失败")
            }
            //如果当前的前一个状态是审批中则说明 计划中 -> 已取消
            guard preState != .planing else {
                return [.planing,.cancel]
            }
            //如果存在审批中状态则说明 计划中 -> 审批中 -> 已通过 -> 待定妥 -> 已取消
            let hasApproving = historyInfos.contains{ $0.stateBefore == .approving }
            guard !hasApproving else{
                return [.planing,.approving,.passed,.willComplete,.cancel]
            }
            //其他情况说明是 计划中 -> 已通过 -> 待定妥 -> 已取消
            return [.planing,.approving,.passed,.willComplete,.cancel]
        case .planing: //计划中
            //TODO 无需送审
            // 计划中 -> 审批中 -> 已通过 -> 待定妥 -> 已订妥
            
            // add by manman  丰田销售
            if VerifyCompanyCode(companyCode: companyCodeToyota) {
                return [.planing,.passed,.willComplete,.ompleted]
            }
            
            // end of line 
            
            return [.planing,.approving,.passed,.willComplete,.ompleted]
        case .approving: //审批中
            // 计划中 -> 审批中 -> 已通过 -> 待定妥 -> 已订妥
            return [.planing,.approving,.passed,.willComplete,.ompleted]
        case .passed: //已通过
            // 计划中 -> 审批中 -> 已通过 -> 待定妥 -> 已订妥
            return [.planing,.approving,.passed,.willComplete,.ompleted]
        case .rejected: //已拒绝
            //计划中 -> 审批中 -> 已拒绝
            return [.planing,.approving,.rejected]
        case .willComplete: //待定妥
            
//            // add by manman  丰田销售
//            if VerifyCompanyCode(companyCode: companyCodeToyota) {
//                return [.planing,.passed,.willComplete,.ompleted]
//            }
//            
//            // end of line

            
            //如果存在审批中状态则说明 计划中 -> 审批中 -> 已通过 -> 待定妥 -> 已订妥
            let hasApproving = historyInfos.contains{ $0.stateBefore == .approving }
            guard !hasApproving else{
                return [.planing,.approving,.passed,.willComplete,.ompleted]
            }
            //其他情况说明是 计划中 -> 已通过 -> 待定妥 -> 已订妥
            return [.planing,.passed,.willComplete,.ompleted]
        case .ompleted:
            
//            // add by manman  丰田销售
//            if VerifyCompanyCode(companyCode: companyCodeToyota) {
//                return [.planing,.passed,.willComplete,.ompleted]
//            }
//            
//            // end of line

            
            //如果存在审批中状态则说明 计划中 -> 审批中 -> 已通过 -> 待定妥 -> 已订妥
            let hasApproving = historyInfos.contains{ $0.stateBefore == .approving }
            guard !hasApproving else{
                return [.planing,.approving,.passed,.willComplete,.ompleted]
            }
            //其他情况说明是 计划中 -> 已通过 -> 待定妥 -> 已订妥
            return [.planing,.passed,.willComplete,.ompleted]
        case .offline: //转线下
            //如果存在审批中状态则说明 计划中 -> 审批中 -> 已通过 -> 待定妥 -> 转线下
            let hasApproving = historyInfos.contains{ $0.stateBefore == .approving }
            guard !hasApproving else{
                return [.planing,.approving,.passed,.willComplete,.offline]
            }
            //其他情况说明是 计划中 -> 已通过 -> 待定妥 -> 转线下
            return [.planing,.passed,.willComplete,.offline]
        case .deleted://已删除
            return [.planing,.deleted]
        case .deleteing://删除申请中
            return [.planing,.deleteing]
        default:
            return [.planing,self.orderState]
        }
    }
    
    func VerifyCompanyCode(companyCode:String) -> Bool {
        
        switch companyCode {
        case Toyota:
            return true
        default:
            return false
        }
        
    }
    
    
    
    
    
    
    
    /// 航班实体 (没有出票时限)
    struct FlightVo:ALSwiftyJSONAble{
        /// 小订单唯一标识
        let id:String
        /// 机票小订单状态
        let state:OrderItemState
        /// 违背差旅政策 当为nil表示符合差旅政策
        let contrary:ContraryTravelPolicy?
        /// 飞行时间(分钟)
        let flyTime:Int
        /// 航段信息
        let legs:[Leg]
        /// 退改签规则
        let ei:String
        /// 总价格
        let price:Double
        /// 税费
        let tax:Double
        /// 乘客信息
        let passengers:[Passenger]
        /// 机票状态
        let ticketState:FlightTicketState
        /// 联系人信息
        let contact:ContactUser
        /// 是否有有效保险（0:无，1：有）
        let suranceStatus:String
        /// 违背政策实体
        struct ContraryTravelPolicy {
            /// 违背原因
            let contraryReason:String
            /// 违背差旅政策描述
            let contraryTravelPolicyDesc:String
        }
        init(jsonData: JSON) {
            self.flyTime = jsonData["flyTime"].intValue
            if jsonData["contraryTravelPolicy"].boolValue {
                let contraryReason = jsonData["contraryReason"].stringValue
                let contraryTravelPolicyDesc = jsonData["contraryTravelPolicyDesc"].stringValue
                contrary = ContraryTravelPolicy(contraryReason: contraryReason, contraryTravelPolicyDesc: contraryTravelPolicyDesc)
            }else {
               contrary = .none
            }
            if let legs = jsonData["departCoFlightInfos"].array {
                self.legs = legs.map{ Leg(jsonData: $0) }
            }else {
               self.legs = jsonData["returnCoFlightInfos"].arrayValue.map{ Leg(jsonData: $0) }
            }
            self.ei = jsonData["ei"].stringValue
            self.price = jsonData["ticketPrice"].doubleValue
            self.tax = jsonData["tax"].doubleValue
            self.id = jsonData["flightOrderNo"].stringValue
            self.state = OrderItemState(rawValue: jsonData["flightOrderState"].stringValue) ?? .unknow
            self.ticketState = FlightTicketState(rawValue: jsonData["ticketState"].stringValue) ?? .unknow
            self.passengers = jsonData["passengers"].arrayValue.map{
                let name = $0["name"].stringValue
                let mobile = $0["mobile"].stringValue
                let certNo = $0["certNo"].stringValue
                let id = $0["uid"].stringValue
                return Passenger(id:id,name: name, mobile: mobile, certNo: certNo)
            }
            self.suranceStatus = jsonData["suranceStatus"].stringValue
            let contactName = jsonData["contactName"].stringValue
            let contactMobile = jsonData["contactMobile"].stringValue
            let contactEmails = jsonData["contactEmails"].arrayValue.map{ $0.stringValue }
            self.contact = ContactUser(name: contactName, email: contactEmails, mobile: contactMobile)
        }
        /// 乘机人信息实体
        struct Passenger {
            /// 用户唯一标示
            let id:String
            /// 姓名
            let name:String
            /// 手机号
            let mobile:String
            /// 身份证号
            let certNo:String
        }
        /// 单航段信息
        struct Leg :ALSwiftyJSONAble{
            /// 出发机场名称
            let takeOffAirportName:String
            /// 出发机场航站楼
            let takeOffTerminal:String
            /// 出发时间
            let takeOffTime:DateInRegion
            /// 到达机场名称
            let arriveAirportName:String
            /// 到达机场航站楼
            let arriveTerminal:String
            /// 到达时间
            let arriveTime:DateInRegion
            /// 航空公司名称简写
            let flightName:String
            /// 航班号
            let flightNo:String
            /// 仓位类型
            let cabinType:String
            /// 仓位code码
            let cabinCode:String
            /// 是否经停
            let stopover:Bool
            /// 航班类型
            let craftType:String
            init(jsonData: JSON) {
                self.takeOffAirportName = jsonData["takeOffAirportName"].stringValue
                self.takeOffTerminal = jsonData["takeOffTerminal"].stringValue
                self.takeOffTime = jsonData["takeOffTime"].dateFormat(.unix)
                self.arriveAirportName = jsonData["arriveAirportName"].stringValue
                self.arriveTerminal = jsonData["arriveTerminal"].stringValue
                self.arriveTime = jsonData["arriveTime"].dateFormat(.unix)
                self.flightName = jsonData["flightName"].stringValue
                self.flightNo = jsonData["flightNo"].stringValue
                self.cabinType = jsonData["cabinType"].stringValue
                self.cabinCode = jsonData["cabinCode"].stringValue
                self.stopover = jsonData["stopover"].boolValue
                self.craftType = jsonData["craftType"].stringValue
            }
        }
    }
    /// 订单中酒店实体
    struct HotelVo :ALSwiftyJSONAble{
        /// 酒店订单唯一标识
        let id:String
        /// 酒店小订单状态
        let state:OrderItemState
        /// 酒店订单状态
        let hotelBookState:HotelBookState
        /// 入住天数
        let nights:Int
        /// 酒店名称
        let hotelName:String
        /// 房型
        let roomType:String
        /// 床型
        let bedTypeName:String
        /// 入住日期
        let checkInDate:DateInRegion
        /// 离店日期
        let checkOutDate:DateInRegion
        /// 违背差旅政策
        let contrary:ContraryTravelPolicy?
        /// 最晚到店时间
        let arriveLastTime:String
        /// 担保情况
        let guaranteeState:HotelGuaranteeState
        /// 价格
        let price:Double
        /// 退改政策
        let ei:String
        /// 入住人信息
        let passengers:[HotelPassenger]
        /// 联系人信息
        let contact:ContactUser
        /// 无需送审
        let needApproval:Bool
        /// 酒店入住人信息
        struct HotelPassenger {
            /// 用户唯一标示
            let id:String
            /// 入住人姓名
            let name:String
            /// 入住人联系电话
            let mobile:String
        }
        init(jsonData: JSON) {
            self.id = jsonData["hotelOrderNo"].stringValue
            self.state = OrderItemState(rawValue: jsonData["hotelOrderState"].stringValue) ?? .unknow
            self.hotelBookState = HotelBookState(rawValue: jsonData["hotelBookState"].stringValue) ?? .unknow
            self.nights = jsonData["nights"].intValue
            self.hotelName = jsonData["hotelName"].stringValue
            self.roomType = jsonData["roomTypeName"].stringValue
            self.bedTypeName = jsonData["bedTypeName"].stringValue
            self.checkInDate = jsonData["checkInDate"].dateFormat(.unix)
            self.checkOutDate = jsonData["checkOutDate"].dateFormat(.unix)
            if jsonData["contraryTravelPolicy"].boolValue {
                let contraryReason = jsonData["contraryReason"].stringValue
                let contraryTravelPolicyDesc = jsonData["contraryTravelPolicyDesc"].stringValue
                contrary = ContraryTravelPolicy(contraryReason: contraryReason, contraryTravelPolicyDesc: contraryTravelPolicyDesc)
            }else {
                contrary = .none
            }
            self.arriveLastTime = jsonData["arriveLastTime"].stringValue
            var state = HotelGuaranteeState.unknow
            if jsonData["guaranteeState"].stringValue == "Y" {
                state = .unGuarantee
            }else if jsonData["guaranteeState"].stringValue == "T" {
                state = .guarantee
            }
            self.guaranteeState = state
            self.price = jsonData["roomPrice"].doubleValue
            self.ei = jsonData["ei"].stringValue
            passengers = jsonData["passengers"].arrayValue.map{
                let name = $0["name"].stringValue
                let mobile = $0["mobile"].stringValue
                let id = $0["uid"].stringValue
                return HotelPassenger(id:id,name: name, mobile: mobile)
            }
            let contactName = jsonData["contactName"].stringValue
            let contactMobile = jsonData["contactMobile"].stringValue
            let contactEmails = jsonData["contactEmails"].arrayValue.map{ $0.stringValue }
            self.contact = ContactUser(name: contactName, email: contactEmails, mobile: contactMobile)
            self.needApproval = jsonData["hightestApvLevel"].intValue > 0
        }
    }
    
    struct TrainVo:ALSwiftyJSONAble{
        /// 车票单元id
        let trainItemId:Int
        /// 12580订单号
        let officialOrderNo:String
        /// 车次
        let checi:String
        /// 乘车日期
        let trainDate:DateInRegion
        /// 出发日期
        let startTime:DateInRegion
        /// 到达日期
        let endTime:DateInRegion
        /// 运行时间 分钟
        let runTime:Int
        /// 出发站简码
        let fromStationCode:String
        /// 出发站中文名
        let fromStationNameCn:String
        /// 到达站简码
        let toStationCode:String
        /// 到达站中文名
        let toStationNameCn:String
        /// 订单票价（人民币）
        let spAmount:Double
        /// 订单状态（1正常 2删除 火车票订单状态）
        let trainOrderStatus:OrderItemState
        /// 火车票订单状态（火车退票用 201:待处理，204：出票申请，205：出票成功，206：出票失败，207：已申请退票，208 ：退票成功，209：退票失败，301：已取消） ,
        let bookedTrainStatus:TrainOrderStatusEnum
        /// 票号
        let ticketNo:String
        /// 车票单价
        let ticketPrice:Double
        /// 座次编码
        let siteCode:String
        /// 车票类型编码
        let ticketType:String
        /// 车票座位信息
        let siteInfo:String
        /// 客户PARID
        let parIds:String
        /// 退款金额 退票费
        let refundAmount:Double
        /// 联系人名称
        let contactName:String
        /// 联系人电话
        let contactPhone:String
        /// 联系人email
        let contactEmail:String
        /// 旅客
        let passengers:[TrainPassenger]
        ///
        let denyTravelPolicy:Bool
//        /// 手续费/人
//        let serviceFee:String
        /// 手续费/每人
        let deliveryFee:String
        /// 单人合计/每人
        let totalFee:String
        
        init(jsonData: JSON) {
            self.trainItemId = jsonData["trainItemId"].intValue
            self.officialOrderNo = jsonData["officialOrderNo"].stringValue
            self.checi = jsonData["checi"].stringValue
            self.trainDate = jsonData["trainDate"].dateFormat(.unix)
            self.startTime = jsonData["startTime"].dateFormat(.unix)
            self.endTime = jsonData["endTime"].dateFormat(.unix)
            self.runTime = jsonData["runTime"].intValue
            self.fromStationCode = jsonData["fromStationCode"].stringValue
            self.fromStationNameCn = jsonData["fromStationNameCn"].stringValue
            self.toStationCode = jsonData["toStationCode"].stringValue
            self.toStationNameCn = jsonData["toStationNameCn"].stringValue
            self.spAmount = jsonData["spAmount"].doubleValue
            self.trainOrderStatus = OrderItemState(rawValue: jsonData["trainOrderStatus"].stringValue) ?? .unknow
            self.bookedTrainStatus = TrainOrderStatusEnum(rawValue: jsonData["bookedTrainStatus"].stringValue) ??  .unknow
            self.ticketNo = jsonData["ticketNo"].stringValue
            self.ticketPrice = jsonData["ticketPrice"].doubleValue
            self.siteCode = jsonData["siteCode"].stringValue
            self.ticketType = jsonData["ticketType"].stringValue
            self.siteInfo = jsonData["siteInfo"].stringValue
            self.parIds = jsonData["parIds"].stringValue
            self.refundAmount = jsonData["refundAmount"].doubleValue
            self.contactName = jsonData["contactName"].stringValue
            self.contactPhone = jsonData["contactPhone"].stringValue
            self.contactEmail = jsonData["contactEmail"].stringValue
            self.passengers = jsonData["passengers"].arrayValue.map{ TrainPassenger(jsonData: $0 ) }
            self.denyTravelPolicy = jsonData["denyTravelPolicy"].boolValue
            //self.serviceFee = jsonData["serviceFee"].stringValue
            self.deliveryFee = jsonData["deliveryFee"].stringValue
            self.totalFee = jsonData["totalFee"].stringValue
        }
        
        
        struct TrainPassenger:ALSwiftyJSONAble{
            /// 旅客姓名
            let name:String
            /// 旅客ID
            let uid:String
            /// 旅客邮箱
            let emails:String
            /// 旅客电话
            let mobile:String
            /// 证件号
            let certNo:String
            /// 证件类型
            let certType:Int
            init(jsonData: JSON) {
                self.name = jsonData["name"].stringValue
                self.uid = jsonData["uid"].stringValue
                self.emails = jsonData["emails"].arrayValue.first?.stringValue ?? ""
                self.mobile = jsonData["mobile"].stringValue
                self.certNo = jsonData["certNo"].stringValue
                self.certType = jsonData["certType"].intValue
            }
            
            
        }
    }
    
    
    
    struct CarVo:ALSwiftyJSONAble{
        /// 专车单元主键
        let carItemId:String
        /// 用车类型 1接机 2送机 3预约用车
        let orderType:OrderCarTypeEnum
        /// 车型
        let carType:String
        /// 起始地点
        let startAddress:String
        /// 起始地点纬度
        let startLatitude:String
        /// 起始地点经度
        let stratLongitude:String
        /// 起始时间
        let startTime:DateInRegion
        /// 到达地点
        let endAddress:String
        /// 到达地点纬度
        let endLatitude:String
        /// 到达地点经度
        let endLongitude:String
        /// 预订到达时间
        let endTime:DateInRegion
        /// 报销人姓名
        let expenseName:String
        /// 报销人常客id
        let expenseParId:String
        /// 旅客
        let passengers:[CarPassenger]
        ///  订单状态（1正常 2删除 专车订单状态）
        let carOrderStatus:OrderItemState
        /// 专车预订状态   专车预订状态 201:计划中，202：待定妥，203：已分配，204：已订妥 ,205已取消
        let bookedCarStatus:CarOrderStatusEnum
        /// 司机名称
        let driverName:String
        /// 司机手机号
        let driverPhone:String
        /// 司机车牌号
        let driverNO:String
        /// 总价格
        let totalAmount:Double
        /// 联系人名称
        let contactName:String
        /// 联系人电话
        let contactPhone:String
        /// 联系人email
        let contactEmail:String
        
        init(jsonData: JSON) {
              self.carItemId = jsonData["carItemId"].stringValue
              self.orderType = OrderCarTypeEnum(rawValue: jsonData["orderType"].stringValue) ?? .unknow
              self.carType = jsonData["carType"].stringValue
              self.startAddress = jsonData["startAddress"].stringValue
              self.startLatitude = jsonData["startLatitude"].stringValue
              self.stratLongitude = jsonData["stratLongitude"].stringValue
              self.startTime = jsonData["startTime"].dateFormat(.unix)
              self.endAddress = jsonData["endAddress"].stringValue
              self.endLatitude = jsonData["endLatitude"].stringValue
              self.endLongitude = jsonData["endLongitude"].stringValue
              self.endTime = jsonData["endTime"].dateFormat(.unix)
              self.expenseName = jsonData["expenseName"].stringValue
              self.expenseParId = jsonData["expenseParId"].stringValue
              self.passengers = jsonData["passengers"].arrayValue.map{ CarPassenger(jsonData: $0 ) }
              self.carOrderStatus = OrderItemState(rawValue: jsonData["carOrderStatus"].stringValue) ?? .unknow
              self.bookedCarStatus = CarOrderStatusEnum(rawValue:jsonData["bookedCarStatus"].stringValue) ?? .unknow
              self.driverName = jsonData["driverName"].stringValue
              self.driverPhone = jsonData["driverPhone"].stringValue
              self.driverNO = jsonData["driverNO"].stringValue
              self.totalAmount = jsonData["totalAmount"].doubleValue
              self.contactName = jsonData["contactName"].stringValue
              self.contactPhone = jsonData["contactPhone"].stringValue
              self.contactEmail = jsonData["contactEmail"].stringValue
        }
        
        struct CarPassenger:ALSwiftyJSONAble{
            /// 旅客姓名
            let name:String
            /// 旅客ID
            let uid:String
            /// 旅客邮箱
            let emails:String
            /// 旅客电话
            let mobile:String
            /// 证件号
            let certNo:String
            /// 证件类型
            let certType:Int
            init(jsonData: JSON) {
                self.name = jsonData["name"].stringValue
                self.uid = jsonData["uid"].stringValue
                self.emails = jsonData["emails"].arrayValue.first?.stringValue ?? ""
                self.mobile = jsonData["mobile"].stringValue
                self.certNo = jsonData["certNo"].stringValue
                self.certType = jsonData["certType"].intValue
            }
        }

    }
    /// 保险订单实体
    struct SuranceVo :ALSwiftyJSONAble{
        /// 唯一标识
        let id:String
        /// 保险单号
        let suranceNo:String
        /// 保险公司名称
        let suranceCompany:String
        /// 保险有效起始时间
        let startDate:DateInRegion
        /// 保险有效截止日期
        let endDate:DateInRegion
        /// 被保险人姓名
        let insuredName:String
        /// 保险名(投保类型)
        let suranceName:String
        /// 保险介绍
        let suranceDescribe:String
        /// 价格
        let price:Double
        /// 保险订单状态
        let suranceState:SuranceOrderState
        init(jsonData: JSON) {
            self.id = jsonData["id"].stringValue
            self.suranceNo = jsonData["suranceNo"].stringValue
            self.suranceCompany = jsonData["suranceCompany"].stringValue
            self.startDate = jsonData["startDate"].dateFormat(.unix)
            self.endDate = jsonData["endDate"].dateFormat(.unix)
            self.insuredName = jsonData["insuredName"].stringValue
            self.suranceName = jsonData["suranceName"].stringValue
            self.suranceDescribe = jsonData["suranceDescribe"].stringValue
            self.suranceState = SuranceOrderState(rawValue: jsonData["status"].stringValue) ?? .unknow
            self.price = jsonData["price"].doubleValue
        }

    }
    /// 历史订单状态
    struct HistoryInfo:ALSwiftyJSONAble {
        /// 状态变更时间
        let datetime:DateInRegion
        /// 成功之后的后一个状态
        let stateAfter:CoOrderState?
        /// 前一个状态
        let stateBefore:CoOrderState?
        init(jsonData: JSON) {
            self.datetime = jsonData["operateTime"].dateFormat(.unix)
            self.stateAfter = CoOrderState(rawValue: jsonData["stateAfter"].stringValue)
            self.stateBefore = CoOrderState(rawValue: jsonData["stateBefore"].stringValue)
        }
    }
    /// 历史审批状态
    struct HistoryApprovalInfo:ALSwiftyJSONAble {
        /// 审批时间
        let datetime:DateInRegion
        /// 审批人姓名
        let apverName:String
        /// 审批人id
        let apverId:String
        /// 审批人级别
        let apverLevel:Int
        /// 审批结果(true 代表同意)
        let apvResult:Bool
        init(jsonData: JSON) {
            self.datetime = jsonData["apvTime"].dateFormat(.unix)
            self.apverName = jsonData["apverName"].stringValue
            self.apverId = jsonData["apverUid"].stringValue
            self.apverLevel = jsonData["apverLevel"].intValue
            self.apvResult = jsonData["apvResult"].stringValue == "1"

        }
    }
    /// 小订单状态
    ///
    /// - active:  可用
    /// - delete: 删除
    enum OrderItemState:String{
        case active = "1"
        case delete = "0"
        case unknow = "unknow"
    }
    
    
}

/// 火车票订单状态
/// 火车退票用 201:待处理，204：出票申请，205：出票成功，206：出票失败，207：已申请退票，208 ：退票成功，209：退票失败，301：已取消
///
/// - waiting: 待处理
/// - ticketApply: 出票申请
/// - ticketSuccessfully: 出票成功
/// - ticketFailure: 出票失败
/// - applyRefund: 申请退票
/// - refunduccess: 退票成功
/// - refundFailure: 退票失败
/// - cancel: 已经取消
/// - unknow: 未知状态
enum TrainOrderStatusEnum:String {
    case success = "1"
    case wait = "0"
    case unknow = "unknow"
}
extension TrainOrderStatusEnum {
    var color: UIColor {
        switch self {
        case .wait :
            return TBIThemeOrangeColor
        case .success  :
            return TBIThemeGreenColor
        default :
            return UIColor.darkGray
        }
    }
}

extension TrainOrderStatusEnum : CustomStringConvertible{
    var description: String{
        switch self {
        case .success:
            return "已出票"
        case .wait:
            return "未出票"
        case .unknow:
            return "未知状态"
        }
    }
    
}
///  专车订单状态 201:计划中，202：待定妥，203：已分配，204：已订妥 ,
enum CarOrderStatusEnum:String {
    case success = "1"
    case wait = "0"
    case unknow = "unknow"
}
extension CarOrderStatusEnum : CustomStringConvertible{
    var description: String{
        switch self {
        case .success:
            return "已分配"
        case .wait:
            return "未分配"
        case .unknow:
            return "未知状态"
        }
    }
    
    var color: UIColor {
        switch self {
        case .wait :
            return TBIThemeOrangeColor
        case .success  :
            return TBIThemeGreenColor
        default :
            return UIColor.darkGray
        }
    }
    
}
/// 1接机 2送机 3预约用车
enum OrderCarTypeEnum:String {
    case pick = "1"
    case send = "2"
    case about  = "99"
    case unknow = "unknow"
}
extension OrderCarTypeEnum {
    var description: String{
        switch self {
        case .pick:
            return "接机"
        case .send:
            return "送机"
        case .about:
            return "预约用车"
        case .unknow:
            return "未知状态"
        }
    }
    
}
