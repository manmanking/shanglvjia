//
//  SubmitCarOrderVO.swift
//  shanglvjia
//
//  Created by manman on 2018/4/8.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class SubmitCarOrderVO: NSObject {

    /// 车型
    var carType:NSInteger = 0
    
    ///  联系人电子邮件 ,
    var contactEmail:String = ""
    
    ///  联系人姓名 ,
    var contactName:String = ""
    
    ///  联系人常客id ,
    var contactParid:String = ""
    
    /// 联系人电话 ,
    var contactPhone:String = ""
    
    /// 司机邮箱 ,
    var driverEmail:String = ""
    
    ///  司机名称 ,
    var driverName:String = ""
    
    ///  司机电话 ,
    var driverPhone:String = ""
    
    /// 到达地点 ,
    var endAddress:String = ""
    
    /// 到达城市 ,
    var endCity:String = ""
    
    /// 到达经纬度 ,
    var endLat:String = ""
    
    /// 到达经纬度 ,
    var endLong:String = ""
    
    ///  到达时间 ,
    var endTime:String = ""
    
    /// 报销人成本中心id ,
    var expenseCostid:String = ""
    
    /// 报销人成本中心名称 ,
    var expenseCostname:String = ""
    
    ///  报销人名字 ,
    var expenseName:String = ""
    
    /// 报销人常客id ,
    var expenseParid:String = ""
    
    /// 额外价格 ,
    var extraPrice:NSNumber = 0
    
    /// 是否需要出差申请单（0：否，1：是） ,
    var hasTravelApply:String = ""
    
    
    var orderNo:String = ""
    
    ///  (string, optional): 订单来源（1：PC，2：IOS，3：ANDROID，4：微信，5：手工导入） ,
    var orderSource:String = ""
    
    /// 订单类型：接机1，送机2，其他99 ,
    var orderType:NSInteger = 0
    
    ///  个人价格 ,
    var personPrice:NSNumber = 0
    
    /// 备注 ,
    var remark:String = ""
    
    ///  出发地点 ,
    var startAddress:String = ""
    
    /// 出发城市 ,
    var startCity:String = ""
    
    /// 出发地经纬度 ,
    var startLat:String = ""
    
    ///  出发地经纬度 ,
    var startLong:String = ""
    
    ///  出发时间 ,
    var startTime:String = ""
    
    /// 是否分配司机与价格，0：未分配，1：已分配 ,
    var status:NSInteger = 0
    
    /// 实际总价 ,
    var totalPrice:NSNumber = 0
    
    ///  乘客信息 ,
    var submitCarPassengerVOList:[SubmitCarPassengerVO] = Array()
    
    ///  (string, optional): 出差申请单ID ,
    var travelApplyId:String = ""
    
    ///  (string, optional): 出差地 ,
    var travelDest:String = ""
    
    ///  (string, optional): 出差目的 ,
    var travelPurpose:String = ""
    
    ///  (string, optional): 出差理由 ,
    var travelReason:String = ""
    
    ///  (string, optional): 出差返回时间 ,
    var travelRetTime:String = ""
    
    ///  (string, optional): 出差出发时间
    var travelTime:String = ""
    
    
    override init() {
        
    }
    
    
    class SubmitCarPassengerVO: NSObject {
        var certNo:String = ""
        var certType:String = ""
        var email:String = ""
        var name:String = ""
        var parId:String = ""
        var phone:String = ""
        
        override init() {
            
        }
    }
    final public func carFormConvertObtCarOrderVO(model:CoCarForm)->SubmitCarOrderVO{
//        let carOrderVO = SubmitCarOrderVO()
         self.contactEmail = model.carContact.email
         self.contactPhone = model.carContact.phone
         self.contactParid = model.accountId
         self.contactName = model.carContact.name
     
         self.carType = NSInteger(model.carVO.carTypeId )!
         self.endAddress = model.carVO.endAddress
         self.endCity = model.carVO.endCityName
         self.endLat = model.carVO.endLatitude
         self.endLong = model.carVO.endLongitude
         self.endTime = model.carVO.endTime
         self.expenseCostid = model.carVO.expenseCostcenterid
         self.expenseCostname = model.carVO.expenseCostcentername
         self.expenseName = model.carVO.expenseName
         self.expenseParid = model.carVO.expenseParid
         self.orderType = NSInteger(model.carVO.carType )!
         self.personPrice = 0
         self.remark = model.remark
         self.startAddress = model.carVO.startAddress
         self.startCity = model.carVO.startCityName
         self.startLat = model.carVO.startLatitude
         self.startLong = model.carVO.stratLongitude
         self.startTime = model.carVO.startTime
         self.status = 0
         self.totalPrice = 0
        for element in model.carPassengerList {
            let tmp:SubmitCarPassengerVO = SubmitCarPassengerVO()
            tmp.certNo = element.cardNo
            tmp.certType = element.cardType.description
            tmp.email = element.email
            tmp.name = element.name
            tmp.parId = element.parId
            tmp.phone = element.phone.value
             self.submitCarPassengerVOList.append(tmp)
        }
         self.travelApplyId = ""
        self.hasTravelApply = "1"
         self.travelDest = model.orderVO.travelDestination
         self.travelRetTime = model.orderVO.endDate
         self.travelTime = model.orderVO.startDate
         self.travelPurpose = model.orderVO.travelPurposen
         self.travelReason = model.orderVO.travelReason
//         self.orderVO.endDate = model.orderVO.endDate
//         self.orderVO.orderSource = 1//model.orderVO.
//         self.orderVO.startDate = model.orderVO.startDate


        
        
        return  self
    }
    
    
    
}
