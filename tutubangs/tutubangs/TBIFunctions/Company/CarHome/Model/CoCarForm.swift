//
//  CoCarForm.swift
//  shop
//
//  Created by TBI on 2018/1/23.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON
import Moya_SwiftyJSONMapper

struct CoCarForm: DictionaryAble {
    
    /// 专车单元
    var carVO:CarVO = CarVO()
    
    /// 联系人单元
    var carContact:CarContact = CarContact()
    
    /// 出差单单元
    var orderVO:OrderVO =  OrderVO()
    
    /// 乘客单元
    var carPassengerList:[CarPassenger] = []
    
    /// 公司Code
    var corpCode:String = ""
    
    var accountId:String = ""
    
    /// 备注
    var remark:String = ""
    
    
    struct CarVO: DictionaryAble {
        /// 用车类型：2.接机；3.送机；1.预约用车
        var carType:String   = ""
        
        /// 起始地点
        var startAddress:String = ""
        
        /// 起始地点纬度
        var startLatitude:String = ""
        
        /// 起始地点经度
        var stratLongitude:String = ""
        
        /// 起始时间
        var startTime:String = ""
        
        /// 到达地点
        var endAddress:String = ""
        
        /// 到达地点纬度
        var endLatitude:String = ""
        
        /// 到达地点经度
        var endLongitude:String = ""
        
        /// 预订到达时间
        var endTime:String = ""
        
        /// 车型id  1:5人座公务用车 2:七人座商务用车
        var carTypeId:String = ""
        
        /// 报销人名称
        var expenseName:String = ""
        
        /// 报销人成本中心id
        var expenseCostcenterid:String = ""
        
        /// 报销人成本中心名称
        var expenseCostcentername:String = ""
        
        /// 报销人parid
        var expenseParid:String = ""
        
        /// 出发城市
        var startCityName:String = ""
        
        /// 到达城市
        var endCityName:String = ""
        
        /// 备注
        var remark:String = ""
        
    }
    
    struct OrderVO: DictionaryAble {
     
        /// 出差单号
        var travelOrderNo:String = ""
        
        /// 出差开始时间
        var startDate:String = ""
        
        /// 出差结束时间
        var endDate:String = ""
        
        /// 出差地点
        var travelDestination:String = ""
        
        /// 出差目的
        var travelPurposen:String = ""
        
        /// 出差理由
        var travelReason:String = ""
        
        /// 备注
        var remark:String = ""
    }
    
    struct CarContact: DictionaryAble {

        /// 姓名
        var name:String = ""
        
        /// 电话
        var phone:String = ""
        
        /// 邮件地址
        var email:String = ""
    
        var parId:String = ""

    }
    
    struct CarPassenger: DictionaryAble {
    
        /// 电话
        var phone:Variable = Variable("")
        
        /// 邮件地址
        var email:String = ""
        
        /// 证件号
        var cardNo:String = ""
   
        /// 证件类型 1身份证 2护照 3其他
        var cardType:Int = 1
        
        /// 乘车人姓名
        var name:String = ""
        
        var parId:String = ""
    }
}
