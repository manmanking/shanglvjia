//
//  DefaultConstant.swift
//  shop
//
//  Created by TBI on 2017/4/5.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SwiftDate

/// 日志开关
let  DEBUG = true

let USERINFO = "userInfo"
let HOTLINE = "hotLine"
// true:个人   false:公司
var  PersonalType:Bool = false

let Toyota:String = "FTMS"

let HotelTBIProtocol:String = "TBI"

let DefHotLine = "4006735858"


let AccordTravel:Float = 99999

let EARTH_RADIUS:Double = 6378137.0;

let regionRome = Region(tz: TimeZoneName.current, cal: CalendarName.current, loc: LocaleName.chinese)


//MARK:--字体库
// family:'PingFang TC'

let FontTCMedium = "PingFangTC-Medium"
let FontTCLight = "PingFangTC-Light"
let FontTCUltralight = "PingFangTC-Ultralight"
let FontTCSemibold = "PingFangTC-Semibold"
let FontTCThin = "PingFangTC-Thin"


/*
 font:'PingFangSC'
 */

let FontSCRegular = "PingFangSC-Regular"
let FontSCSemibold = "PingFangSC-Semibold"
let FontSCThin = "PingFangSC-Thin"
let FontSCLight = "PingFangSC-Light"
let FontSCMedium = "PingFangSC-Medium"

/*
 首页权限
 front:order:flight front:order:hotel front:order:train front:order:car
 */

let FrontFlight:String = "app:front:order:flight"
let FrontHotel:String = "app:front:order:hotel"
let FrontTrain:String = "app:front:order:train"
let FrontCar:String = "app:front:order:car"
let FrontApprove:String = "front:menu:shenpi"
let FrontVIP:String = "front:menu:vip"
let FrontOrder:String = "front:menu:dingdan"



 

/// 获得屏幕的宽度
let ScreenWindowWidth = UIScreen.main.bounds.width;

/// 获得屏幕的高度
let ScreentWindowHeight = UIScreen.main.bounds.height;

/// 获得屏幕的尺寸
let ScreenWindowFrame = UIScreen.main.bounds

/// 获得APP的主视图
let KeyWindow = UIApplication.shared.keyWindow

/// 获得屏幕的高度
let NavigationBarHeight:Double = 0//20 + 44

// 之前系统的版本
let SystemVersionKey = "SystemVersionKey"

let isIPhoneX = (max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.height) == 812.0 ? true : false)
/// 导航栏高度
let kNavigationHeight   = isIPhoneX ? 88 : 64


// 主题底色
let TBIThemeBaseColor = UIColor(r:245,g:245,b:249)
//  未选中颜色
let TBIThemeNormalBaseColor = UIColor(r:245,g:245,b:245)
//  选中颜色
let TBIThemeSelectBaseColor = UIColor(r:255,g:247,b:229)
// 子页面 底色
let TBIThemeMinorColor = UIColor(r:245,g:245,b:249)

// 子页面footer字颜色
let TBIThemeFooterColor = UIColor(r:193,g:194,b:213)

// 主要信息字色
let TBIThemePrimaryTextColor = UIColor(r:53,g:53,b:53)

// 蒙层
let TBIThemeBackgroundViewColor = UIColor(r:0,g:0,b:0,alpha:0.6)

// 蒙层
let TBIThemeBackgroundViewPolicyColor = UIColor(r:0,g:0,b:0,alpha:0.8)

// 蒙层
let TBIThemeBackgroundHotColor = UIColor(r:0,g:0,b:0,alpha:0.2)

// 中线突出
let TBIThemeTextThirdClassColor = UIColor(r:54,g:91,b:193,alpha:0.8)


// 次要信息字色
let TBIThemeMinorTextColor = UIColor(r:136,g:136,b:136)

// 红色  退出登录
let TBIThemeRedColor = UIColor(r:241,g:84,b:63)//gb(241,84,63)

