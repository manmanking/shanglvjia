//
//  PersonalOrderRouter.swift
//  shanglvjia
//
//  Created by manman on 2018/8/25.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya

enum   PersonalOrderRouter{
    case orderVisaUpload(fileURL:URL) //POST /api/v1/order/expense/upload
    //case orderFlightSuranceDownload(fileName:String) //GET /gds/surance/personDownLoad/{suranceId}
    case updateDelivery([String:Any])//POST /api/v1/order/visa/visa/update/delivery
    case getOrderCount()//GET /api/v1/personal/order/count
    case getIntegralDetail([String:Any])//POST /api/v1/integral/queryDetail
    
}
extension PersonalOrderRouter:TargetType{
    
    
    
    var baseURL: URL {return URL(string: "\(BASE_URL)/tbi-cus-order-api")!}
    
    var path: String {
        switch self {
        case .orderVisaUpload:
            return "/api/v1/order/expense/upload"
        case .updateDelivery:
            return "/api/v1/order/visa/visa/update/delivery"
        case .getOrderCount:
            return "/api/v1/personal/order/count"
        case .getIntegralDetail:
            return "/api/v1/integral/queryDetail"
//        case .orderFlightSuranceDownload(let fileName):
//            return "/gds/surance/personDownLoad/\(fileName)"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .orderVisaUpload,.updateDelivery,.getIntegralDetail:
            return .post
        case .getOrderCount:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .orderVisaUpload,.getOrderCount:
            return nil
        case .updateDelivery(let params),.getIntegralDetail(let params):
            return params
            
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .orderVisaUpload,.getOrderCount:
            return  TokenURLEncoding.default
        case .updateDelivery,.getIntegralDetail:
            return TokenJSONEncoding.default
        }
    }
    
    /// 请求类型 如普通请求，发送文件，下载文件
    var task: Task {
        switch self {
        case .orderVisaUpload(let fileURL):
           
            //文件2
            let formData = MultipartFormData(provider: .file(fileURL), name: "thumbnail",
                                              fileName: "pickedimage.png", mimeType: "image/png")
            return .upload(UploadType.multipart([formData]))
            //.upload(UploadType.file(fileURL))
//        case .orderFlightSuranceDownload(let fileName):
//            return .download(.request(DefaultDownloadDestination))
        case .updateDelivery(_),.getOrderCount,.getIntegralDetail:
            return .request
        }
    }
    /// 单元测试所需
    var sampleData: Data {
            return Data()
        
//        switch self {
////        case .orderFlightSuranceDownload:
////            return animatedBirdData()
////        case .orderVisaUpload(let fileURL):
//
//        }
    }

//    private let DefaultDownloadDestination: DownloadDestination = { temporaryURL, response -> NSURL in
//        let fileManager = NSFileManager.defaultManager()
//        let directoryURLs = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//        let destination = directoryURLs[0].URLByAppendingPathComponent(response.suggestedFilename!)
//        //overwriting
//        try! fileManager.removeItemAtURL(destination)
//        return destination
//    }

}

