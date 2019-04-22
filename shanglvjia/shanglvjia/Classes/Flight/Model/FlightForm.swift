//
//  FlightForm.swift
//  shop
//
//  Created by akrio on 2017/4/24.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import SwiftDate
import RxSwift

struct FlightSearchForm:DictionaryAble {
    /// 出发地城市三字码
    let departCityCode:String
    /// 到达城市三字码
    let arriveCityCode:String
    /// 出发日期
    let departDate:String
}

struct FlightCommitForm:DictionaryAble {
    /// 乘机人信息
    var passengers:[Passenger]
    /// 发票相关信息
    var orderInvoice:Invoice?
    /// 联系人相关信息
    var orderContact:Contact
    /// 订单总价
    var orderTotalAmount:Int
    /// 查询条件
    let searchVo:Search
    /// 乘客相关信息
    struct Passenger:DictionaryAble{
        /// 乘机人姓名
        var name = ""
        /// 乘机人证件类型
        var cardType = "0"
        /// 证件号
        var cardNo = ""
        /// 手机号
        var phone = ""
        /// 去程常旅客卡号
        var depCards = [Variable("")]
        /// 回程常旅客卡号
        var rtnCards = [Variable("")]
    }
    /// 发票相关信息
    struct Invoice:DictionaryAble{
        /// 发票抬头
        var invoiceTitle = Variable("")
        /// 发票类型 1全额发票 2机票行程单+差额发票
        var invoiceType = Variable("")
        /// 邮寄发票的省份代码
        var provinceCode = Variable("")
        /// 邮寄发票的城市代码
        var cityCode = Variable("")
        /// 邮寄发票的街道代码
        var countyCode = Variable("")
        /// 邮寄发票的详细地址
        var address = Variable("")
        /// 邮寄发票的邮编
        var postcode = Variable("")
        /// 邮寄发票的收件人电话
        var tel  = Variable("")
        /// 邮寄发票的收件人姓名
        var name = Variable("")
    }
    /// 联系人信息
    struct Contact:DictionaryAble{
        /// 联系人邮箱
        var contactEmail = Variable("")
        /// 联系人电话
        var contactPhone = Variable("")
        /// 联系人姓名
        var contactName = Variable("")
    }
    /// 查询条件
    struct Search:DictionaryAble{
        /// 出发地城市三字码
        var departCityCode:String
        /// 到达城市三字码
        var arriveCityCode:String
        /// 出发日期
        var departDate:String
        /// 去程选中舱位id
        var departCabinId:String
        /// 回程选中舱位id
        var returnCabinId:String?
        /// 回程日期
        var returnDate:String?
    }
}
