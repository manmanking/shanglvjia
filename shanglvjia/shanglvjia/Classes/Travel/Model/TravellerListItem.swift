//
//  TravellerListItem.swift
//  shop
//
//  Created by TBI on 2017/7/5.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SwiftDate
import Moya_SwiftyJSONMapper
import SwiftyJSON

struct TravellerListItem: ALSwiftyJSONAble {
    
    //guid
    var guid:Int
    //用户id
    var userId:String
    //中文名
    var nameChi:String
    //英文名
    var nameEng:String
    //性别 0 男 1 女
    var gender:Int
    //电话
    var phone:String
    //生日 例子：yyyy-mm-dd
    var birthday:String
    //国籍
    var country:String
    //旅人类型 0学生 1成人 2儿童 3婴儿
    var travelType:Int
    //城市id
    var cityId:String
    //身份正
    var idCard:String
    // 护照
    var passport:String
    //排序
    var sort:Int
    //备注
    var remarks:String
    //选中标志
    var selectFlag:Bool =  false

    init(jsonData: JSON) {
        self.guid = jsonData["guid"].intValue
        self.userId = jsonData["userId"].stringValue
        self.nameChi = jsonData["nameChi"].stringValue
        self.nameEng = jsonData["nameEng"].stringValue
        self.gender = jsonData["gender"].intValue
        self.phone = jsonData["phone"].stringValue
        if jsonData["birthday"].doubleValue > 1000 {
            self.birthday = DateInRegion(absoluteDate: Date(timeIntervalSince1970: (jsonData["birthday"].doubleValue)/1000.0)).string(custom: "yyyy-MM-dd")
        }else {
            self.birthday = ""
        }
        self.country = jsonData["country"].stringValue
        self.travelType = jsonData["travelType"].intValue
        self.cityId = jsonData["cityId"].stringValue
        self.idCard = jsonData["idCard"].stringValue
        self.passport = jsonData["passport"].stringValue
        self.sort = jsonData["sort"].intValue
        self.remarks = jsonData["remarks"].stringValue
    }

}
