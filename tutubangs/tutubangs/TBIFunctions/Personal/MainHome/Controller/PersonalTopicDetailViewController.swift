//
//  PersonalTopicDetailViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/15.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalTopicDetailViewController: PersonalBaseViewController,UIWebViewDelegate {

    private let webView:UIWebView = UIWebView()
    public var nationStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = PersonalThemeNormalColor
        self.automaticallyAdjustsScrollViewInsets = false
        setUIViewAutolayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        initNavigation(title:"",bgColor:TBIThemeBlueColor,alpha:0,isTranslucent:true)
        
        setNavigationBackButton(backImage: "BackCircle")
    }
    
    func setUIViewAutolayout() {
        webView.delegate = self
        
        let token:String = DBManager.shareInstance.userDetailDraw()?.cusLoginInfo.token ?? ""
        webView.loadRequest(URLRequest.init(url: URL.init(string:"\(H5_Base_Url)/static/testOrder/special/\(nationStr).html?token=\(token)")!))
        webView.scrollView.bounces = false
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(-kNavigationHeight)
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
        if requestUrlStr.contains("view_list.html?") == true {
            let specialSpotsView = PersonalSpecialSpotsViewController()
            let requestParameters = requestUrlStr.urlParameters
            specialSpotsView.internationalCountry = requestParameters!["country"] as! String
            self.navigationController?.pushViewController(specialSpotsView, animated: true)
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
        //self.navigationController?.popViewController(animated: true)
                if webView.canGoBack{
                    webView.goBack()
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
    }

}
