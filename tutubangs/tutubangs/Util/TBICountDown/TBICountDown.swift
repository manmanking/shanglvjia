//
//  TBICountDown.swift
//  shanglvjia
//
//  Created by manman on 2018/3/29.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class TBICountDown: NSObject {
    typealias TBICountDownSecondIntervalBlcok = (NSInteger)->Void
    
    public var countDownSecondIntervalBlcok:TBICountDownSecondIntervalBlcok!
    
    private var countdownMax:NSInteger = 0
    
    private var countdownTimer: Timer?
    private var remainingSeconds: Int = 0 {
        willSet{
            //通知视图 同步
            if countDownSecondIntervalBlcok != nil {
                countDownSecondIntervalBlcok(newValue)
            }
            if newValue <= 0{
                isCounting = false
            }
        }
    }
    
    private var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
                remainingSeconds = countdownMax
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                
            }
        }
    }
    
    @objc private func updateTime() {
        remainingSeconds -= 1
    }
    
    ///停止计时
    public func stopCounting() {
        isCounting = false
    }

    /// 获取 计时器 状态
    public func countDownStatus()->Bool{
        return isCounting
    }
    
    ///开始计时
    public func startCounting(seconds:NSInteger) {
        guard seconds > 0 else {
            return
        }
        countdownMax = seconds
        isCounting = true
        
    }
    

}
