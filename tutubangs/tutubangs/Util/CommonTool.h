//
//  CommonTool.h
//  shanglvjia
//
//  Created by tbi on 2018/5/9.
//  Copyright © 2018年 TBI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CommonTool : NSObject
//时间戳转时间格式
+(NSString *)stampToString:(NSString *)stamp withFormat:(NSString *)format;
//文字宽度
+(CGFloat)contentHeight:(NSString *)content withWidth:(float)width withFont:(float)f;
//字符串替换
+(NSString *)replaceString:(NSString *)content withInstring:(NSString *)inStr withOut:(NSString *)outStr;
//时长转换
+(NSString *)returnRuntime:(NSString *)timeMinute;
//字符串截取
+(NSString *)returnSubString:(NSString *)str withStart:(int)start withLenght:(int)length;
//移除子view
+(void)removeSubviewsOnBgview:(UIView *)bgView;
//验证身份证号
+(BOOL)isIdcardNumWith:(NSString *)idcard;
//渐变色
+(void)gradientColor:(UIView *)bgView withOneColor:(UIColor *)oneColor withTwoColor:(UIColor *)twoColor;
//字符串为空的时候返回
+(NSString *)returnString:(NSString *)nullStr replaceStr:(NSString *)replaceStr;
@end
