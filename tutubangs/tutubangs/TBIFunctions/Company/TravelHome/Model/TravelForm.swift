//
//  TravelForm.swift
//  shop
//
//  Created by akrio on 2017/6/27.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import SwiftDate
import RxSwift
/// 旅游相关表单实体
struct TravelForm {
    /// 列表查询实体
    struct Search:DictionaryAble {
        /*
         必填项
         */
        /// 当前页码
        var pageIndex:Int
        /// 每页显示条目
        var pageSize:Int
        /// 地域 1--国内 2--国际
        var region:Int
        /// 出发地
        var startCity:String?
        /// 目的地id
        var destId:String?
        /// 目的地
        var arriveCity:String?
        /// 出发日期(yyyy-MM-dd)--开始
        var saleDateBegin:String?
        /// 到达日期(yyyy-MM-dd)--结束
        var saleDateEnd:String?
        /// 搜索关键字
        var searchKey:String?
        /// 类型 类型 1--推荐版块1 2--推荐版块2 3--推荐版块3 4--推荐版块4 5--推荐版块5 6--出境跟团游搜索 7--出境自由行搜索 8--国内跟团游搜索 9--国内自由行搜索 10--当地参团游搜索
        var type:String?
        /// 搜索类型
        var searchType:String?
        /// 行程天数：最小天数
        var dayNumBegin:Int?
        /// 行程天数：截止天数
        var dayNumEnd:Int?
        /// 价格区间：开始价格
        var priceAreaBegin:String?
        /// 价格区间：截止价格
        var priceAreaEnd:String?
        /// 排序规则： 关注度、点击量升序：1 关注度、点击量降序：2 出发时间升序：3 出发时间降序：4 价格升序：5 价格降序：6 天数升序：7 天数降序：8 订单数升序：9 订单数降序：10
        var orderBy:String?
        
        init(pageIndex:Int = 1,pageSize:Int = 5,region:Region = .inland ,startCity:String? = nil,arriveCity:String? = nil,saleDateBegin:DateInRegion? = nil,saleDateEnd:DateInRegion? = nil,searchKey:String? = nil) {
            self.pageIndex = pageIndex
            self.pageSize = pageSize
            self.region = region.rawValue
            self.startCity = startCity
            self.arriveCity = arriveCity
            self.saleDateBegin = saleDateBegin?.string(custom: "YYYY-MM-dd")
            self.saleDateEnd = saleDateEnd?.string(custom: "YYYY-MM-dd")
            self.searchKey  = searchKey
        }
        
        /// 地域类型
        ///
        /// - inland: 国内
        /// - international: 国际
        enum Region:Int {
            case inland = 1
            case international = 2
            case unknow = 999
        }
        
    }
    /// 获取特价产品价格列表信息查询表单
    struct SpecialPriceSearch:DictionaryAble {
        /// 特价产品类型Id
        ///var specialProductsCategoryId:String
        /// 销售月份(yyyy-MM)
        var saleDate:String
    }
    struct OrderSpecialInfo:DictionaryAble {
        /// 特价产品ID
        var specialProductsMainId:String = ""
        /// 特价产品类型ID
        var specialProductsCategoryId:String = ""
        /// 特价产品价格ID
        var specialProductsPriceId:String = ""
        /// 销售日期
        var saleDate:String = ""
        /// 总价格
        var totalAmount:Double = 0
        /// 成人数量
        var adultNum:Int = 0
        /// 儿童含床数量
        var childBedNum:Int = 0
        /// 儿童不含床数量
        var childNobedNum:Int = 0
        /// 房间数量
        var roomNum:Int = 0
        /// 是否需要发票
        var isNeedInvoice:String = ""
        /// 联系人姓名
        var contactName = Variable("")
        /// 联系人电话
        var contactPhone = Variable("")
        /// 人员信息列表
        var orderSpecialPersonInfoList:[OrderSpecialPersonInfo]? = []
        /// 发票信息
        var invoice:Invoice =  Invoice()
        /// 邮寄信息
        var logistics:Logistics = Logistics()
        /// 人员信息
        struct OrderSpecialPersonInfo:DictionaryAble {
            /// 出行人中文姓名
            var personNameCn:String? = ""
            /// 出行人英文姓名
            var personNameEn:String? = ""
            /// 出行人性别
            var personSex:String? = ""
            /// 出行人手机号码
            var personPhone:String? = ""
            /// 出行人类型，成人/儿童占床/儿童不占床
            var personType:String? = ""
            /// 出行人护照
            var personPassport:String? = ""
            /// 出行人身份证
            var personIdCard:String? = ""
            /// 出行人国籍
            var personNationality:String? = ""
            /// 出生日期
            var personBirthDay:String? = ""
            
            mutating func initData(model:TravellerListItem){
                self.personNameCn = model.nameChi
                self.personNameEn = model.nameEng
                self.personSex = String(describing:model.gender)
                self.personPhone = model.phone
                self.personType = String(describing:model.travelType)
                self.personPassport = model.passport
                self.personIdCard = model.idCard
                self.personNationality = model.country
                self.personBirthDay =  model.birthday
            }
        }
        /// 发票
        struct Invoice:DictionaryAble {
            /// 发票抬头
            var invoiceTitle = Variable("")
            /// 发票类型 1全额发票 2机票行程单+差额发票 0 公司  1个人
            var invoiceType:String? = "1"
        }
        /// 邮寄信息
        struct Logistics:DictionaryAble {
            /// 省份代码
            var provinceCode:String? = ""
            /// 城市代码
            var cityCode:String? = ""
            /// 街道代码
            var countyCode:String? = ""
            /// 详细地址
            var logisticsAddress  = Variable("")
            /// 邮编
            var postalCode:String? = ""
            /// 收件人电话
            var logisticsPhone = Variable("")
            /// 收件人姓名
            var logisticsName  = Variable("")
        }
    }
   
}
