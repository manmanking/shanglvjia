//
//  UIButton+Extension.swift
//  Weibo
//
//  Created by TBI on 2016/12/6.
//  Copyright © 2016年 TBI. All rights reserved.
//

import UIKit

extension UIButton {

    
    class func createButton(_ imageName: String, backImageName: String) -> UIButton {
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: UIControlState.normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: UIControlState.highlighted)
        
        btn.setBackgroundImage(UIImage(named: backImageName), for: UIControlState.normal)
        btn.setBackgroundImage(UIImage(named: backImageName + "_highlighted"), for: UIControlState.highlighted)
        btn.sizeToFit()
        return btn
    }
    
    convenience init(imageName: String, backImageName: String) {
        
        self.init()
        setImage(UIImage(named: imageName), for: UIControlState.normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: UIControlState.highlighted)
        
        setBackgroundImage(UIImage(named: backImageName), for: UIControlState.normal)
        setBackgroundImage(UIImage(named: backImageName + "_highlighted"), for: UIControlState.highlighted)
        sizeToFit()
    }
    
    convenience init(title: String, titleColor: UIColor, backImageName: String) {
        
        self.init()
        setTitle(title, for: UIControlState.normal)
        setTitleColor(titleColor, for: UIControlState.normal)
        setBackgroundImage(UIImage(named: backImageName), for: UIControlState.normal)
        sizeToFit()
    }
    
    convenience init(imageName: String) {
        
        self.init()
        setImage(UIImage(named: imageName), for: UIControlState.normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: UIControlState.highlighted)
        sizeToFit()
    }
    
    convenience init(backImageName: String) {
        
        self.init()
        setBackgroundImage(UIImage(named: backImageName), for: UIControlState.normal)
        setBackgroundImage(UIImage(named: backImageName + "_highlighted"), for: UIControlState.highlighted)
        sizeToFit()
    }
    
    convenience init(title: String, imageName: String) {
        
        self.init()
        setImage(UIImage(named: imageName), for: UIControlState.normal)
        setTitle(title, for: UIControlState.normal)
        setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        adjustsImageWhenHighlighted = false
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    convenience init(title: String,titleColor: UIColor,titleSize: CGFloat) {
        self.init()
        setTitle(title, for: UIControlState.normal)
        setTitleColor(titleColor, for: UIControlState.normal)
        titleLabel?.font = UIFont.systemFont(ofSize: titleSize)
        sizeToFit()
    }
}
