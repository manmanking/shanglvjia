//
//  PTravelVisaDetailViewController.swift
//  shanglvjia
//
//  Created by tbi on 28/08/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit

class PTravelVisaDetailViewController: PersonalBaseViewController,UIWebViewDelegate {

    private let webView:UIWebView = UIWebView()
    public var idStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBlackTitleAndNavigationColor(title: "签证详情")
        setUIViewAutolayout()
    }

    func setUIViewAutolayout() {
        webView.delegate = self
        
        let token:String = DBManager.shareInstance.userDetailDraw()?.cusLoginInfo.token ?? ""
        webView.loadRequest(URLRequest.init(url: URL.init(string:"\(Html_Base_Url)/static/testOrder/order/orderDetail_noPrice.html?id=\(idStr)&token=\(token)")!))
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
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
