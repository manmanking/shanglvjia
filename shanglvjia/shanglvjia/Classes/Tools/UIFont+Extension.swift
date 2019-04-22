//
//  UIFont+Extension.swift
//  shop
//
//  Created by manman on 2017/6/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import UIKit



extension UIFont
{

//     open override static func initialize() {
//    
//        super.initialize()
//        
//        let newMethod = class_getClassMethod(self.classForCoder(),#selector(TBIFont(name: size:)))
//        let claseMethod = class_getClassMethod(self.classForCoder(), #selector(UIFont.init(name: size:)))
//        method_exchangeImplementations(newMethod,claseMethod)
//       
//    
//    }
    
    open override static func initialize() {
        
        super.initialize()
        
//        let newMethod = class_getClassMethod(self.classForCoder(),#selector(TBIFont(size:)))
//        let claseMethod = class_getClassMethod(self.classForCoder(), #selector(systemFont(ofSize:)))
//        method_exchangeImplementations(newMethod,claseMethod)
        
        
    }
    
   
   open class func TBIFont(size:CGFloat)->UIFont {
        //Hiragino Mincho ProN
        //FZLanTingHeiS-R-GB
        let font = UIFont.init(name:"FZLanTingHeiS-R-GB" , size: size)
        guard font != nil else {
            print("字体 出问题了")
            return self.TBIFont(size:size)
        }
        // print("字体 修改了")
        return font!
        
    }
    
//    open class func TBIFont(name:String , size:CGFloat)->UIFont {
//        
//        let font = UIFont.init(name:"FZLanTingHeiS-R-GB" , size: size)
//        guard font != nil else {
//            print("字体 出问题了")
//            return self.TBIFont(name:"", size:size)
//        }
//        print("字体 修改了")
//        return font!
//        
//    }
//    
    
    
    
    
    
   
    
    
    
    
    
    
    
}

