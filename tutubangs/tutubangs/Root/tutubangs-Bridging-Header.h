//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#ifndef bridging_Header_h
#define bridging_Header_h
#import <objc/runtime.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AmapSearchKit.h>
#import "UMMobClick/MobClick.h"
#import "UIButton+EnlargeTouchArea.h"
#import "FSCalendar.h"
#import "SDCycleScrollView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WXApi.h"
#import "AlipaySDK/AlipaySDK.h"
#import "TBICollectionViewCell.h"
#import "SGPagingView.h"
#import "CommonTool.h"
#import "PGGCodeScanning.h"
#import "UITextView+ZWPlaceHolder.h"
#import "UITextView+ZWLimitCounter.h"
#import <CoreMotion/CoreMotion.h>


// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
//#import <AdSupport/AdSupport.h>





#endif
