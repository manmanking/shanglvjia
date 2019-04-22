//
//  CGRect+Extension.swift
//  tutubangs
//
//  Created by manman on 2018/10/19.
//  Copyright © 2018 manman. All rights reserved.
//

import Foundation

extension CGRect {
    
    func verifyPointContains(point:CGPoint) -> Bool {
        
        let minX = self.origin.x
        let maxX = self.origin.x + self.size.width
        
        let minY = self.origin.y
        let maxY = self.origin.y + self.size.height
        printDebugLog(message: minX)
        printDebugLog(message: maxX)
        printDebugLog(message: minY)
        printDebugLog(message: maxY)
        printDebugLog(message: point)
        if minX <= point.x && maxX >= point.x && minY <= point.y && maxY >= point.y {
            return true
        }
        return false
        
    }
    
    
    
    
}
