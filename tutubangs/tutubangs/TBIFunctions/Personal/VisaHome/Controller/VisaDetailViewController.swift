//
//  VisaDetailViewController.swift
//  shanglvjia
//
//  Created by manman on 2018/7/16.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import JavaScriptCore
import RxSwift

class VisaDetailViewController: PersonalBaseViewController,UIWebViewDelegate {
    
    
    public var visaItem:VisaProductListResponse.BaseVisaProductListVo = VisaProductListResponse.BaseVisaProductListVo()
    
    private let customProtocolTipDefault:String = "newspage"

    private let webView:UIWebView = UIWebView()
    
    private var travelSuranceArr:[VisaOrderAddResquest.TravelSuranceResponse] = Array()
    
    private let intoBookViewVerifyURL:String = "productdetail"
    private let intoBookViewVerifyDebugURL:String = "newspage"
     private let bag = DisposeBag()
    ///发票类型数组
    public var invoiceArr:[PTravelNearbyDetailModel.InvoicesModel] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBackButton(backImage: "")
        setBlackTitleAndNavigationColor(title: "签证详情")
//        if visaItem.visaName.isEmpty == false {
//            setBlackTitleAndNavigationColor(title: visaItem.visaName)
//        }else{
//            setBlackTitleAndNavigationColor(title: "签证详情")
//        }
        
        setUIViewAutolayout()
        getVisaDetail(productId:visaItem.id)
        getVisaDetailInvoices(productId:visaItem.id)
        loadDataSourcesNET()
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func loadDataSourcesNET() {
        let token:String = DBManager.shareInstance.userDetailDraw()?.cusLoginInfo.token ?? ""
        var requestURL:URLRequest = URLRequest.init(url: URL.init(string: "\(H5_Base_Url)/static/testOrder/order/orderDetail.html?id=" + visaItem.id + "&token=" + token)!)
        requestURL.cachePolicy = URLRequest.CachePolicy.useProtocolCachePolicy
        webView.loadRequest(requestURL)
    }
    
    
    func setUIViewAutolayout() {
        webView.delegate = self
        cleanCacheAndCookie()
       
        //webView.loadRequest(URLRequest.init(url: URL.init(string: "http://www.baidu.com")!))
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        printDebugLog(message: " into here ")
        printDebugLog(message: request.httpMethod)
        printDebugLog(message: request.url?.absoluteString)
        
        let requestUrlStr:String = (request.url?.absoluteString)!
    
        
        if requestUrlStr.contains(intoBookViewVerifyURL) == true {
            let requestParameters = requestUrlStr.urlParameters
            printDebugLog(message: requestParameters)
            let peopleCount:NSInteger = NSInteger(requestParameters!["num"] as! String) ?? 1
            let writeOrderView = VisaWriteInfoViewController()
            writeOrderView.delayDay = NSInteger(requestParameters!["useTime"] as! String) ?? 1
            writeOrderView.visaItem = visaItem
            writeOrderView.peopleCount = peopleCount
            writeOrderView.travelSuranceArr = travelSuranceArr
            writeOrderView.needTcconfirm = requestParameters!["needTcconfirm"] as! String
            writeOrderView.invoiceArr = invoiceArr
            self.navigationController?.pushViewController(writeOrderView, animated: true)
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
    
    func cleanCacheAndCookie()  {
        
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        let storage:HTTPCookieStorage = HTTPCookieStorage.shared
        if storage.cookies != nil && (storage.cookies?.count)! > 0 {
            
            storage.deleteCookie((storage.cookies?.last)!)
            
        }

    }
    
    
    func getVisaDetail(productId:String) {
        
        weak var weakSelf = self
        VisaServices.sharedInstance
            .getVisaDetail(productId: productId)
            .subscribe { (event) in
                
                switch event {
                case .next(let element):
                    printDebugLog(message: element)
                    weakSelf?.travelSuranceArr = element
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                    
                }
            }.addDisposableTo(bag)
        
    }
    func getVisaDetailInvoices(productId:String) {
        
        weak var weakSelf = self
        VisaServices.sharedInstance
            .getVisaDetailInvoice(productId: productId)
            .subscribe { (event) in
                
                switch event {
                case .next(let element):
                    printDebugLog(message: element)
                    for invoiceModel in element{
                        let model = PTravelNearbyDetailModel.InvoicesModel(jsonData: "")
                        model?.name = invoiceModel.name
                        model?.value = invoiceModel.value
                        weakSelf?.invoiceArr.append((model)!)
                    }
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                    
                }
            }.addDisposableTo(bag)
        
        
        
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    //MARK: -------- Action ------
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    
}
