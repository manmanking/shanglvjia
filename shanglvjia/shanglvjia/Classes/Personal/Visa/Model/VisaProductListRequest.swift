//
//  VisaProductListRequest.swift
//  shanglvjia
//
//  Created by manman on 2018/7/16.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class VisaProductListRequest: NSObject {
    
    /// 国家 ,
    var country:String = ""// (string, optional),
    var num:String = ""// (integer, optional),
    
    ///  (string, optional): 热门签证0：不是，1：是 ,
    var hotVisa:String = ""
    var size:String = "" //(integer, optional),
    /// 签证名称
    var visaName:String = ""// (string, optional)
    
    override init() {
        
    }

}
