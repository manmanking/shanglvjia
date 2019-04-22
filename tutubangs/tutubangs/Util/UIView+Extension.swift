//
//  UIView+Extension.swift
//  tbiVehicleClient
//
//  Created by TBI on 2016/12/29.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

extension UIView {
    //点击手势
    func addOnClickListener(target: AnyObject, action: Selector) {
        let gr = UITapGestureRecognizer(target: target, action: action)
        gr.numberOfTapsRequired = 1
        isUserInteractionEnabled = true
        addGestureRecognizer(gr)
    }
    //左边滑动
    func addLeftSlideListener(target: AnyObject, action: Selector) {
        let gr = UISwipeGestureRecognizer(target: target, action: action)
        gr.direction = UISwipeGestureRecognizerDirection.left
        addGestureRecognizer(gr)
    }
    //右边滑动
    func addRightSlideListener(target: AnyObject, action: Selector) {
        let gr = UISwipeGestureRecognizer(target: target, action: action)
        addGestureRecognizer(gr)
    }
    
    convenience init(color: UIColor) {
        self.init()
        backgroundColor = color
    }
    //等待动画
    func animationView(view:UIView?) ->UIView{
        let lodingView = LoadingView(frame: ScreenWindowFrame)
        view?.addSubview(lodingView)
        return lodingView
    }
    
    
    func getCurrentViewController() -> UIViewController {
        
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindowLevelNormal {
            let windows = UIApplication.shared.windows
            for tmpWind in windows {
                if tmpWind.windowLevel == UIWindowLevelNormal {
                    window = tmpWind
                    break
                }
            }
        }
        
        let frontView = window?.subviews.first
        let nextResponder = frontView?.next
        if (nextResponder?.isKind(of: UIViewController.classForCoder()))! {
            return nextResponder as! UIViewController
        }else
        {
            return (window?.rootViewController)!
        }
        
        
        
    }

    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func addCorner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    
}
