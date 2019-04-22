//
//  HotelRoomDetailRequest.swift
//  shanglvjia
//
//  Created by manman on 2018/5/2.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class HotelRoomDetailRequest: NSObject {

    ///  (string, optional): 入住时间 ,
    var arrivalDate:String = ""
    
    ///  (string, optional): 公司编码 ,
    var corpCode:String = ""
    
    ///  (string, optional): 离店时间 ,
    var departureDate:String = ""
    
    ///  (Array[string], optional): 分公司 ,
    var groupCodes:[String] = Array()
    
    ///  (string, optional): 酒店艺龙id ,
    var hotelElongId:String = ""
    
    ///  (string, optional): 自有酒店id ,
    var ownHotelId:String = ""
    
    /// (Array[string], optional): 入住人id
    var parIds:[String]  = Array()
    
    
    override init() {
        
    }
    
    
    

    
}
