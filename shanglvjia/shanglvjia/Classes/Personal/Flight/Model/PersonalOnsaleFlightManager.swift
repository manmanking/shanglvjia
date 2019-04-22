//
//  PCommonFlightManager.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/8.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalOnsaleFlightManager: NSObject {

    private var  commitParamVOModel:CommitParamVOModel = CommitParamVOModel()
    
    //PCommonFlightSVSearchModel.CabinVO
    
    /// 选中的 仓位信息 列表
    private var selectedFlightCabinsArr:[PCommonFlightSVSearchModel.CabinVO] = Array()
    
    /// 机票的搜索 信息 列表
    private var searchConditionFlightArr:[FlightSVSearchConditionModel] = Array()
    
    /// 选中的 机票信息 列表
    private var selectedFlightInfos:[PCommonFlightSVSearchModel.AirfareVO] = Array()
    
    
    /// 推荐 机票信息
    private var recommendFlightTripInfs:[RecommendFlightResultVOModel] = Array()
    
    
    
    /// 由于 推荐航班需要显示 机票信息 仓位信息 所以 暂时将航班信息 保存
    /// 后期将这几个 列表 整合
    public var currentAirTrip:PCommonFlightSVSearchModel.AirfareVO =  PCommonFlightSVSearchModel.AirfareVO()
    
    
    static let shareInStance = PersonalOnsaleFlightManager()
    
    
    private override init() {
        
    }
    
    
//    override func load() {
//
//        printDebugLog(message: "into load here")
//    }
    
//    open override static func initialize() {
//
//        printDebugLog(message: "into initialize here")
//    }
//
    
    
    /// 全部重置信息
    func resetAllFlightInfo() {
        if commitParamVOModel.flights.count > 0 {
            commitParamVOModel.flights.removeAll()
        }
        if commitParamVOModel.passangers.count > 0 {
            commitParamVOModel.passangers.removeAll()
        }
        if searchConditionFlightArr.count > 0 {
            searchConditionFlightArr.removeAll()
        }
        if selectedFlightInfos.count > 0 {
            selectedFlightInfos.removeAll()
        }
        commitParamVOModel = CommitParamVOModel()
        if recommendFlightTripInfs.count > 0 {
            recommendFlightTripInfs.removeAll()
        }
        
    }
    
    /// 重置信息  除(搜索条件 )
    func resetPartFlightInfo() {
        if commitParamVOModel.flights.count > 0 {
            commitParamVOModel.flights.removeAll()
        }
        if commitParamVOModel.passangers.count > 0 {
            commitParamVOModel.passangers.removeAll()
        }
        if selectedFlightInfos.count > 0 {
            selectedFlightInfos.removeAll()
        }
        commitParamVOModel = CommitParamVOModel()
        if recommendFlightTripInfs.count > 0 {
            recommendFlightTripInfs.removeAll()
        }
    }
    
    
    
    
    //MARK:---------搜索条件------------
    
    /// 保存机票搜索条件
    func flightConditionStore(searchConditionArr:[FlightSVSearchConditionModel]) {
        guard searchConditionArr.count > 0 else { return }
        searchConditionFlightArr = searchConditionArr
        
    }
    
    /// 添加搜索机票条件
    func addSearchFlightCondition(searchCondition:FlightSVSearchConditionModel,tripSection:NSInteger) {
        
        guard searchCondition.arriveAirportName.isEmpty == false else {
            return
        }
        
        if searchConditionFlightArr.count <= tripSection { searchConditionFlightArr.append(searchCondition) }
        else {searchConditionFlightArr[tripSection] = searchCondition }
    }
    
    
    
    /// 搜索条件 提取
    func flightConditionDraw() -> [FlightSVSearchConditionModel] {
        return searchConditionFlightArr
    }
    
    //MARK:----------机票----------------
    /// 添加 机票 信息
    func addSelectedFlightTrip(searchCondition:PCommonFlightSVSearchModel.AirfareVO,tripSection:NSInteger) {
        
        guard searchCondition.flightInfos.first?.arriveAirportName.isEmpty == false else {
            return
        }
        
        if selectedFlightInfos.count < tripSection { selectedFlightInfos.append(searchCondition) }
        else {selectedFlightInfos[tripSection - 1] = searchCondition }
    }
    /// 删除最后一个
    func deleteSelectedFlightLastTrip() {
        if selectedFlightInfos.count > 0 {
            selectedFlightInfos.removeLast()
        }
    }
    
    func selectedFlightTripStore(flightTripArr:[PCommonFlightSVSearchModel.AirfareVO]) {
        guard flightTripArr.count > 0 else {
            return
        }
        selectedFlightInfos.removeAll()
        selectedFlightInfos = flightTripArr
        
    }
    
    
    
    
    /// 提取机票信息 提取
    func selectedFlightTripDraw() -> [PCommonFlightSVSearchModel.AirfareVO] {
        return selectedFlightInfos
    }
    
    ///机票信息 删除最后一个信息
    func selectedFlightTripDeleteLast() {
        selectedFlightInfos.removeLast()
    }
    
    
    
    
    //MARK:-------基本信息 ------------
    /// 添加旅客信息
    func addFlightTraveller(traveller:CommitParamVOModel.TravellerCommitInfoVO) {
        
        guard traveller.uid.isEmpty == false else {
            return
        }
        commitParamVOModel.passangers.append(traveller)
    }
    
    ///保险
    func insuranceCacheId(insuranceCacheId:String) {
        commitParamVOModel.insuranceCacheId = insuranceCacheId
    }
    
    /// 出差申请单
    func hasTravelApply(hasTravelApply:String) {
        commitParamVOModel.hasTravelApply = hasTravelApply
    }
    
    
    ///联系人邮箱
    func linkmanEmail(linkmanEmail:String) {
        commitParamVOModel.linkmanEmail = linkmanEmail
    }
    
    ///联系人邮箱
    func linkmanEmail()->String {
        return commitParamVOModel.linkmanEmail
    }
    /// 联系人姓名
    func linkmanName(linkmanName:String) {
        commitParamVOModel.linkmanName = linkmanName
    }
    /// 联系人姓名
    func linkmanName() ->String{
        return commitParamVOModel.linkmanName
    }
    
    
    /// 联系人电话
    func linkmanMobile(linkmanMobile:String) {
        commitParamVOModel.linkmanMobile = linkmanMobile
    }
    /// 联系人电话
    func linkmanMobile()->String {
        return commitParamVOModel.linkmanMobile
    }
    
    /// 联系人常客ID ,
    func linkmanParId(linkmanParId:String) {
        commitParamVOModel.linkmanParId = linkmanParId
    }
    
    /// 订单来源（1：PC，2：IOS，3：ANDROID，4：微信，5：手工导入） ,
    func orderSource(orderSource:String) {
        commitParamVOModel.orderSource = orderSource
    }
    
    ///  出差地 ,
    func travelDest(travelDest:String) {
        commitParamVOModel.travelDest = travelDest
    }
    
    
    ///: 出差目的 ,
    func travelPurpose(travelPurpose:String) {
        commitParamVOModel.travelPurpose = travelPurpose
    }
    
    /// 出差理由 ,
    func travelReason(travelReason:String) {
        commitParamVOModel.travelReason = travelReason
    }
    
    
    ///出差出发时间
    func travelTime(travelTime:String) {
        commitParamVOModel.travelTime = travelTime
    }
    
    ///出差返回时间 ,
    func travelRetTime(travelRetTime:String) {
        commitParamVOModel.travelRetTime = travelRetTime
    }
    
}