// 红色背景
let TBIThemeRedBGColor = UIColor(r:255,g:244,b:242)//gb(241,84,63)

// 辅助 OR 提示 字色
let TBIThemeTipTextColor = UIColor(r:136,g:136,b:136)

// 重点提醒色
let TBIThemePrimaryWarningColor = UIColor(r:241,g:84,b:63)//UIColor(r:255,g:93,b:7)

// 链接色
let TBIThemeLinkColor = UIColor(r:88,g:107,b:148)

// 主题灰色线条
let TBIThemeGrayLineColor = UIColor(r:229,g:229,b:229)

// 主题蓝色
let TBIThemeBlueColor = UIColor(r:253,g:139,b:37)///UIColor(r:54,g:91,b:193) //UIColor(r:70,g:162,b:255)

//  重点突出 蓝色
let TBIThemeDarkBlueColor = UIColor(r:253,g:139,b:37)///UIColor(r:54,g:91,b:193)
// 共享航班、退改规则 蓝色
let TBIThemeShallowBlueColor = UIColor(r:255,g:170,b:0)///UIColor(r:113,g:144,b:242)

// 白色
let TBIThemeWhite = UIColor(r:255,g:255,b:255)

// 主题橘色
let TBIThemeOrangeColor = UIColor(r:241,g:84,b:63)//UIColor(r:255,g:93,b:7)

// 主题橘色
let TBIThemeMinorOrangeColor = UIColor(r:255,g:244,b:242)

// 主题黄色
let TBIThemeYellowColor = UIColor(r:250,g:172,b:45)

//绿色
let TBIThemeGreenColor =  UIColor(r: 49, g: 193, b: 124)//rgb(37,196,122)

// 暗文颜色
let TBIThemePlaceholderTextColor = UIColor(r:187,g:187,b:187)

// 暗文颜色
let TBIThemePlaceholderLabelColor = UIColor(r:169,g:169,b:173)

// 暗文颜色
let TBIThemePlaceholderColor = UIColor(r:205,g:205,b:209)

//APP 按钮指定 灰色
let TBIThemeButtonGrayColor = UIColor(r:221,g:221,b:221)
//APP 按钮指定 灰色
let TBIThemeButtonBGGrayColor = UIColor(r:250,g:250,b:250)

//APP goBackground
let GoBackground = "GoBackground"


//APP goForeground

let GoForeground = "goForeground"

// 首次登陆
let firstTime = "first"

let pushNewMessage:String = "pushNewMessage"


//企业登陆表示
let companyLogin = "companyLogin"
//个人登陆
let personalLogin = "personalLogin"

let firstCompanyLogin = "firstCompanyLogin"

let companySearchCity = "companySearchCity"

let personalSearchCity = "personalSearchCity"


let appScheme = "com.tbi.tj.shop"

let storeVersion = "AppStoreVersion"

let companyHotelSearchKeyword = "companyHotelSearchKeyword"

let personalHotelSearchKeyword = "companyHotelSearchKeyword"

var systemVersion9:Bool = false


/// 城市 历史记录  酒店 火车票 
let userHistoryRecordKey:String = "userHistoryRecordKey"


/// 订单 模块

let orderRefreshListNotificationKey:String = "orderRefreshListNotificationKey"


let notificationJpushHandlerName = "notificationJpushHandlerName"

let notificationAppEnterBackgroundKey = "notificationAppEnterBackgroundKey"

let notificationAppEnterActiveKey = "notificationAppEnterActiveKey"


//酒店 关键字
let HotelCompanySearchCityName = "cityName"
let HotelCompanySearchCityId = "cityId"
let HotelCompanySubsidiarySearchCityId = "Subsidiary"

let HotelCompanySearchCheckinDate = "checkinDate"
let HotelCompanySearchCheckoutDate = "checkoutDate"
let HotelCompanySearchKeyword = "Keyword"


let PersonalNormalHotelCityKey:String = "personalNormalHotelCityKey"




