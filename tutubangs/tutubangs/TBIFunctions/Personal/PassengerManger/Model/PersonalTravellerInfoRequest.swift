//
//  ModifiedTravellerInfoRequest.swift
//  shanglvjia
//
//  Created by manman on 2018/7/24.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON
import SwiftDate

class PersonalTravellerInfoRequest: NSObject,ALSwiftyJSONAble {

    
    ///  (string, optional): yyyy-MM-dd ,
    var birthday:String = ""
    
    ///  (string, optional): 身份证号 ,
    var certNo:String = ""
    
    ///  (string, optional): 中文名 ,
    var chName:String = ""
    
    ///  (string, optional): 英文名姓 ,
    var enNameFirst:String = ""
    
    ///  (string, optional): 英文名 名 ,
    var enNameSecond:String = ""
    
    ///  (string, optional): 港澳通行证 ,
    var gangaoNo:String = ""
    
    /// 性别1男2女 ,
    var gender:String = ""//
    
    
    var id:String = ""
    
    ///  (string, optional): 军人证 ,
    var militaryCard:String = ""
    
    ///  (string, optional): 手机号 ,
    var mobile:String = ""
    
    ///  (string, optional): 护照no ,
    var passportNo:String = ""
    
    ///  (string, optional): 台胞证 ,
    var taiwanNo:String = ""
    
    ///  (string, optional): 台湾通行证 ,
    var taiwanpassNo:String = ""
    
    /// 出生证明
    var bornCert:String = ""
    
    ///回乡证
    var huixiangCert:String = ""
    
    /// 户口簿
    var hukouCert:String = ""
    
    ///出行人与本人关系 关系类型：1：父亲，2：母亲，3：岳父，4：岳母，5：配偶 6:子女，7:自己,0：其他 ,
    var relationType:String = ""
    
    /// 与本人关系 ,
    var gtpPsgType:String = ""
    
    var relationTypeLocal:UserRelationShip = UserRelationShip.Unknow
    
    ///  (integer, optional): 用户id
    var userId:String = ""
    
    var showIdCardName:String = ""
    
    var showIdCardNo:String = ""
    
    var isChild:Bool = false
    
    
    ///  (string, optional): 护照发证国 , CN JP
    var passportCountry:String = ""
    
    ///  护照有效期 yyyy-MM-dd ,
    var passportExpireDate:String = ""
    
    
    /*
     birthday (string, optional): yyyy-MM-dd ,
     bornCert (string, optional): 出生证明 ,
     certNo (string, optional): 身份证号 ,
     chName (string, optional): 中文名 ,
     enNameFirst (string, optional): 英文名姓 ,
     enNameSecond (string, optional): 英文名 名 ,
     gangaoNo (string, optional): 港澳通行证 ,
     gender (integer, optional): 性别1男2女 ,
     huixiangCert (string, optional): 回乡证 ,
     hukouCert (string, optional): 户口本 ,
     id (integer, optional),
     militaryCard (string, optional): 军人证 ,
     mobile (string, optional): 手机号 ,
     passportCountry (string, optional): 护照发证国 ,
     passportExpireDate (string, optional): 护照有效期 yyyy-MM-dd ,
     passportNo (string, optional): 护照no ,
     relationType (integer, optional): 出行人与本人关系1：父亲，2：母亲，3：岳父，4：岳母，5：子女，6：配偶，7：本人，0：ben ,
     taiwanNo (string, optional): 台胞证 ,
     taiwanpassNo (string, optional): 台湾通行证 ,
     userId (integer, optional): 登陆人
     
     */
    

    override init() {
        
    }
    
    required init?(jsonData: JSON) {
        birthday = jsonData["birthday"].stringValue
        certNo = jsonData["certNo"].stringValue
        chName = jsonData["chName"].stringValue
        enNameFirst = jsonData["enNameFirst"].stringValue
        enNameSecond = jsonData["enNameSecond"].stringValue
        gangaoNo = jsonData["gangaoNo"].stringValue
        id = jsonData["id"].stringValue
        militaryCard = jsonData["militaryCard"].stringValue
        mobile = jsonData["mobile"].stringValue
        gender = jsonData["gender"].stringValue
        bornCert = jsonData["bornCert"].stringValue
        huixiangCert = jsonData["huixiangCert"].stringValue
        hukouCert = jsonData["hukouCert"].stringValue
        passportNo = jsonData["passportNo"].stringValue
        taiwanNo = jsonData["taiwanNo"].stringValue
        taiwanpassNo = jsonData["taiwanpassNo"].stringValue
        relationType = jsonData["relationType"].stringValue
        gender = jsonData["gender"].stringValue
        passportCountry = jsonData["passportCountry"].stringValue
        passportExpireDate = jsonData["passportExpireDate"].stringValue
        
        
        
        gtpPsgType = relationType
        relationTypeLocal = UserRelationShip.init(rawValue:jsonData["relationType"].intValue)!
        userId = jsonData["userId"].stringValue
        if birthday.isEmpty == false {
            let birthDayDate:Date = birthday.stringToDate(dateFormat:"YYYY-MM-dd")
            let birthdayTimeInterval = (birthDayDate + 12.year).timeIntervalSince1970
            let currentDate = (Date().timeIntervalSince1970)
            if  currentDate < birthdayTimeInterval{
                isChild = true
            }
        }
       
    }
    
    
    enum UserRelationShip:NSInteger {
        case Father = 1
        case Mother = 2
        case Father_Law = 3
        case Mother_Law = 4
        case Children = 5
        case Wife = 6
        case Myself = 7
        case Other = 0
        case Unknow = 99
        
