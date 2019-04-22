//
//  UIButton+EnlargeTouchArea.swift
//  shop
//
//  Created by manman on 2017/6/20.
//  Copyright © 2017年 zhangwangwang. All rights reserved.
//

import Foundation
import UIKit

var  topNameKey:Character = "a"
var  leftNameKey:Character = "a"
var  bottomNameKey:Character = "a"
var  rightNameKey:Character = "a"

extension UIButton
{
   
   public func setEnlargeEdge(size:CGFloat) {
        
        
        objc_setAssociatedObject(self, &topNameKey, NSNumber.init(value: Float(size)), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        
        objc_setAssociatedObject(self, &leftNameKey, NSNumber.init(value: Float(size)), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        
        objc_setAssociatedObject(self, &bottomNameKey, NSNumber.init(value: Float(size)), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        
        objc_setAssociatedObject(self, &rightNameKey, NSNumber.init(value: Float(size)), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        
        
        
    }
    
    
   public func setEnlargeEdgeCustom(top:CGFloat,left:CGFloat,bottom:CGFloat,right:CGFloat) {
        
        objc_setAssociatedObject(self, &topNameKey, NSNumber.init(value: Float(top)), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        
        objc_setAssociatedObject(self, &leftNameKey, NSNumber.init(value: Float(left)), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        
        objc_setAssociatedObject(self, &bottomNameKey, NSNumber.init(value: Float(bottom)), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        
        objc_setAssociatedObject(self, &rightNameKey, NSNumber.init(value: Float(right)), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        
    }
    
    func enlargedRect()->CGRect {
        
        let topEdge:NSNumber = objc_getAssociatedObject(self, &topNameKey) as! NSNumber;
        let rightEdge:NSNumber = objc_getAssociatedObject(self, &rightNameKey) as! NSNumber;
        let bottomEdge:NSNumber = objc_getAssociatedObject(self, &bottomNameKey) as! NSNumber;
        let leftEdge:NSNumber = objc_getAssociatedObject(self, &leftNameKey) as! NSNumber;
        if (topEdge != nil  && leftEdge != nil && bottomEdge != nil && rightEdge != nil )
        {
            
            return CGRect.init(x: self.bounds.origin.x - CGFloat(leftEdge.floatValue), y:self.bounds.origin.y - CGFloat(topEdge.floatValue) , width: self.bounds.size.width + CGFloat(leftEdge.floatValue) + CGFloat(rightEdge.floatValue), height:self.bounds.size.height + CGFloat(topEdge.floatValue) + CGFloat(bottomEdge.floatValue))
            
            
        }
        else
        {
            return self.bounds;
        }
    }
    
    
    func hitTest(point:CGPoint, event:UIEvent) -> UIView {
        
        let rect = self.enlargedRect()
        if rect.equalTo(self.bounds) {
            return super.hitTest(point, with: event)!
        }
        return (rect.contains(point) ? self : nil)!
        
    }
}
