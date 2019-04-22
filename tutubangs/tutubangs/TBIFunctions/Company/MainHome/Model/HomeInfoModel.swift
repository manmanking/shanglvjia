//
//  HomeInfoModel.swift
//  shop
//
//  Created by TBI on 2017/6/12.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya_SwiftyJSONMapper
import SwiftDate

//首页信息
struct HomeInfoModel: ALSwiftyJSONAble {
    //左上角公司图标
    let corpLogo:String
    //个人轮播图
    let pics_0:[AdvPic]
    //特价图片
    let pics_1:[AdvPic]
    //企业轮播图
    let pics_2:[AdvPic]
    //热门旅游
    let travelHot:[SpecialMainListResponse]
    //热门特价
    let airticketsHot:[SpecialMainListResponse]
    
    let journeys:[CoJourney]
    
    init(jsonData result: JSON) {
        corpLogo = result["corpLogo"].stringValue
        pics_0 =  result["pics_0"].arrayValue.map{AdvPic(jsonData:$0)}
        pics_1 =  result["pics_1"].arrayValue.map{AdvPic(jsonData:$0)}
        pics_2 =  result["pics_2"].arrayValue.map{AdvPic(jsonData:$0)}
        travelHot = result["travelHot"].arrayValue.map{SpecialMainListResponse(jsonData:$0)}
        airticketsHot = result["airticketsHot"].arrayValue.map{SpecialMainListResponse(jsonData:$0)}
        journeys = result["journeys"].arrayValue.map{CoJourney(jsonData:$0)}
        
//        travelHot (Array[SpecialMainListResponse]): 热门旅游 ,
//        airticketsHot (Array[SpecialMainListResponse]): 热门机票 ,
//        journeys (Array[CoJourney]): 行程
    }
    
    struct AdvPic : ALSwiftyJSONAble{
        let advId:Int
        let advType:String
        let advTitle:String
        let advContent:String
        let advUrl:String
        let advPic:String
        let remark1:String
        let remark2:String
        let remark3:String
        let remark4:String
        let sort:Int
        let state:Int
        let createTime:DateInRegion?
        init(jsonData result:JSON){
            advId = result["advId"].intValue
            advType = result["advType"].stringValue
            advTitle = result["advTitle"].stringValue
            advContent = result["advContent"].stringValue
            advUrl = result["advUrl"].stringValue
            advPic = result["advPic"].stringValue
            remark1 = result["remark1"].stringValue
            remark2 = result["remark2"].stringValue
            remark3 = result["remark3"].stringValue
            remark4 = result["remark4"].stringValue
            sort = result["sort"].intValue
            state = result["state"].intValue
            createTime = result["createTime"].dateFormat(.custom("YYYYMMDD"))
        }
    }
    
    struct SpecialMainListResponse:ALSwiftyJSONAble {
        let productId:String// (string): 特价产品id ,
        let productName:String// (string): 特价产品名称 ,
        let productType:String// (integer): 特价产品类型 ,
        let price:Float// (number, optional): 原价 ,
        let salePrice:Float// (number): 售价 ,
        let startCity:String// (string): 出发地 ,
        let arriveCity:String// (string): 目的地 ,
        let showContract:String// (string, optional): 是否显示合同 ,
        let confirm:String// (string, optional): 是否确认库存 ,
        let region:Int// (integer, optional): 地域1国内2国际 ,
        let imgUrl:String// (string): 产品封面 ,
        let hot:Int// (integer, optional): 热度 ,
        let productDescription:String// (string, optional): 产品描述 ,
        let label:String// (string, optional): 标签
        init(jsonData result:JSON){
            productId = result["productId"].stringValue
            productName = result["productName"].stringValue
            productType = result["productType"].stringValue
            price = result["price"].floatValue
            salePrice = result["salePrice"].floatValue
            startCity = result["startCity"].stringValue
            arriveCity = result["arriveCity"].stringValue
            showContract = result["showContract"].stringValue
            confirm = result["confirm"].stringValue
            region = result["region"].intValue
            imgUrl = result["imgUrl"].stringValue
            hot = result["hot"].intValue
            productDescription = result["productDescription"].stringValue
            label = result["label"].stringValue
        }
    }
    struct CoJourney:ALSwiftyJSONAble {
        let travelData:Int// (integer, optional): 出行日期 ,
        let type:Int// (integer, optional): 行程类型 ,
        let orderNo:String// (string, optional): 关联订单号 ,
        let flight:CoFlightJourneyItem// (CoFlightJourneyItem, optional),
        let hotel:CoHotelJourneyItem// (CoHotelJourneyItem, optional)
        init(jsonData result:JSON){
            travelData = result["travelData"].intValue
            type = result["type"].intValue
            orderNo = result["orderNo"].stringValue
            flight = CoFlightJourneyItem(jsonData:result["flight"])
            hotel = CoHotelJourneyItem(jsonData:result["hotel"])
        }
    }
    struct CoFlightJourneyItem:ALSwiftyJSONAble {
        let departureDate:Int// (integer, optional): 出发日期 ,
        let departureAirport:String// (string, optional): 出发机场 ,
        let departureCity:String// (string, optional): 出发城市 ,
        let arriveDate:Int// (integer, optional): 到达日期 ,
        let arriveAirport:String// (string, optional): 到达机场 ,
        let arriveCity:String// (string, optional): 到达城市 ,
        let flightNo:String// (string, optional): 航班号 ,
        let companyName:String// (string, optional): 航空公司名称
        init(jsonData result:JSON){
            departureDate = result["departureDate"].intValue
            departureAirport = result["departureAirport"].stringValue
            departureCity = result["departureCity"].stringValue
            arriveDate = result["arriveDate"].intValue
            arriveAirport = result["arriveAirport"].stringValue
            arriveCity = result["arriveCity"].stringValue
            flightNo = result["flightNo"].stringValue
            companyName = result["companyName"].stringValue
        }
    }
    struct CoHotelJourneyItem:ALSwiftyJSONAble {
        let hotelName:String// (string, optional): 酒店名称 ,
        let roomName:String// (string, optional): 房型名称 ,
        let arriveDate:Int// (integer, optional): 到店日期 ,
        let leaveDate:Int// (integer, optional): 离店日期 ,
        let contactNumber:String// (string, optional): 联系电话 ,
        let address:String// (string, optional): 酒店地址
        
        init(jsonData result:JSON){
            hotelName = result["hotelName"].stringValue
            roomName = result["roomName"].stringValue
            arriveDate = result["arriveDate"].intValue
            leaveDate = result["leaveDate"].intValue
            contactNumber = result["contactNumber"].stringValue
            address = result["address"].stringValue
        }
    }
}