        init(type:NSInteger){
            if type == 1 {
                self = .Father
            }else if type == 2{
                self = .Mother
            }else if type == 3{
                self = .Father_Law
            }else if type == 4{
                self = .Mother_Law
            }else if type == 5{
                self = .Children
            }else if type == 6{
                self = .Wife
            }else if type == 7{
                self = .Myself
            }else if  type == 0{
                self = .Other
            }else {
                self = .Unknow
            }
        }
        
        init(type:String){
            if type == "父亲" {
                self = .Father
            }else if type == "母亲"{
                self = .Mother
            }else if type == "配偶父亲"{
                self = .Father_Law
            }else if type == "配偶母亲"{
                self = .Mother_Law
            }else if type == "配偶"{
                self = .Wife
            }else if type == "子女"{
                self = .Children
            }else if type == "本人"{
                self = .Myself
            }else if type == "其他" {
                self = .Other
            }else {
                self = .Unknow
            }
        }
        
        func getChineseRelation() -> String {
            switch self {
            case .Father:
                return "父亲"
            case .Mother:
                return "母亲"
            case .Father_Law:
                return "配偶父亲"
            case .Mother_Law:
                return "配偶母亲"
            case .Wife:
                return "配偶"
            case .Children:
                return "子女"
            case .Myself:
                return "本人"
            case .Other:
                return "其他"
            case .Unknow:
                return ""
            }
        }
        
    }
    
    enum IDCardType:NSInteger {
        
        case idCard = 1 //"身份证"
        case Passport = 2 //"护照"
        case HKANDMacaoPassport = 3//"港澳通行证"
        case TaiwanCompatriotsCard = 4 //"台胞证"
        case TaiwanesePass = 5 //"台湾通行证"
        case MilitaryCer  = 6 //"军官证"
        case BackHomeTown = 7 //"回乡证"
        case PermanentResidenceBooklet = 8 //"户口簿" //permanent residence booklet
        case BirthCertificate = 9 //"出生证明"
        case Unknown
        
        init(type:String){
            if type == "身份证" {
                self = .idCard
            }else if type == "护照"{
                self = .Passport
            }else if type == "港澳通行证"{
                self = .HKANDMacaoPassport
            }else if type == "台胞证"{
                self = .TaiwanCompatriotsCard
            }else if type == "台湾通行证"{
                self = .TaiwanesePass
            }else if type == "军官证" {
                self = .MilitaryCer
            }else if type == "回乡证" {
                self = .BackHomeTown
            }else if type == "户口簿" {
                self = .PermanentResidenceBooklet
            }else if type == "出生证明" {
                self = .BirthCertificate
            }else {
                self = .Unknown
            }
        }
        
       
        init(type:NSInteger){
            if type == 1 {
                self = .idCard
            }else if type == 2{
                self = .Passport
            }else if type == 3{
                self = .HKANDMacaoPassport
            }else if type == 4{
                self = .TaiwanCompatriotsCard
            }else if type == 5{
                self = .TaiwanesePass
            }else if type == 6{
                self = .MilitaryCer
            }else if type == 7{
                self = .BackHomeTown
            }else if type == 8{
                self = .PermanentResidenceBooklet
            }else if type == 9{
                self = .BirthCertificate
            }else {
                self = .Unknown
            }
        }
        
        func getChineseName() -> String {
            switch self {
            case .idCard:
                return "身份证"
            case .Passport:
                return "护照"
            case .HKANDMacaoPassport:
                return "港澳通行证"
            case .TaiwanCompatriotsCard:
                return "台胞证"
            case .TaiwanesePass:
                return "台湾通行证"
            case .MilitaryCer:
                return "军官证"
            case .BackHomeTown:
                return "回乡证"
            case .PermanentResidenceBooklet:
                return "户口簿"
            case .BirthCertificate:
                return "出生证明"
            default:
                return ""
            }
        }
        
    }
    
    
    func convertPassengerModel() -> SubmitHotelOrderRequest.HotelPassengerInfo {
        
        let passengerInfo:SubmitHotelOrderRequest.HotelPassengerInfo = SubmitHotelOrderRequest.HotelPassengerInfo()
        passengerInfo.gtpBirthday = self.birthday
        passengerInfo.gtpCertDate = self.passportExpireDate
        passengerInfo.gtpCertNo = self.passportNo
        passengerInfo.gtpCertType = "2"
        passengerInfo.gtpChName = self.chName
        passengerInfo.gtpSex = self.gender
        passengerInfo.gtpEnFirstname = self.enNameFirst
        passengerInfo.gtpEnLastname = self.enNameSecond
        passengerInfo.gtpPhone = self.mobile
        passengerInfo.gtpType = self.isChild  == true ? "1" : "0"
        return passengerInfo
    }
    
    
    
    
    
}
