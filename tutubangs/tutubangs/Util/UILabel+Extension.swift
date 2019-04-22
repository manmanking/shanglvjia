//
//  UILabel+Extension.swift
//  Weibo
//
//  Created by TBI on 2016/12/6.
//  Copyright © 2016年 TBI. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(color: UIColor, lines: Int) {
        
        self.init()
        textColor = color
        numberOfLines = lines
    }
    
    convenience init(color: UIColor) {
        self.init()
        backgroundColor = color
    }
    
    
    convenience init(text:String, color: UIColor, size: CGFloat) {
        self.init()
        self.text = text
        textColor = color
        //font = UIFont.systemFont(ofSize: size)
        font = UIFont.systemFont( ofSize: size)
    }
    
}
