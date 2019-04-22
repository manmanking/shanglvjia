//
//  TravellerForm.swift
//  shop
//
//  Created by TBI on 2017/7/5.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON
import Moya_SwiftyJSONMapper
import HandyJSON

struct  TravellerForm:HandyJSON, DictionaryAble ,ALSwiftyJSONAble{
   


    //guid
    var guid:Int?
    //用户id
    var userId:String?
    //中文名
    var nameChi =  Variable("")
    //英文名
    var nameEng =  Variable("")
    //性别 0 男 1 女
    var gender:Int?
    //电话
    var phone =  Variable("")
    //生日 例子：yyyy-mm-dd
    var birthday:String?
    //国籍
    var country =  Variable("")
    //旅人类型 0学生 1成人 2儿童 3婴儿
    var travelType:Int? = 1
    //城市id
    var cityId:String?
    //身份正
    var idCard =  Variable("")
    // 护照
    var passport =  Variable("")
    //排序
    var sort:Int?
    //备注
    var remarks:String?
    
    var relation:String?// (string, optional): 亲属关系(1：父亲，2：母亲，3：配偶父亲，4：配偶母亲，5,：配偶，6：孩子一，7：孩子二) ,
    var candelStatus:String?// (string, optional): 是否可修改删除（0：否，1：是）
    
    init() {
        
    }
    
    init?(jsonData: JSON) {
        
        let jsonStr = jsonData.description
        self = getNewInstance(jsonStr: jsonStr)!
    }
    
    
    func getNewInstance(jsonStr:String)->TravellerForm?
    {
        let myInstance = TravellerForm.deserialize(from: jsonStr)
        
        return myInstance
    }
    
    
}
