//
//  FeedBackModel.swift
//  shop
//
//  Created by zhanghao on 2017/7/10.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import SwiftyJSON

///个人
struct FeedBackVO : DictionaryAble{
    let id:String
    let contact:String
    let opinion:String
}
///企业
struct CoFeedBackVO : DictionaryAble{
    let name:String
    let company:String
    let phone:String
    let common:String
}
