//
//  NSObject+Extension.swift
//  shanglvjia
//
//  Created by manman on 2018/6/6.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation

extension NSObject {
   
    func printAddress<T: AnyObject>(model: T) -> String {
        return String.init(format: "%018p", unsafeBitCast(model, to: Int.self))
    }
}

