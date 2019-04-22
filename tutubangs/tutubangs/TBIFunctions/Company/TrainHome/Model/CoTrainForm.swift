//
//  CoTrainForm.swift
//  shop
//
//  Created by TBI on 2017/12/26.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON
import Moya_SwiftyJSONMapper

struct CoTrainForm: DictionaryAble {
    
    /// 出发地城市
    var fromStationName:String
    /// 到达城市
    var toStationName:String
    /// 出发地城市三字码
    var fromStation:String
    /// 到达城市三字码
    var toStation:String
    /// 出发日期
    var departDate:String
    /// 回程日期
    var returnDate:String?
    /// 是否只看高铁
    var isGt:Bool
    
    /// 单程0、去程1、回程2
    var type: Int
    
    ///  去程选中座位
    var fromSeat: SeatTrain?
    
    ///  回程选中座位
    var toSeat: SeatTrain?
    /// 出差城市
    var city:String
}

// 提交火车票
struct CoTrainCommitForm: DictionaryAble {
    /// 去程信息
    var goTrip:SubmitTrainInfo?
    
    /// 回程信息
    var backTrip:SubmitTrainInfo?
    
    /// 联系人信息
    var  contactInfo:ContactInfo =  ContactInfo()
    
    /// 账号id
    var accountId:String = ""
    
    /// 出差单号
    var travelNo:String = ""
    
    struct SubmitTrainInfo: DictionaryAble {
        
        
        ///  (string, optional): 是否符合差标（0：否，1：是） ,
        var accordPolicy:String = ""
        
        var disPolicyReason:String = ""
        
        ///  (string, optional): 车次 ,
        var trainCode:String = ""
        
        ///  (string, optional): 列车号 ,
        var trainNo:String = ""
        /// 旅行日期
        var trainDate:String = ""
        
        /// 出发站CODE
        var fromStation:String = ""
        
        
        /// 到达站CODE
        var toStation:String = ""
        
        ///  (string, optional): 列车从始发站出发的日期 ,
        var trainStartDate:String = ""
        
        ///  (string, optional): 始发站名称 ,
        var startStationName:String = ""
        
        ///  (string, optional): 终点站名称 ,
        var endStationName:String = ""
        
        /// 车次
        var checi:String = ""
        
        /// 乘客信息
        var passengers:[PassengerInfo] = []
        
        /// 出差开始时间
        var travelStartTime:String = ""
        
        /// 出差结束时间
        var travelEndTime:String = ""
        
        /// 出差目的
        var travelDestination:String = ""
        
        /// 出差目的
        var travelPurposen:String = ""
        
        ///  (string, optional):  列车类型 ,
        var trainType:String = ""
        
        /// 出差理由
        var travelReason:String = ""
        
        /// 订单备注
        var remark:String = ""
        
        /// 火车开始时间
        var startTime:String = ""
        
        /// 火车到达时间
        var arriveTime:String = ""
        
        /// 运行时间
        var runTime:String = ""
        
        /// 到达日
        var arriveDay:String = ""
        
        
        struct PassengerInfo: DictionaryAble {
            
            /// 乘客的顺序号，如：1
            var passengerId:String = ""
            
            /// 乘车人姓名
            var passengerName:String = ""
            
            /// 车票类型 如：1。其中，1 :成人票,2 :儿童票,4 :残军票
            var piaoType:String = ""
            
            /// 证件类型 如：1。其中，1身份证 2护照 3其他
            var passportTypeseId:String = ""
            
            /// 乘客证件号码
            var passportNo = Variable("")
            
            /// 票价，即当前乘客选择的座位的价格
            var price:String  = ""
            
            ///座位编码 如：1。表示座位编码，其中 9:商务座, P:特等座,  M:一等座,  O（大写字母O，不是数字0）:二等座,6:高级软卧,4:软卧,3:硬卧,2:软座,1:硬座。
            var zwcode:String = ""
            
            /// 电话号码
            var phone:String = ""
            
            var email:String = ""
            
            /// 出行人生日
            var birthday:String = ""
            
            /// 出行人性别
            var sex:String = ""
            
            /// PAR_ID
            var parId:String = ""
        }
        
    }
    
    struct ContactInfo: DictionaryAble {
        
        var contactUid:String = ""
        /// 联系人名称
        var contactName = Variable("")
        
        /// 联系人电话
        var contactPhone = Variable("")
        
        /// 联系人邮箱
        var contactEmail = Variable("")
    }
    
}


struct CoTrainResultItem: ALSwiftyJSONAble,DictionaryAble {
    
    var  backOuterOrderId:String
    
    var  goOuterOrderId:String
    
    
    init(jsonData:JSON){
        self.goOuterOrderId = jsonData["goOuterOrderId"].stringValue
        self.backOuterOrderId = jsonData["backOuterOrderId"].stringValue
    }
}

struct CoTrainStatusResultItem: ALSwiftyJSONAble {
    
    var  msg:String
    
    var  status:String
    
    var  travelOrderNo:String
    
    init(jsonData:JSON){
        self.msg = jsonData["msg"].stringValue
        self.status = jsonData["status"].stringValue
        self.travelOrderNo = jsonData["travelOrderNo"].stringValue
    }
}
