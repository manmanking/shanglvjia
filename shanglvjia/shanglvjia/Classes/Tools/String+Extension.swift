//
//  String+Extension.swift
//  shop
//
//  Created by TBI on 2017/4/23.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

extension String{
    
    
    
    /// 字符串转化为Date
    func stringToDate(dateFormat:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from:self) ?? Date()
  
    }
    
    /// 计算 飞行时间
    ///
    /// - Parameters:
    ///   - first: 第一段 飞行时间 传入格式 为 “08:08”
    ///   - second:第二段 飞行时间 传入格式 为 “08:08” 可为 “”
    ///   - third: 中间 转机时间 传入格式 为 “188”可为 “”
    /// - Returns: 总的时间 格式。约 ** 小时 ** 分钟
    public static func caculateFlightTime(first:String,second:String,third:String)->String {
        guard first.isEmpty == false else {
            return  ""
        }
        var firstDateCompoment:[String] =  Array() //first.components(separatedBy: ":")
        if first.isEmpty == false {
            firstDateCompoment = first.components(separatedBy: ":")
        }
        
        var secondDateCompoment:[String] =  Array() //first.components(separatedBy: ":")
        if second.isEmpty == false {
            secondDateCompoment = second.components(separatedBy: ":")
        }
        
        var thirdDateCompoment:[String] = Array()
        if let thirdInt = NSInteger(third) {
            let hourInt:NSInteger = thirdInt / 60
            let minInt:NSInteger = thirdInt % 60
            thirdDateCompoment = [hourInt.description,minInt.description]
        }
        
        var hours:NSInteger = 0
        var mins:NSInteger = 0
        if firstDateCompoment.isEmpty == false {
            hours += NSInteger(firstDateCompoment.first!) ?? 0//NSNumber.init(value: ).intValue
            mins += NSInteger(firstDateCompoment.last!) ?? 0 //NSNumber.init(value: ).intValue
        }
        if secondDateCompoment.isEmpty == false {
            hours += NSInteger(secondDateCompoment.first!) ?? 0//NSNumber.init(value: ).intValue
            mins += NSInteger(secondDateCompoment.last!) ?? 0//NSNumber.init(value: ).intValue
        }
        
        if thirdDateCompoment.isEmpty == false {
            hours +=  NSInteger(thirdDateCompoment.first!) ?? 0//NSNumber.init(value:).intValue
            mins += NSInteger(thirdDateCompoment.last!) ?? 0//NSNumber.init(value: ).intValue
        }
        
        var result:String = "约"
        if mins / 60 > 0 {
            hours += mins / 60
        }
        
        if hours > 0 {
            result += (hours.description + "小时")
        }
        if mins % 60 > 0 {
            result +=  ((mins % 60).description + "分")
        }
        return result
    }
    

    

    // MARK: 汉字 -> 拼音
    func chineseToPinyin() -> String {
        
        let stringRef = NSMutableString(string: self) as CFMutableString
        // 转换为带音标的拼音
        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false)
        // 去掉音标
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false)
        let pinyin = stringRef as String
        
        return pinyin
    }
    
    func chineseToUpperPinyin() -> String {
        
        let stringRef = NSMutableString(string: self) as CFMutableString
        // 转换为带音标的拼音
        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false)
        // 去掉音标
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false)
        let pinyin = stringRef as String
        let pinyinArr:Array<String> = pinyin.uppercased().components(separatedBy: " ")
        var  result:String = ""
        for element in pinyinArr
        {
            result += element
        }
        
        return result
    }
    
    func getTextHeigh(font:UIFont,width:CGFloat) -> CGFloat {
        
        if self.characters.count == 0 || self == nil {
            return 0.0
        }
        let normalText: NSString = self as! NSString
        let size = CGSize(width:width,height:1000)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        return stringSize.height
    }
    
    func getTextWidth(font:UIFont,height:CGFloat) -> CGFloat {
        
        if self.characters.count == 0 || self == nil {
            return 0.0
        }
        let normalText: NSString = self as! NSString
        let size = CGSize(width:1000,height:height)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        return stringSize.width
    }
    
    
    
    
    
    
    
    // MARK: 判断是否含有中文
    func isIncludeChineseIn() -> Bool {
        
        for (_, value) in self.characters.enumerated() {
            
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        
        return false
    }
    
    // MARK: 判断是否事中文
    func isChinese() -> Bool {
        if ("\u{4E00}" <= self  && self <= "\u{9FA5}") {
            return true
        }
        return false
    }
    
    // MARK: 获取第一个字符
    func first() -> String {
        let index = self.index(self.startIndex, offsetBy: 1)
        return self.substring(to: index)
    }
    /// 验证字符串是否符合要求
    ///
    /// - Parameter type: 验证规则
    /// - Returns: 是否符合要求
    func validate(_ type:ValidateType) -> Bool {
        return self =~ type.rawValue
    }
    //字符串是否非空
    public var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    
    ///  校验身份证
    ///
    /// - Parameter sfz:
    /// - Returns:
    func validateIDCardNumber()-> Bool{
        
        let value = self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        var length = 0
        if value == ""{
            return false
        }else{
            length = value.characters.count
            if length != 15 && length != 18{
                return false
            }
        }
        
        //省份代码
        let arearsArray = ["11","12", "13", "14",  "15", "21",  "22", "23",  "31", "32",  "33", "34",  "35", "36",  "37", "41",  "42", "43",  "44", "45",  "46", "50",  "51", "52",  "53", "54",  "61", "62",  "63", "64",  "65", "71",  "81", "82",  "91"]
        let valueStart2 = (value as NSString).substring(to: 2)
        var arareFlag = false
        if arearsArray.contains(valueStart2){
            
            arareFlag = true
        }
        if !arareFlag{
            return false
        }
        var regularExpression = NSRegularExpression()
        
        var numberofMatch = Int()
        var year = 0
        switch (length){
        case 15:
            year = Int((value as NSString).substring(with: NSRange(location:6,length:2)))!
            if year%4 == 0 || (year%100 == 0 && year%4 == 0){
                do{
                    regularExpression = try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: .caseInsensitive) //检测出生日期的合法性
                    
                }catch{
                    
                    
                }
                
                
            }else{
                do{
                    regularExpression =  try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: .caseInsensitive) //检测出生日期的合法性
                    
                }catch{}
            }
            
            numberofMatch = regularExpression.numberOfMatches(in: value, options:NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, value.characters.count))
            
            if(numberofMatch > 0) {
                return true
            }else {
                return false
            }
            
        case 18:
            year = Int((value as NSString).substring(with: NSRange(location:6,length:4)))!
            if year%4 == 0 || (year%100 == 0 && year%4 == 0){
                do{
                    regularExpression = try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive) //检测出生日期的合法性
                    
                }catch{
                    
                }
            }else{
                do{
                    regularExpression =  try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive) //检测出生日期的合法性
                    
                }catch{}
            }
            
            numberofMatch = regularExpression.numberOfMatches(in: value, options:NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, value.characters.count))
            
            if(numberofMatch > 0) {
                var lSumQT = 0
                //加权因子
                let R = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
                //校验码
                let sChecker: [Int8] = [49,48,88, 57, 56, 55, 54, 53, 52, 51, 50]
                let paperId = value.utf8CString
                //验证最末的校验码
                for i in 0...16 {
                    lSumQT += (paperId[i] - 48) * R[i]
                }
                if sChecker[lSumQT%11] != paperId[17] {
                    return false
                }
                return true
//                let s =
//                    (Int((value as NSString).substring(with: NSRange(location:0,length:1)))! +
//                        Int((value as NSString).substring(with: NSRange(location:10,length:1)))!) * 7 +
//                        (Int((value as NSString).substring(with: NSRange(location:1,length:1)))! +
//                            Int((value as NSString).substring(with: NSRange(location:11,length:1)))!) * 9 +
//                        (Int((value as NSString).substring(with: NSRange(location:2,length:1)))! +
//                            Int((value as NSString).substring(with: NSRange(location:12,length:1)))!) * 10 +
//                        (Int((value as NSString).substring(with: NSRange(location:3,length:1)))! +
//                            Int((value as NSString).substring(with: NSRange(location:13,length:1)))!) * 5 +
//                        (Int((value as NSString).substring(with: NSRange(location:4,length:1)))! +
//                            Int((value as NSString).substring(with: NSRange(location:14,length:1)))!) * 8 +
//                        (Int((value as NSString).substring(with: NSRange(location:5,length:1)))! +
//                            Int((value as NSString).substring(with: NSRange(location:15,length:1)))!) * 4 +
//                        (Int((value as NSString).substring(with: NSRange(location:6,length:1)))! +
//                            Int((value as NSString).substring(with: NSRange(location:16,length:1)))!) *  2 +
//                        Int((value as NSString).substring(with: NSRange(location:7,length:1)))! * 1
//
//                let Y = s%11
//                var M = "F"
//                let JYM = "10X98765432"
//
//                M = (JYM as NSString).substring(with: NSRange(location:Y,length:1))
//                if M == (value.uppercased() as NSString).substring(with: NSRange(location:17,length:1))
//                {
//                    return true
//                }else{return false}
                
            }else {
                return false
            }  
            
        default:  
            return false  
        }
    }
    
    
}

