//
//  SpecialTravelsAdvsModel.swift
//  shop
//
//  Created by zhanghao on 2017/7/10.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import SwiftDate
import Moya_SwiftyJSONMapper
import SwiftyJSON

struct AdvsModel : DictionaryAble{
    let type:String
    let departure:String
}

struct TravelAdvListResponse : ALSwiftyJSONAble{
    
    let type : String
    
    let firstTravelAdvResponse : TravelAdvResponse
    ///热门线路图列表
    var travelAdvResponseList : [TravelAdvResponse] = []
    
    init(jsonData: JSON) {
        self.type = jsonData["type"].stringValue
//        self.firstTravelAdvResponse = TravelAdvResponse(rawValue: jsonData["firstTravelAdvResponse"].stringValue) ?? .unknow
        self.firstTravelAdvResponse = TravelAdvResponse(jsonData: jsonData["firstTravelAdvResponse"])!
        self.travelAdvResponseList = jsonData["travelAdvResponseList"].arrayValue.map{TravelAdvResponse(jsonData: $0)! }
    }
}

struct TravelAdvResponse : ALSwiftyJSONAble {
    ///标题
    let title : String?
    ///副标题
    let subtitle : String?
    ///图片链接
    let imgUrl : String?
    ///更多
    let more : String?
    ///首图颜色 存色号，带#号
    let color : String?
    ///目的地中文，西文逗号分隔
    let destinationchs : String?
    ///目的地id，西文逗号分隔
    let destinationids : String?
    ///关键字
    let keyword : String?
    ///线路ID
    let routeId : String?
    ///检索类型
    let searchType : String?
    
    init?(jsonData: JSON) {
        self.title = jsonData["title"].stringValue
        self.subtitle = jsonData["subtitle"].stringValue
        self.imgUrl = jsonData["imgUrl"].stringValue
        self.more = jsonData["more"].stringValue
        self.color = jsonData["color"].stringValue
        self.destinationchs = jsonData["destinationchs"].stringValue
        self.destinationids = jsonData["destinationids"].stringValue
        self.keyword = jsonData["keyword"].stringValue
        self.routeId = jsonData["routeId"].stringValue
        self.searchType = jsonData["searchType"].stringValue
    }
}

//enum advEnum : String{
    ///1--推荐版块1 2--推荐版块2 3--推荐版块3 4--推荐版块4 5--推荐版块5 6--出境跟团游搜索 7--出境自由行搜索 8--国内跟团游搜索 9--国内自由行搜索 10--当地参团游搜索
//}
