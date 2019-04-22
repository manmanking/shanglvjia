//
//  ADController.swift
//  shop
//
//  Created by zhanghao on 2017/7/28.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import JavaScriptCore

class ADViewController : CompanyBaseViewController {
    fileprivate let bag = DisposeBag()
    let webView = UIWebView()
    var jsContext:JSContext!
    var tarUrl:String = ""
    var titleString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation(title:"广告详情")
        initView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func backButtonAction(sender:UIButton) {
        if webView.canGoBack {
            webView.goBack()
        }else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

extension ADViewController: UIWebViewDelegate{
    func initView(){
        showLoadingView()
        let url = NSURL.init(string: tarUrl)
        if let u = url {
            webView.loadRequest(NSURLRequest.init(url: u as URL) as URLRequest)
        }
        webView.delegate = self
        self.webView.scalesPageToFit = true
        webView.backgroundColor = TBIThemeWhite
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(0)
        }
    }
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        hideLoadingView()
        self.title = "加载失败"
    }
    
    // MARK: 绑定JS交互事件
    func webViewDidFinishLoad(_ webView: UIWebView) {
        hideLoadingView()
        self.jsContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        let model = AdJsModel()
        //weak var weakself = self
        
//        model.clickBlock = { () in
//            DispatchQueue.main.async(execute: {
//                let vc = TravelCategoryViewController()
//                self.navigationController?.pushViewController(vc, animated: true)
//            })
//        }
        
        model._hrefTravel = {(_ productId: String, _ productType: String) in
            if productType == "1"{
                let travelProductView = TravelDetailViewController()
                travelProductView.productId = productId
                self.navigationController?.pushViewController(travelProductView, animated: false)
            }
            if productType == "2"{
                let specialProductView = SpecialDetailViewController()
                specialProductView.productId = productId
                self.navigationController?.pushViewController(specialProductView, animated: false)
            }
        }
        model._hrefHotelList = {(_ hotelType:String,_ cityId:String,_ cityName:String,_ arrivalDate:String,_ departureDate:String,_ keyWord:String) in
            if hotelType == "1"{
                let hotelListView = HotelListViewController()
                hotelListView.title = cityName
                hotelListView.searchCondition.cityId = cityId
                hotelListView.searchCondition.keyWord = keyWord
                hotelListView.searchCondition.arrivalDate = arrivalDate
                hotelListView.searchCondition.departureDate = departureDate
                self.navigationController?.pushViewController(hotelListView, animated: true)
            }
            if hotelType == "2"{
                let hotelCompanyListView = HotelCompanyListViewController()
                hotelCompanyListView.title = cityName
                hotelCompanyListView.searchCondition.cityId = cityId
                hotelCompanyListView.searchCondition.keyWord = keyWord
                hotelCompanyListView.searchCondition.arrivalDate = arrivalDate
                hotelCompanyListView.searchCondition.departureDate = departureDate
                self.navigationController?.pushViewController(hotelCompanyListView, animated: true)
            }
        }
        model._finish = {() in
            DispatchQueue.main.async(execute: {
                let vc = TravelCategoryViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
        
        
        model.jsContext = self.jsContext
        self.jsContext.setObject(model, forKeyedSubscript: "adv" as NSCopying & NSObjectProtocol)
        
        let curUrl = webView.request?.url   //WebView当前访问页面的链接 可动态注册
        if curUrl != nil {
            self.jsContext.evaluateScript(try? String(contentsOf: curUrl!, encoding: String.Encoding.utf8))
            
            self.jsContext.exceptionHandler = { (context, exception) in
                print("exception：", exception as Any)
            }
        }
        
        let meta:String = "document.getElementsByName(\"viewport\")[0].content = \"width=\(ScreenWindowWidth), initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\""
        webView.stringByEvaluatingJavaScript(from: meta)
    }
}

// 这里必须使用@objc，因为JavaScriptCore库是ObjectiveC版本的。如果不加@objc，则调用无效果
@objc protocol AdSwiftJavaScriptDelegate:JSExport {
    func hrefTravel(_ productId:String,_ productType:String)
    func hrefHotelList(_ hotelType:String,_ cityId:String,_ cityName:String,_ arrivalDate:String,_ departureDate:String,_ keyWord:String)
    func finish()
}

@objc class AdJsModel: NSObject, AdSwiftJavaScriptDelegate {
    var jsContext:JSContext!
    typealias HrefTravel = (_ productId: String, _ productType: String) -> Void
    var _hrefTravel:HrefTravel!
    func hrefTravel(_ productId: String, _ productType: String) {
        _hrefTravel(productId,productType)
    }
    
    typealias HrefHotelList = (_ hotelType:String,_ cityId:String,_ cityName:String,_ arrivalDate:String,_ departureDate:String,_ keyWord:String) -> Void
    var _hrefHotelList:HrefHotelList!
    func hrefHotelList(_ hotelType:String,_ cityId:String,_ cityName:String,_ arrivalDate:String,_ departureDate:String,_ keyWord:String){
        _hrefHotelList(hotelType,cityId,cityName,arrivalDate,departureDate,keyWord)
    }
    
    typealias Finish = () -> Void
    var _finish:Finish!
    func finish(){
        _finish()
    }
}
