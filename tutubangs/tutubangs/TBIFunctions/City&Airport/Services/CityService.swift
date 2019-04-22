//
//  CityService.swift
//  shop
//
//  Created by akrio on 2017/4/26.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON
/// 单例
final class CityService {
    static let sharedInstance = CityService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

extension  CityService: Validator{
    /// 获取
    ///
    /// - Parameter type: 获取城市信息
    /// - Returns: 城市信息
     func getCityList(_ type:CitySearchType) -> Observable<JSON>{
        let provider = RxMoyaProvider<CitiesRouter>()
        return provider
            .request(.list(["type":type.rawValue,"version":1]))
            .debugHttp(true)
            .validateResponse()
            .do(onNext: { (json) in
                UserDefaults.standard.set(json.description, forKey: type.rawValue)
            })
        
    }
    
    /// 缓存所有城市信息
    ///
    /// - Returns: 是否缓存成功
    func bufferAllCity() -> Observable<Bool> {
        var arr:[Observable<JSON>] = []
        if (UserDefaults.standard.string(forKey: CitySearchType.flightAirport.rawValue) == nil){
            arr.append(getCityList(.flightAirport))
        }
        if (UserDefaults.standard.string(forKey: CitySearchType.flightCity.rawValue) == nil){
            arr.append(getCityList(.flightCity))
        }
        if (UserDefaults.standard.string(forKey: CitySearchType.hotelCity.rawValue) == nil){
            arr.append(getCityList(.hotelCity))
        }
        guard arr.count > 0 else {
            return Observable.just(true)
        }
        return Observable.combineLatest(arr){_ in 
             true
        }
    }

    /// 获取无查询条件时返回的按首字母分组城市结构
    ///
    /// - Parameter type: 查询类型
    /// - Returns: 按首字母分组城市结构
    func getGroups(_ type:CitySearchType) -> Observable<[CityGroup]>{
        guard let cities = UserDefaults.standard.string(forKey: type.rawValue) else{
            return self.getCityList(type)
                .map{ self.citiesToGroups($0.arrayValue.flatMap{City(jsonData:$0)})}
        }
        let jcities = JSON(parseJSON: cities)
        return Observable.just(self.citiesToGroups(jcities.arrayValue.flatMap{City(jsonData:$0)}))
    }

    /// 纯在查询条件按城市排序
    ///
    /// - Parameter searchText: 查询字符串
    /// - Returns: 查询结果
    func getCities(_ searchText:String,type:CitySearchType) ->  Observable<[City]>{
        let searchText = searchText.uppercased()
        guard let cities = UserDefaults.standard.string(forKey: type.rawValue) else{
            return self.getCityList(type)
                .map{ $0.arrayValue.flatMap{City(jsonData:$0)}}
                .map{$0.filter{$0.name.contains(searchText) || $0.code.contains(searchText) || $0.spell.contains(searchText) }}
        }
        let jcities = JSON(parseJSON: cities)
        return Observable.just(jcities.arrayValue.flatMap{City(jsonData:$0)})
            .map{$0.filter{$0.name.contains(searchText) || $0.code.contains(searchText) || $0.spell.contains(searchText) }}
    }
    
    /// 城市转首字母排序格式格式
    ///
    /// - Parameter cities: 待排序城市
    /// - Returns: 排序后的城市组
    private func citiesToGroups(_ cities:[City]) -> [CityGroup]{
        var groups:[CityGroup] = []
        cities.forEach{ cityItem in
            //获取首字母
            let firstCode = cityItem.spell.characters.first?.description ?? "没有首字母"
            if let currentGroup = groups.first(where: {$0.code == firstCode}) {
                currentGroup.cities.append(cityItem)
            } else {
                //如果不存在该字母的项则创建
                groups.append(CityGroup(code: firstCode, cities: [cityItem]))
            }
        }
        //排序
        return  groups.sorted{ $0.code < $1.code}.map{ group in
            group.cities = group.cities.sorted{ $0.spell < $1.spell }
            return group
        }
    }
    
    //MARK:------------NEWOBT----------
    
