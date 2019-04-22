//
//  GuaranteeAmountRequest.swift
//  shanglvjia
//
//  Created by manman on 2018/5/4.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class GuaranteeAmountRequest: NSObject {

    /// // (string, optional): 担保规则 ,
    var guaranteeType:String = ""
    
    ///  (integer, optional): 间夜数 ,
    var nightCount:String = ""
    
    ///  (number, optional): 平均价格 ,
    var rate:String = ""
    
    ///  (integer, optional): 房间数
    var roomCount:String = ""

}
