//
//  SubmitOrderVO.swift
//  shanglvjia
//
//  Created by manman on 2018/5/2.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class SubmitOrderVO: NSObject {
    
    ///  //(integer, optional): 订单来源 ,
    var orderSource:NSInteger = 0
    
    /// 房间数量
    var roomNum:NSInteger = 0
    
    /// // (Array[], optional): 入住人详情 ,
    var submitDetailVOList:[SubmitDetailVO] = Array()
    
    /// // (, optional): 提交艺龙信息 ,
    var submitElongData:SubmitElongData = SubmitElongData()
    
    /// //, optional): 提交生单自有信息
    var submitOwnData:SubmitOwnData = SubmitOwnData()
    
    
    
    
    class SubmitDetailVO:NSObject {
        
        ///  (number, optional): 额外价格 ,
        var extraPrice:NSNumber = 0
        
        ///  (integer, optional),
        var id:NSInteger = 0

        ///  (string, optional): 餐食信息 ,
        var meal:String = ""
        
        ///  (integer, optional): 餐食数量 ,
        var mealCount:NSInteger = 0
        
        ///  (integer, optional): 间夜数 ,
        var nightNum:NSInteger = 0
        
        ///  (string, optional): 乘客名称 ,
        var passengerName:String = ""
        
        ///  (string, optional): 房客常客id ,
        var passengerParid:String = ""
        
        ///  (string, optional): 支付方式，1现付；2预付 ,
        var payType:String = ""
        
        ///  (number, optional): 平均价格 ,
        var perPrice:NSNumber = 0
        
        ///  (string, optional): 房型描述 ,
        var roomType:String = ""
        
        ///  (string, optional): 特殊要求
        var special:String = ""
        
        ///  (string, optional): 价格详情 ,
        var priceDetail:[HotelDetailResult.NightRate] = Array()
        
        ///  (string, optional): 备注
        var remark:String = ""
        
    }
    
    class SubmitElongData:NSObject  {
        
        ///  (, optional): 信用卡信息 ,
        var submitCreditCardData:SubmitCreditCardData = SubmitCreditCardData()
        
        ///  (number, optional): 总价
        var totalPrice:NSNumber = 0
    }
    
    class SubmitOwnData:NSObject {
        
        ///  (string, optional): 是否符合差标（0否，1是） ,
        var accordPolicy:String = ""
        
        ///  (integer, optional): 是否为担保酒店1担保酒店；2非担保酒店 ,
        var agreementHotel:NSInteger = 0
        
        ///  (string, optional): 备注 ,
        var contactDesc:String = ""
        
        ///  (string, optional): 联系邮箱 ,
        var contactEmail:String = ""
        
        ///  (string, optional): 联系人名称 ,
        var contactName:String = ""
        
        ///  (string, optional): 联系人常客id ,
        var contactParid:String = ""
        
        ///  (string, optional): 联系电话 ,
        var contactPhone:String = ""
        
        ///  (string, optional): 违背差标原因 ,
        var disPolicyReason:String = ""
        
        ///  (string, optional): 最早到店时间 ,
        var earliestArrivalTime:String = ""
        
        ///  (string, optional): 是否需要出差申请单（0：否，1：是） ,
        var hasTravelApply:String = ""
        
        ///  (string, optional): 酒店地址 ,
        var hotelAddress:String = ""
        
        ///  (string, optional): 酒店所属城市 ,
        var hotelCity:String  = ""
        
        ///  (string, optional): 酒店描述（宽带，设施等简述） ,
        var hotelDesc:String = ""
        
        ///  (integer, optional): 酒店在elong中的id ,
        var hotelElongId:String = ""
        
        ///  (string, optional): 酒店联系电话 ,
        var hotelFax:String = ""
        
        ///  (string, optional): 经纬度 ,
        var hotelLat:String = ""
        
        ///  (string, optional): 经纬度 ,
        var hotelLong:String = ""
        
        ///  (string, optional): 酒店名称 ,
        var hotelName:String = ""
        
        ///  (integer, optional): 自有酒店在系统中的id ,
        var hotelOwnId:String = ""
        
        var id:NSInteger = 0

        ///  (string, optional): 最晚到店时间 ,
        var latestArrivalTime:String = ""

        ///  (integer, optional): 入住人数 ,
        var numberOfCustorm:NSInteger = 0
        
        ///  (integer, optional): 订单来源1：pc;2:ios;3:android;4:weixin;5:手工 ,
        var orderSource:NSInteger = 0
        
        ///  (integer, optional): 产品id ,
        var ratePlanId:String = ""
        
        ///  (string, optional): 订单备注 ,
        var remark:String = ""
        
        ///  (string, optional): 房型类型Id ,
        var roomTypeId:String = ""
        
        ///  (string, optional): tc备注 ,
        var tcremark:String = ""
        
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
        
        ///  (string, optional): 出差出发时间 ,
        var travelTime:String = ""
        
        ///  (string, optional): 离店时间 ,
        var tripEnd:String = ""

        ///  (string, optional): 入住时间
        var tripStart:String = ""
    }
    
    
    class SubmitCreditCardData: NSObject {
        
        var cvv:String = ""
        
        ///  (integer, optional): 有效期-月 ,
        var expirationMonth:String = ""
        
        ///  (integer, optional): 有效期-年 ,
        var expirationYear:String = ""
        
        ///  (string, optional): 持卡人 ,
        var holderName:String = ""
        
        ///  (string, optional): 证件号码 ,
        var idNo:String = ""
        
        ///  (string, optional): 证件类型:身份证 IdentityCard;护照 Passport;其他 Other ,
        var idType:String = ""
        
        ///  (string, optional): 卡号
        var number:String = ""
    }
    
}
