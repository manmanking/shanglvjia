//
//  CoOldFlightForm.swift
//  shop
//
//  Created by akrio on 2017/5/22.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift

struct CoOldFlightForm {
    /// 生成机票订单
    struct Create:DictionaryAble {
        /// 去程航班ID
        var depFlightId:String?
        /// 去程舱位ID
        var depCabinId:String?
        /// 联系人姓名
        var linkmanName = Variable("")
        /// 联系人电话
        var linkmanMobile = Variable("")
        /// 联系人邮箱
        var linkmanEmail = Variable("")
        /// 乘客信息
        var passangers:[Passenger]?
        /// 订单号（有值为在已有订单上添加）
        var orderNo:String?
        /// 回程航班ID（有值为往返程）
        var rtnFlightId:String?
        /// 回程舱位ID（有值为往返程）
        var rtnCabinId:String?
        /// 有值则为违背差旅政策
        var reason = Variable("")
        init(
            depFlightId:String,
            depCabinId:String,
            linkmanName:String,
            linkmanMobile:String,
            linkmanEmail:String,
            passangers:[Passenger],
            orderNo:String? = nil,
            rtnFlightId:String? = nil,
            rtnCabinId:String? = nil,
            reason:String? = nil
            ) {
            self.depFlightId = depFlightId
            self.depCabinId = depCabinId
            self.linkmanName = Variable(linkmanName)
            self.linkmanMobile = Variable(linkmanMobile)
            self.linkmanEmail = Variable(linkmanEmail)
            self.passangers = passangers
            self.orderNo = orderNo
            self.rtnFlightId = rtnFlightId
            self.rtnCabinId = rtnCabinId
            self.reason = Variable(reason ?? "")
        }
        init(){
        }
        /// 乘客信息
        struct Passenger:DictionaryAble {
            /// 乘客ID
            var uid:String
            /// 乘客联系电话
            var mobile:String
            /// 乘客生日 1994-11-14
            var birthday:String
            /// 性别
            var gender:String
            /// 是否购买去程保险
            var depInsurance:Bool
            /// 是否购买回程保险
            var rtnInsurance:Bool
            /// 去程常旅客卡 如果多航段则为多个常旅卡对象
            var depTravelCards:[Card]
            /// 回程常旅客卡 如果多航段则为多个常旅卡对象 没有回程此处为nil
            var rtnTravelCards:[Card]?
            /// 证件号
            var certNo:String
            /// 证件类型
            var certType:Int
            /// 性别
            ///
            /// - man: 男性
            /// - female: 女性
            enum Gender:String {
                case man = "M"
                case female = "F"
            }
            /// 常旅卡信息
            struct Card:DictionaryAble {
                /// 常旅客卡号
                var number:String
                /// 供应商
                var supplier:String
                init() {
                    self.number = ""
                    self.supplier = ""
                }
            }
            init(uid:String,
                 mobile:String,
                 birthday:String,
                 gender:Gender,
                 depInsurance:Bool,
                 rtnInsurance:Bool,
                 depTravelCards:[Card],
                 certNo:String,
                 certType:CertType,
                 rtnTravelCards:[Card]? = nil ) {
                self.uid = uid
                self.mobile = mobile
                self.birthday = birthday
                self.gender = gender.rawValue
                self.depInsurance = depInsurance
                self.rtnInsurance = rtnInsurance
                self.depTravelCards = depTravelCards
                self.rtnTravelCards = rtnTravelCards
                self.certNo = certNo
                self.certType = certType.rawValue
                
                
            }
        }
    }
}
