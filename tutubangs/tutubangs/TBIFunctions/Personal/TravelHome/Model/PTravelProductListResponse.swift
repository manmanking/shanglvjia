//
//  PTravelProductListResponse.swift
//  shanglvjia
//
//  Created by manman on 2018/7/31.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class PTravelProductListResponse: NSObject,ALSwiftyJSONAble{

    var count:NSInteger = 0
    var list:[BaseTravelProductListVo] = Array()
    
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        
        count = jsonData["count"].intValue
        list = jsonData["responses"].arrayValue.map{BaseTravelProductListVo.init(jsonData: $0)!}
        
        
    }
    
    

    
    class BaseTravelProductListVo: NSObject,ALSwiftyJSONAble{
        
        /// 出发地 ,
        var dept:String = ""
        
        ///  出发地中文 ,
        var deptCN:String = ""
        var id:String = ""
        var minPrice:String = ""
        
        /// 商品名称 ,
        var name:String = ""
        
        ///商品缩略图 ,
        var pic:String = ""

        /// 总库存 ,
        var stockCount:NSInteger = 0
        
        ///  类型0目的游1跟团游2自由行
        var type:String = ""
        
        ///需要员工证0否1是 ,
        var employee:String = ""
        /// 亮点 ,
        var spot:String = ""
        ///亮点描述 ,
        var spotDesc:String = ""
        /// 副标题
        var sideName:String = ""
        ///途经城市
        var stopCity:String = ""
        
        
        override init() {
            
        }
        
        
        required init?(jsonData: JSON) {
            dept = jsonData["dept"].stringValue
            deptCN = jsonData["deptCN"].stringValue
            id = jsonData["id"].stringValue
            minPrice = jsonData["minPrice"].stringValue
            name = jsonData["name"].stringValue
            pic = jsonData["pic"].stringValue
            stockCount = jsonData["stockCount"].intValue
            type = jsonData["type"].stringValue
            employee = jsonData["employee"].stringValue
            spot = jsonData["spot"].stringValue
            spotDesc = jsonData["spotDesc"].stringValue
            sideName = jsonData["sideName"].stringValue
            stopCity = jsonData["stopCity"].stringValue
        }
    }


    
    
    
    
}
