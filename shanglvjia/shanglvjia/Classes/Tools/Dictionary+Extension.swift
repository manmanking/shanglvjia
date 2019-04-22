//
//  Dictionary+Extension.swift
//  shop
//
//  Created by manman on 2017/5/12.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation



protocol OptionalType {
    associatedtype Wrapped
    var asOptional : Wrapped? { get }
}

extension Optional : OptionalType {
    var asOptional : Wrapped? {
        return self
    }
}


extension Dictionary where Value: OptionalType {
    
    func jsonSanitize() -> [Key: Value.Wrapped] {
        var newDict: [Key: Value.Wrapped] = [:]
        for (key, value) in self {
            if let v = value.asOptional {
                newDict.updateValue(v, forKey: key)
            }
        }
        return newDict
    }
}
