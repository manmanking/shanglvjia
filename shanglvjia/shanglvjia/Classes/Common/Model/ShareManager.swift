//
//  ShareManager.swift
//  shop
//
//  Created by manman on 2017/7/17.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import MJExtension


enum shareObjectPlantformType:String {
    case WechatSession = "1"
    case WechatTimeLine = "2"
    case QQ  = "3"
}




class ShareManager: NSObject {

    public var shareURL:String = ""
    
    public var productName:String = ""
    
    public var imgUrl:String = ""
    
    
    let  shareMessage  = UILabel(text: "分享成功", color: TBIThemeWhite, size: 13)
    
    
    
    static  let sharedInstance = ShareManager()
    private let shareView:ShareCustomView = ShareCustomView()
    
    
    override init() {
        super.init()
       
    }
    
    
    
    public func showView() {
        setUIViewAutolayout() 
    }
    
   private func setUIViewAutolayout() {
        shareMessage.isHidden = true
        shareMessage.backgroundColor = TBIThemeBackgroundViewColor
        shareMessage.layer.cornerRadius = 5
        shareMessage.layer.masksToBounds = true
        shareMessage.textAlignment = .center
        KeyWindow?.addSubview(shareMessage)
        shareMessage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
    
        KeyWindow?.addSubview(shareView)
        shareView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    
//        weak var weakSelf = self
        shareView.shareCustomViewTypeBlock = { (type:String) in
        
            self.matchPlatform(type:type)
            
        }
        
        
    }
    func matchPlatform(type:String) {
        // 津旅商务  感谢使用津旅商务APP
        switch type {
            case "1":
            shareWebPageToPlatformType(platformType: UMSocialPlatformType.wechatSession, controller: getCurrentViewController(), title: productName, descrbTitle: "分享给你一个性价比超高的旅游线路！", webUrl:shareURL )
            case "2":
            shareWebPageToPlatformType(platformType: UMSocialPlatformType.wechatTimeLine, controller: getCurrentViewController(), title: productName, descrbTitle: "分享给你一个性价比超高的旅游线路！", webUrl:shareURL )
            case "3":
            shareWebPageToPlatformType(platformType: UMSocialPlatformType.QQ, controller: getCurrentViewController(), title: productName, descrbTitle: "分享给你一个性价比超高的旅游线路！", webUrl:shareURL )
            default:
                break
        }
        
        
        
        
    }
    
    
   
    
    
    private func shareWebPageToPlatformType(platformType:UMSocialPlatformType ,controller:UIViewController ,title:String ,
                                    descrbTitle:String,webUrl:String) {
        
        guard UMSocialManager.default().isInstall(platformType) == true  else {
            
            var tipMessage = ""
            switch platformType {
            case .wechatSession,.wechatTimeLine:
                tipMessage = "分享前，请检查微信是否安装"
                break
            case .QQ:
                tipMessage = "分享前，请检查QQ是否安装"
                break
            default:
                tipMessage = "分享前，请检查分享APP是否安装"
            }
            
            
            showSystemAlertView(titleStr: "提示", message: tipMessage)
            return
        }
        let messageObject:UMSocialMessageObject = UMSocialMessageObject()
        
        let thumbURL = "https://mobile.umeng.com/images/pic/home/social/img-1.png"
        var img  = NSData.init()
        if imgUrl.isNotEmpty {
            img = try!  NSData.init(contentsOf: URL.init(string: imgUrl)!)
        }

        
        let shareObject = UMShareWebpageObject.shareObject(withTitle:title, descr: descrbTitle, thumImage: img)
        shareObject?.webpageUrl = webUrl
        messageObject.shareObject = shareObject
        UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: controller) { (result, error) in
            if (error != nil)
            {
                printDebugLog(message:UMSocialLogErrorFlagString)
                
            }
            else
            {
                
                Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ShareManager.dismiss), userInfo: nil, repeats: false)
                self.shareMessage.isHidden = false
                //print((result as! UMSocialUserInfoResponse).originalResponse)
                //print((result as! UMSocialUserInfoResponse).message)
                
            }
        }
    }
    
    /// 分享回掉隐藏
    func  dismiss (){
        shareMessage.isHidden = true
    }
    
    func getCurrentViewController() -> UIViewController {
        
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindowLevelNormal {
            let windows = UIApplication.shared.windows
            for tmpWind in windows {
                if tmpWind.windowLevel == UIWindowLevelNormal {
                    window = tmpWind
                    break
                }
            }
        }
        
        let frontView = window?.subviews.first
        let nextResponder = frontView?.next
        if (nextResponder?.isKind(of: UIViewController.classForCoder()))! {
            return nextResponder as! UIViewController
        }else
        {
            return (window?.rootViewController)!
        }
        
        
        
    }
    
    
    private func showSystemAlertView(titleStr:String,message:String) {
        let alertView = UIAlertView.init(title: titleStr, message: message, delegate: self, cancelButtonTitle: "确定")
        alertView.show()
        
    }
    
    
    
}








