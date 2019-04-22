//
//  HomeService.swift
//  shop
//
//  Created by TBI on 2017/6/12.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON
/// 单例
final class HomeService {
    static let sharedInstance = HomeService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

extension HomeService: Validator {

    //获取轮播图 banner
    func getHomeInfo() -> Observable<HomeInfoModel>{
        let provider = RxMoyaProvider<HomesRouter>()
        return provider
            .request(.list)
            .debugHttp(true)
            .validateJustReturn(to: HomeInfoModel.self)
        
    }
    
    
    func getVersionInfo() -> Observable<String> {
        
        let provider = RxMoyaProvider<HomesRouter>()
        return provider
            .request(.version)
            .debugHttp(true)
            .validateResponse()
            .map{($0.stringValue)}
    }
    
    /// 获得审批人
    func getApproval(request:QueryApproveVO) ->Observable<QueryApproveResponseVO> {
        let provider = RxMoyaProvider<HomesRouter>()
        return provider
            .request(.getApprovel(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: QueryApproveResponseVO.self)
    }
    
    /// 提交审批
    func submitApproval(request:SubmitApproveVO)->Observable<JSON> {
        let provider = RxMoyaProvider<HomesRouter>()
        return provider
            .request(.submitApproval(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateResponse()
    }
    /// 取消审批
    func revokeApproval(request:QueryApproveVO) -> Observable<QueryApproveResponseVO> {
        let provider = RxMoyaProvider<HomesRouter>()
        return provider
            .request(.revokeApproval(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: QueryApproveResponseVO.self)
    }
    //取消申请
    func cancelRequire(request:QueryApproveVO) -> Observable<QueryApproveResponseVO> {
//        var request:Dictionary<String,Any> = Dictionary()
        let provider = RxMoyaProvider<HomesRouter>()
        return provider
            .request(.cancelRequire(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: QueryApproveResponseVO.self)
    }
    
    /// 首页的订单 数量
    func personalOrderCount() ->Observable<PersonalOrderCountResponseVO>{
        let provider = RxMoyaProvider<HomesRouter>()
        return provider
            .request(.personalOrderCount())
            .debugHttp(true)
            .validateJustReturn(to: PersonalOrderCountResponseVO.self)
    }
    
    func getMainHomeImage() -> Observable<[CarouselResponse]> {
        let provider = RxMoyaProvider<HomesRouter>()
        return provider
            .request(.mainHomeCarouselImage())
            .debugHttp(true)
            .validateJustReturn(to: [CarouselResponse.self])
    }
    func getAppStoreVersion() -> Observable<String> {
        let request:[String:Any] = ["systemType":"1"]
        let provider = RxMoyaProvider<HomesRouter>()
        return provider
            .request(.appStoreVersion(request))
            .debugHttp(true)
            .validateResponse()
            .map({ (json) -> String in
                return json.stringValue
            })
    }
    
    
    func cancelFlight(request:QueryApproveVO) -> Observable<QueryApproveResponseVO> {
        let provider = RxMoyaProvider<HomesRouter>()
        return provider
            .request(.cancelFlightOrder(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: QueryApproveResponseVO.self)
    }
    func cancelCar(request:QueryApproveVO) -> Observable<QueryApproveResponseVO> {
        let provider = RxMoyaProvider<HomesRouter>()
        return provider
            .request(.cancelCarOrder(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: QueryApproveResponseVO.self)
    }
    func cancelHotel(request:QueryApproveVO) -> Observable<QueryApproveResponseVO> {
        let provider = RxMoyaProvider<HomesRouter>()
        return provider
            .request(.cancelHotelOrder(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: QueryApproveResponseVO.self)
    }
    func cancelTrain(request:QueryApproveVO) -> Observable<QueryApproveResponseVO> {
        let provider = RxMoyaProvider<HomesRouter>()
        return provider
            .request(.cancelTrainOrder(request.mj_keyValues() as! [String : Any]))
            .debugHttp(true)
            .validateJustReturn(to: QueryApproveResponseVO.self)
    }
}
