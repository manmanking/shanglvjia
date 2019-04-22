//
//  UIBarButtonItem+Extension.swift
//  shop
//
//  Created by SLMF on 2017/4/18.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

extension UIBarButtonItem {
    
    /**
     创建UIBarButtonItem
     - parameter imageName: item显示的图片
     - parameter target:    谁来监听
     - parameter action:    监听到之后执行的方法®
     */
    convenience init(imageName: String, target: AnyObject? ,action: Selector) {
        let btn = UIButton(imageName: imageName)
        btn.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        self.init(customView: btn)
    }
    
    convenience init(imageUrl: String, target: AnyObject? ,action: Selector) {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 108*adaptationRatio, height: 16))
        btn.sd_setImage(with: URL.init(string: imageUrl), for: UIControlState.normal, placeholderImage: UIImage.init(named: ""))
        btn.contentMode = UIViewContentMode.scaleAspectFill
        self.init(customView: btn)
        btn.imageView?.contentMode = .scaleAspectFit
        if IS_IOS11 () {
            btn.snp.makeConstraints { (make) in
                make.height.equalTo(16)
                make.width.equalTo(108*adaptationRatio)
            }
        }
        btn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
    }
}
