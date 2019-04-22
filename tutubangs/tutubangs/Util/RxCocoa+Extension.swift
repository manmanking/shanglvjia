//
//  RxCocoa+Extension.swift
//  shop
//
//  Created by akrio on 2017/4/21.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ControlPropertyType where Self.E == String {
    
    /// 验证非空
    public var fill: Observable<Bool> {
        return self.asObservable().map{ $0.characters.count > 0 }
    }
    /// 验证手机号是否符合
    public var validatePhone: Observable<Bool> {
        return self.asObservable().map{ $0.validate(.phone) }
    }
    /// 验证邮箱是否符合
    public var validateEmail: Observable<Bool> {
        return self.asObservable().map{ $0.validate(.email) }
    }
    
}
