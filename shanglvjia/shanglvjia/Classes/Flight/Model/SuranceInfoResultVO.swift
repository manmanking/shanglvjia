//
//  SuranceInfoResultVO.swift
//  shanglvjia
//
//  Created by manman on 2018/3/27.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class SuranceInfoResultVO: NSObject,ALSwiftyJSONAble {

    
    /// (string, optional): 保险默认类型 ,
    var defaultType:String = ""
    /// (Array[TravellerCommitInfoVO]): 旅客 ,
    var passangers:[CommitParamVOModel.TravellerCommitInfoVO] = Array()
    
    ///  (string, optional): 保险后台缓存ID ,
    var suranceCacheId:String = ""
    
    ///  (integer, optional): 需要购买保险份数 ,
    var suranceCount:NSInteger = 0
    
    ///  (string, optional): 保险描述 ,
    var suranceDesc:String = ""
    
    ///  (string, optional): 保险名称 ,
    var suranceName:String = ""
    
    ///  (string, optional): 保险单价
    var surancePrice:String = ""
    
    
    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        self.passangers = jsonData["passangers"].arrayValue.map{CommitParamVOModel.TravellerCommitInfoVO(jsonData:$0)!}
        self.defaultType = jsonData["defaultType"].stringValue
        self.suranceCacheId = jsonData["suranceCacheId"].stringValue
        self.suranceCount = jsonData["suranceCount"].intValue
        self.suranceDesc = jsonData["suranceDesc"].stringValue
        self.suranceName = jsonData["suranceName"].stringValue
        self.surancePrice = jsonData["surancePrice"].stringValue
        
    }
    
}
