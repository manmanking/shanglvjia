//
//  PassengerManager.swift
//  shop
//
//  Created by manman on 2017/10/13.
//  Copyright © 2017年 TBI. All rights reserved.
//



/*
     本类统一管理旅客信息
     本类为单例模式
 
 */

import UIKit

final class PassengerManager: NSObject {

    
    ///
    private var passengerArr:[Traveller] = Array()
    
    /// NewOBT旅客信息列表
    private var passengerSVArr:[QueryPassagerResponse] = Array()
    static let shareInStance = PassengerManager()
    private override init() {
        
    }
    
    
    /// 角色选择司机的时候 将自己添加到旅客信息中
    final public func passengerSelf() {
        passengerSVArr.removeAll()
        let userInfo = DBManager.shareInstance.userDetailDraw()
        let passengerResponse:QueryPassagerResponse = QueryPassagerResponse()
        passengerResponse.birthday = userInfo?.busLoginInfo.userBaseInfo.birthday ?? ""
        for element in (userInfo?.busLoginInfo.userBaseInfo.certInfos)! {
            let certInfo:LoginResponse.UserBaseCertInfo = LoginResponse.UserBaseCertInfo()
            certInfo.expiryDate = element.expiryDate
            certInfo.certType = element.certType
            certInfo.certNo = element.certNo
            certInfo.nameOnCert = element.nameOnCert
            certInfo.nation = element.nation
            passengerResponse.certInfos.append(certInfo)
        }
        passengerResponse.trainPolicyShow = userInfo?.busLoginInfo.userBaseInfo.trainPolicyShow ?? ""
        passengerResponse.airPolicyShow = userInfo?.busLoginInfo.userBaseInfo.airPolicyShow ?? ""
        passengerResponse.carPolicyShow = userInfo?.busLoginInfo.userBaseInfo.carPolicyShow ?? ""
        passengerResponse.hotelPolicyShow = userInfo?.busLoginInfo.userBaseInfo.hotelPolicyShow ?? ""
        passengerResponse.sex = userInfo?.busLoginInfo.userBaseInfo.sex ?? ""
        passengerResponse.mobiles = userInfo?.busLoginInfo.userBaseInfo.mobiles ?? Array()
        passengerResponse.passagerId = userInfo?.busLoginInfo.userBaseInfo.uid ?? ""
        passengerResponse.name = userInfo?.busLoginInfo.userBaseInfo.name ?? ""
        passengerResponse.emails = userInfo?.busLoginInfo.userBaseInfo.emails ??  Array()
        passengerResponse.approveId = userInfo?.busLoginInfo.userBaseInfo.aprvId ?? ""
        passengerResponse.policyId = userInfo?.busLoginInfo.userBaseInfo.policyId ?? ""
        passengerResponse.isSpecial = userInfo?.busLoginInfo.userBaseInfo.isSpecial ?? ""
        passengerResponse.costInfoName = userInfo?.busLoginInfo.userBaseInfo.costCenterName ?? ""
        passengerResponse.uid = userInfo?.busLoginInfo.userBaseInfo.uid ?? ""
        passengerSVArr.append(passengerResponse)

    }
    
    
    
    //获得旅客信息
    final public func passengerDraw() -> [Traveller] {
        
        return passengerArr
    }
    // 保存旅客信息
   final public func passengerStore(passengers:[Traveller]) {
        passengerArr = passengers
    }
    
    //增加旅客信息
   final public func passengerAdd(passenger:Traveller) {
        passengerArr.append(passenger)
    }
    
    //删除旅客信息
    // 返回 false 则删除不成功 包含 未包含此元素
    // 返回 true 删除成功
   final public func passengerDelete(passenger:Traveller) -> Bool {
        for (index,element) in passengerArr.enumerated() {
            if element.uid == passenger.uid
            {
                passengerArr.remove(at: index)
                return true
            }
        }
        return false
    }
    //删除旅客信息
   final public func passengerAdd(index:NSInteger) -> Bool {
        passengerArr.remove(at: index)
        return true
    }
    //删除所有旅客信息
   final public func passengerDeleteAll() -> Bool {
        passengerArr.removeAll()
        return true
    }
    
    //MARK:---------NEWOBT-------------------
    
    
    //获得旅客信息
    final public func passengerSVDraw() -> [QueryPassagerResponse] {
        
        return passengerSVArr
    }
    // 保存旅客信息
    final public func passengerSVStore(passengers:[QueryPassagerResponse]) {
        passengerSVArr = passengers
    }
    
    //增加旅客信息
    final public func passengerSVAdd(passenger:QueryPassagerResponse) {
        passengerSVArr.append(passenger)
    }
    
    //删除旅客信息
    // 返回 false 则删除不成功 包含 未包含此元素
    // 返回 true 删除成功
    final public func passengerSVDelete(passenger:QueryPassagerResponse) -> Bool {
        for (index,element) in passengerSVArr.enumerated() {
            if element.passagerId == passenger.passagerId
            {
                passengerSVArr.remove(at: index)
                return true
            }
        }
        return false
    }
    //删除旅客信息
    final public func passengerSVAdd(index:NSInteger) -> Bool {
        passengerSVArr.remove(at: index)
        return true
    }
    //删除所有旅客信息
    final public func passengerSVDeleteAll() -> Bool {
        passengerSVArr.removeAll()
        return true
    }
    
    
    // QueryPassagerResponse TravellerCommitInfoVO
     final public func passengerLocalconvertToTravellerNET() ->[CommitParamVOModel.TravellerCommitInfoVO]{
        var travellerArr:[CommitParamVOModel.TravellerCommitInfoVO] = Array()
        for element in passengerSVArr {
            
            let tmpTraveller:CommitParamVOModel.TravellerCommitInfoVO = CommitParamVOModel.TravellerCommitInfoVO()
            tmpTraveller.birthday = element.birthday
            tmpTraveller.certExpire = element.certInfos.first?.expiryDate ?? ""
            tmpTraveller.certNo = element.certInfos.first?.certNo ?? ""
            tmpTraveller.certType = element.certInfos.first?.certType ?? ""
            tmpTraveller.personName = element.name
            //tmpTraveller.insuranceCount = "1" //暂时 先购买
            if element.certInfos.first?.certType == "2"{
                for cerElement in element.certInfos {
                    if cerElement.certType == "2"{
                        tmpTraveller.personEnName = cerElement.nameOnCert
                        break
                    }
                }
            }
            tmpTraveller.gender = element.sex == "M" ? "1" : "2"
            tmpTraveller.mobile = element.mobiles.first ?? ""
            tmpTraveller.parId = element.passagerId
            tmpTraveller.personType = "1"
            tmpTraveller.uid = element.passagerId
            travellerArr.append(tmpTraveller)
            
        }
        return travellerArr
    }
    
    
    
    
}
