//
//  BaseUIColor.swift
//  Tbi1
//
//  Created by TBI on 2016/12/6.
//  Copyright © 2016年 TBI. All rights reserved.
//

import UIKit

//16进制颜色
extension UIColor {
    
    // MARK:- 把#ffffff颜色转为UIImage
    class func creatImageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    convenience init?(hexString: String) {
        self.init(hexString: hexString, alpha: 1.0)
    }
    
    convenience init?(hexString: String, alpha: Float) {
        let set = CharacterSet.whitespacesAndNewlines
        var hex = hexString.trimmingCharacters(in: set).uppercased()
        
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }
        
        guard let hexVal = Int(hex, radix: 16) else {
            self.init()
            return nil
        }
        
        switch hex.characters.count {
        case 3:
            self.init(hex3: hexVal, alpha: alpha)
        case 6:
            self.init(hex6: hexVal, alpha: alpha)
        default:
            self.init()
            return nil
        }
    }
    
    convenience init?(hexNumber: Int) {
        self.init(hexNumber: hexNumber, alpha: 1.0)
    }
    
    convenience init?(hexNumber: Int, alpha: Float) {
        guard (0x000000 ... 0xFFFFFF) ~= hexNumber else {
            self.init()
            return nil
        }
        self.init(hex6: hexNumber, alpha: alpha)
    }
}

private extension UIColor {
    convenience init?(hex3: Int, alpha: Float) {
        self.init(red:   CGFloat( ((hex3 & 0xF00) >> 8).duplicate4bits() ) / 255.0,
                  green: CGFloat( ((hex3 & 0x0F0) >> 4).duplicate4bits() ) / 255.0,
                  blue:  CGFloat( ((hex3 & 0x00F) >> 0).duplicate4bits() ) / 255.0,
                  alpha: CGFloat(alpha))
    }
    
    convenience init?(hex6: Int, alpha: Float) {
        self.init(red:   CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
                  green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
                  blue:  CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0,
                  alpha: CGFloat(alpha))
    }
}

private extension Int {
    func duplicate4bits() -> Int {
        return (self << 4) + self
    }
}

//rgb颜色
extension UIColor
{
    /**
     根据RGB生成颜色
     
     - parameter r: red
     - parameter g: green
     - parameter b: blue
     
     - returns: 颜色
     */
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    /**
     根据RGB生成颜色
     
     - parameter r: red
     - parameter g: green
     - parameter b: blue
     - parameter alpha: 透明度
     
     - returns: 颜色
     */
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
    
    /**
     生成灰色
     
     - parameter gray: 灰色
     
     - returns: 颜色
     */
    convenience init(gray: CGFloat) {
        self.init(red: gray/255.0, green: gray/255.0, blue: gray/255.0, alpha: 1)
    }
}
