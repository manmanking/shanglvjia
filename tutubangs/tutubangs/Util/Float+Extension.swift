//
//  Float+Extension.swift
//  shop
//
//  Created by manman on 2017/8/9.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation


extension Float
{
    
    func OneOfTheEffectiveFraction() -> String {
        let outFirst:String = String.init(format: "%.1f", self)
        var outFirstArr:[String]  = outFirst.components(separatedBy: ".")
        if outFirstArr[1] == "0"
        {
            return (outFirstArr.first!)
        }else
        {
            return (outFirst)
        }
    }
    func TwoOfTheEffectiveFraction() -> String {
        var outFirst:String = String.init(format: "%.2f", self)
        var outFirstArr:[String]  = outFirst.components(separatedBy: ".")
        if outFirstArr[1] == "00"
        {
            return (outFirstArr.first!)
        }else
        {
            if outFirstArr.last?.last == "0" {
               outFirst = self.OneOfTheEffectiveFraction()
            }
           return outFirst
        } 
    }
    
    
    
    
    
    
}
