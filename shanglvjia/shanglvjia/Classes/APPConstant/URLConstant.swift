//
//  URLConstant.swift
//  shop
//
//  Created by TBI on 2017/4/5.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Alamofire


// 测试环境 老库
//let BASE_URL = "http://60.28.59.67:8088/tbi-shop/api/v1"
//let BASE_WEB_URL = "http://60.28.59.67:8088/tbi-shop/app/"
//let BASE_NEW_URL = "http://60.28.59.67:7050/train/api/v1"
//let BASE_CAR_URL = "http://60.28.59.67:7050/car/api/v1"
//let BASE_USER_URL = "http://60.28.59.67:7050/user/api/v1"

// 测试环境 新库
//let BASE_URL = "http://60.28.59.67:8088/tbi-shop-public/api/v1"
//let BASE_WEB_URL = "http://60.28.59.67:8088/tbi-shop-public/app/"

// 生产环境
//let BASE_URL = "http://www.tbiplus.com/api/v1"
//let BASE_WEB_URL = "http://www.tbiplus.com/app/"
//let BASE_NEW_URL = "http://www.tbiplus.com:7050/train/api/v1"
//let BASE_CAR_URL = "http://www.tbiplus.com:7050/car/api/v1"
//let BASE_USER_URL = "http://www.tbiplus.com:7050/user/api/v1"


// newOBT
//http://172.17.18.166:7071/api/v2/
let IP_ADD = "http://60.28.158.166"
//let IP_ADD = "http://tbi.btravelplus.com"

let BASE_URL = "\(IP_ADD):7050"

let PersonalSpecialHotelCorpCode:String = "TBTJ"//"SFTM"

let PersonaltbiCorpCode:String = "TBI"

let PersonalftmsCorpCode:String = "FTMSPERSONAL"//"FTMS"

/// 改签申请 //TTB_order_ticketChange.html
let PersonalFlightCommonRebookURL:String = "TTB_order_ticketChange"

/// 改签申请
let PersonalFlightInternayionAndSpecialRebookURL:String = "TTB_order_flightAlter_result"

/// 上传 快递单号
let PersonalVisaUploadDeliveryURL:String = "TTB_order_uploadCourierNumber"

/// 改签申请
let PersonalTravelDownloadURL:String = "travelDownload"

let PersonalTravelCalendarShowURL:String = "TTB_travel_calendar_show"

let PersonalTravelCalendarHiddenURL:String = "TTB_travel_calendar_hidden"



///tbi-cus-h5/order/order_detail.html?travelDownload=http://172.17.21.75/static/image/20180903/pythonpythonpythonpythonpythonpython.pdf


/// 订单详情 下载 发票信息
let PersonalOrderDownloadInvoice:String = "TTB_order_downloadInvoice"

/// 订单详情 下载 保险信息
let PersonalOrderDownloadSurances:String = "TTB_order_downloadSurances"

 

// 上线需要 屏蔽
let creditCard_Debug:String = ""//"5254980012170051"

let identityCard_Debug:String = ""//"350722199905162918"

let DEBUG_Account:String = "cad"

let DEBUG_Account_Password:String = "123456"


let DEBUG_Account_Phone:String = "17777788888"

let DEBUG_Idcard_Num:String = "411081199004235955"

let DEBUG_PaymentWechat_Num:String = "CVAS20180720094327"//"CVAS20180720103909"


let BASE_WEB_URL = "http://60.28.59.67:8088/tbi-shop/app/"
let BASE_NEW_URL = "http://60.28.59.67:7050/train/api/v1"
let BASE_CAR_URL = "http://60.28.59.67:7050/car/api/v1"
let BASE_USER_URL = "http://60.28.59.67:7050/user/api/v1"


let TOKEN_KEY = "token"
