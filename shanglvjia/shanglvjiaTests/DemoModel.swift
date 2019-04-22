//
//  DemoModel.swift
//  shanglvjia
//
//  Created by akrio on 2017/4/13.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import SwiftDate
import Moya_SwiftyJSONMapper
import SwiftyJSON

private typealias DemoListItem = DemoModel.ListItem
private typealias DemoUserItem = DemoModel.UserItem
/// 主题列表对应实体
struct DemoModel {
    struct ListItem{
        /// 唯一标识
        var id:String!
        /// 姓名
        var name:String!
        /// 帖子内容
        var createTime:String!
    }
    struct UserItem{
        /// 唯一标识
        var id:String!
        /// 姓名
        var name:String!
        /// 创建时间
        var createTime:String!
    }
    struct UserPo:JSONAble {
        /// 姓名
        var name:String
    }
}

// MARK: - 格式化json -> 结构体
extension DemoListItem:ALSwiftyJSONAble{
    init (jsonData:JSON){
        id = jsonData["id"].stringValue
        name = jsonData["name"].stringValue
        createTime = jsonData["createTime"].stringValue
    }
}

// MARK: - 日志输出
extension DemoListItem:CustomStringConvertible{
    var description: String {
        var des = "===========ListItem============\r\n"
        des += "id -> \(id)\r\n"
        des += "姓名 -> \(name)\r\n"
        des += "创建日期 -> \(createTime)\r\n"
        return des
    }
}

// MARK: - 格式化json -> 结构体
extension DemoUserItem:ALSwiftyJSONAble{
    init (jsonData:JSON){
        id = jsonData["id"].stringValue
        name = jsonData["name"].stringValue
        createTime = jsonData["createTime"].stringValue
    }
}

// MARK: - 日志输出
extension DemoUserItem:CustomStringConvertible{
    var description: String {
        var des = "===========UserItem============\r\n"
        des += "id -> \(id)\r\n"
        des += "姓名 -> \(name)\r\n"
        des += "创建日期 -> \(createTime)\r\n"
        return des
    }
}


protocol JSONAble {}

extension JSONAble {
    func toDict() -> [String:Any] {
        var dict = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        return dict
    }
}
