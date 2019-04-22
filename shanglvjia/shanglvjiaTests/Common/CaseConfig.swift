//
//  TestConfig.swift
//  shanglvjia
//
//  Created by akrio on 2017/4/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import XCTest

/// testcase中通用参数
protocol CaseConfig {
    /// http请求超时时间
    var timeout:TimeInterval {get}
}

extension CaseConfig where Self: XCTestCase{
    var timeout:TimeInterval  {
        return 10000000.0
    }
}
