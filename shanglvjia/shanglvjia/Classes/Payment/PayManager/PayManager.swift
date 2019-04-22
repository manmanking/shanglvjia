//
//  PayManager.swift
//  shop
//
//  Created by manman on 2017/7/10.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import KissXML


@objc protocol PayManagerStateProtocol
{
    
   @objc optional func payManagerDidRecvFailureInfo(parameters:Dictionary<String,Any>?)
   @objc optional func payManagerDidRecvSuccessInfo(parameters:Dictionary<String,Any>?)
}




class PayManager: NSObject,WXApiDelegate {

    public var delegate:PayManagerStateProtocol!
    static  let sharedInstance = PayManager()
    
    private override init() {
        super.init()
        configLocationManager()
    }

    
    
    func configLocationManager(){
        
    }
    
    
    
    func aliPayRequest(order:String) {
        
        AlipaySDK.defaultService().payOrder(order, fromScheme: appScheme) { (resultDic) in
            print("支付宝 支付结果",resultDic)
            
            let stateCode:String = resultDic!["resultStatus"] as! String
            
            
             if stateCode == "9000"
             {
               //支付成功
                self.delegate.payManagerDidRecvSuccessInfo!(parameters:nil)
                
                
             }
             else
             {
               //支付失败
                self.delegate.payManagerDidRecvFailureInfo!(parameters: nil)
                
                }
            
            
//            self.delegate.payManagerDidRecvSuccessInfo(parameters: )
            //self.delegate.payManagerDidRecvFailureInfo(parameters: )
            
            
            
            
        }
    }
    
    
    
    //web 返回方法？
    func aliPayResponse(url:URL) {
        
        AlipaySDK.defaultService().processOrder(withPaymentResult: url) { (resultDic) in
            print("web 返回方法？ 支付完成 结果",resultDic)
            
            
            self.delegate.payManagerDidRecvSuccessInfo(parameters: )
            self.delegate.payManagerDidRecvFailureInfo(parameters: )
            
        }
        
    }
    
    func wxPayRequst(order:String) {
        
        /*
         :"<weixin><appid>wx8294a942631b1cbf</appid> <noncestr>1f4183315762e30ea441d3caef5e64ad</noncestr> <package>Sign=WXPay</package> <partnerid>1481503392</partnerid> <prepayid>wx2017071111085991dbb75e160839727583</prepayid> <sign>1E92B40A471C06CB99CC8994709945EB</sign> <timestamp>1499742404</timestamp> </weixin>"
         
         */
        
        var appidStr = String.init();
        var nonceStr = String.init();
        var packageStr = String.init();
        var partneridStr = String.init();
        var prepayidStr = String.init();
        var signStr = String.init();
        var timestampStr = String.init();
        
        var tmpStr = order
        tmpStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + tmpStr;
        do {
            let doc =  try DDXMLDocument.init(xmlString: tmpStr, options: 0)
            
            appidStr = (doc.rootElement()?.elements(forName: "appid")[0].stringValue)!;
            nonceStr = (doc.rootElement()?.elements(forName: "noncestr")[0].stringValue)!;
            packageStr = (doc.rootElement()?.elements(forName: "package")[0].stringValue)!;
            partneridStr = (doc.rootElement()?.elements(forName: "partnerid")[0].stringValue)!;
            prepayidStr = (doc.rootElement()?.elements(forName: "prepayid")[0].stringValue)!;
            signStr = (doc.rootElement()?.elements(forName: "sign")[0].stringValue)!;
            timestampStr = (doc.rootElement()?.elements(forName: "timestamp")[0].stringValue)!;
            
            
        } catch _ {
            
        }
        
        
        
        let request:PayReq = PayReq();
        request.openID              = WechatAppKey
        request.partnerId           = WexinPartnerId //[requestParamater objectForKey:@"partnerId"];//
        request.prepayId            = prepayidStr//[requestParamater objectForKey:@"prepayId"];
        request.nonceStr            = nonceStr//[requestParamater objectForKey:@"nonceStr"];
        request.timeStamp           = UInt32(timestampStr)!//timeStamp.intValue;
        request.package             = packageStr
        request.sign                = signStr //[requestParamater objectForKey:@"sign"];
        WXApi.send(request);
        
        
        
        
        
        
    }
    
    
    
    
    
    /*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
     *
     * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
     * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
     * @param req 具体请求内容，是自动释放的
     */
    func onReq(_ req: BaseReq!) {
        
    }
    /*! @brief 发送一个sendReq后，收到微信的回应
     *
     * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
     * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
     * @param resp具体的回应内容，是自动释放的
     */
    func onResp(_ resp: BaseResp!) {
       
        if resp.isKind(of: PayResp.classForCoder())
        {
            
            let result:WXErrCode = WXErrCode(rawValue: resp.errCode)
            switch result {
            case WXSuccess:
                
                printDebugLog(message: "微信支付成功...");
              //  let _:Dictionary<String,Any> = [String(describing: WXSuccess):"Success"];
                // 代理执行 结果
                
                self.delegate.payManagerDidRecvSuccessInfo?(parameters: nil);
                
                break;
            case  WXErrCodeUserCancel:
                printDebugLog(message: "微信支付失败 ...");
                // 代理执行 结果
                let errorInfo:Dictionary<String,Any> = [String(resp.errCode):"Failure"];
                self.delegate.payManagerDidRecvFailureInfo?(parameters: errorInfo);
                break;
            default:
                printDebugLog(message: "default ...")
                //                printDebugLog(message:"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                // 代理执行 结果
                
            }
            
            
        }
        
        
        
        
        
    }
}
