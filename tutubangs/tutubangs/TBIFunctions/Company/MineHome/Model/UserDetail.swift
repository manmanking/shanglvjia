//
//  UserDetail.swift
//  shop
//
//  Created by akrio on 2017/4/21.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON
import SwiftDate

struct UserDetail {
    /// 个人用户姓名
    var name:String?
    /// 个人用户Id
    var id:String?
    /// 个人用户登录账号
    var userName:String?
    /// 个人用户邮箱
    var email:String?
    /// 企业用户
    var companyUser:CompanyUser?
    /// 历史客户信息
    var customers:[Customer]?
    
    struct Customer {
        /// 姓名
        var name:String?
        /// 企业用户parId
        var cardNo:String?
        /// 证件类型 0-身份证 1-护照
        var cardType:String?
    }
    /// 个人企业用户信息
    struct CompanyUser {
        /// 企业用户accountId
        var accountId:String?
        /// 企业用户parId
        var parId:String?
        /// 公司编码
        var companyCode:String?
        /// log图片链接
        var logoUrl:String?
        /// 是否为新版用户
        var newVersion:Bool?
        /// 是否第一次登录
        var firstLogin:Bool?
        /// 是否为秘书型用户
        var secretary:Bool?
        /// 企业用户手机号
        var mobile:String?
        /// 企业用户审批规则id
        var apvRuleId:String?
        // TODO 这是毛线
        var lowestPriceInterval:Int?
        /// 企业用户生日
        var birthday:DateInRegion?
        /// 企业用户工号
        var employeeNo:String?
        /// 企业用户成本中心id
        var costCenterId:String?
        ///  企业用户成本中心名称
        var costCenterName:String?
        /// 企业用户性别
        var gender:Gender?
        ///  企业用户差旅政策ID
        var travelPolicyId:String?
        /// 企业用户姓名
        var name:String?
        /// 邮箱
        var emails:[String] = []
        /// 证件信息
        var certificates:[Certificate] = []
        /// 权限
        var permissions:[Permission]
        /// 公司编码
        var corpCode:String
        /// 公司编码
        var loginName:String
        /// 默认起飞时间
        var coDefTakeOffTimeStr:String
        /// 大客户编码
        var coHotelOrgCode:String
        /// 性别
        ///
        /// - man: 男性
        /// - female: 女性
        enum Gender:String {
            case man = "M"
            case female = "F"
            func format(gender:String?) -> Gender? {
                guard let gender = gender else {
                    return nil
                }
                return Gender(rawValue: gender)
            }
        }
        /// 证件信息
        struct Certificate {
            /// 证件号
            var number:String?
            /// 证件类型名称
            var typeName:String?
            /// 证件类型
            var type:Int?
            /// 过期时间
            var expiryDate:DateInRegion?
        }
        /// 常旅客卡
        struct CompanyTravelCard  {
            /// 常旅卡名称
            var name:String?
            /// 常旅卡编号
            var number:String?
            /// 常旅卡类型
            var type:String?
            /// 常旅卡所属类别
            var category:String?
            /// 供应商
            var supplier:String?
        }
        /// 企业用户权限
        ///
        /// - flight: 机票
        /// - hotel: 酒店
        /// - approval: 审批
        /// - oaApproval: OA送审
        /// - insurance: 保险
        /// - insuranceAll: 默认保险全选
        /// - unknow: 未知权限
        enum Permission:String {
            case flight = "flight"
            case hotel = "hotel"
            case train = "train"
            case car = "car"
            case approval = "approval"
            case oaApproval = "oaApproval"
            case insurance = "insurance"
            case insuranceAll = "insuranceAll"
            case unknow = "unknow"
        }
    }
}
// MARK: - 格式化json -> 结构体
extension UserDetail:ALSwiftyJSONAble{
    init (jsonData jPersonUser:JSON){
        self.name = jPersonUser["name"].string
        self.id = jPersonUser["id"].string
        self.userName = jPersonUser["userName"].string
        self.email = jPersonUser["email"].string
        self.companyUser = CompanyUser(jsonData:jPersonUser["coUser"])
        self.customers = jPersonUser["customerList"].arrayValue.map{UserDetail.Customer(jsonData:$0)}
        
    }
}
// MARK: - 格式化json -> 结构体
extension UserDetail.Customer:ALSwiftyJSONAble{
    init (jsonData jPersonUser:JSON){
        self.name = jPersonUser["name"].string
        self.cardNo = jPersonUser["cardNo"].string
        self.cardType = jPersonUser["cardType"].string
    }
}
// MARK: - 格式化json -> 结构体
extension UserDetail.CompanyUser:ALSwiftyJSONAble{
    init? (jsonData jCompanyUser:JSON){
        guard jCompanyUser.exists() else {
            return nil
        }
        self.accountId = jCompanyUser["accountId"].string
        self.parId = jCompanyUser["uid"].string
        self.companyCode = jCompanyUser["companyCode"].string
        self.logoUrl = jCompanyUser["logoUrl"].string
        self.newVersion = jCompanyUser["newVersion"].bool
        self.firstLogin = jCompanyUser["firstLogin"].bool
        self.secretary = jCompanyUser["secretary"].bool
        // traveler对象里内容
        let jTraveler = jCompanyUser["traveller"]
        self.mobile = jTraveler["mobile"].string
        self.apvRuleId = jTraveler["apvRuleId"].string
        self.lowestPriceInterval = jTraveler["lowestPriceInterval"].int
        self.birthday = jTraveler["birthday"].dateFormat(.custom("YYYYMMDD"))
        self.employeeNo = jTraveler["employeeNo"].string
        self.costCenterId = jTraveler["costCenterId"].string
        self.costCenterName  = jTraveler["costCenterName"].string
        self.travelPolicyId  = jTraveler["travelPolicyId"].string
        self.emails = jTraveler["emails"].arrayValue.map{$0.stringValue}
        self.name = jTraveler["name"].string
        if let gender = jTraveler["gender"].string {
            self.gender = Gender(rawValue: gender)
        }else {
            self.gender = nil
        }
        self.certificates = jTraveler["certificates"].arrayValue.map{Certificate(jsonData:$0) }
        self.permissions = jCompanyUser["permissions"].arrayValue.map{ UserDetail.CompanyUser.Permission(rawValue: $0.stringValue) ?? .unknow }
        self.corpCode = jCompanyUser["corpCode"].stringValue
        self.loginName = jCompanyUser["loginName"].stringValue
        self.coDefTakeOffTimeStr = jCompanyUser["coDefTakeOffTimeStr"].stringValue
        self.coHotelOrgCode = jCompanyUser["coHotelOrgCode"].stringValue
        //        companyUser?.certificates = jCompanyUser["certificates"].array.flatMap{
        //             $0.flatMap{ CompanyUser.Certificate(number: $0["number"].string, typeName: $0["name"].string, type: $0["type"].int, expiryDate: nil)}
        //        } ?? []
        //        companyUser?.apvRuleId = jCompanyUser["apvRuleId"].string
        //        companyUser?.apvRuleId = jCompanyUser["apvRuleId"].string
        //        companyUser?.apvRuleId = jCompanyUser["apvRuleId"].string
    }
}
// MARK: - 格式化json -> 结构体
extension UserDetail.CompanyUser.Certificate:ALSwiftyJSONAble{
    init (jsonData jCompanyUserCertificate:JSON){
        self.number = jCompanyUserCertificate["number"].string
        self.typeName = jCompanyUserCertificate["name"].string
        self.type = jCompanyUserCertificate["type"].int
        self.expiryDate = jCompanyUserCertificate["expiryDate"].dateFormat(.unix)
    }
}
