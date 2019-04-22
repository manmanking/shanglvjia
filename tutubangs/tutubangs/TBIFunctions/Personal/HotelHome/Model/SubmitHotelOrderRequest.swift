//
//  SubmitHotelOrderRequest.swift
//  shanglvjia
//
//  Created by manman on 2018/7/30.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class SubmitHotelOrderRequest: NSObject {

    
    /// hotel基本信息 ,
    var hotelBaseInfo:HotelBaseInfo = HotelBaseInfo()
    
    ///  酒店报销单信息 ,
    var hotelExpenseVO:VisaOrderAddResquest.VisaOrderExpenseResquest? // = VisaOrderAddResquest.VisaOrderExpenseResquest()
    
    /// // (Array[], optional): hotel出行人信息 ,
    var hotelPassengerInfos:[HotelPassengerInfo] = Array()
    
    ///酒店订单类型，5定投酒店，6普通酒店
    var type:String = ""
    
    ///  1自有酒店，2艺龙酒店, 3定投酒店(必填
    var elongType:String = ""
    
    
    class HotelBaseInfo: NSObject {
        
        ///  1预付，2现付
        var payType:String = ""
        
        /// 联系email ,
        var contactEmail:String = ""
        
        /// 联系人 ,
        var contactName:String = ""
        
        /// 联系电话 ,
        var contactPhone:String = ""
        
        /// 最早到店时间 ,
        var earliestArrivalTime:String = ""
        
        
        ///  (string, optional): 最晚到店时间 ,
        var latestArrivalTime:String = ""
        
        /// 床型 ,
        var bedType:String = ""
        
        ///   1担保酒店，2非担保酒店 ,
        var guaranteeConfig:String = ""
        
        ///  担保描述 ,
        var guaranteeDesc:String = ""
        
        /// 酒店地址 ,
        var hotelAddress:String = ""
        
        /// 酒店城市elongid ,
        var hotelCityId:String = ""
        
        /// 酒店城市名称 ,
        var hotelCityName:String = ""
        
        /// 酒店描述 ,
        var hotelDesc:String = ""
        
        /// 酒店在elong中的id ,
        var hotelElongId:String = ""
        
        var roomElongId:String = ""
        
        /// 酒店在elong中的id ,
        var hotelRoomId:String = ""
        
        /// 酒店联系电话 ,
        var hotelFax:String = ""
        
        ///  经纬度 ,
        var hotelLat:String = ""
        
        ///  经纬度 ,
        var hotelLong:String = ""
        
        ///  酒店中文名 ,
        var hotelName:String = ""
        
        ///  酒店订单产品id ,
        var hotelProductId:String = ""
        
        ///  酒店产品名称 ,
        var hotelProductName:String = ""
        
        ///   含早情况 ,
        var mealCount:String = ""
        
        /// 订单来源：2ios，3android ,
        var orderSource:String = ""
        
        ///  房间单价 ,
        var perRate:String = ""
        var refundDesc:String = ""
        
        ///  备注 ,
        var remark:String = ""
        
        /// 房间数 ,
        var roomCount:String = ""
        
        ///  房型描述 ,
        var roomDesc:String = ""
        
        /// 房型名称 ,
        var roomType:String = ""
        
        var totalPrice:String = ""
        
        var regionType:String = ""
        
        ///  离店日期 ,
        var  tripEnd:String = ""
        
        /// 到店日期
        var tripStart:String = ""

    }
    
    

    
    class HotelPassengerInfo: NSObject {

        ///  生日 ,
        var gtpBirthday:String = ""

        ///  证件有效期 ,
        var gtpCertDate:String = ""

        ///  证件号 ,
        var gtpCertNo:String = ""

        /// 证件类型 ,证件类型(1: 身份证，2：护照) ,
        var gtpCertType:String = ""

        ///  中文名 ,
        var gtpChName:String = ""

        /// 英文姓 ,
        var gtpEnFirstname:String = ""

        ///  英文名 ,
        var gtpEnLastname:String = ""

        ///  手机号 ,
        var gtpPhone:String = ""

        /// 乘客类型0成人；1儿童
        var gtpType:String = ""
        
        ///  1男2女
        var gtpSex:String = ""
    }
//
    
    
    
}
