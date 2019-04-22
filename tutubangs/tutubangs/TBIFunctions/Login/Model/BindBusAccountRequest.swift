//
//  BindBusAccountRequest.swift
//  shanglvjia
//
//  Created by manman on 2018/7/20.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class BindBusAccountRequest: NSObject {

    ///  (string, optional): 公司编码 ,
    var corpCode:String = ""
    
    ///  (string, optional): 登陆名称 ,
    var loginName:String = ""
    
    ///  (string, optional): 密码 ,
    var pwd:String = ""
    
    ///  (integer, optional): 用户id
    var userId:String = ""
    
    override init() {
        
    }
    
    
}
