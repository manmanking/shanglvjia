//
//  PersonalSpecialSpotsViewController.swift
//  tutubangs
//
//  Created by manman on 2018/10/22.
//  Copyright © 2018 manman. All rights reserved.
//

import UIKit

class PersonalSpecialSpotsViewController:  PersonalBaseViewController,UIWebViewDelegate {
    
    public var internationalCountry = ""
    public var whereFromView:String = "&back=1"
    private let webView:UIWebView = UIWebView()
    private let localBackButton : UIButton = UIButton()
    
    private let detailPlaceHolder:String = "view_detail"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = PersonalThemeNormalColor
        self.automaticallyAdjustsScrollViewInsets = true
        setUIViewAutolayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        setBackButtonAutolayout()
    }
    func setBackButtonAutolayout() {
        localBackButton.setImage(UIImage(named:"BackCircle"), for: UIControlState.normal)
        localBackButton.addTarget(self, action: #selector(backButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(localBackButton)
        localBackButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset( kNavigationHeight - 44)
            make.left.equalToSuperview().inset( isIPhoneX ? 1 : (ScreenWindowWidth == 375) ? 0 : 4)
            make.width.height.equalTo(44)
        }
    }
        
    func setUIViewAutolayout() {
        webView.delegate = self
        
        let token:String = DBManager.shareInstance.userDetailDraw()?.cusLoginInfo.token ?? ""
        // 全景介绍 更新 2018-10-22
        //"http://60.28.158.166:10081/static/testOrder" + country +
        webView.loadRequest(URLRequest.init(url: URL.init(string:"\(H5_Base_Url)/static/testOrder/overView/view_list.html?country=" + internationalCountry + "&authorization=" + token)!))
        webView.scrollView.bounces = false
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(44-kNavigationHeight)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        printDebugLog(message: " into here ")
        printDebugLog(message: request.httpMethod)
        printDebugLog(message: request.url?.absoluteString)
        
        let requestUrlStr:String = (request.url?.absoluteString)!
        if requestUrlStr.contains("travel_new.html?") == true {
            let requestParameters = requestUrlStr.urlParameters
            printDebugLog(message: requestParameters)
            let detailView = PTravelDetailViewController()
            detailView.idStr = requestParameters!["id"] as! String
            detailView.typeStr = "2"
            self.navigationController?.pushViewController(detailView, animated: true)
            return false
            
        }
        
        if requestUrlStr.contains("view_detail.html?") == true {
            let requestParameters = requestUrlStr.urlParameters
            printDebugLog(message: requestParameters)
            let detailView = PersonalAllViewDetailViewController()
            detailView.urlStr = requestUrlStr
            self.navigationController?.pushViewController(detailView, animated: true)
            return false
            
        }
        if requestUrlStr.contains("travel_new_pic.html?") == true {
            let detailView = PersonalAllViewDetailViewController()
            detailView.urlStr = requestUrlStr
            self.navigationController?.pushViewController(detailView, animated: true)
            return false
            
        }
        
        if requestUrlStr.contains(detailPlaceHolder)  == true {
            localBackButton.isHidden = true
        }else {
            localBackButton.isHidden = false
        }
        if requestUrlStr.contains("http://showmodle/")  == true {
            localBackButton.isHidden = true
            return false
        }
        if requestUrlStr.contains("http://hidemodle/")  == true{
            localBackButton.isHidden = false
            return false
        }
        
        
        return true
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        printDebugLog(message: " into here ")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        printDebugLog(message: " into here ")
        
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        printDebugLog(message: " into here ")
    }
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
//        if webView.canGoBack{
//            webView.goBack()
//        }else{
//            self.navigationController?.popViewController(animated: true)
//        }
    }

}
