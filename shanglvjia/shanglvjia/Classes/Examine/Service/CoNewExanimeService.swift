//
//  CoNewExanimeService.swift
//  shop
//
//  Created by akrio on 2017/5/27.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

/// 单例
final class CoNewExanimeService {
    static let sharedInstance = CoNewExanimeService()
    private init() {} // 阻止其他对象使用这个类的默认的'()'初始化方法
}

// MARK: - 企业新版审批service
extension  CoNewExanimeService: Validator{
    /// 查询订单列表
    ///
    /// - Parameter form: 查询条件
    /// - Returns: 机票信息
    func search(_ form:CoNewExanimeForm.SearchList) -> Observable<[CoNewExanimeListItem]> {

        let provider = RxMoyaProvider<CoNewExamineRouter>()
        return provider
            .request(.list(form.toDict()))
            .debugHttp(true)
            .validateResponse()
            .map{ json in
                let json = json["orders"]
                return json.arrayValue.flatMap{CoNewExanimeListItem(jsonData:$0)}
        }
    }
    /// 同意订单
    ///
    /// - Parameters:
    ///   - orderNo: 出差单号
    ///   - form: 审批相关数据
    /// - Returns: 审批后订单详情
    func agree(_ orderNo:String, form:CoNewExanimeForm.Agree) ->  Observable<CoNewOrderDetail>{
        var form = form
        let provider = RxMoyaProvider<CoNewExamineRouter>()
        return getNextApvId(orderNo).map{ apvId  ->  Observable<CoNewOrderDetail> in
            form.nextApverId = apvId
            return provider
                .request(.agree(orderNo, form.toDict()))
                .debugHttp()
                .validateJustReturn(to: CoNewOrderDetail.self)
        }.concat()
    }
    /// 拒绝订单
    ///
    /// - Parameters:
    ///   - orderNo: 出差单号
    ///   - form: 审批相关数据
    /// - Returns: 审批后订单详情
    func agree(_ orderNo:String,form:CoNewExanimeForm.Reject) ->  Observable<CoNewOrderDetail>{
        let provider = RxMoyaProvider<CoNewExamineRouter>()
        return provider
            .request(.reject(orderNo, form.toDict()))
            .debugHttp()
            .validateJustReturn(to: CoNewOrderDetail.self)
    }
    /// 获取下级审批人Id
    ///
    /// - Parameter orderNo: 订单号
    /// - Returns: 下级审批人id
    func getNextApvId(_ orderNo:String) -> Observable<String> {
        let provider = RxMoyaProvider<CoNewExamineRouter>()
        return provider
            .request(.nextApver(orderNo))
            .debugHttp(true)
            .validateResponse()
            .map{ $0.stringValue }

    }
    
    //MARK:--------NewOBT------
    
    
    /// 获取审批列表  \
    ///
    /// - Parameters:
    ///   - pageNo:
    ///   - status:
    /// - Returns:
    func getApprovalList(pageNo:NSInteger,status:String)->Observable<ApproveListResponseVO> {
        var requestDic:[String:Any] = ["pageNo":pageNo]
        if status.isEmpty == false {
            requestDic["status"] = status
        }
        
        let provider = RxMoyaProvider<CoNewExamineRouter>()
        return provider
            .request(.approvalList(requestDic))
            .debugHttp(true)
            .validateJustReturn(to: ApproveListResponseVO.self)
    }
    
    
    ///获取审批详情
    func getApprovalDetail(approvalId:String) ->Observable<ApproveDetailResponseVO>{
        let requestDic:[String:Any] = ["orderNo":approvalId]
        let provider = RxMoyaProvider<CoNewExamineRouter>()
        return provider
            .request(.approvalDetail(requestDic))
            .debugHttp(true)
            .validateJustReturn(to: ApproveDetailResponseVO.self)
    }
    
    
    /// 审批 同意
    func approvalOrdersAgree(isAgree:Bool,approvalNo:[String],comment:String)->Observable<(status:String,message:String)> {
        
        var requestDic:[String:Any] = ["approveNos":approvalNo]
        if isAgree == false {
            requestDic["comment"] = comment
        }
        let provider = RxMoyaProvider<CoNewExamineRouter>()
        return provider
            .request(.approvalAgree(requestDic))
            .debugHttp(true)
            .validateResponse()
            .map({ (data) -> (status:String,message:String) in
               return (data["status"].stringValue,data["msg"].stringValue)
            })
    }
    
    /// 审批 拒绝
    func approvalOrdersReject(approvalNo:[String],comment:String)->Observable<(status:String,message:String)> {
        
        let requestDic:[String:Any] = ["approveNos":approvalNo,"comment":comment]
        let provider = RxMoyaProvider<CoNewExamineRouter>()
        return provider
            .request(.approvalReject(requestDic))
            .debugHttp(true)
            .validateResponse()
            .map({ (data) -> (status:String,message:String) in
                return (data["status"].stringValue,data["msg"].stringValue)
            })
    }
    
    
    
}
