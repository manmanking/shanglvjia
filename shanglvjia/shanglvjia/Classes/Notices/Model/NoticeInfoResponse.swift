//
//  NoticeInfoResponse.swift
//  shanglvjia
//
//  Created by manman on 2018/3/19.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON
import MJExtension
import HandyJSON

class NoticeInfoResponse: NSObject ,ALSwiftyJSONAble {
    
    var notices:[TbiNotice] = Array()
    
    override init() {
        
    }
    required init?(jsonData: JSON) {
        self.notices = jsonData["notices"].arrayValue.map{TbiNotice(jsonData:$0)!}
    }
    
    class TbiNotice: NSObject,ALSwiftyJSONAble {
        
        var gmtCreate:String = ""
        var gmtModified:String = ""
        var id:NSInteger = 0
        var noticeEndTime:String = ""
        var noticeName:String = ""
        var noticeOrder:NSInteger = 0
        var noticeStartTime:String = ""
        var noticeStatus:String = ""
        var noticeText:String = ""
        var userCreate:NSInteger = 0
        var userModified:NSInteger = 0
        
        required init?(jsonData: JSON) {
            self.gmtCreate = jsonData["gmtCreate"].stringValue
            self.gmtModified = jsonData["gmtModified"].stringValue
            self.id = jsonData["id"].intValue
            self.noticeEndTime = jsonData["noticeEndTime"].stringValue
            self.noticeName = jsonData["noticeName"].stringValue
            self.noticeOrder = jsonData["noticeOrder"].intValue
            self.noticeStartTime = jsonData["noticeStartTime"].stringValue
            self.noticeStatus = jsonData["noticeStatus"].stringValue
            self.noticeText = jsonData["noticeText"].stringValue
            self.userCreate = jsonData["userCreate"].intValue
            self.userModified = jsonData["costInfoName"].intValue
        }
        
        
    }
    
}
