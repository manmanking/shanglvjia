//
//  TravelDetailViewController.swift
//  shop
//
//  Created by TBI on 2017/6/27.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import JavaScriptCore
import WebKit


class TravelDetailViewController: CompanyBaseViewController {

    fileprivate let bag = DisposeBag()
    
    let webView = UIWebView()//WKWebView()
    
    var jsContext:JSContext!
    
    var travelItem:TravelListItem?
    
    var productId:String?
    
    lazy var leftView:UIView = {
        let vi = UIView()
        vi.backgroundColor = TBIThemeWhite
        let img = UIImageView(imageName: "ic_customer service_grey")
        let textLabel = UILabel(text: "联系客服", color: TBIThemeMinorTextColor, size: 11)
        vi.addSubview(textLabel)
        textLabel.snp.makeConstraints{ (make) in
            make.bottom.equalTo(-8)
            make.centerX.equalToSuperview()
        }
        vi.addSubview(img)
        img.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(textLabel.snp.top).offset(-5)
            make.width.equalTo(22)
            make.height.equalTo(20)
        }
        
        return vi
    }()
    
     let reserveButton:UIButton = UIButton(title: "立即预订",titleColor: TBIThemeWhite,titleSize: 18)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation(title:"旅游详情")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "ic_share", target: self, action: #selector(rightItemClick(sender:)))
        initView()
        
        
        TravelService.sharedInstance.detail(productId ?? "").subscribe{ event in
            switch event{
            case .next(let e):
                self.travelItem = e
            case .error(let e):
                try? self.validateHttp(e)
            case .completed:
                break
            }
        }.addDisposableTo(self.bag)

    }
    
    /// 分享事件触发
    ///
    /// - Parameter sender: 、
    func rightItemClick(sender: UIBarButtonItem) {
        let urlStr =  BASE_WEB_URL + "/detail?share=1&id=\(String(describing: productId ?? ""	))"
        print("分享")
        
        let shareManager =  ShareManager.sharedInstance
        shareManager.shareURL = urlStr
        shareManager.productName = travelItem?.productName ?? ""
        shareManager.imgUrl = travelItem?.imgUrl ?? ""
        shareManager.showView()
        
        
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
//extension TravelDetailViewController: WKUIDelegate {}

extension TravelDetailViewController: UIWebViewDelegate{
    
    func initView(){
        showLoadingView()
        let url = NSURL.init(string: BASE_WEB_URL + "/detail?share=0&id=\(String(describing: productId ?? ""	))")
        if let u = url {
            webView.loadRequest(NSURLRequest.init(url: u as URL) as URLRequest)
        }
        webView.delegate = self
        self.webView.scalesPageToFit = true
        webView.backgroundColor = TBIThemeWhite
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(-54)
        }
        reserveButton.backgroundColor = TBIThemeDarkBlueColor
        view.addSubview(leftView)
        leftView.snp.makeConstraints { (make) in
            make.bottom.left.equalToSuperview()
            make.height.equalTo(54)
            make.width.equalTo(100)
           
        }
        view.addSubview(reserveButton)
        reserveButton.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.height.equalTo(54)
             make.left.equalTo(leftView.snp.right)
        }
       
       leftView.addOnClickListener(target: self, action: #selector(leftButton))
       reserveButton.addTarget(self, action: #selector(reserveButton(sender:)), for: .touchUpInside)
    }
    
    ///  联系客服
    func leftButton() {
        //UIApplication.shared.openURL(NSURL(string :"tel://"+DefHotLine)! as URL)
        getHotLine()
    }
    
    func reserveButton(sender: UIButton) {
        let vc = TravelCategoryViewController()
        vc.travelItem = self.travelItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        hideLoadingView()
        self.title = "加载失败"
    }
    
    // MARK: 绑定JS交互事件
    func webViewDidFinishLoad(_ webView: UIWebView) {
        hideLoadingView()
        self.jsContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        let model = JsModel()
        //weak var weakself = self
       
        model.clickBlock = { () in
            DispatchQueue.main.async(execute: {
                let vc = TravelCategoryViewController()
                vc.travelItem = self.travelItem
                self.navigationController?.pushViewController(vc, animated: true)
            })
            
        }

        
        model.jsContext = self.jsContext
        // 将jiajiao100app注入到JS中，在JS让jiajiao100app以对象的形式存在
        self.jsContext.setObject(model, forKeyedSubscript: "travel" as NSCopying & NSObjectProtocol)
        
        let curUrl = webView.request?.url   //WebView当前访问页面的链接 可动态注册
        if curUrl != nil {
            do {
                try self.jsContext.evaluateScript(String(contentsOf: curUrl!, encoding: String.Encoding.utf8))
                self.jsContext.exceptionHandler = { (context, exception) in
                    print("exception：", exception as Any)
                }
            } catch {
                print("网页加载错误")
            }
            
            
        }

        let meta:String = "document.getElementsByName(\"viewport\")[0].content = \"width=\(ScreenWindowWidth), initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\""
        webView.stringByEvaluatingJavaScript(from: meta)
    }
    
    
}

// 这里必须使用@objc，因为JavaScriptCore库是ObjectiveC版本的。如果不加@objc，则调用无效果
@objc protocol SwiftJavaScriptDelegate:JSExport {
    func click()
}

@objc class JsModel: NSObject, SwiftJavaScriptDelegate {
    
    var jsContext:JSContext!
    
    typealias ClickBlock = () ->Void
    
    var clickBlock:ClickBlock!
    
    func click() {
        clickBlock()
    
    }
}