let personalHotelWarmTipDefault:String = "1.入住前48小时可免费取消；入住前24-48小时取消，收取首日房费的20%；入住前0-24小时取消，将收取100%首日房费。\n 2.不可携带宠物。\n 3.带有协议标记的酒店仅适用于丰田员工本人，并限一间。办理入住时，需出示丰田员工卡或名片。\n 4.同行亲友增加订房时，请洽询途途帮客服。客服联系酒店并申请优惠价格，酒店将视其出租率情况给与确认。途途帮客服电话：400-673-5858."

let personalFlightWarmTipDefault:String = "1.中国国籍旅客在预定境内机票/旅游产品时，需使用身份证预定；非中国国籍旅客需使用护照；\n 2.当大陆用户去往香港、澳门等地时，如选择护照出行，须持有7天内前往第三国或地区的机票；否则需使用港澳台通行证；\n 3.如护照有效期至出行结束日不足6个月，请更新证件；\n 4.如证件有效期早于出行日期，请重新更换填写；\n 5.如果中转地是美国或者加拿大，需要出示中转国家的签证."



let servicesPhoneAir:String = "servicesPhoneAir"
let servicesPhoneNWAir:String = "servicesPhoneNWAir"
let servicesPhoneHotel:String = "servicesPhoneHotel"
let servicesPhoneNWHotel:String = "servicesPhoneNWHotel"
let servicesPhoneTrain:String = "servicesPhoneTrain"
let servicesPhoneNWTrain:String = "servicesPhoneNWTrain"
let servicesPhoneCar:String = "servicesPhoneCar"
let servicesPhoneNWCar:String = "servicesPhoneNWCar"
let kMainHomeLogoUrl:String = "kMainHomeLogoUrl"

let hotelBookMaxDate:String = "hotelBookMaxDate"

let personalHotelBookMaxDate:String = "hotelBookMaxDate"


let PersonalContactPersonerNameKey:String = "PersonalContactPersonerNameKey"

let PersonalContactPersonerPhoneKey:String = "PersonalContactPersonerPhoneKey"

let PersonalContactPersonerEmailKey:String = "PersonalContactPersonerEmailKey"



// 签证 有效期在6个月内 不可以生单
let visaPassportMaxDate:NSInteger = 6

let hotelSearchMaxPrice:NSInteger = 200000




//火车票 信息

let trainBookMaxDate:String = "trainBookMaxDate"






func IS_IOS8() -> Bool { return (UIDevice.current.systemVersion as NSString).doubleValue >= 8.0 && (UIDevice.current.systemVersion as NSString).doubleValue < 9.0}
func IS_IOS8Later() -> Bool { return (UIDevice.current.systemVersion as NSString).doubleValue >= 8.0 }

func IS_IOS9() -> Bool { return (UIDevice.current.systemVersion as NSString).doubleValue >= 9.0 }

func IS_IOS11() -> Bool { return (UIDevice.current.systemVersion as NSString).doubleValue >= 11.0 }

//提示框
func popNewAlertView(content:String,titleStr:String,btnTitle:String,imageName:String,nullStr:String)  {
    let aletView = NewAlertView(frame:ScreenWindowFrame)
    aletView.setViewWithContent(content:content,titleStr:titleStr,btnTitle:btnTitle,imageName:imageName,nullStr:nullStr)
    
    KeyWindow?.addSubview(aletView)
}
//提示框 个人版
func popPersonalNewAlertView(content:String,titleStr:String,btnTitle:String)  {
    let aletView = PersonalAlertView(frame:ScreenWindowFrame)
    aletView.setViewWithContent(content:content,titleStr:titleStr,btnTitle:btnTitle)
    
    KeyWindow?.addSubview(aletView)
}
//MARK:-------------NEWOBT--------------

let kUserDetail:String = "UserDetail"
let kUserBaseinfoDetail:String = "UserBaseinfo"











