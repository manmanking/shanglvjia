//
//  UIButton+Category.swift
//  tbiVehicleClient
//
//  Created by manman on 2017/11/13.
//  Copyright © 2017年 com. All rights reserved.
//

import Foundation


extension UIButton{

    private struct AssociatedKeys {
        static var mm_defaultInterval:TimeInterval = 1.0
        static var mm_customInterval = "mm_customInterval"
        static var mm_ignoreInterval = "mm_ignoreInterval"
    }
    var customInterval: TimeInterval {
        get {
            let mm_customInterval = objc_getAssociatedObject(self, &AssociatedKeys.mm_customInterval)
            if let time = mm_customInterval {
                return time as! TimeInterval
            }else{
                return AssociatedKeys.mm_defaultInterval
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.mm_customInterval,  newValue as TimeInterval ,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var ignoreInterval: Bool {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.mm_ignoreInterval) != nil)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.mm_ignoreInterval, newValue as Bool, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    override open class func initialize() {
        if self == UIButton.self {
            DispatchQueue.once(token: NSUUID().uuidString, block: {
                let systemSel = #selector(UIButton.sendAction(_:to:for:))
                let swizzSel = #selector(UIButton.mySendAction(_:to:for:))
                
                let systemMethod = class_getInstanceMethod(self, systemSel)
                let swizzMethod = class_getInstanceMethod(self, swizzSel)
                
                
                let isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod))
                
                if isAdd {
                    class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
                }else {
                    method_exchangeImplementations(systemMethod, swizzMethod);
                }
            })
        }
    }
    
    private dynamic func mySendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        if !ignoreInterval {
            isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+customInterval, execute: { [weak self] in
                self?.isUserInteractionEnabled = true
            })
        }
        mySendAction(action, to: target, for: event)
    }
    
    func layerCornerRadius(radius:Float) { self.layer.cornerRadius = CGFloat(radius) }
    
    
    
    
}
