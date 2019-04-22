//
//  DebugUtil.swift
//  shanglvjia
//
//  Created by manman on 2018/3/8.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation


func printDebugLog<T>(message: T,
               file: String = #file,
               method: String = #function,
               line: Int = #line)
{
    #if DEBUGTYPE
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}






//MARK:------- 记录接口 缺失 --------


// MARK:---- 现在 主页 缺少
/*
 1、客服电话 接口
 2、企业公告信息
 
 
 */
 // AMRK:--------- 机票 搜索页面
/*
 
 1、差标详情
 2、获取机场列表
 

 */
