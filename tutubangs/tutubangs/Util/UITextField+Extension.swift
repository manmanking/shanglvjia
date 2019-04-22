//
//  UITextField+Extension.swift
//  tbiVehicleClient
//
//  Created by TBI on 2017/1/8.
//  Copyright © 2017年 com. All rights reserved.
//

import UIKit

extension UITextField {
    
    convenience init(fontSize: CGFloat) {
        self.init()
        font = UIFont.systemFont(ofSize: fontSize)
    }
    
    convenience init(placeholder: String,fontSize: CGFloat) {
        self.init()
        font = UIFont.systemFont(ofSize: fontSize)
        self.placeholder = placeholder
    }
    
    convenience init(borderWidth: CGFloat,color: UIColor,fontSize: CGFloat) {
        self.init()
        font = UIFont.systemFont(ofSize: fontSize)
        layer.borderWidth = borderWidth
        layer.borderColor = color.cgColor
        textAlignment = .center
    }
    
}

class CustomTextField:UITextField {
    
    @objc convenience init(fontSize: CGFloat) {
        self.init()
        font = UIFont.systemFont(ofSize: fontSize)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect{
        let cg = CGRect(x: 15, y: bounds.origin.y, width: bounds.size.width - 30, height: bounds.size.height)
        return cg
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect{
        let cg = CGRect(x:15, y: bounds.origin.y, width: bounds.size.width - 30, height: bounds.size.height)
        return cg
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let cg = CGRect(x:15, y: bounds.origin.y, width: bounds.size.width - 30, height: bounds.size.height)
        return cg
    }
}

