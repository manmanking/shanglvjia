//
//  TravelDIYIntentOrder.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/7/6.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

struct TravelDIYIntentOrder:DictionaryAble
{
    var id:String? //用户ID
    var destination:String! //目的地，字符串，用逗号分隔 ,
    var travelType:Int = 2 //旅行方式 1-自由行，2-跟团游 ,
    var togetherCount:Int! //同行人数 1-一人，2-二到三人，3-三到五人，4-六人及以上 ,
    var travelDate:String! //出行日期 ,
    var travelDays:Int! //旅行天数 ,
    
    var departureCity:String! //出发城市 ,
    var budget:String! //人均预算 ,
    var specialNeeds:String! //特殊需求 ,
    var customerName:String! //客户姓名 ,
    var phoneNum:String! //联系电话 ,
    
    var email:String! //邮箱
    
    
    
    init()
    {
        
    }
    
    init(destination: String!, travelType: Int = 1, togetherCount: Int!, travelDate: String!, travelDays: Int!, departureCity: String!, budget: String!, specialNeeds: String!, customerName: String!, phoneNum: String!, email: String!)
    {
        self.destination = destination
        self.travelType = travelType
        self.togetherCount = togetherCount
        self.travelDate = travelDate
        self.travelDays = travelDays
        
        self.departureCity = departureCity
        self.budget = budget
        self.specialNeeds = specialNeeds
        self.customerName = customerName
        self.phoneNum = phoneNum
        
        self.email = email
    }
    
}




