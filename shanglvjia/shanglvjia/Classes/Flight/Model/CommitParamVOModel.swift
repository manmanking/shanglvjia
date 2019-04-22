//
//  CommitParamVOModel.swift
//  shanglvjia
//
//  Created by manman on 2018/3/26.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON


class CommitParamVOModel: NSObject {
    
    ///需要生单的航程信息
    var flights:[CommitFlightVO] = Array()
    /// (string, optional): 是否需要出差申请单（0：否，1：是） ,
    var hasTravelApply:String = ""
    /// (string, optional): 保险缓存ID（调用chechInsurance获取，空表示不买保险） ,
    var insuranceCacheId:String = ""
    /// (string): 联系人邮箱 ,
    var linkmanEmail:String = ""
    /// (string): 联系人电话 ,
    var linkmanMobile:String = ""
    /// (string): 联系人姓名 ,
    var linkmanName:String = ""
    /// (string): 联系人常客ID ,
    var linkmanParId:String = ""
    /// (string, optional): 订单来源（1：PC，2：IOS，3：ANDROID，4：微信，5：手工导入） ,
    var orderSource:String = ""
    
    /// 订单类型（1:普通机票；2，特价机票；3定投机
    var orderType:String = ""
    /// (Array[TravellerCommitInfoVO]): 旅客 ,
    var passangers:[TravellerCommitInfoVO] = Array()
    /// (string, optional): 出差申请单ID ,
    var travelApplyId:String = ""
    /// (string, optional): 出差地 ,
    var travelDest:String = ""
    /// (string, optional): 出差目的 ,
    var travelPurpose:String = ""
    /// (string, optional): 出差理由 ,
    var travelReason:String = ""
    /// (string, optional): 出差返回时间 ,
    var travelRetTime:String = ""
     ///(string, optional): 出差出发时间
    var travelTime:String = ""
     /// 备注
    var comment : String = ""
    
    class CommitFlightVO: NSObject {
        /// (string, optional): 是否符合差旅政策（0：否，1：是） ,
        var accordPolicy:String = ""
        //// 违法政策描述
        var contraryPolicyDesc:String = ""
        /// (string): 查询返回的仓位cacheID ,
        var cabinCacheId:String = ""
        /// (string, optional): 违背原因 ,
        var disPolicyReason:String = ""
        /// (string): 查询返回的最外层cacheID ,
        var flightCacheId:String = ""
        /// (string, optional): 对应符合差标的仓位ID
        var rightCabinCacheId:String = ""
        ///  (string): 国际机票查询全仓位时返回的仓位cacheId ,
        var allCabinCacheId:String = ""
    }
    
    class TravellerCommitInfoVO: NSObject,ALSwiftyJSONAble  {
        /// (string, optional): 生日 ,
        var birthday:String = ""
        /// (string, optional): 护照有效期 ,
        var certExpire:String = ""
        
        /// 是否可用协议价（0：不可，1：可）；用户本人可用 ,
        var  canUseAccountCode:String = "0"
        /// (string, optional): 证件号 ,
        var certNo:String = ""
        /// (string, optional): 证件类型(1: 身份证，2：护照) ,
        var certType:String = ""
        /// (string, optional): 性别（1：男，2：女） ,
        var gender:String = ""
        /// (string, optional): 保险份数 0 表示不买 ,
        var insuranceCount:String = ""
        /// (string, optional): 手机号 ,
        var mobile:String = ""
        /// (string, optional): 常客ID ,
        var parId:String = ""
        /// (string, optional): 乘客姓名 ,
        var personEnName:String = ""
        
        var personName:String = ""
        /// (string, optional): 乘客类型（1：成人，2：儿童） ,
        var personType:String = ""
        /// (string, optional): 旅客ID
        var uid:String = ""
        override init() {
            
        }
        required init?(jsonData: JSON) {
            self.birthday = jsonData["birthday"].stringValue
            self.certExpire = jsonData["certExpire"].stringValue
            self.certNo = jsonData["certNo"].stringValue
            self.certType = jsonData["certType"].stringValue
            self.gender = jsonData["gender"].stringValue
            self.insuranceCount = jsonData["insuranceCount"].stringValue
            self.mobile = jsonData["mobile"].stringValue
            self.parId = jsonData["parId"].stringValue
            self.personName = jsonData["personName"].stringValue
            self.personType = jsonData["personType"].stringValue
            self.certType = jsonData["certType"].stringValue
            self.uid = jsonData["uid"].stringValue
            
        }
    }
    
}
