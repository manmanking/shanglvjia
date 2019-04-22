//
//  RequestLoadingPlugin.swift
//  shanglvjia
//
//  Created by manman on 2018/3/13.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya
import Result

final class RequestLoadingPlugin: PluginType {

    
    func willSend(_ request: RequestType, target: TargetType) {
        printDebugLog(message:  "willSend")
        printDebugLog(message: request)
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        printDebugLog(message:"didReceive")
        printDebugLog(message:result)
        
    }
    
    
}
