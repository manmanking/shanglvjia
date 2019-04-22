//
//  Bundle+Extension.swift
//  shop
//
//  Created by TBI on 2017/4/5.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation

extension Bundle {
    // 计算性属性类似函数，没有参数，有返回值
    /// 获取当前的bundleName
    var nameSpace : String {
        return (infoDictionary?["CFBundleName"] as? String) ?? ""
    }
    var version : String {
        return (infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }
}
