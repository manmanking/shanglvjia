//
//  PIntegralDetialViewController.swift
//  shanglvjia
//
//  Created by tbi on 07/09/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit

class PIntegralDetialViewController: PersonalBaseViewController ,UIWebViewDelegate{

    private let webView:UIWebView = UIWebView()
    
    override func viewWillAppear(_ animated: Bool) {
        setBlackTitleAndNavigationColor(title: "")
        self.navigationController?.navigationBar.setNavigationColor(color:TBIThemeBaseColor,alpha:1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = TBIThemeBaseColor
        self.automaticallyAdjustsScrollViewInsets = false
         setUIViewAutolayout()
    }

    func setUIViewAutolayout() {
        webView.delegate = self
        
        let token:String = DBManager.shareInstance.userDetailDraw()?.cusLoginInfo.token ?? ""
        webView.loadRequest(URLRequest.init(url: URL.init(string:"\(H5_Base_Url)/static/testOrder/travel/card.html?token=\(token)")!))
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalToSuperview().offset(-44)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
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
    }

}
