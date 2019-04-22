//
//  CoNewOrderCustomConfig.swift
//  shop
//
//  Created by akrio on 2017/5/18.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON
import RxSwift
/// 新版订单自定义字段
struct CoNewOrderCustomConfig :ALSwiftyJSONAble{
    // 出差事由是否必填项
    let travelPurposeFlag:Bool
    // 出差时间是否必填项
    let travelDateFlag:Bool
    // 出差地点是否必填项
    let travelDestFlag:Bool
    // 出差目的是否必填项
    let travelTargetFlag:Bool
    /// 出差目的可选项
    let travelTargets:[String]
    /// 自定义字段
    var customFields:[CustomField]
    
    init(jsonData:JSON) {
        self.travelPurposeFlag = jsonData["travelPurposeFlag"].boolValue
        self.travelDateFlag = jsonData["travelDateFlag"].boolValue
        self.travelDestFlag = jsonData["travelDestFlag"].boolValue
        self.travelTargetFlag = jsonData["travelTargetFlag"].boolValue
        self.customFields = jsonData["customFields"].arrayValue.map{ CustomField(jsonData: $0) }
        self.travelTargets = jsonData["travelTargets"].arrayValue.map{ $0.stringValue}
    }
    
    /// 自定义字段实体
    struct CustomField :ALSwiftyJSONAble{
        /// 唯一标示
        let id:String
        /// 全部可选值
        let defaultValue:[String]
        /// 选中值
        var selectValue:[String]?
        /// 已创建订单中的唯一标识
        let resultId:String?
        /// 类型
        let type:CustomType
        /// 是否必填
        let required:Bool
        /// 标题
        let title:String
        
        var value = Variable("")
        /// 自定义字段类型
        ///
        /// - select:下拉单选 和 singleSelect形式是一样的，只不过后台这么设计的
        /// - singleSelect: 单选
        /// - mulSelect: 多选
        /// - text: 文本
        enum CustomType:Int {
            case select = 1
            case singleSelect = 2
            case mulSelect = 3
            case text = 4
            case unknow = 9999

        }
        init(jsonData: JSON) {
            self.id = jsonData["id"].stringValue
            self.defaultValue = jsonData["defaultValue"].arrayValue.map{ $0.stringValue }
            if let jSelectValue = jsonData["selectValue"].array {
                self.selectValue = jSelectValue.map { $0.stringValue }
            }else {
                self.selectValue = nil
            }
            self.resultId = jsonData["resultId"].string
            self.type = CustomType(rawValue: jsonData["type"].intValue) ?? .unknow
            self.required = jsonData["require"].boolValue
            self.title = jsonData["name"].stringValue
        }
    }
}
