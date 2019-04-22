//
//  PickableEnum.swift
//  shop
//
//  Created by manman on 2017/9/26.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation

protocol PickableEnum
{

    var displayName: String { get }
    var permanentID: String { get }
    static var allValues: [Self] { get }
    static func fromPermanentID(id: String) -> Self?
    
}



extension PickableEnum where Self: RawRepresentable, Self.RawValue == Int
{
    var displayName: String
    {
        return NSLocalizedString("\(type(of: self)).\(self)", comment: "")
    }
    
    var permanentID: String
    {
        return String(describing: self)
    }
    
    static var allValues: [Self]
    {
        var result: [Self] = []
        var value = 0
        while let item = Self(rawValue: value)
        {
            result.append(item)
            value += 1
        }
        return result
    }
    
    static func fromPermanentID(id: String) -> Self?
    {
        return allValues.index { $0.permanentID == id }.flatMap { self.init(rawValue: $0) }
    }
}

