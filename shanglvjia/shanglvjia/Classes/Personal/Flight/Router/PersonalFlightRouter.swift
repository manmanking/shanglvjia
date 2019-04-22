//
//  PersonalFlightRouter.swift
//  shanglvjia
//
//  Created by manman on 2018/7/30.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation
import Moya

enum PersonalFlightRouter {
    case personalFlightlList([String:Any])//POST /gds/flight/query/personal
    case sepcialPersonalFlightList(parameters:[String:Any])//GET /gds/flight/query/list
    case sepcialPersonalFlightCabinList(parameters:[String:Any])//POST /gds/flight/query/flightInfo
    case onsalePersonalFlightInfoList(parameters:[String:Any])//POST /gds/flight/query/flightOnsaleInfo
    case personalFlightSubmitOrder([String:Any])//tbi-cus-gds-api:7200  //POST /gds/flight/submit
    case onsalePersonalFlightCabinInfo([String:Any]) //POST /gds/flight/query/flightOnsaleInfoCabins
    case rebookCommonFlightOrder([String:Any])//POST /gds/flight/submit/reorder
    case personalSpecialFlightInfoList([String:Any]) //POST /gds/flight/query/flightInfo
    case personalSpecialReturnFlightInfo([String:Any])//POST /gds/flight/query/flightReturnInfo

}
extension PersonalFlightRouter:TargetType{
    var baseURL: URL {
        return URL(string: "\(BASE_URL)/tbi-cus-gds-api")!
    }
    
    var path: String {
        switch self {
        case .personalFlightlList:
            return "/gds/flight/query/personal"
        case .sepcialPersonalFlightList:
            return "/gds/flight/query/list"
        case .sepcialPersonalFlightCabinList:
            return "/gds/flight/query/flightInfo"
        case .onsalePersonalFlightInfoList:
            return "/gds/flight/query/flightOnsaleInfo"
        case .personalFlightSubmitOrder:
            return "/gds/flight/submit"
        case .onsalePersonalFlightCabinInfo:
            return "/gds/flight/query/flightOnsaleInfoCabins"
        case .rebookCommonFlightOrder:
            return "/gds/flight/submit/reorder"
        case .personalSpecialFlightInfoList:
            return "/gds/flight/query/flightInfo"
        case .personalSpecialReturnFlightInfo:
            return "/gds/flight/query/flightReturnInfo"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .personalFlightlList,.sepcialPersonalFlightCabinList,
             .onsalePersonalFlightInfoList,.rebookCommonFlightOrder,.personalSpecialFlightInfoList:
            return .post
        case .sepcialPersonalFlightList,.personalFlightSubmitOrder,.onsalePersonalFlightCabinInfo,
             .personalSpecialReturnFlightInfo:
            return .post
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .personalFlightlList(let params),.sepcialPersonalFlightList(let params),
             .sepcialPersonalFlightCabinList(let params),.onsalePersonalFlightInfoList(let params),
             .personalFlightSubmitOrder(let params),.onsalePersonalFlightCabinInfo(let params),
             .rebookCommonFlightOrder(let params),.personalSpecialFlightInfoList(let params),
             .personalSpecialReturnFlightInfo(let params):
            return params
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .personalFlightlList,.personalFlightSubmitOrder,
             .sepcialPersonalFlightCabinList,.onsalePersonalFlightInfoList,
             .sepcialPersonalFlightList,.onsalePersonalFlightCabinInfo,
             .rebookCommonFlightOrder,.personalSpecialFlightInfoList,
             .personalSpecialReturnFlightInfo:
            return  TokenJSONEncoding.default
        }
    }
    
    /// 请求类型 如普通请求，发送文件，下载文件
    var task: Task {
        return .request
    }
    /// 单元测试所需
    var sampleData: Data {
        return Data()
    }
    

}
