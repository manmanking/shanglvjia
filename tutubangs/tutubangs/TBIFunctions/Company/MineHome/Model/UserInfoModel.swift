//
//  UserInfoModel.swift
//  shop
//
//  Created by manman on 2017/8/30.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class UserInfoModel: NSObject,NSCoding {

    /// 个人用户姓名
    var name:String?
    /// 个人用户Id
    var id:String?
    /// 个人用户登录账号
    var userName:String?
    /// 个人用户邮箱
    var email:String?
    /// 历史客户信息
    var customers:[Customer]?
    
    
    
    class Customer:NSObject {
        /// 姓名
        var name:String?
        /// 企业用户parId
        var cardNo:String?
        /// 证件类型 0-身份证 1-护照
        var cardType:String?
    }
    
    
    
    override init() {
        super.init()
    }
    
    
    
    func encode(with aCoder: NSCoder) {
        
        
        
        
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    
    
    
}