    /// 获取机场信息
    func getAirport() ->Observable<AirportInfoResponse> {
        
        let provider = RxMoyaProvider<CitiesRouter>()
        
        return provider
            .request(.airPortList)
            //.debugHttp(true)
            .validateJustReturn(to: AirportInfoResponse.self)
    }
    /// 获取酒店城市信息
    func getHotelCity()->Observable<[HotelCityModel]> {
       
        return getHotelCityNET()
    }
    
    func getHotelCityNET()->Observable<[HotelCityModel]> {
        let provider = RxMoyaProvider<CitiesRouter>()
        return provider
            .request(.hotelCity)
            .debugHttp(false)
            .validateJustReturn(to: [HotelCityModel.self])
        //.validateJustReturn(to: [HotelCityModel.self])
    }
    
   
//    /// 获取酒店城市信息
//    func getHotelCity()->Observable<[HotelCityModel]> {
//        guard let cityJsonStr = UserDefaults.standard.string(forKey: PersonalNormalHotelCityKey) else {
//            let cityJsonNET = getHotelCityNET()
//            cityJsonNET.subscribe { (result) in
//                let cityJson = JSON.init(parseJSON: result)
//                return Observable.just(cityJson.arrayValue.map{HotelCityModel.init(jsonData: $0)!})
//            }
//
//            //return Observable.just(cityJson.arrayValue.map{HotelCityModel.init(jsonData: $0)!})
//        }
//        let cityJson = JSON.init(parseJSON: cityJsonStr)
//        return Observable.just(cityJson.arrayValue.map{HotelCityModel.init(jsonData: $0)!})
//
//    }
//
//    func getHotelCityNET()->Observable<String> {
//        let provider = RxMoyaProvider<CitiesRouter>()
//        return provider
//            .request(.hotelCity)
//            .debugHttp(true)
//            .validateResponse()
//            .map({ (json) -> String in
//                UserDefaults.standard.string(forKey:PersonalNormalHotelCityKey)
//                return json.stringValue
//            })
//            //.validateJustReturn(to: [HotelCityModel.self])
//    }
//
//
    
    
    func getHotelLandMark(elongId:String,policyId:String)->Observable<CityCategoryRegionModel> {
        let requestDic:[String:Any] = ["cityId":elongId,"travelPolicyId":policyId]
        
        let provider = RxMoyaProvider<CitiesRouter>()
        return provider
            .request(.landMark(requestDic))
            .debugHttp(true)
            .validateJustReturn(to: CityCategoryRegionModel.self)
        
    }
    
    /// 获取城市酒店差标
    func getHotelTravelPolicy(elongId:String,policyId:String) ->Observable<String>{
        let requestDic:[String:Any] = ["cityId":elongId,"travelPolicyId":policyId,"types":"3"]
        
        let provider = RxMoyaProvider<CitiesRouter>()
        return provider
            .request(.landMark(requestDic))
            .debugHttp(true)
            .validateResponse()
            .map({ (jsonData) -> String in
                return jsonData["travelpolicyLimit"].stringValue
            })
        
    }
    
    
    
    /// 获取地级市
    func getPrefecturelevelCity(cityId:String) -> Observable<(distName:String,distId:String,cityId:String)> {
        let requestDic:[String:Any] = ["cityElongId":cityId]
        
        let provider = RxMoyaProvider<CitiesRouter>()
        return provider
            .request(.prefecturelevelCity(requestDic))
            .debugHttp(true)
            .validateResponse()
            .map({ (json) -> (distName:String,distId:String,cityId:String) in
                return (json["cityName"].stringValue,json["distId"].stringValue,json["cityId"].stringValue)
            })
    }
    
    /// 获取酒店城市信息
    func getSpecialHotelCity(request:[String])->Observable<[HotelCityModel]> {
        let tmpRequest:[String:Any] = ["corpCode":request]
        let provider = RxMoyaProvider<CitiesRouter>()
        return provider
            .request(.specialHotelCity(tmpRequest))
            .debugHttp(true)
            .validateJustReturn(to: [HotelCityModel.self])
    }
    
    
    
    
}
