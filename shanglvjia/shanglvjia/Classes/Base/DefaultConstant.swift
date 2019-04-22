//
//  DefaultConstant.swift
//  shop
//
//  Created by zhangwangwang on 2017/4/5.
//  Copyright © 2017年 zhangwangwang. All rights reserved.
//

import UIKit

/// 日志开关
let  DEBUG = true;

/// 获得屏幕的宽度
let ScreenWindowWidth = UIScreen.main.bounds.width;

/// 获得屏幕的高度
let ScreentWindowHeight = UIScreen.main.bounds.height;

/// 获得屏幕的尺寸
let ScreenWindowFrame = UIScreen.main.bounds

/// 获得APP的主视图
let KeyWindow = UIApplication.shared.keyWindow

/// 获得屏幕的高度
let NavigationBarHeight:Double = 20 + 44

// 之前系统的版本
let SystemVersionKey = "SystemVersionKey"


// 主题灰色
let ThemeGrayColor = UIColor(r:243,g:244,b:245)










func MMKLog<T>(message: T,
            file: String = #file,
            method: String = #function,
            line: Int = #line)
{
    if DEBUG{
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)");
    }
    
    
}
