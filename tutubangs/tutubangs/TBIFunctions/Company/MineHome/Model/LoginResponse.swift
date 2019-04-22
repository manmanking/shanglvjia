//
//  UserDetailSVModel.swift
//  shanglvjia
//
//  Created by manman on 2018/3/9.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON
import MJExtension
import HandyJSON


class LoginResponse: NSObject,ALSwiftyJSONAble,NSCoding,HandyJSON{

//
//    //  异常信息 ,
//    var errorMsg:String = ""
//
//    ///
//    var resourceList:[ResourceList]  = Array()
//
//    /// 登录状态（0：成功，-1：参数不全，-2：用户名或密码不正确） ,
//    var status:String = ""
//
//    /// 登录TOKEN ,
//    var token:String  = ""
//
//    /// 用户基本信息
//    var userBaseInfo:QueryUserBaseInfo = QueryUserBaseInfo()
//    ///  用户姓名
//    var userName:String = ""
    
    /// 个人登陆返回信息
    var cusLoginInfo:CusLoginInfo = CusLoginInfo()
    var busLoginInfo:BusLoginInfo = BusLoginInfo()
    
    override required init() {
        super.init()
    }
    
    required init?(jsonData: JSON) {
//        self.errorMsg = jsonData["errorMsg"].stringValue
//        self.resourceList = jsonData["resourceList"].arrayValue.map{ResourceList.init(jsonData: $0)!}
//        self.status = jsonData["status"].stringValue
//        self.token = jsonData["token"].stringValue
//        self.userName = jsonData["userName"].stringValue
//        self.userBaseInfo = QueryUserBaseInfo(jsonData:jsonData["userBaseInfo"])!
//        super.init()
//        JSONDeserializer<LoginResponse>.deserializeFrom(json: jsonData.)
//        self.mj_setKeyValues(jsonData)
        self.cusLoginInfo = CusLoginInfo(jsonData:jsonData["cusLoginInfo"])!//cusLoginInfo
        self.busLoginInfo = BusLoginInfo(jsonData:jsonData["busLoginInfo"])!//busLoginInfo
    }
    func encode(with aCoder: NSCoder) {
        self.mj_encode(aCoder)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.mj_decode(aDecoder)
    }
    
    
    @objc(_TtCC10shanglvjia13LoginResponse12ResourceList)class ResourceList :NSObject,ALSwiftyJSONAble,NSCoding {
        var resourceUrl:String = ""//:"front:menu:dingdan",
        var resourceName:String = ""//:"订单",
        var id:String = ""//:132,
        var resourceRegex:String = ""//:"front:menu:dingdan",
        var resourceType:String = "" //:"1"
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            self.resourceUrl = jsonData["resourceUrl"].stringValue
            self.resourceName = jsonData["resourceName"].stringValue
            self.id = jsonData["id"].stringValue
            self.resourceRegex = jsonData["resourceRegex"].stringValue
            self.resourceType = jsonData["resourceType"].stringValue
        }
        func encode(with aCoder: NSCoder) {
            self.mj_encode(aCoder)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init()
            self.mj_decode(aDecoder)
        }
    }
    
    
    
    @objc(_TtCC10shanglvjia13LoginResponse17QueryUserBaseInfo)class QueryUserBaseInfo: NSObject,ALSwiftyJSONAble,NSCoding{
        ///   地址
        var address:String = ""
        
        
        ///  机票差标显示 ,
        var airPolicyShow:String = ""
        
        var aprvId:String = ""
        
        /// 违反差标时是否可预订(0：不可预订，1：可预订) ,
        var canOrder:String = ""
        
        ///  (string, optional): 专车差标显示 ,
        var carPolicyShow:String = ""
        
        ///  (string, optional): 酒店差标显示 ,
        var hotelPolicyShow:String = ""
        
        ///  (string, optional): 火车差标显示 ,
        var trainPolicyShow:String = ""
        ///  生日
        var birthday:String  = ""
        /// 证件信息
        var certInfos:[UserBaseCertInfo] = Array()
        
        var corpBsaeInfo:CorpBsaeInfo = CorpBsaeInfo()
         /// 公司编码
        var corpCode:String  = ""
        /// 账号名字
        var loginName:String  = ""
        /// 公司logi
        var corpLogo:String  = ""
        /// 违反差标列表
        var disPolicy:[TravelPurposes] = Array()
        ///  邮箱地址
        var emails:[String]  = Array()
        /// 是否是秘书（0：否，1：是,3:公司级别秘书） ,
        var isSecretary:String = ""
        /// 机票是否特殊差标（0：否，1：是） ,
        var isSpecial:String  = ""
        
        ///  (string, optional): 成本中心id
        var costCenterId:String = ""
        ///costCenterName (string, optional): 成本中心名称 ,
        var costCenterName:String = ""
        
        
        /// 机票 是否能购买保险（0：不可以，1：可以） ,
        var needInsurance:String = ""
        
        /// 机票 默认是否购买机票 买保险是否勾选（0：否，1：是） ,
        var defultInsurance:String = ""
        
        var policyId:String = ""
        /// 手机号码
        var mobiles:[String] = Array()
        
        /// 是否OA对接 1是OA对接 0 未对接
        var oaCorp:String = ""
        
        ///   姓名
        var name:String  = ""
        /// 性别（M,F） ,
        var sex:String = ""
        /// 出差单配置
        var travelConfig:UserBaseTravelConfig  = UserBaseTravelConfig()
        ///  出差目的列表
        var travelPurposes:[TravelPurposes]  = Array()
        ///常客ID
        var uid:String = ""
        
        
        override init() {
            super.init()
        }

        required init?(jsonData: JSON) {
            self.address = jsonData["address"].stringValue
            self.aprvId = jsonData["aprvId"].stringValue
            self.birthday = jsonData["birthday"].stringValue
            self.canOrder = jsonData["canOrder"].stringValue
            self.airPolicyShow = jsonData["airPolicyShow"].stringValue
            self.carPolicyShow = jsonData["carPolicyShow"].stringValue
            self.hotelPolicyShow = jsonData["hotelPolicyShow"].stringValue
            self.trainPolicyShow = jsonData["trainPolicyShow"].stringValue
            self.costCenterName = jsonData["costCenterName"].stringValue
            self.costCenterId = jsonData["costCenterId"].stringValue
            self.certInfos = jsonData["certInfos"].arrayValue.map{UserBaseCertInfo(jsonData:$0)!}
            corpBsaeInfo = CorpBsaeInfo.init(jsonData:jsonData["corpBsaeInfo"])!
            self.corpCode = jsonData["corpCode"].stringValue
            self.loginName = jsonData["loginName"].stringValue
            self.corpLogo = jsonData["corpLogo"].stringValue
            self.needInsurance = jsonData["needInsurance"].stringValue
            self.defultInsurance = jsonData["defultInsurance"].stringValue
            self.disPolicy = jsonData["disPolicy"].arrayValue.map{TravelPurposes.init(jsonData: $0)!}
            self.emails = jsonData["emails"].arrayValue.map{$0.stringValue}
            self.isSecretary = jsonData["isSecretary"].stringValue
            self.isSpecial = jsonData["isSpecial"].stringValue
            self.policyId = jsonData["policyId"].stringValue
            self.mobiles = jsonData["mobiles"].arrayValue.map{$0.stringValue}
            oaCorp = jsonData["oaCorp"].stringValue
            self.name = jsonData["name"].stringValue
            self.sex = jsonData["sex"].stringValue
            self.travelConfig = UserBaseTravelConfig(jsonData:jsonData["travelConfig"])!
            self.travelPurposes = jsonData["travelPurposes"].arrayValue.map{TravelPurposes.init(jsonData: $0)!}
            self.travelConfig.travelPurposes = self.travelPurposes
            self.uid = jsonData["uid"].stringValue
        }
        func encode(with aCoder: NSCoder) {
            self.mj_encode(aCoder)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init()
            self.mj_decode(aDecoder)
        }

    }
    
    
    @objc(_TtCC10shanglvjia13LoginResponse12CorpBsaeInfo)class CorpBsaeInfo:NSObject ,ALSwiftyJSONAble,NSCoding {
        
        var airHotline:String = ""
        var aprvSMS:Bool = false
        var carHotline:String = ""
        var hotelHotline:String = ""
        var trainHotline:String = ""
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            self.airHotline = jsonData["airHotline"].stringValue
            self.aprvSMS = jsonData["aprvSMS"].boolValue
            self.carHotline = jsonData["carHotline"].stringValue
            self.hotelHotline = jsonData["hotelHotline"].stringValue
            self.trainHotline = jsonData["trainHotline"].stringValue
        }
        func encode(with aCoder: NSCoder) {
            self.mj_encode(aCoder)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init()
            self.mj_decode(aDecoder)
        }
    }
    
    @objc(_TtCC10shanglvjia13LoginResponse16UserBaseCertInfo)class UserBaseCertInfo:  NSObject,ALSwiftyJSONAble,NSCoding{
        ///    证件号
        var certNo:String = ""
        /// 证件类型（1：身份证，2：护照）
        var certType:String  = ""
        ///  证件过期时间
        var expiryDate:String = ""
        ///  发证国家
        var nation:String  = ""
        
        /// 证件上的名称 ,
        var nameOnCert:String = ""
        
        override init() {
             super.init()
        }


        required init?(jsonData: JSON) {
            self.certNo = jsonData["certNo"].stringValue
            self.certType = jsonData["certType"].stringValue
            self.expiryDate = jsonData["expiryDate"].stringValue
            self.nation = jsonData["nation"].stringValue
            self.nameOnCert = jsonData["nameOnCert"].stringValue
        }
        func encode(with aCoder: NSCoder) {
            self.mj_encode(aCoder)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init()
            self.mj_decode(aDecoder)
        }
    }
    @objc(_TtCC10shanglvjia13LoginResponse20UserBaseTravelConfig)class UserBaseTravelConfig:  NSObject,ALSwiftyJSONAble,NSCoding{
        ///   是否显示出差信息（0：否，1：是） ,
        var hasTravel:String = ""
        ///  是否显示出差目的地（0：否，1：是） ,
        var hasTravelDest:String  = ""
        /// 是否显示出差目的（0：否，1：是） ,
        var hasTravelPurpose:String = ""
        ///  是否显示出差理由（0：否，1：是） ,
        var hasTravelReason:String  = ""
        ///   是否显示出差返回时间（0：否，1：是） ,
        var hasTravelRetTime:String = ""
        /// 是否显示出差出发时间（0：否，1：是） ,
        var hasTravelTime:String  = ""
        ///   出差目的地是否必填（0：否，1：是）
        var travelDestRequire:String = ""
        ///   出差目的是否必填（0：否，1：是）
        var travelPurposeRequire:String  = ""
        ///   出差理由是否必填（0：否，1：是）
        var travelReasonRequire:String = ""
        /// 出差返回时间是否必填（0：否，1：是）
        var travelRetTimeRequire:String  = ""
        ///  出差出发时间是否必填（0：否，1：是）
        var travelTimeRequire:String = ""
        ///  出差目的列表
        var travelPurposes:[TravelPurposes]  = Array()
        override init() {
             super.init()
        }
        required init?(jsonData: JSON) {
            self.hasTravel = jsonData["hasTravel"].stringValue
            self.hasTravelDest = jsonData["hasTravelDest"].stringValue
            self.hasTravelPurpose = jsonData["hasTravelPurpose"].stringValue
            self.hasTravelReason = jsonData["hasTravelReason"].stringValue
            self.hasTravelRetTime = jsonData["hasTravelRetTime"].stringValue
            self.hasTravelTime = jsonData["hasTravelTime"].stringValue
            self.travelDestRequire = jsonData["travelDestRequire"].stringValue
            self.travelPurposeRequire = jsonData["travelPurposeRequire"].stringValue
            self.travelReasonRequire = jsonData["travelReasonRequire"].stringValue
            self.travelRetTimeRequire = jsonData["travelRetTimeRequire"].stringValue
            self.travelTimeRequire = jsonData["travelTimeRequire"].stringValue
            self.travelPurposes = jsonData["travelPurposes"].arrayValue.map{TravelPurposes.init(jsonData: $0)!}
            
        }
        func encode(with aCoder: NSCoder) {
            self.mj_encode(aCoder)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init()
            self.mj_decode(aDecoder)
        }
        
    }
    
    @objc(_TtCC10shanglvjia13LoginResponse14TravelPurposes)class TravelPurposes: NSObject,ALSwiftyJSONAble,NSCoding {
    
        var chDesc:String  = ""
        var engDesc:String = ""
        var errorCode:String  = ""
        var type:String = ""
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            self.chDesc = jsonData["chDesc"].stringValue
            self.engDesc = jsonData["engDesc"].stringValue
            self.errorCode = jsonData["errorCode"].stringValue
            self.type = jsonData["type"].stringValue
        }
        
        func encode(with aCoder: NSCoder) {
            self.mj_encode(aCoder)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init()
            self.mj_decode(aDecoder)
        }
    }
    
    ///个人登陆返回信息
    @objc(_TtCC10shanglvjia13LoginResponse12CusLoginInfo)class CusLoginInfo: NSObject,ALSwiftyJSONAble,NSCoding{
        var phoneNo:String = ""
        var token:String = ""
        var userId:String = ""
        var userName:String = ""
        var userStatus:String = ""
        
        
        override init() {
            super.init()
        }
        
        required init?(jsonData: JSON) {
            phoneNo = jsonData["phoneNo"].stringValue
            token = jsonData["token"].stringValue
            userId = jsonData["userId"].stringValue
            userName = jsonData["userName"].stringValue
            userStatus = jsonData["userStatus"].stringValue
        }
        
        func encode(with aCoder: NSCoder) {
            self.mj_encode(aCoder)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init()
             self.mj_decode(aDecoder)
        }        
    }
    @objc(_TtCC10shanglvjia13LoginResponse12BusLoginInfo)class BusLoginInfo: NSObject,ALSwiftyJSONAble,NSCoding {
        
        //  异常信息 ,
        var errorMsg:String = ""
        
        ///
        var resourceList:[ResourceList]  = Array()
        
        /// 登录状态（0：成功，-1：参数不全，-2：用户名或密码不正确） ,
        var status:String = ""
        
        /// 登录TOKEN ,
        var token:String  = ""
        
        /// 用户基本信息
        var userBaseInfo:QueryUserBaseInfo = QueryUserBaseInfo()
        ///  用户姓名
        var userName:String = ""
        
        override init() {
            super.init()
        }
        required init?(jsonData: JSON) {
            self.errorMsg = jsonData["errorMsg"].stringValue
            self.resourceList = jsonData["resourceList"].arrayValue.map{ResourceList.init(jsonData: $0)!}
            self.status = jsonData["status"].stringValue
            self.token = jsonData["token"].stringValue
            self.userName = jsonData["userName"].stringValue
            self.userBaseInfo = QueryUserBaseInfo(jsonData:jsonData["userBaseInfo"])!
        }
        
        func encode(with aCoder: NSCoder) {
            self.mj_encode(aCoder)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init()
             self.mj_decode(aDecoder)
        }
        
        
    }
}
