//
//  CitsModel.swift
//  shop
//
//  Created by zhanghao on 2017/7/12.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import SwiftDate
import Moya_SwiftyJSONMapper
import SwiftyJSON

struct DestinationsModel : DictionaryAble {
    /// 类型 1--推荐版块1 2--推荐版块2 3--推荐版块3 4--推荐版块4 5--推荐版块5 6--出境跟团游搜索 7--出境自由行搜索 8--国内跟团游搜索 9--国内自由行搜索 10--当地参团游搜索
    let type : String
    /// 出发地
    let departure : String
    /// 目的地
    let destId : String
    /// 关键字
    let keyWord : String
   
}
//途经地搜索
struct SearchDestinationsModel : DictionaryAble{
    /// 类型 1--推荐版块1 2--推荐版块2 3--推荐版块3 4--推荐版块4 5--推荐版块5 6--出境跟团游搜索 7--出境自由行搜索 8--国内跟团游搜索 9--国内自由行搜索 10--当地参团游搜索
    let type : String
    /// 出发地
    let departure : String
    /// 目的地
    let destId : String
    /// 关键字
    let keyWord : String
}

//当地参团旅数据
struct LocalCitys :ALSwiftyJSONAble{
    
    let name:String?
    
    var citys:[Citys] = []
    
    init(jsonData result: JSON) {
        self.name = result["name"].stringValue
        self.citys = result["citys"].arrayValue.map{Citys(jsonData:$0)}
    }
    
    struct Citys: ALSwiftyJSONAble{
        let start_place_id:String?
        let start_place:String?
        
        init(jsonData result: JSON) {
            self.start_place_id = result["start_place_id"].stringValue
            self.start_place = result["start_place"].stringValue
        }
    }
    
    
}

struct CitsCitys {
    let name:String?
    var citys:[CitysBeanX] = []
    
    struct CitysBeanX {
        let name:String?
        let child_codes:String?
        let child_names:String?
        var citys:[CityBean] = []
    }
    struct CityBean {
        let code:String?
        let name:String?
    }
   
}
extension CitsCitys:ALSwiftyJSONAble{
    init(jsonData result: JSON) {
        self.name = result["name"].stringValue
        self.citys = result["citys"].arrayValue.map{CitysBeanX(jsonData:$0)}
    }
}
extension CitsCitys.CitysBeanX:ALSwiftyJSONAble{
    init(jsonData citysbeansJsonDate:JSON){
        self.name = citysbeansJsonDate["name"].stringValue
        self.child_codes = citysbeansJsonDate["child_codes"].stringValue
        self.child_names = citysbeansJsonDate["child_names"].stringValue
        self.citys = citysbeansJsonDate["citys"].arrayValue.map{CitsCitys.CityBean(jsonData:$0)}
    }
}

extension CitsCitys.CityBean:ALSwiftyJSONAble{
    init(jsonData cityBeanJsonDate:JSON){
        self.code=cityBeanJsonDate["code"].stringValue
        self.name=cityBeanJsonDate["name"].stringValue
    }
}


