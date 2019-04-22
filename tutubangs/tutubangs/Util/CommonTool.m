//
//  CommonTool.m
//  shanglvjia
//
//  Created by tbi on 2018/5/9.
//  Copyright © 2018年 TBI. All rights reserved.
//

#import "CommonTool.h"



@implementation CommonTool
+(NSString *)stampToString:(NSString *)stamp withFormat:(NSString *)format
{
    NSTimeInterval times=([stamp doubleValue]+28800)/1000;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:times];
//    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}
+(CGFloat)contentHeight:(NSString *)content withWidth:(float)width withFont:(float)f
{
    CGRect rect=[content boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:f]} context:nil];
    return rect.size.height;
}
+(NSString *)replaceString:(NSString *)content withInstring:(NSString *)inStr withOut:(NSString *)outStr
{
    return [content stringByReplacingOccurrencesOfString:inStr withString:outStr];
}
+(NSString *)returnRuntime:(NSString *)timeMinute
{
    if (timeMinute.integerValue<60) {
        return [NSString stringWithFormat:@"%ld分",timeMinute.integerValue%60];
    }else{
        return [NSString stringWithFormat:@"%ld时%ld分",timeMinute.integerValue/60,timeMinute.integerValue%60];
    }
    
}
+(NSString *)returnSubString:(NSString *)str withStart:(int)start withLenght:(int)length
{
    return [str substringWithRange:NSMakeRange(start, length)];
}
+(void)removeSubviewsOnBgview:(UIView *)bgView{
    [bgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
+(BOOL)isIdcardNumWith:(NSString *)idcard
{
    NSString *strRegex=@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$";
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",strRegex];
    BOOL rt=[pre evaluateWithObject:idcard];
    return rt;
}
+(void)gradientColor:(UIView *)bgView withOneColor:(UIColor *)oneColor withTwoColor:(UIColor *)twoColor{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = bgView.bounds;
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [bgView.layer addSublayer:gradientLayer];
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0.1);
    gradientLayer.endPoint = CGPointMake(0, 1);
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)oneColor.CGColor,
                             (__bridge id)twoColor.CGColor];
}
+(NSString *)returnString:(NSString *)nullStr replaceStr:(NSString *)replaceStr{
    if(nullStr==nil||[nullStr isKindOfClass:[NSNull class]]||[nullStr isEqualToString:@""])
    {
        return replaceStr;
    }else{
        return nullStr;
        
    }
}
@end
