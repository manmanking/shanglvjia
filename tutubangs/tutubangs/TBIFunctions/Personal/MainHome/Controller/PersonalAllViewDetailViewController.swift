//
//  PersonalAllViewDetailViewController.swift
//  tutubangs
//
//  Created by tbi on 2018/10/26.
//  Copyright © 2018 manman. All rights reserved.
//

import UIKit

class PersonalAllViewDetailViewController: PersonalBaseViewController,UIWebViewDelegate {

    private let webView:UIWebView = UIWebView()
    var urlStr = ""
    private let localBackButton : UIButton = UIButton()
    
    override func viewWillAppear(_ animated: Bool) {
       self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        setUIViewAutolayout()
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
        ///let token:String = DBManager.shareInstance.userDetailDraw()?.cusLoginInfo.token ?? ""
        webView.loadRequest(URLRequest.init(url: URL.init(string:urlStr)!))
        webView.scrollView.bounces = false
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
                make.top.equalTo(44-kNavigationHeight)            
        }
    }


    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        printDebugLog(message: " into here ")
        printDebugLog(message: request.httpMethod)
        printDebugLog(message: request.url?.absoluteString)
    
        
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
