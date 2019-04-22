//
//  CoOldOrderDetail.swift
//  shop
//
//  Created by akrio on 2017/5/15.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON
import SwiftDate

/// 老版订单详情
struct CoOldOrderDetail :ALSwiftyJSONAble{
    /// 订单号
    let orderNo:String
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
    /// 历史订单变化
    let historyInfos:[HistoryInfo]
    /// 历史审批信息记录
    let historyApprovalInfos:[HistoryApprovalInfo]
    /// 订单状态
    let state:CoOrderState
    /// 送审方式
    var approvalType:CoOrderSubmitType
    //审批相关需要字段
    
    /// 创建人姓名
    let bookerName:String
    /// 创建时间
    let createTime:DateInRegion
    /// 订单中的旅客姓名
    let orderPsgNames:[String]
    /// 旅客id
    let psgIds:[String]
    /// 出行目的（审批中时有值）
    let travelPurpose:String
    /// 出行事由（审批中时有值）
    let travelDesc:String
    /// 当前审批级别
    let currentApvLevel:Int
    /// 通过计算获取当前审批人Id
    var currentApvId:String
    /// 是否因为审批过 而无需审批
    let hideApproval:Bool
    
    init(jsonData: JSON) {
        self.orderNo = jsonData["orderNo"].stringValue
        self.flightItems = jsonData["flightOrderItems"].arrayValue.map{ FlightVo(jsonData: $0) }
        self.hotelItems = jsonData["hotelOrderItems"].arrayValue.map{ HotelVo(jsonData: $0) }
        self.suranceItems = jsonData["suranceOrderItems"].arrayValue.map{ SuranceVo(jsonData: $0) }
        self.state = CoOrderState(rawValue: jsonData["orderState"].stringValue) ?? .unknow
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
        self.bookerName = jsonData["bookerName"].stringValue
        self.createTime = jsonData["createTime"].dateFormat(.unix)
        self.orderPsgNames = jsonData["orderPsgNames"].arrayValue.map{$0.stringValue}
        self.travelPurpose = jsonData["travelPurpose"].stringValue
        self.travelDesc = jsonData["travelDesc"].stringValue
        self.trainItems = jsonData["trainOrderItems"].arrayValue.map{ TrainVo(jsonData: $0) }
        self.carItems = jsonData["carOrderItems"].arrayValue.map{ CarVo(jsonData: $0) }
        if(jsonData["hotelOrderItems"].arrayValue.count != 0){
            self.psgIds = jsonData["hotelOrderItems"].arrayValue.first!["passengers"].arrayValue.map{$0["uid"].stringValue}
        }else if(jsonData["flightOrderItems"].arrayValue.count != 0){
           self.psgIds = jsonData["flightOrderItems"].arrayValue.first!["passengers"].arrayValue.map{$0["uid"].stringValue}
        }else {
            self.psgIds = []
        }
        //判断当前审批人是否需要审批
        let lastApproval = jsonData["orderApprovalRecords"].arrayValue.filter{ $0["apverLevel"].intValue == jsonData["currentApvLevel"].intValue }.last
        if let lastApproval = lastApproval {
            self.hideApproval = lastApproval["apvState"].intValue != 0 || lastApproval["apverUid"].stringValue != (UserService.sharedInstance.userDetail()?.companyUser?.parId ?? "unknow")
        }else {
            self.hideApproval = false
        }
    }
    /// 订单中酒店实体
    struct HotelVo :ALSwiftyJSONAble{
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
        /// 酒店入住人信息
        struct HotelPassenger {
            /// 入住人姓名
            let name:String
            /// 入住人联系电话
            let mobile:String
        }
        init(jsonData: JSON) {
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
            self.guaranteeState = HotelGuaranteeState(rawValue: jsonData["guaranteeState"].stringValue) ?? .unknow
            self.price = jsonData["roomPrice"].doubleValue
            self.ei = jsonData["ei"].stringValue
            passengers = jsonData["passengers"].arrayValue.map{
                let name = $0["name"].stringValue
                let mobile = $0["mobile"].stringValue
                return HotelPassenger(name: name, mobile: mobile)
            }
            let contactName = jsonData["contactName"].stringValue
            let contactMobile = jsonData["contactMobile"].stringValue
            let contactEmails = jsonData["contactEmails"].arrayValue.map{ $0.stringValue }
            self.contact = ContactUser(name: contactName, email: contactEmails, mobile: contactMobile)
        }
    }
    /// 航班实体 (没有出票时限)
    struct FlightVo:ALSwiftyJSONAble{

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
            self.ticketState = FlightTicketState(rawValue: jsonData["ticketState"].stringValue) ?? .unknow
            self.passengers = jsonData["passengers"].arrayValue.map{
                let name = $0["name"].stringValue
                let mobile = $0["mobile"].stringValue
                let certNo = $0["certNo"].stringValue
                return Passenger(name: name, mobile: mobile, certNo: certNo)
            }
            let contactName = jsonData["contactName"].stringValue
            let contactMobile = jsonData["contactMobile"].stringValue
            let contactEmails = jsonData["contactEmails"].arrayValue.map{ $0.stringValue }
            self.contact = ContactUser(name: contactName, email: contactEmails, mobile: contactMobile)
        }
        /// 乘机人信息实体
        struct Passenger {
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
            }
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
        let trainOrderStatus:String
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
        /// 退款金额
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
            self.trainOrderStatus = jsonData["trainOrderStatus"].stringValue
            self.bookedTrainStatus =  TrainOrderStatusEnum(rawValue: jsonData["bookedTrainStatus"].stringValue) ??  .unknow
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
        /// 用车类型
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
        let carOrderStatus:String
        /// 专车预订状态
        let bookedCarStatus:String
        /// 司机名称
        let driverName:String
        /// 司机手机号
        let driverPhone:String
        /// 司机车牌号
        let driverNO:String
        /// 总价格
        let totalAmount:Double
        
