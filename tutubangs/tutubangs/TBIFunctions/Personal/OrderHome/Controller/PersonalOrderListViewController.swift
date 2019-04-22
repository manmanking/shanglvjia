//
//  PersonalOrderListViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/21.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class PersonalOrderListViewController: PersonalBaseViewController,UIWebViewDelegate {

    private let webView:UIWebView = UIWebView()
    let bag = DisposeBag()
    public var isBack:Bool = false
    ///3待定妥，2待支付
    public var orderStatus:String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        self.automaticallyAdjustsScrollViewInsets = false

        setUIViewAutolayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        if isBack == true{
            setBlackTitleAndNavigationColor(title: "我的订单")
        }else{
            setBlackTitleAndNavigationColor(title: "我的订单")
            setNavigationBackButton(backImage: "")
        }
        let token:String = DBManager.shareInstance.userDetailDraw()?.cusLoginInfo.token ?? ""
        webView.loadRequest(URLRequest.init(url: URL.init(string:"\(H5_Base_Url)/static/testOrder/personalOrder/order_list.html?authorization=" + token + "&orderStatus=" + orderStatus)!))
    }
    func setUIViewAutolayout() {
        webView.delegate = self
        
       
        
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
        printDebugLog(message: " into here ")
        printDebugLog(message: request.httpMethod)
        printDebugLog(message: request.url?.absoluteString)
        
        let requestUrlStr:String = (request.url?.absoluteString)!
        let requestParameters = requestUrlStr.urlParameters
        printDebugLog(message: requestParameters)
        
        if requestUrlStr.contains("order_detail.html") == true
        {
            let detailVC:PersonalOrderDetailViewController = PersonalOrderDetailViewController()
            detailVC.urlString = requestUrlStr
            self.navigationController?.pushViewController(detailVC, animated: true)
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
        self.navigationController?.popToRootViewController(animated: true)
//                if webView.canGoBack{
//                    webView.goBack()
//                }else{
//                    self.navigationController?.popViewController(animated: true)
//                }
    }

    func showPaymentView(orderId:String,price:String) {
        weak var weakSelf = self
        let payView:SelectPaymentView = SelectPaymentView(frame:ScreenWindowFrame)
        
        payView.setView(money: price)
        payView.paymentBlock = { btnTag in
            /// btnTag ==0微信支付 1：支付宝
            var paymentType:PaymentType = PaymentType.OtherPay
            switch btnTag {
            case 0:
                paymentType = PaymentType.Wechat
            case 1:
                paymentType = PaymentType.AliPay
            default:
                break
            }
            weakSelf?.choicePaymentType(type:paymentType, orderId: orderId)
            
        }
        KeyWindow?.addSubview(payView)
    }
    
    func choicePaymentType(type:PaymentType,orderId:String) {
        switch type {
        case PaymentType.AliPay:
            //alipayOrderInfo(type: type)
            break
        case PaymentType.Wechat:
            wechatOrderInfo(type: type, orderId: orderId)
            break
        case PaymentType.Unknow:
            break
        default: break
            
        }
    }
    func wechatOrderInfo(type:PaymentType,orderId:String)  {
        
        weak var weakSelf = self
        PaymentService.sharedInstance
            .wechatPersonalOrderInfo(order: orderId)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                if case .next(let result) = event {
                    print(result)
                    PayManager.sharedInstance.wxPayRequst(order:result)
                }
                if case .error(let result) = event {
                    try? weakSelf?.validateHttp(result)
                }
                
            }.disposed(by: bag)
        
        
    }
}
