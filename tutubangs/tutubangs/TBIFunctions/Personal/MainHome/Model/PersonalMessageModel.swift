//
//  PersonalMessageModel.swift
//  shanglvjia
//
//  Created by tbi on 05/09/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class PersonalMessageModel: NSObject,ALSwiftyJSONAble {

    ///  1 二次确认 2 去支付
    var count:String = ""
    var pushLists:[PushListVo] = Array()
    
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        count = jsonData["count"].stringValue
        pushLists = jsonData["pushLists"].arrayValue.map{PushListVo.init(jsonData: $0)!}
    }
    
    class PushListVo: NSObject,ALSwiftyJSONAble{
        
        var msgContent:String = ""
        var msgNext:String = ""
        var msgOrderId:String = ""
        var msgOrderNo:String = ""
        var msgOrderType:String = ""
        ///msgTarget (string, optional): 用户登录手机号 ,
        var msgTarget:String = ""
        var msgTitle:String = ""
        /// 消息类型, @PushEnum ,
        var msgType:String = ""
        var userId:String = ""
        var gmtCreate:String = ""
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
             msgContent = jsonData["msgContent"].stringValue
            msgNext = jsonData["msgNext"].stringValue
            msgOrderId = jsonData["msgOrderId"].stringValue
            msgOrderNo = jsonData["msgOrderNo"].stringValue
            msgOrderType = jsonData["msgOrderType"].stringValue
            msgTarget = jsonData["msgTarget"].stringValue
            msgTitle = jsonData["msgTitle"].stringValue
            msgType = jsonData["msgType"].stringValue
            userId = jsonData["userId"].stringValue
            gmtCreate = jsonData["gmtCreate"].stringValue
            
        }
        
        
    }
}