        init(jsonData: JSON) {
            self.carItemId = jsonData["carItemId"].stringValue
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
            self.carOrderStatus = jsonData["carOrderStatus"].stringValue
            self.bookedCarStatus = jsonData["bookedCarStatus"].stringValue
            self.driverName = jsonData["driverName"].stringValue
            self.driverPhone = jsonData["driverPhone"].stringValue
            self.driverNO = jsonData["driverNO"].stringValue
            self.totalAmount = jsonData["totalAmount"].doubleValue
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
        /// 当前审批人id
        let apverId:String
        /// 审批人姓名
        let apverName:String
        /// 审批结果(true 代表同意)
        let apvResult:Bool
        /// 审批人级别
        let apverLevel:Int
        init(jsonData: JSON) {
            self.datetime = jsonData["apvTime"].dateFormat(.unix)
            self.apverId = jsonData["apverUid"].stringValue
            self.apverName = jsonData["apverName"].stringValue
            self.apverLevel = jsonData["apverLevel"].intValue
            self.apvResult = jsonData["apvResult"].stringValue == "1"
            
        }
    }
}

// MARK: - 计算订单状态
extension CoOldOrderDetail:Validator {
    /// 获取订单流转状态
    ///
    /// - Returns: 当前状态在流转状态的位置 订单流转状态
    /// - Throws: 出现非符合条件的流转状态
    func getStates() throws -> (currentIndex:Int,states:[CoOrderState]) {
        let states = try self.getOrderStates()
        let currentStateIndex = states.index(of: self.state) ?? 0
        return (currentStateIndex,states)
    }
    /// 获取订单流转状态
    ///
    /// - Returns: 订单流转状态
    /// - Throws: 出现非符合条件的流转状态
    private func getOrderStates() throws -> [CoOrderState]{
        var states:[CoOrderState] = []
        switch self.state {
        case .cancel:
            let pre = historyInfos.last?.stateBefore
            guard let preState = pre else {
                throw validateMessage("当前状态为已取消，获取前一个状态失败")
            }
            //如果当前的前一个状态是审批中则说明 计划中 -> 已取消
            guard preState != .planing else {
                states = [.planing,.cancel]
                break
            }
            //如果存在审批中状态则说明 计划中 -> 审批中 -> 已通过 -> 待定妥 -> 已取消
            let hasApproving = historyInfos.contains{ $0.stateBefore == .approving }
            guard !hasApproving else{
                states = [.planing,.approving,.passed,.willComplete,.cancel]
                break
            }
            //其他情况说明是 计划中 -> 已通过 -> 待定妥 -> 已取消
            states = [.planing,.approving,.passed,.willComplete,.cancel]
        case .planing: //计划中
            //TODO 无需送审
            // 计划中 -> 审批中 -> 已通过 -> 待定妥 -> 已订妥
            states = [.planing,.approving,.passed,.willComplete,.ompleted]
        case .approving: //审批中
            // 计划中 -> 审批中 -> 已通过 -> 待定妥 -> 已订妥
            states = [.planing,.approving,.passed,.willComplete,.ompleted]
        case .passed: //已通过
            // 计划中 -> 审批中 -> 已通过 -> 待定妥 -> 已订妥
            states = [.planing,.approving,.passed,.willComplete,.ompleted]
        case .rejected: //已拒绝
            //计划中 -> 审批中 -> 已拒绝
            states = [.planing,.approving,.rejected]
        case .willComplete: //待定妥
            //如果存在审批中状态则说明 计划中 -> 审批中 -> 已通过 -> 待定妥 -> 已订妥
            let hasApproving = historyInfos.contains{ $0.stateBefore == .approving }
            guard !hasApproving else{
                states = [.planing,.approving,.passed,.willComplete,.ompleted]
                break
            }
            //其他情况说明是 计划中 -> 已通过 -> 待定妥 -> 已订妥
            states = [.planing,.approving,.passed,.willComplete,.ompleted]
        case .ompleted:
            //如果存在审批中状态则说明 计划中 -> 审批中 -> 已通过 -> 待定妥 -> 已订妥
            let hasApproving = historyInfos.contains{ $0.stateBefore == .approving }
            guard !hasApproving else{
                states = [.planing,.approving,.passed,.willComplete,.ompleted]
                break
            }
            //其他情况说明是 计划中 -> 已通过 -> 待定妥 -> 已订妥
            states = [.planing,.approving,.passed,.willComplete,.ompleted]
        case .offline: //转线下
            //如果存在审批中状态则说明 计划中 -> 审批中 -> 已通过 -> 待定妥 -> 转线下
            let hasApproving = historyInfos.contains{ $0.stateBefore == .approving }
            guard !hasApproving else{
                states = [.planing,.approving,.passed,.willComplete,.offline]
                break
            }
            //其他情况说明是 计划中 -> 已通过 -> 待定妥 -> 转线下
            states = [.planing,.approving,.passed,.willComplete,.offline]
        case .deleteing://删除申请中
            return [.planing,.deleteing]
        default:
            states = [.planing,self.state]
        }
        if UserService.sharedInstance.userDetail()?.companyUser?.companyCode?.lowercased() == "ftms" {
            let approvalIndex = states.index(of: .approving)
            guard let index = approvalIndex else {
                return states
            }
            states.remove(at: index)
        }
        return states
    }
}

