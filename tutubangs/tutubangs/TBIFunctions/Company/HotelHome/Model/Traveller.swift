//
//  StaffModel.swift
//  shop
//
//  Created by manman on 2017/5/11.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON
import MJExtension



struct Traveller:ALSwiftyJSONAble{

    /// 旅客ID
    var uid:            String = ""
    /// 旅客姓名
    var name:           String = ""
    /// 旅客生日
    var birthday:       String = ""
    /// 联系电话
    var mobile:         String = ""
    /// 邮箱
    var emails:         [String] = Array()
    /// 性别
    var gender:         String = ""
    /// 员工编号
    var employeeNo:     String = ""
    /// 证件
    var certificates:   [Certificate] = Array()
    //常旅卡
    var travelCards:    [TravelCard] = Array()
    /// 最低的价格区间
    var lowestPriceInterval:String = ""
    /// 审批规则ID
    var apvRuleId:          String = ""
    /// 差旅政策ID
    var travelPolicyId:     String = ""
    /// 成本中心ID
    var costCenterId:       String = ""
    /// 成本中心名称
    var costCenterName:     String = ""
    
    
    
    //证件
    struct Certificate {
        
        /// 证件类型名称
        var name:      String = ""
        /// 证件编号
        var number:    String = ""
        /// 证件类型
        var type:      Int?
        /// 证件到期时间
        var expiryDate:String = ""

        init(){
            self.name = ""
            self.number = ""
            self.type = 1
            self.expiryDate = ""
        }
    }

    //常旅卡
    struct TravelCard {
        
        ///  常旅卡名称
        var name:           String = ""
        /// 常旅卡编号
        var number:         String = ""
        /// 证件类型
        var type:           Int?
        /// 常旅卡所属类别
        var category:       String = ""
        /// 供应商
        var supplierCode:   String = ""
        
    }
    
    
    
    
}

extension Traveller{
    
    
    
      init (jsonData result:JSON){
        self.uid =  result["uid"].stringValue
        self.name = result["name"].stringValue
        self.birthday = result["birthday"].stringValue
        self.mobile = result["mobile"].stringValue
        self.emails = result["emails"].arrayValue.map{String($0.stringValue)}
        self.gender = result["gender"].stringValue
        self.employeeNo = result["employeeNo"].stringValue
        
        self.lowestPriceInterval = result["lowestPriceInterval"].stringValue
        self.apvRuleId = result["apvRuleId"].stringValue
        self.travelPolicyId = result["travelPolicyId"].stringValue
        self.costCenterId = result["costCenterId"].stringValue
        self.costCenterName = result["costCenterName"].stringValue
        
        
        self.certificates = result["certificates"].arrayValue.map{Certificate(jsonData:$0)}
        self.travelCards = result["travelCards"].arrayValue.map{TravelCard(jsonData:$0)}
        
    }

    
}





extension Traveller.Certificate:ALSwiftyJSONAble
{
        
        init(jsonData result:JSON){
            self.name = result["name"].stringValue
            self.number = result["number"].stringValue
            self.type = result["type"].intValue
            self.expiryDate = result["expiryDate"].stringValue
        }
}

extension Traveller.TravelCard:ALSwiftyJSONAble
{
    
    init (jsonData result:JSON){
        
        self.name = result["name"].stringValue
        self.number = result["number"].stringValue
        self.type = result["type"].intValue
        self.category = result["category"].stringValue
        self.supplierCode = result["supplierCode"].stringValue
    }
    
}






