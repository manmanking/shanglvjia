//
//  TestDictionaryAble.swift
//  shanglvjia
//
//  Created by akrio on 2017/4/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import XCTest
import SwiftyJSON
import SwiftDate
@testable import shanglvjia
class TestDictionaryAble: XCTestCase {
    
    func testFramework(){
        let p  = Yeye(name: "爷爷", age: 20)
        let p1  = Parent(name: "父亲1", age: 20,yeye:p)
        let p2  = Parent(name: "父亲1", age: 20,yeye:p)
        let pars = [p1,p2]
        let s = Student(name: "学生", age: 20, sex: .faleman, parents: pars)
        print("============")
        print(s.JSONRepresentation)
    }
    func testArrayTest(){
        struct A : JSONSerializable{
            let arr:[String]
        }
        print(A(arr: ["1","2"]).JSONRepresentation)
    }
    /// 测试可选值情况
    func testOption(){
        struct A : JSONSerializable{
            let arr:[String]?
            let b:B?
        }
        struct B : JSONSerializable{
            let a:String?
            let c:C?
        }
        struct C : JSONSerializable{
            let c:String?
        }
        print(A(arr: ["1","2"],b:B(a: "```", c: C(c:"2312"))).JSONRepresentation)
        print(["1","2","3"].joined(separator: "、"))
    }
}

struct Student :JSONSerializable{
    let name:String
    let age:Int
    let sex:Sex
    let parents:[Parent]
}
struct Parent:JSONSerializable {
    let name:String
    let age:Int
    let yeye:Yeye
}
struct Yeye:JSONSerializable {
    let name:String
    let age:Int
}
enum Sex:String{
    case man = "M"
    case faleman = "F"
}
protocol JSONRepresentable {
    var JSONRepresentation: [String: Any] { get }
}
protocol JSONSerializable: JSONRepresentable {
}
extension JSONSerializable {
    var JSONRepresentation: [String: Any] {
        var representation = [String: Any]()
        for case let (label?, value) in Mirror(reflecting: self).children {
            switch value {
            case let value as  Array<Any>:
                print("类型 -> \(type(of: value))")
                var arr:[Any] = []
                value.forEach{model in
                    if let child = model as? JSONRepresentable {
                        arr.append(child.JSONRepresentation)
                    }else {
                        arr.append(model)
                    }
                }
                representation[label] = arr
            case let value as JSONRepresentable:
                representation[label] = value.JSONRepresentation
            case let value as Optional<Any>:
                if let realValue = value{
                    if let v = realValue as? JSONRepresentable {
                        representation[label] = v.JSONRepresentation
                    }else{
                        representation[label] = realValue
                    }
                }else {
                    representation[label] = nil
                }
            case let value as NSObject:
                representation[label] = value
            default:
                // Ignore any unserializable properties
                break
            }
        }
        return representation
    }
}
