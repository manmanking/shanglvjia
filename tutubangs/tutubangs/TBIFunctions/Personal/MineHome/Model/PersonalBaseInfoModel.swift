//
//  PersonalBaseInfoModel.swift
//  shanglvjia
//
//  Created by tbi on 23/08/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class PersonalBaseInfoModel: NSObject,ALSwiftyJSONAble{
    ///address (string, optional): 详细地址 ,
    var address:String = ""
    ///bank (string, optional): 开户银行 ,
    var bank:String = ""
    ///bankAccount (string, optional): 银行账户 ,
    var bankAccount:String = ""
    ///bankFax (string, optional): 银行电话号码 ,
    var bankFax:String = ""
    ///birthday (string, optional): 1990-01-01格式 ,
    var birthday:String = ""
    ///certCardNo (string, optional): 身份证号 ,
    var certCardNo:String = ""
    ///city (string, optional): 城市 ,
    var city:String = ""
    ///cnName (string, optional): 中文名 ,
    var cnName:String = ""
    ///companyAddress (string, optional): 银行地址 ,
    var companyAddress :String = ""
    ///contactPhone (string, optional): 联系电话 ,
    var contactPhone :String = ""
    ///country (string, optional): 国籍 ,
    var country :String = ""
    ///distrct (string, optional): 区域 ,
    var distrct :String = ""
    ///email (string, optional): 邮箱 ,
    var email :String = ""
    ///engFirst (string, optional): 英文名第一个 ,
    var engFirst :String = ""
    ///engSecond (string, optional): 英文第二个 ,
    var engSecond :String = ""
    ///gender (integer, optional): 1男，2女 ,
    var gender :String = ""
    ///id (integer, optional): 主键id ,
    var id :String = ""
    ///invoiceTitle (string, optional): 发票抬头 ,
    var invoiceTitle :String = ""
    ///invoiceType (integer, optional): 0个人，公司 ,
    var invoiceType :String = ""
    ///passportCountry (string, optional): 护照发证国 ,
    var passportCountry :String = ""
    ///passportDate (string, optional): YYYY-MM-DD 护照有效期 ,
    var passportDate :String = ""
    ///passportNo (string, optional): 护照号 ,
    var passportNo :String = ""
    ///province (string, optional): 省 ,
    var province :String = ""
    ///taxIdCode (string, optional): 纳税人识别码
    var taxIdCode :String = ""
    required init?(jsonData: JSON) {
        address = jsonData["address"].stringValue
        bank = jsonData["bank"].stringValue
        bankAccount = jsonData["bankAccount"].stringValue
        bankFax = jsonData["bankFax"].stringValue
        birthday = jsonData["birthday"].stringValue
        certCardNo = jsonData["certCardNo"].stringValue
        city = jsonData["city"].stringValue
        cnName = jsonData["cnName"].stringValue
        companyAddress = jsonData["companyAddress"].stringValue
        contactPhone = jsonData["contactPhone"].stringValue
        country = jsonData["country"].stringValue
        distrct = jsonData["distrct"].stringValue
        email = jsonData["email"].stringValue
        engFirst = jsonData["engFirst"].stringValue
        engSecond = jsonData["engSecond"].stringValue
        gender = jsonData["gender"].stringValue
        id = jsonData["id"].stringValue
        invoiceTitle = jsonData["invoiceTitle"].stringValue
        invoiceTitle = jsonData["invoiceTitle"].stringValue
        passportCountry = jsonData["passportCountry"].stringValue
        passportDate = jsonData["passportDate"].stringValue
        passportNo = jsonData["passportNo"].stringValue
        province = jsonData["province"].stringValue
        taxIdCode = jsonData["taxIdCode"].stringValue
       
    }
    

}