/// 违背政策实体
struct ContraryTravelPolicy {
    /// 违背原因
    let contraryReason:String
    /// 违背差旅政策描述
    let contraryTravelPolicyDesc:String
}
/// 担保情况
///
/// - guarantee: 信用卡担保
/// - unGuarantee: 无需担保
/// - unknow: 未知状态
enum HotelGuaranteeState:String {
    case guarantee = "1"
    case unGuarantee = "0"
    case unknow = "unknow"
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
/// - buy:  	已入账
/// - ensureFail: 担保失败
/// - confirmOrder:  	确认单
/// - applyOrder:  	申请单
/// - modifyOrder:  	修改单
/// - cancelOrder:  	取消单
/// - rejectOrder:  	拒绝单
/// - test:  	测试
/// - passengerCancel: 客户取消
/// - roomConfirm: 房间确认
/// - deleteApply: 删除申请中
enum HotelBookState:String {
    case waitConfirm = "1"
    case payed = "2"
    case haveRoom = "3"
    case noRoom = "4"
    case comfirm = "5"
    case cancel = "6"
    case offLine = "7"
    case commitEnsure = "8"
    case commitNoConfirm = "9"
    case exception = "10"
    case commit = "11"
    case buy = "12"
    case ensureFail = "13"
    case confirmOrder = "CON"
    case applyOrder = "RES"
    case modifyOrder = "MOD"
    case cancelOrder = "CAN"
    case rejectOrder = "HAC"
    case test = "TET"
    case passengerCancel = "XXX"
    case roomConfirm = "RCM"
    case deleteApply = "RESCANING"
    case unknow = "unknow"
}
/// 机票出票状态
///
/// - success: 已出票
/// - wait: 未出票
enum FlightTicketState :String{
    case success = "1"
    case wait  = "0"
    case unknow = "unknow"
}
/// 新版出查单状态
///
/// - cancel: 已取消
/// - planing: 计划中
/// - approving: 审批中
/// - passed: 已通过
/// - rejected: 已拒绝
/// - willComplete: 待定妥
/// - ompleted: 已定妥
/// - offline: 转线下
/// - canceling: 申请取消
/// - applying: 申请中
/// - deleted: 已删除
/// - airComplete: 航空已订妥
/// - waitPay: 待支付
/// - changeing: 变更申请中
/// - closed: 已关闭
/// - deleting: 申请删除
/// - computing: 结算中
/// - computed: 已结算
/// - deleteing: 删除申请中
/// - closed2: 已关闭
/// - unknow: 未知的状态
enum CoOrderState:String {
    case cancel = "0"
    case planing  =  "1"
    case approving = "2"
    case passed = "3"
    case rejected = "4"
    case willComplete = "5"
    case ompleted = "6"
    case offline = "8"
    case canceling = "c"
    case applying = "e"
    case deleted = "n"
    case airComplete = "d"
    case waitPay = "i"
    case changeing = "g"
    case closed = "b"
    case computing = "w"
    case computed = "j"
    case deleteing = "s"
    case unknow = "unknow"
}
extension CoOrderState : CustomStringConvertible {
    var description: String {
        switch self {
        case .cancel :
            return "已取消"
        case .planing  :
            return "计划中"
        case .approving:
            return "审批中"
        case .passed :
            return "已通过"
        case .rejected :
            return "已拒绝"
        case .willComplete :
            return "待订妥"
        case .ompleted :
            return "已订妥"
        case .offline :
            return "转线下"
        case .canceling :
            return "申请取消"
        case .applying :
            return "申请中"
        case .deleted :
            return "已删除"
        case .airComplete :
            return "航空已订妥"
        case .waitPay :
            return "待支付"
        case .changeing :
            return "变更申请中"
        case .closed :
            return "已关闭"
        case .computing :
            return "结算中"
        case .computed :
            return "已结算"
        case .deleteing :
            return "删除申请中"
        case .unknow :
            return "未知的状态"
        }
    }
}

// MARK: - 每个状态对应颜色
extension CoOrderState {
    var color: UIColor {
        switch self {
        case .cancel,.deleted,.offline :
            return UIColor(r: 136, g: 136, b: 136)
        case .planing  :
            return UIColor(r: 70, g: 162, b: 255)
        case .approving,.applying:
            return UIColor(r: 152, g: 109, b: 178)
        case .passed,.ompleted :
            return UIColor(r: 49, g: 193, b: 124)
        case .rejected :
            return UIColor(r: 230, g: 67, b: 64)
        case .willComplete,.canceling :
            return UIColor(r: 255, g: 93, b: 7)
        default :
            return UIColor.darkGray
        }
    }
}
/// 保险状态
///
/// - apply: 申请中
/// - effected: 已生效
/// - revocationed: 已撤销
/// - buyFail: 购买失败
/// - retreatFail: 退保失败
/// - repeaturchase: 重复购买
/// - unknow: 未知状态
enum SuranceOrderState:String {
    case apply = "0"
    case effected = "1"
    case revocationed = "2"
    case buyFail = "3"
    case retreatFail  = "4"
    case repeaturchase  = "5"
    case unknow = "unknow"
}
/// 联系人信息
struct ContactUser {
    /// 姓名
    let name:String
    /// 邮箱
    let email:[String]
    /// 手机号
    let mobile:String
}
/// 送审类型
///
/// - approval: 正常送审
/// - noApproval: 无需送审
enum CoOrderSubmitType {
    case approval
    case noApproval
    case unknow
}

