//
//  CompanyTravellerRouter.swift
//  shop
//
//  Created by manman on 2017/5/11.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import Moya


//GET /api/v1/company/hotels/calcprice

//v1/new_orders/configs //公司个性化配置

enum CompanyTravellerRouter {
    //查询旅客列表
    case search(uid:String)
    //查询旅客列表分页
    case searchPage(qname:String,pageSize:Int,pageIndex:Int)
    //查询旅客信息
    case searchDetailsBy(uids:String)
    //查询分公司列表
    case subsidiaryList(cityName:String)
    //查询酒店列表
    case searchHotelList(parameters:[String:Any])
    //查询酒店详情
    case detail(id:String,parameters:[String:Any])
    //提交酒店订单
    case commit(parameters:[String:Any])
    //担保金额
    case guaranteeCompany(parameters:[String:Any])
    case companyConfig()
}

extension CompanyTravellerRouter :TargetType
{
    
    /// 请求的基础路径
    var baseURL:URL {return URL(string: "\(BASE_URL)/company")!}
    /// 拼接路径
    var path:String{
        switch self {
        case .search:
            
        print("\(BASE_URL)/company/travellers/search")
            return "/travellers/search"
        case .searchPage:
            return "/travellers/searchPage"
            
        case .subsidiaryList:
            print("\(BASE_URL)/company/hotels/filiale")
            return "/hotels/filiale"
            
        case .searchHotelList,.commit:
            print("\(BASE_URL)/company/hotels")
            return "/hotels"
        case .detail(let id,_):
            return "/hotels/" + "\(id)"
        case .guaranteeCompany:
            return "/hotels/calcprice"
        case .companyConfig:
            return "/new_orders/configs"
        case .searchDetailsBy(let uids):
            return "travellers/\(uids)"
        }
    }
    
    /// 请求方法
    var method:Moya.Method{
        switch self {
        case .search,.searchPage,.subsidiaryList,.searchHotelList,.detail,.guaranteeCompany,.companyConfig,.searchDetailsBy:
            return .get
        case .commit:
            return .post
        }
        
    }
    /// 请求参数
    var parameters:[String:Any]?{
        switch self {
        case .search(let uid):
            let parameter =  ["qname": uid as AnyObject]
            print(parameter)
            return parameter
            
        case .searchPage(let qname,let pageSize,let  pageIndex):
            return ["qname":qname,"pageSize":pageSize,"pageIndex":pageIndex]
            
        case .subsidiaryList(let cityName):
            
            let parameter =  ["cityName": cityName as AnyObject]
            print(parameter)
            return parameter
            
        case .searchHotelList(let parameter),.commit(let parameter):
            print(parameter)
            return parameter
            
        case .detail(_,let parameters):
            return parameters
        case .guaranteeCompany(let parameters):
            return parameters
            
        case .companyConfig,.searchDetailsBy:
            return nil
        }
    }
    /// 请求参数的发送方式
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .search,.searchPage,.subsidiaryList,.searchHotelList,.detail,.companyConfig,.searchDetailsBy,.guaranteeCompany:
            return TokenURLEncoding.default
        case .commit:
            return TokenJSONEncoding.default
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
