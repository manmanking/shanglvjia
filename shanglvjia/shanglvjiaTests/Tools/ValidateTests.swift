//
//  ValidateTests.swift
//  shanglvjia
//
//  Created by akrio on 2017/4/24.
//  Copyright © 2017年 TBI. All rights reserved.
//

import XCTest

class ValidateTests: XCTestCase {
    
    func testEmail(){
        if "admin@hangge.com".validate(.email){
            print("邮箱地址格式正确")
        }else{
            print("邮箱地址格式有误")
        }
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
// MARK: - 扩展字符串
extension String {
    func validate(_ type:ValidateType) -> Bool {
        return self =~ type.rawValue
    }
}
enum ValidateType:String{
    case email = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
    case phone = "^1[0-9]{10}$"

}
