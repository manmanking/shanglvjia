//
//  SpecialHotelDetailResponse.swift
//  shanglvjia
//
//  Created by manman on 2018/8/1.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class SpecialHotelDetailResponse: NSObject,ALSwiftyJSONAble,NSCoding {

    
    
    ///   可用时常集合 ,
    var hotelUsableDateInfos:[HotelUsableDateInfo] = Array()
    
    ///  房间
    var roomInfoList:[RoomInfo] = Array()
    
    var specialHotelBaseResponse:SpecialHotelListResponse.SpecialHotelInfo = SpecialHotelListResponse.SpecialHotelInfo()
    
    
    
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        
        hotelUsableDateInfos = jsonData["hotelUsableDateInfos"].arrayValue.map{HotelUsableDateInfo.init(jsonData: $0)!}
        roomInfoList = jsonData["roomInfoList"].arrayValue.map{RoomInfo.init(jsonData: $0)!}
        specialHotelBaseResponse = SpecialHotelListResponse.SpecialHotelInfo.init(jsonData:jsonData["specialHotelBaseResponse"])! 
        
    }
    
    func encode(with aCoder: NSCoder) {
        self.mj_encode(aCoder)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.mj_decode(aDecoder)
    }
    
    
    
    
    @objc(_TtCC10shanglvjia26SpecialHotelDetailResponse19HotelUsableDateInfo)class HotelUsableDateInfo: NSObject,ALSwiftyJSONAble,NSCoding {
        
        ///  持续时常 ,
        var constantly:NSInteger = 0
        
        ///  销售时间 , 毫秒单位
        var saleDate:NSInteger = 0
        
        ///  销售截至时间 毫秒单位
        var saleEndDate:NSInteger = 0
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            constantly = jsonData["constantly"].intValue
            saleDate = jsonData["saleDate"].intValue
            saleEndDate = jsonData["saleEndDate"].intValue
        }
        
        func encode(with aCoder: NSCoder) {
            self.mj_encode(aCoder)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init()
            self.mj_decode(aDecoder)
        }
        
        
        
        
    }
    @objc(_TtCC10shanglvjia26SpecialHotelDetailResponse8RoomInfo)class RoomInfo: NSObject ,ALSwiftyJSONAble,NSCoding{
        
        ///  床型 ,
        var bedType:String = ""
        
        ///  房型图 ,
        var imageUrl:String = ""
        
        ///  产品列表 ,
        var ratePlanInfoList:[RatePlanInfo] = Array()
        
        ///  房间名称 ,
        var roomName:String = ""
        
        ///  房间类型id
        var roomTypeId:String = ""
        
        ///展开 默认
        var isFolderOpen:Bool = true
        
        var selectedPlanInfoIndex:NSInteger = 99// 默认数据
        
        /// 1 是国内 2 是国际
        var regionType:String = ""
        
        /// 1 预付 2 现付
        var payType:String = ""
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            //constantly = jsonData["constantly"].intValue
            bedType = jsonData["bedType"].stringValue
            imageUrl = jsonData["imageUrl"].stringValue
            ratePlanInfoList = jsonData["ratePlanInfoList"].arrayValue.map{RatePlanInfo.init(jsonData: $0)!}
            roomName = jsonData["roomName"].stringValue
            roomTypeId = jsonData["roomTypeId"].stringValue
            regionType = jsonData["regionType"].stringValue
            payType = jsonData["payType"].stringValue
        }
        
        func encode(with aCoder: NSCoder) {
            self.mj_encode(aCoder)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init()
            self.mj_decode(aDecoder)
        }
        
        
        
    }
    
    @objc(_TtCC10shanglvjia26SpecialHotelDetailResponse12RatePlanInfo)class  RatePlanInfo:NSObject ,ALSwiftyJSONAble,NSCoding{
        
        /// 平均价格 ,
        var averageRate:Float = 0
        
        ///  (Array[PriceDetailInfo], optional): 价格详情 ,
        var priceDetailInfoList:[PriceDetailInfo] = Array()
        
        var productRemark:String = ""
        
        
        ///  产品id ,
        var ratePlanId:String = ""
        
        /// 产品名称 ,
        var ratePlanName:String = ""
        
        ///  总库存量
        var totalInventory:NSInteger = 0
        
        
        var needConfirm:String = ""
        
        ///发票类型数组
        var orderInvoiceBaseList:[InvoicesModel] = Array()
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            averageRate = jsonData["averageRate"].floatValue
            priceDetailInfoList = jsonData["priceDetailInfoList"].arrayValue.map{PriceDetailInfo.init(jsonData: $0)!}
            needConfirm = jsonData["ratePlanId"].stringValue
            ratePlanId = jsonData["ratePlanId"].stringValue
            productRemark = jsonData["productRemark"].stringValue
            totalInventory = jsonData["totalInventory"].intValue
            ratePlanName = jsonData["ratePlanName"].stringValue
            orderInvoiceBaseList = jsonData["orderInvoiceBaseList"].arrayValue.map{InvoicesModel.init(jsonData: $0)!}
        }
        
        func encode(with aCoder: NSCoder) {
            self.mj_encode(aCoder)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init()
            self.mj_decode(aDecoder)
        }
        
        
        
    }
    @objc(_TtCC9tutubangs26SpecialHotelDetailResponse13InvoicesModel)class InvoicesModel: NSObject,ALSwiftyJSONAble,NSCoding {
        var name:String = ""
        var value:String = ""
        override init() {

        }
        required init?(jsonData: JSON) {
            name = jsonData["name"].stringValue
            value = jsonData["value"].stringValue
        }
        func encode(with aCoder: NSCoder) {
            self.mj_encode(aCoder)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init()
            self.mj_decode(aDecoder)
        }
        
        
    }
    
    @objc(_TtCC10shanglvjia26SpecialHotelDetailResponse15PriceDetailInfo)class  PriceDetailInfo:NSObject,ALSwiftyJSONAble,NSCoding{
        
        ///  (integer, optional): 库存量 ,
        var inventory:NSInteger = 0
        
        ///  价格id ,
        var priceId:String = ""
        
        ///  销售时间 ,
        var saleDate:NSInteger = 0
        
        ///   销售价格
        var saleRate:Float = 0
        
        override init() {
            
        }
        
        required init?(jsonData: JSON) {
            inventory = jsonData["inventory"].intValue
            saleDate = jsonData["saleDate"].intValue
            priceId = jsonData["priceId"].stringValue
            saleRate = jsonData["saleRate"].floatValue
        }
        func encode(with aCoder: NSCoder) {
            self.mj_encode(aCoder)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init()
            self.mj_decode(aDecoder)
        }
        
        
    }
    
}

extension Array where Element == SpecialHotelDetailResponse.RoomInfo {
    
  
    
    
    
    
    
    
    
}

