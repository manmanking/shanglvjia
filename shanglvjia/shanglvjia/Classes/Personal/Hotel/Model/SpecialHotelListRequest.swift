//
//  SpecialHotelListRequest.swift
//  shanglvjia
//
//  Created by manman on 2018/7/30.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class SpecialHotelListRequest: NSObject {

    
    ///  1国内，2国际 ,
    var regionType:String = ""
    ///  城市code
    var cityCode = ""
    
    ///  公司代码 ,
    var corpCode:[String] = Array()
    
    var dateStr:String = ""
    
    var endCount:String = ""
    
    /// 页数 ,
    var pageNum:String = ""
    
    /// 大小 ,
    var pageSize:String = ""
    
    ///  星级 ,
    var starRate:String = ""
    
    var startCount:String = ""
    
    ///酒店名字
    var hotelName:String = ""
    
    
    ///  到店时间  时间戳
    var arriveDate:String = ""

    /// 离店时间 时间戳
    var depDate:String = ""
    
    
    
    
    
    
}
