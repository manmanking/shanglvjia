//
//  Array+Extension.swift
//  shop
//
//  Created by akrio on 2017/4/28.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
// MARK: - 数组相关扩展
extension Array where Element:Equatable {
    /// 去重
    ///
    /// - Returns: 去重后数据
    func distinct() -> [Element]{
        return self.reduce([]){all,item in
            guard !all.contains(item) else{
                return all
            }
            return all + [item]
        }
    }
}
extension Array {
    /// 去重
    ///
    /// - Returns: 去重后数据
    func distinct(where predicate: (Element,Element) -> Bool) -> [Element]{
        return self.reduce([]){all,item in
            guard !(all.contains{predicate(item,$0)}) else {
                return all
            }
            return all + [item]
        }
    }
    /// 将数组用逗号进行进行分隔，并拼接成字符串
    ///
    /// - Returns: 拼接后的字符串
    func toString() -> String {
        return self.reduce(""){
            var result = $0
            if result == "" {
                result = "\($1)"
            }else {
                result += ",\($1)"
            }
            return result
        }
    }
}
