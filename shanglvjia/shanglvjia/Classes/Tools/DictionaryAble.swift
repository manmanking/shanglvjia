//
//  DictionaryAble.swift
//  shop
//
//  Created by akrio on 2017/4/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
/// 可以被转化为字典
protocol DictionaryAble{
    var JSONRepresentation: [String: Any] { get }
}
extension DictionaryAble {
    var JSONRepresentation: [String: Any] {
        var representation = [String: Any]()
        for case let (label?, value) in Mirror(reflecting: self).children {
            switch value {
            case let value as  Array<Any>:
                var arr:[Any] = []
                value.forEach{model in
                    if let child = model as? DictionaryAble {
                        arr.append(child.JSONRepresentation)
                    }else {
                        if let model = model as? Variable<String> {
                            arr.append(model.value)
                        }else {
                            arr.append(model)
                        }
                    }

                }
                representation[label] = arr
            case let value as DictionaryAble:
                representation[label] = value.JSONRepresentation
            case let value as Variable<String>:
                representation[label] = value.value
            case let value as Optional<Any>:
                if let realValue = value{
                    if let v = realValue as? DictionaryAble {
                        representation[label] = v.JSONRepresentation
                    }else{
                        representation[label] = realValue
                    }
                }else {
                    representation[label] = nil
                }
            case let value as NSObject:
                representation[label] = value
            default:
                // Ignore any unserializable properties
                break
            }
        }
        return representation
    }
        func toDict() -> [String:Any] {
            return self.JSONRepresentation
        }
}
