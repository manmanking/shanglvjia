//
//  SubmitTrainParams.swift
//  shanglvjia
//
//  Created by manman on 2018/4/11.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class SubmitTrainParams: NSObject {
    
    
    ///  (SubmitTrainInfo, optional): 回程信息 ,
    var backTrip:SubmitTrainInfo?
    
    ///  (ContactInfo, optional): 联系人信息 ,
    var contactInfo:ContactInfo = ContactInfo()
    
    ///  (SubmitTrainInfo, optional): 去程信息 ,
    var goTrip:SubmitTrainInfo?
    
    ///  (string, optional): 是否需要出差申请单（0：否，1：是） ,
    var hasTravelApply:String = ""
    
    ///  (string, optional): 订单来源（1：PC，2：IOS，3：ANDROID，4：微信，5：手工导入） ,
    var orderSource:String = ""
    
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
    
    
    
    class SubmitTrainInfo: NSObject {
        
        /// 是否符合差标（0：否，1：是） ,
        var accordPolicy:String = ""
        
        var disPolicyReason:String = ""
        
        ///  (string, optional): 到达日 ,
        var arriveDay:String = ""
        
        ///  (string, optional): 火车到达时间 ,
        var arriveTime:String = ""
        
        ///  (string, optional): 终点站名称 ,
        var endStationName:String = ""
        
        ///  (string, optional): 出发站CODE ,
        var fromStation:String = ""
        
        ///  (Array[PassengerInfo], optional): 乘客信息 ,
        var passengers:[PassengerInfo] = Array()
        
        ///  (string, optional): 运行时间 ,
        var runTime:String = ""
        
        ///  (string, optional): 选座信息：一个乘客，想要编号为A的座位 siteSelect=1A，两个乘客，想要邻近的AB两个座位siteSelect=1A1B五个乘客，想占用两排siteSelect=1B1D1E1F2A，可参考 https://code.juhe.cn/docs/201 43条 ,
        
        var siteSelect:String = ""
        
        ///  (string, optional): 始发站名称 ,
        var startStationName:String = ""
        
        ///  (string, optional): 火车开始时间 ,
        var startTime:String = ""
        
        ///  (string, optional): 到达站CODE ,
        var toStation:String = ""
        
        ///  (string, optional): 车次 ,
        var trainCode:String = ""
        
        ///  (string, optional): 乘车日期，如：2015-07-01 ,
        var trainDate:String = ""
        
        ///  (string, optional): 列车号 ,
        var trainNo:String = ""
        
        ///  (string, optional): 列车从始发站出发的日期 ,
        var trainStartDate:String = ""
        
        ///  (string, optional): 列车类型
        var trainType:String = ""
        
        /// 订单备注
        var remark:String = ""
        
        override init() {
            
        }
        
    }
   
        class ContactInfo: NSObject {
            
            ///  (string, optional): 联系人邮箱，如：2015-07-01 ,
            var  contactEmail:String = ""
            
            ///  (string, optional): 联系人名称，如：2015-07-01 ,
            var contactName:String = ""
            
            ///  (string, optional): 联系人电话，如：2015-07-01
            var contactPhone:String = ""
        }
        
        class PassengerInfo: NSObject {
            
            ///  (string, optional): 出行人生日 ,
            var birthday:String = ""
            
            ///  (string, optional): PAR_ID ,
            var parId:String = ""
            
            ///  (string, optional): 乘客的顺序号，如：1 ,
            var passengerId:String = ""
            
            ///  (string, optional): 乘车人姓名 ,
            var passengerName:String = ""
            
            ///  (string, optional): 乘客证件号码 ,
            var passportNo:String = ""
            
            ///  (string, optional): 证件类型 如：1。其中，1:二代身份证,2:护照 ,
            var passportTypeseId:String = ""
            
            ///  (string, optional): 电话号码 ,
            var phone:String = ""
            
            ///  (string, optional): 车票类型 如：1。其中，1 :成人票,2 :儿童票,4 :残军票 ,
            var piaoType:String = ""
            
            ///  (string, optional): 票价，即当前乘客选择的座位的价格 ,
            var price:String = ""
            
            ///  (string, optional): 出行人性别 ,
            var sex:String = ""
            
            ///  (string, optional): 座位编码 如：1。表示座位编码，其中 9:商务座, P:特等座, M:一等座, O（大写字母O，不是数字0）:二等座,6:高级软卧,4:软卧,3:硬卧,2:软座,1:硬座
            
            var zwcode:String = ""
            
            
            override init() {
                
            }
            
            func CoTrainCommitFormPassengerInfoConvertPassengerInfo(passenger:CoTrainCommitForm.SubmitTrainInfo.PassengerInfo) -> PassengerInfo {
                self.birthday = passenger.birthday
                self.parId = passenger.parId
                self.passengerId = passenger.passengerId
                self.passengerName = passenger.passengerName
                self.passportNo = passenger.passportNo.value
                self.passportTypeseId = passenger.passportTypeseId
                self.phone = passenger.phone
                self.piaoType = passenger.piaoType
                self.price = passenger.price
                self.sex = passenger.sex
                self.zwcode = passenger.zwcode
                return self
            }
            
            
            
    }
    
    
    func CoTrainCommitFormConvertSubmitTrainParams(model:CoTrainCommitForm) -> SubmitTrainParams {
        //let trainParams:SubmitTrainParams = SubmitTrainParams()
        if model.goTrip != nil {
             let goTrip:SubmitTrainInfo = SubmitTrainInfo()
             goTrip.arriveDay = model.goTrip?.arriveDay ?? ""
             goTrip.arriveTime = model.goTrip?.arriveTime ?? ""
             goTrip.trainType = model.goTrip?.trainType ?? ""
             goTrip.trainStartDate = model.goTrip?.trainStartDate ?? ""
             goTrip.toStation = model.goTrip?.toStation ?? ""
             goTrip.fromStation = model.goTrip?.fromStation ?? ""
             goTrip.startStationName = model.goTrip?.startStationName ?? ""
             goTrip.endStationName = model.goTrip?.endStationName ?? ""
             goTrip.accordPolicy = model.goTrip?.accordPolicy ?? ""
             goTrip.disPolicyReason = model.goTrip?.disPolicyReason ?? ""
             goTrip.remark = model.goTrip?.remark ?? ""
             for element in (model.goTrip?.passengers)! {
                let passenger: PassengerInfo = PassengerInfo().CoTrainCommitFormPassengerInfoConvertPassengerInfo(passenger: element)
                 goTrip.passengers.append(passenger)
             }
             goTrip.runTime = model.goTrip?.runTime ?? ""
             goTrip.startTime = model.goTrip?.startTime ?? ""
    
             goTrip.trainCode = model.goTrip?.checi ?? ""
             goTrip.trainDate = model.goTrip?.trainDate ?? ""
             goTrip.trainNo =  model.goTrip?.trainNo ?? ""
             goTrip.trainCode = model.goTrip?.trainCode ?? ""
            self.goTrip = goTrip
        }
        if model.backTrip != nil {
            let backTrip:SubmitTrainInfo = SubmitTrainInfo()
             backTrip.arriveDay = model.backTrip?.arriveDay ?? ""
             backTrip.arriveTime = model.backTrip?.arriveTime ?? ""
             backTrip.accordPolicy = model.backTrip?.accordPolicy ?? ""
             backTrip.disPolicyReason = model.backTrip?.disPolicyReason ?? ""
             backTrip.trainStartDate = model.backTrip?.trainStartDate ?? ""
             backTrip.trainType = model.backTrip?.trainType ?? ""
             backTrip.fromStation = model.backTrip?.fromStation ?? ""
             backTrip.startStationName = model.backTrip?.startStationName ?? ""
             backTrip.endStationName = model.backTrip?.endStationName ?? ""
             backTrip.toStation = model.backTrip?.toStation ?? ""
             backTrip.remark = model.backTrip?.remark ?? ""
            for element in (model.backTrip?.passengers)! {
                let passenger: PassengerInfo = PassengerInfo().CoTrainCommitFormPassengerInfoConvertPassengerInfo(passenger: element)
                 backTrip.passengers.append(passenger)
            }
            
             backTrip.runTime = model.backTrip?.runTime ?? ""
             backTrip.startTime = model.backTrip?.startTime ?? ""
             backTrip.trainCode = model.backTrip?.checi ?? ""
             backTrip.trainDate = model.backTrip?.trainDate ?? ""
             backTrip.trainNo =  model.backTrip?.trainNo ?? ""
            self.backTrip = backTrip
        }
        // hasTravelApply = model.
        self.orderSource = "2"
        //出差单信息
        self.hasTravelApply = "1"
        self.travelTime = model.goTrip?.travelStartTime ?? ""
        self.travelRetTime = model.goTrip?.travelEndTime ?? ""
        self.travelDest = model.goTrip?.travelDestination ?? ""
        self.travelPurpose = model.goTrip?.travelPurposen ?? ""
        self.travelReason = model.goTrip?.travelReason ?? ""
        self.contactInfo.contactEmail = model.contactInfo.contactEmail.value
        self.contactInfo.contactName = model.contactInfo.contactName.value
        self.contactInfo.contactPhone = model.contactInfo.contactPhone.value
        
        return self
    }

   
    
    
    

}
