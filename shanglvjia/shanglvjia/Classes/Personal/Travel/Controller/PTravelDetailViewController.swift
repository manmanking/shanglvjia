//
//  TravelDetailViewController.swift
//  shanglvjia
//
//  Created by manman on 2018/7/27.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PTravelDetailViewController: PersonalBaseViewController,UIWebViewDelegate {

    
    private let travelFreeDetailRequestURL:String = "travel/travel"
    private let travelPlayDetailRequestURL:String = "travel/play"
    //
    
    private let webView:UIWebView = UIWebView()
    
    private let intoBookViewVerifyURL:String = "detail"
    private let intoBookViewVerifyDebugURL:String = "newspage"
    var idStr = ""
    var typeStr = ""
    var productName = ""
    var productPrice = ""
    var travelModel:PTravelIndependentDetailModel = PTravelIndependentDetailModel()
    var nearbyModel:PTravelNearbyDetailModel = PTravelNearbyDetailModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = TBIThemeBlueColor
       
            self.automaticallyAdjustsScrollViewInsets = false
        
        
        setUIViewAutolayout()
        
        if typeStr == "2"{
            loadTravelDetail()
        }else{
            loadNearbyDetail()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initNavigation(title:"",bgColor:TBIThemeBlueColor,alpha:0,isTranslucent:true)
        
        setNavigationBackButton(backImage: "BackCircle")
    }
    
    func setUIViewAutolayout() {
        webView.delegate = self
        
        let token:String = DBManager.shareInstance.userDetailDraw()?.cusLoginInfo.token ?? ""
        webView.loadRequest(URLRequest.init(url: URL.init(string:"\(Html_Base_Url)/static/testOrder/travel/" + (typeStr == "2" ? "travel" : "play") + ".html?id=" + idStr + "&token=" + token + (typeStr == "2" ? "&type=" : ""))!))
        //webView.loadRequest(URLRequest.init(url: URL.init(string: "http://www.baidu.com")!))
        webView.scrollView.bounces = false
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            if IS_IOS11(){
                make.top.equalTo(-kNavigationHeight)
            }else{
                 make.top.equalToSuperview()
            }            
        }
    }
    func loadTravelDetail(){
        weak var weakSelf = self
        PersonalTravelServices.sharedInstance.personalTravelDetail(id: idStr)
            .subscribe{(event) in
                switch event {
                case .next(let result):
                    printDebugLog(message: result.mj_keyValues())
                    weakSelf?.travelModel = result
                case .error( _):
                    break
                case .completed:
                    break
                }
        }
    }
    func loadNearbyDetail(){
        weak var weakSelf = self
        PersonalTravelServices.sharedInstance.personalNearbyDetail(id: idStr)
            .subscribe{(event) in
                switch event {
                case .next(let result):
                    printDebugLog(message: result.mj_keyValues())
                    weakSelf?.nearbyModel = result
                case .error(_):
                    break
                case .completed:
                    break
                }
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        printDebugLog(message: " into here ")
        printDebugLog(message: request.httpMethod)
        printDebugLog(message: request.url?.absoluteString)
        
        let requestUrlStr:String = (request.url?.absoluteString)!
        
        if typeStr == "2"{
            if requestUrlStr.contains(intoBookViewVerifyURL) == true {
                let requestParameters = requestUrlStr.urlParameters
                printDebugLog(message: requestParameters)
                let travelView = PTravelBookViewController()
                travelView.productId = idStr
                travelView.stokeId = requestParameters!["curID"] as! String
                travelView.leaveTime = requestParameters!["date"] as! String
                travelView.productName = (productName.isEmpty ? travelModel.name:productName)
                travelView.travelModel = travelModel
                travelView.unitPrice = productPrice
                travelView.stocks = requestParameters!["stocks"] as! String
                self.navigationController?.pushViewController(travelView, animated: true)
                return false
                
            }
        }else{
            if requestUrlStr.contains(intoBookViewVerifyURL) == true {
                let requestParameters = requestUrlStr.urlParameters
                printDebugLog(message: requestParameters)
                let travelView = PNearbyPlayViewController()
                travelView.productId = idStr
                travelView.leaveTime = requestParameters!["date"] as! String
                travelView.productName = productName
                travelView.unitPrice = requestParameters!["price"] as! String
                travelView.nearbyModel = nearbyModel
                travelView.stokeId = requestParameters!["curID"] as! String
                travelView.stocks = requestParameters!["stocks"] as! String
                self.navigationController?.pushViewController(travelView, animated: true)
                return false
                
            }
        }
        
        if requestUrlStr.contains(PersonalTravelCalendarShowURL) {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            return false
        }
        if requestUrlStr.contains(PersonalTravelCalendarHiddenURL) {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            return false
        }
        if requestUrlStr.contains(travelFreeDetailRequestURL) || requestUrlStr.contains(travelPlayDetailRequestURL) {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
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
