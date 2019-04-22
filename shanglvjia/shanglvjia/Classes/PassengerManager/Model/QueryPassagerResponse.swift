//
//  QueryPassagerResponse.swift
//  shanglvjia
//
//  Created by manman on 2018/3/16.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON
import MJExtension
import HandyJSON

class QueryPassagerResponse: NSObject,ALSwiftyJSONAble {
   
    
    var airPolicyShow:String = ""
    var hotelPolicyShow:String = ""
    var trainPolicyShow:String = ""
    var carPolicyShow:String = ""
    
    // (string, optional): 常客审批规则id ,
    var approveId:String = ""
    // (string, optional): 常客审批规则名称 ,
    var approveName:String = ""
    /// (string, optional): 生日 ,
    var birthday:String = ""
    // (Array[UserBaseCertInfo], optional): 证件信息 ,
    var certInfos:[LoginResponse.UserBaseCertInfo] = Array()
    // (string, optional): 常客成本中心id ,
    var costInfoId:String = ""
    
    var employeeNo:String = ""
    
    
    ///  (string, optional): 常客成本中心名称 ,
    var costInfoName:String = ""
    /// (Array[string], optional): 邮箱地址 ,
    var emails:[String] = Array()
    
    /// (string, optional): 机票是否特殊差标（0：否，1：是） ,
    var isSpecial:String = ""
    
    ///  (Array[string], optional): 手机号码 ,
    var mobiles:[String] = Array()
    /// (string, optional): 常客名称 ,
    var name:String = ""
    /// (string, optional): 常客id ,
    var passagerId:String = ""
    /// (string, optional):
    var policyId:String = ""
    /// (string, optional): 差旅政策名称 ,
    var policyName:String = ""
    /// (string, optional): 性别（M,F）
    var sex:String = ""
    ///uid
    var uid:String = ""
    
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        self.approveId = jsonData["aprvId"].stringValue
        self.approveName = jsonData["approveName"].stringValue
        self.birthday = jsonData["birthday"].stringValue
        self.costInfoId = jsonData["costInfoId"].stringValue
        self.airPolicyShow = jsonData["airPolicyShow"].stringValue
        self.hotelPolicyShow = jsonData["hotelPolicyShow"].stringValue
        self.trainPolicyShow = jsonData["trainPolicyShow"].stringValue
        self.carPolicyShow = jsonData["carPolicyShow"].stringValue
        self.costInfoName = jsonData["costInfoName"].stringValue
        self.emails = jsonData["emails"].arrayValue.map{$0.stringValue}
        employeeNo = jsonData["employeeNo"].stringValue
        mobiles = jsonData["mobiles"].arrayValue.map{$0.stringValue}
        self.isSpecial = jsonData["isSpecial"].stringValue
        self.name = jsonData["name"].stringValue
        self.passagerId = jsonData["passagerId"].stringValue
        self.policyName = jsonData["policyName"].stringValue
        self.policyId = jsonData["policyId"].stringValue
        self.sex = jsonData["sex"].stringValue
        self.uid = jsonData["uid"].stringValue
        if self.uid.isEmpty == true {
            self.uid = self.passagerId
        }
        self.certInfos = jsonData["certInfos"].arrayValue.map{LoginResponse.UserBaseCertInfo(jsonData:$0)!}
    }
    
}

