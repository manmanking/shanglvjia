//
//  HttpValidate.swift
//  shop
//
//  Created by akrio on 2017/6/1.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Alamofire
import Moya
protocol HttpValidate {
    
}
let isLoginPage = true
extension HttpValidate where Self:UIViewController {
    /// 验证http请求结果
    ///
    /// - Parameters:
    ///   - data: service返回事件
    ///   - success: 数据成功回调
    func validateHttp(_ e:Swift.Error,handler:@escaping ((UIAlertAction) -> Void) = {_ in }) throws{
        
        let alertController = UIAlertController(title: "提示", message: e.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确认", style: .default){ action in
            handler(action)
            alertController.removeFromParentViewController()
        }
        alertController.addAction(okAction)
        if let error = e as? HttpError {
            switch error {
            case .timeout:
                //判断当前是否已经在登录页了，如果是就不在进行跳转了
                if LoginPageVisable {
                    print("妄图多次跳转登录页")
                    return
                }
                UserDefaults.standard.removeObject(forKey: USERINFO)
                
                LoginPageVisable = true
                let loginView = LoginSVViewController()
                self.navigationController?.pushViewController(loginView, animated: true)
//                let companyAccountView = CompanyAccountViewController()
//                companyAccountView.title = "企业账号登录"
//                self.navigationController?.pushViewController(companyAccountView, animated: true)
//                let vc = LoginViewController()
//                vc.jumpFlag = false
//                self.navigationController?.pushViewController(vc, animated: true)
                JPUSHService.deleteAlias({ (resCode, alias, tags) in
                    print(#function,#line,resCode,alias ?? "",tags)
                }, seq: 1)
                print("登录超时")
                return
            case .serverException(_,let message):
                alertController.message = message
                print("错误 -> \(message)")
            default:
                throw error
            }
        } else if let error = e as? MoyaError {
            switch error {
            case .underlying(let e) :
                if let aerror = e as? NSError {
                    print("code -> \(aerror.code)")
                    print("domain -> \(aerror.domain)")
                    if aerror.code == -1004 {
                        alertController.message = "请求超时"
                    }else if aerror.code == -1009 {
                        alertController.message = "请检查网络连接"
                    }else {
                        alertController.message = "请求超时"
                    }
                }
                
            default:
                alertController.message = "请求超时"
            }
//            if ("The request timed out." == error.localizedDescription) {
//                alertController.message = "请求超时"//"您的手机网络好像不给力"
//            }else if ("似乎已断开与互联网的连接。" == error.localizedDescription){
//                alertController.message = "请检查网络连接"
//            }else {
//                alertController.message = "请求超时"//"差旅专家正在抢修中"
//            }
        } else {
            print(e)
            throw e
        }
        self.present(alertController, animated: true)
        throw e
    }
}