// Swift代码，IOS8以上  从URL中获取参数

extension String {
    
    /// 从String中截取出参数
    var urlParameters: [String: AnyObject]? {
        // 判断是否有参数
        guard self.contains("?") else {
            return nil
        }
        let start = self.components(separatedBy: "?")
        var params = [String: AnyObject]()
        // 截取参数
        let index = start.last?.startIndex.advanced(by: 1)//advancedBy(1)
        let paramsString = start.last ?? "" //substring(from: index!)
        
        
        
        // 判断参数是单个参数还是多个参数
        if paramsString.contains("&") {
            
            // 多个参数，分割参数
            let urlComponents = paramsString.components(separatedBy:"&")
            
            // 遍历参数
            for keyValuePair in urlComponents {
                // 生成Key/Value
                let pairComponents = keyValuePair.components(separatedBy:"=")
                let key = pairComponents.first?.removingPercentEncoding //stringByRemovingPercentEncoding
                let value = pairComponents.last?.removingPercentEncoding//stringByRemovingPercentEncoding
                // 判断参数是否是数组
                if let key = key, let value = value {
                    // 已存在的值，生成数组
                    if let existValue = params[key] {
                        if var existValue = existValue as? [AnyObject] {
                            
                            existValue.append(value as AnyObject)
                        } else {
                            params[key] = [existValue, value] as AnyObject
                        }
                        
                    } else {
                        
                        params[key] = value as AnyObject
                    }
                    
                }
            }
            
        } else {
            
            // 单个参数
            let pairComponents = paramsString.components(separatedBy:"=")
            
            // 判断是否有值
            if pairComponents.count == 1 {
                return nil
            }
            
            let key = pairComponents.first?.removingPercentEncoding//stringByRemovingPercentEncoding
            let value = pairComponents.last?.removingPercentEncoding//stringByRemovingPercentEncoding
            if let key = key, let value = value {
                params[key] = value as AnyObject
            }
            
        }
        
        
        return params
    }
}



struct MyRegex {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matches(in: input,
                                        options: [],
                                        range: NSMakeRange(0, (input as NSString).length)) {
            return matches.count > 0
        }
        else {
            return false
        }
    }
}
infix operator =~

func =~ (lhs: String, rhs: String) -> Bool {
    return MyRegex(rhs).match(input: lhs) //需要前面定义的MyRegex配合
}

enum ValidateType:String{
    case email = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
    case phone = "^[0-9]{1}[0-9]{10}$"
    case card  = "^[1-9]{1}[0-9]{14}$|^[1-9]{1}[0-9]{16}([0-9]|[xX])$"//"^(\\d{14}|\\d{17})(\\d|[xX])$"
    case idCard = "^[0-9]{15}$)|([0-9]{17}([0-9]|X)$"
}
extension Double {
    func priceText() ->String {
        guard "\(self)".contains(".0") else {
            return self.description
        }
        return Int(self).description
    }
}
