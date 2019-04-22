//
//  PersonlBookNotesViewController.swift
//  shanglvjia
//
//  Created by tbi on 29/08/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit

class PersonlBookNotesViewController: PersonalBaseViewController ,UIWebViewDelegate{

    private let webView:UIWebView = UIWebView()
    public var idStr = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeWhite
        setBlackTitleAndNavigationColor(title: "预订条款")
        setUIViewAutolayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setUIViewAutolayout() {
        webView.delegate = self
        
        webView.loadRequest(URLRequest.init(url: URL.init(string:"\(H5_Base_Url)/static/testOrder/rules/\(idStr).html")!))
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalToSuperview()
        }
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
