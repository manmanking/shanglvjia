//
//  FAQModel.swift
//  shop
//
//  Created by akrio on 2017/5/1.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
/// 常见问题类型实体
struct FAQGroupItem {
    let groupName:String
    let questions:[FAQQuestionListItem]
    
}
/// 常见问题问题实体
struct FAQQuestionListItem {
    let question:String
    let detail:FAQDetail
}
/// 常见问题详情实体
struct FAQDetail {
    /// 标题
    let title:String
    /// 内容
    let content:String
}
