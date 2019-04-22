//
//  PersonalBaseENUM.swift
//  shanglvjia
//
//  Created by manman on 2018/8/4.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

enum PersonalPassengerCountry:String {
    
    case CountryChina = "中国"//("中国","CN")
    case CountryJapan = "日本"//("日本","JP")
    case Unkown = ""
//
//    private var name:String = ""
//    private var code:String = ""
}
extension PersonalPassengerCountry{
    
    
    
    init(nameType:String) {
        if nameType ==  PersonalPassengerCountry.CountryChina.rawValue {
            self = .CountryChina
        }else if nameType == PersonalPassengerCountry.CountryJapan.rawValue {
            self = .CountryJapan
        }else{
            self = .Unkown
        }
    }
    
    init(codeType:String) {
        if codeType == "CN" {
            self = .CountryChina
        }else if codeType == "JP"{
            self = .CountryJapan
        }else{
            self = .Unkown
        }
        
    }
    
    func getCountryChineseName() -> String {
        switch self {
        case .CountryChina:
            return PersonalPassengerCountry.CountryChina.rawValue
        case .CountryJapan:
            return PersonalPassengerCountry.CountryJapan.rawValue
        case .Unkown:
            return PersonalPassengerCountry.Unkown.rawValue
        }
    }
    func getCountryCode() -> String {
        switch self {
        case .CountryChina:
            return "CN"
        case .CountryJapan:
            return "JP"
        case .Unkown:
            return ""
        }
    }
}
