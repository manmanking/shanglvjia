//
//  PersonalSpecialHotelSearcCondition.swift
//  shanglvjia
//
//  Created by manman on 2018/8/3.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalSpecialHotelSearcCondition: NSObject {
    
    
    static let shareInstance = PersonalSpecialHotelSearcCondition()
    
    private override init() {
        super.init()
        
    }
    
    
    
    

    /// 入店
    var checkInDate:Date = Date()
    
    /// 离店
    var checkOutDate:Date = Date()
}
