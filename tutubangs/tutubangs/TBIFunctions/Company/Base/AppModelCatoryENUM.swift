//
//  AppModelCatoryENUM.swift
//  shanglvjia
//
//  Created by manman on 2018/8/4.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

enum AppModelCatoryENUM:NSInteger  {
    
    case PersonalSpecialFlight = 33 // 个人 定投机票
    case PersonalOnsaleFlight = 32 // 个人特惠机票
    case PersonalFlight = 31 //个人普通机票
    
    case PersonalHotel = 11
    case PersonalSpecialHotel = 12
    
    case PersonalTravel = 21
    case PersonalSpecialTravel = 22
    
    case PersonalTrain = 41
    case PersonalSpecialTrain = 42
    
    case PersonalVisa = 51
    
    
    
    
    
    
    case CompanyHotel = 1
    case CompanyTravel = 2
    case CompanyFlight = 3
    case CompanyTrain = 4
    case Default //  没有提示信息
}



enum AppModelInternationalType:NSInteger {
    // 81 - 100
    case PersonalSpecialInternationalFlight = 93 // 个人 定投机票
    case PersonalSpecialMainlandFlight = 83 // 个人 定投机票
    case PersonalOnsaleInternationalFlight = 92 // 个人特惠机票
    case PersonalOnsaleMainlandFlight = 82 // 个人特惠机票
    case PersonalInternationalFlight = 91 //个人普通机票
    case PersonalMainlandFlight = 81 //个人普通机票
    
    
    // 101- 120
    case PersonalVisa = 101
    
    // 61 -80
    case PersonalInternationalHotel = 61
    case PersonalMainlandHotel = 71
    case PersonalSpecialInternationalHotel = 62
    case PersonalSpecialMainlandHotel = 72
    
    // 41 -60
    case PersonalInternationalTravel = 41
    case PersonalMainlandTravel = 51
    case PersonalSpecialInternationalTravel = 42
    case PersonalSpecialMainlandTravel = 52
    
    //21 - 40
    case PersonalInternationalTrain = 21
    case PersonalMainlandTrain = 31
    case PersonalSpecialInternationalTrain = 22
    case PersonalSpecialMainlandTrain = 32
    
    
    //1 - 20
    case CompanyInternationalHotel = 1
    case CompanyMainlandHotel = 11
    case CompanyInternationalTravel = 2
    case CompanyMainlandTravel = 12
    case CompanyInternationalFlight = 3
    case CompanyMainlandFlight = 13
    case CompanyInternationalTrain = 4
    case CompanyMainlandTrain = 14
    case Default = 0 //  没有提示信息
    
    
    
    func isInternational() -> Bool {
        switch self {
        case .PersonalInternationalFlight,.PersonalSpecialInternationalFlight,.PersonalOnsaleInternationalFlight,
             .PersonalInternationalHotel,.PersonalSpecialInternationalHotel,
             .PersonalInternationalTravel,.PersonalSpecialInternationalTravel,
             .PersonalInternationalTrain,.PersonalSpecialInternationalTrain,
             .CompanyInternationalHotel,.CompanyInternationalTravel,
             .CompanyInternationalFlight,.CompanyInternationalTrain,.PersonalVisa:
            return true
        default:
            return false
        }
    }
    
    
}
