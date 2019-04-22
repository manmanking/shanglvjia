//
//  CoNewFlightForm.swift
//  shop
//
//  Created by akrio on 2017/5/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
/// 企业新版机票相关表单
struct CoFlightForm {
    /// 查询机票表单
    struct Search:DictionaryAble {
        /// 出发机场三字码
        var takeOffAirportCode:String = ""
        /// 到达机场三字码
        var arriveAirportCode:String = ""
        /// 出发时间
        var departureDate:String = ""
        /// 回程时间
        var returnDate:String = ""
        /// 上下几小时最低价区间
        var lowestPriceInterval:Int? = .none
        /// 查询类型
        var type:Int = 0
        /// 乘客uid
        var travellerUids:String = ""
        //  乘客差旅政策id
        var travelPolicyId:String = ""
        /// 查询类型
        ///
        /// - single: 单程
        /// - go: 去程
        /// - back: 回程
        enum SearchType:Int {
            case single = 0
            case go = 1
            case back = 2
        }
        init(takeOffAirportCode:String,arriveAirportCode:String,departureDate:String,returnDate:String,lowestPriceInterval:Int? = nil,type:SearchType = .single,travellerUids:[String]) {

            self.takeOffAirportCode = takeOffAirportCode
            self.arriveAirportCode = arriveAirportCode
            self.departureDate = ""
            self.returnDate = ""
            self.lowestPriceInterval = lowestPriceInterval
            self.type = type.hashValue
            self.travellerUids = travellerUids.toString()
        }
    }
}
/// 证件类型
///
/// - identityCard: 身份证
/// - passport: 护照
/// - other: 其他
enum CertType:Int {
    case identityCard = 1
    case passport = 2
    case other = 3
}
