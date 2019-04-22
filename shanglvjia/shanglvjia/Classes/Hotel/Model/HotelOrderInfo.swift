//
//  HotelOrderInfo.swift
//  shop
//
//  Created by manman on 2017/5/13.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON

struct HotelOrderInfo:DictionaryAble {
    
    /// 选择产品信息
    var hotelProductParameters:     HotelProductParameters = HotelProductParameters()
    /// 房间信息
    var orderHotelRoomList:         [OrderHotelRoom]?
    /// 联系人信息
    var orderHotelContact:          OrderHotelContact = OrderHotelContact()
    /// 订单来源 'web', 'app', 'weixin
    var orderSource:                String = "app"
    /// 违背描述
    var violationDescription:       String = ""
    /// 用户IP
    var userIp:                     String = ""
    /// 入住人数量
    var customerNum:                NSInteger = 1
    //  信用卡
    var creditCard:                 CreditCard?
    /// 客人类型  企业用户  CUSTOMER_TYPE_COMPANY    个人用户  CUSTOMER_TYPE_PERSONAL 
    var customerType:               String = ""
    var orderNo:                    String = ""
    
    var orderHotelTravelInfo        :OrderHotelTravelInfo?
    
   
    struct HotelProductParameters: DictionaryAble {
        /// 国家
        var country:        String?
        /// 城市id
        var cityId:         String?
        /// 酒店id
        var hotelId:        String?
        /// 入住时间
        var arrivalDate:    String?
        /// 离店时间
        var departureDate:  String?
        /// 房型类型
        var roomTypeId:     String?
        /// 产品id
        var ratePlanId:     String?

        
    }
    

    struct OrderHotelRoom: DictionaryAble {
        /// 最早到店时间
        var earliestArrivalTime:        String?
        /// 最晚到店时间
        var latestArrivalTime:          String?
        /// 特殊要求床
        var noteToHotelBed:             String?
        /// 特殊要求其他
        var noteToHotels:               String?
        /// 房客信息
        var orderHotelRoomCustomersList:[OrderHotelRoomCustomer]?
        /// 房间是否符合差标
        var travel:                     Bool?
        
    }
    
    
    struct OrderHotelContact : DictionaryAble {
        /// 联系人姓名
        var contactName:    String?
        /// 联系人邮箱
        var contactEmail:   String?
        /// 联系人电话
        var contactPhone:   String?
        /// 备注
        var remark:         String?
        
    }
    
    ///担保信息不是担保不需要
    struct CreditCard: DictionaryAble {
        
        ///卡号
        var number:             String?
        /// 有效期年
        var expirationYear:     String?
        ///有效期月
        var expirationMonth:    String?
        ///持卡人
        var holderName:         String?
        /// 证件类型 ['IdentityCard', 'Passport', 'Other', 'OfficerCertificate', 'PoliceID', 'ReentryPermit']
        var idType:             String?
        ///证件号码
        var idNo:               String?
        var cvv:                String?
        
    }
    
    

    struct OrderHotelRoomCustomer : DictionaryAble {
        
        ///员工号
        var customerEmployeeNo:     String?
        ///成本中心名称
        var costCenterName:         String?
        ///成本中心code
        var costCenterCode:         String?
        ///姓名
        var name:                   String?
        ///电话
        var phone:                  String?
        ///邮箱
        var email:                  String?
        ///性别 = ['Female', 'Maile', 'Unknown'],
        var gender:                 String?
        ///国籍
        var nationality:            String?
        //OrderHotelRoomCustomers
        ///审批规则ID
        var apvRuleId:            String?
        ///差旅政策id
        var travelPolicyId:            String?
        
    }
    
    struct OrderHotelTravelInfo:DictionaryAble,ALSwiftyJSONAble{
        
        ///起始时间
        var departureDate:     NSInteger = 0
        ///结束时间
        var returnDate:        NSInteger = 0
        ///出差城市
        var destinations:      [String]  = Array()
        ///出差目的
        var purpose:           String = ""
        ///出差事由
        var reason:            String = ""
        ///自定义字段
        var opinions:          [CustomFieldPara] = Array()
        
        init (jsonData jItem: JSON) {
            self.departureDate = jItem["departureDate"].intValue
            self.returnDate = jItem["returnDate"].intValue
            self.destinations = jItem["destinations"].arrayValue.map{$0.stringValue}
            self.purpose = jItem["purpose"].stringValue
            self.reason = jItem["reason"].stringValue
            self.opinions = jItem["opinions"].arrayValue.map{CustomFieldPara(jsonData:$0)}
        }
        
        
        init() {
        
        }
        
        
        
        
    }
    
    struct  CustomFieldPara:DictionaryAble,ALSwiftyJSONAble{
        
        ///自定义字段id
        var id:                   String = ""
        ///自定义字段value
        var value:                String = ""
    
        init (jsonData jItem: JSON) {
            self.id = jItem["id"].stringValue
            self.value = jItem["value"].stringValue
        }
        
        init() {
            
        }
        
    }
    
    struct CompanyCustomConfig:DictionaryAble,ALSwiftyJSONAble{
        // 出差时间是否必填项
        var travelDateFlag      :Bool?
        // 出差地点是否必填项
        var travelDestFlag      :Bool?
        // 出差目的是否必填项
        var travelTargetFlag    :Bool?
        // 出差事由是否必填项
        var travelPurposeFlag   :Bool?
        // 出差目的
        var travelTargets       :[String]?
        //自定义字段
        var customFields   :[OrderCustomField]?
        
        
        init?(jsonData jItem:JSON) {
            self.travelDateFlag = jItem["travelDateFlag"].boolValue
            self.travelDestFlag = jItem["travelDestFlag"].boolValue
            self.travelTargetFlag = jItem["travelTargetFlag"].boolValue
            self.travelPurposeFlag = jItem["travelPurposeFlag"].boolValue
            self.travelTargets = jItem["travelTargets"].arrayValue.map{$0.stringValue}
            self.customFields = jItem["customFields"].arrayValue.map{OrderCustomField(jsonData:$0)!}
        }
        
        init() {
            
        }
        
        
    }
    
    
    /*
     // 自定义字段
     orderCustomFields: [
     // OrderCustomField.class
     {
     id: "2c909e494dddb973014df68f519908fd",
     resultId: "",
     name: "",
     defaultValue: [""],
     selectValue: [""]
     type: 1,
     require: true
     }
     ]
     */
    
    struct OrderCustomField:DictionaryAble,ALSwiftyJSONAble{
    
        var id:String =  ""
        var resultId:String = ""
        var name:String = ""
        var defaultValue:[String]?
        var selectValue:[String]?
        var type:NSInteger?
        var require:Bool?
    
        init?(jsonData jItem:JSON) {
            self.id = jItem["travelDateFlag"].stringValue
            self.resultId = jItem["resultId"].stringValue
            self.name = jItem["name"].stringValue
            self.defaultValue = jItem["defaultValue"].arrayValue.map{$0.stringValue}
            self.selectValue = jItem["selectValue"].arrayValue.map{$0.stringValue}
            self.type = jItem["type"].intValue
            self.require = jItem["require"].boolValue
        }
    
    
    
    
    }
    
    
    
    


}


