//
//  TrainService.swift
//  shop
//
//  Created by TBI on 2017/12/25.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

/// 单例
final class CoTrainService {
    static let sharedInstance = CoTrainService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

// MARK: - 火车票相关service
extension  CoTrainService: Validator{
    
    /// 查询火车票
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 火车票信息
    func search(fromStation: String, toStation: String, travelDate: String, policy: String) -> Observable<QueryTrainResponse> {
        let requestParameter:[String:Any] = ["fromStation":fromStation,"toStation":toStation,"travelDate":travelDate,"policyId":policy]
        
        let provider = RxMoyaProvider<CoTrainRouter>()
        return provider
            .request(.list(requestParameter))
            .debugHttp(true)
            .validateJustReturn(to: QueryTrainResponse.self)
    }
    
    
    /// 获得火车站
    func trainStation() ->Observable<[StaticTrainStation]> {
        let provider = RxMoyaProvider<CoTrainRouter>()
        return provider.request(.trainStation())
                        .validateJustReturn(to: [StaticTrainStation.self])
    }
    
    
    
    /// 提交订单
    ///
    /// - Parameter model:
    /// - Returns:
    func commit(model:SubmitTrainParams) -> Observable<[String]> {
        let provider = RxMoyaProvider<CoTrainRouter>()
        return provider
            .request(.commit(model.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateResponse()
            .map({ (json) -> [String] in
                return [json["backOuterOrderId"].stringValue,json["goOuterOrderId"].stringValue]
            })
    }
    
    
    /// 占座状态
    ///
    /// - Parameter model:
    /// - Returns:
    func check(model:[String]) -> Observable<CheckStatusResponse> {
        let request:[String:Any] = ["backOuterOrderId":model.first,"goOuterOrderId":model[1]]
        
        let provider = RxMoyaProvider<CoTrainRouter>()
        return provider
            .request(.checkStatus(request))
            .debugHttp(true)
            .validateJustReturn(to: CheckStatusResponse.self)
    }
    
    /// 获取火车站城市名称
    ///
    /// - Returns:
    func stationHot() -> Observable<[CoStationListItem]> {
        guard let cities = UserDefaults.standard.string(forKey: CitySearchType.trainCity.rawValue + "hot") else{
            return self.stationJson()
                .map{ $0.arrayValue.flatMap{CoStationListItem(jsonData:$0)}}
        }
        let jcities = JSON(parseJSON: cities)
        return Observable.just(jcities.arrayValue.flatMap{CoStationListItem(jsonData:$0)})
        
    }
    
    
    /// 获取热门火车票
    ///
    /// - Returns:
    func stationJson() -> Observable<JSON>{
        let provider = RxMoyaProvider<CoTrainRouter>()
        return provider
            .request(.station())
            .debugHttp(true)
            .validateResponse()
            .do(onNext: { (json) in
                UserDefaults.standard.set(json.description, forKey: CitySearchType.trainCity.rawValue + "hot")
        })
    }
    
    /// 获得火车票最大预订 期限
    func getTrainBookMaxDate() ->Observable <NSInteger>{
        let provider = RxMoyaProvider<CoTrainRouter>()
        return provider
            .request(.trainBookMaxDate())
            .debugHttp(true)
            .validateResponse()
            .map({ (json)->NSInteger in
                return json.intValue
            })
    }
    
    
    
}

