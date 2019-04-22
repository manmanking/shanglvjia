//
//  FAQTableViewController.swift
//  shop
//
//  Created by akrio on 2017/5/1.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class CommonProblemsViewController: CompanyBaseViewController,UIWebViewDelegate {
    
    fileprivate let webView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.setNavigationColor()
        setBlackTitleAndNavigationColor(title:"常见问题")
        initView()
    }
    
    func initView() {
        self.showLoadingView()
        let url = NSURL.init(string: BASE_WEB_URL + "/faqList")
        if let u = url {
            webView.loadRequest(NSURLRequest.init(url: u as URL) as URLRequest)
        }
        webView.delegate = self
        self.webView.scalesPageToFit = true
        webView.backgroundColor = TBIThemeWhite
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        hideLoadingView()
        self.title = "加载失败"
    }
    
    // MARK: 绑定JS交互事件
    func webViewDidFinishLoad(_ webView: UIWebView) {
        hideLoadingView()
    }
    
    override func backButtonAction(sender:UIButton) {
        if webView.canGoBack {
            webView.goBack()
        }else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }

}

class FAQTableViewController: UITableViewController {
    
    let bag = DisposeBag()
    
    var groups:[FAQGroupItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let detail1 = FAQDetail(title: "公务出行和个人出行区别", content: "内容内容内容1detailContentdetailContentdetailContentdetailContentdetailContentdetailContentdetailContent")
        let detail2 = FAQDetail(title: "如何开通公务出行相关业务", content: "内容内容内容2")
        let detail3 = FAQDetail(title: "那类人群适合使用公务出行", content: "内容内容内容3")
        let detail4 = FAQDetail(title: "支付的付款付款方式有哪些", content: "内容内容内容4")
        let detail5 = FAQDetail(title: "支付相关", content: "内容内容内容4")
        let detail6 = FAQDetail(title: "退款相关", content: "内容内容内容4")
        let question1 = FAQQuestionListItem(question: "公务出行和个人出行区别", detail: detail1)
        let question2 = FAQQuestionListItem(question: "如何开通公务出行相关业务", detail: detail2)
        let question3 = FAQQuestionListItem(question: "那类人群适合使用公务出行", detail: detail3)
        let question4 = FAQQuestionListItem(question: "支付的付款付款方式有哪些", detail: detail4)
        let question5 = FAQQuestionListItem(question: "支付相关", detail: detail5)
        let question6 = FAQQuestionListItem(question: "退款相关", detail: detail6)
        let group1 = FAQGroupItem(groupName: "出行相关", questions: [question1,question2,question3])
        let group2 = FAQGroupItem(groupName: "支付相关", questions: [question4,question5,question6])
        groups = [group1,group2]
        
        self.title = "常见问题"
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 70, g: 162, b: 255)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.isNavigationBarHidden = false
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor(r: 245, g: 245, b: 249)
        let backButton = UIButton(frame:CGRect(x:0,y:5,width:70,height:18))
            backButton.setImage(#imageLiteral(resourceName: "back"), for: UIControlState.normal)
        backButton.contentHorizontalAlignment = .left
        backButton.setTitle(" 返回", for: .normal)
        backButton.rx.controlEvent(.touchUpInside).subscribe{ _ in
            self.navigationController?.popToRootViewController(animated: true)
            self.navigationController?.isNavigationBarHidden = true
        }.addDisposableTo(bag)
        let backBarButton = UIBarButtonItem.init(customView: backButton)
        // 设置导航栏的leftButton
        self.navigationItem.leftBarButtonItem = backBarButton

    }
    func backButtonAction(sender:UIButton) {
        NSLog("未重写导航条返回按钮点击方法 %s %d",#function,#line)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups[section].questions.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let text = groups[indexPath.section].questions[indexPath.row].question
        var cell:FAQTableViewCell =   FAQTableViewCell(text,reuseIdentifier: "cell")
        if indexPath.row == groups[indexPath.section].questions.count-1 {
            cell = FAQTableViewCell(text,reuseIdentifier: "cell1",hasLine:false)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return FAQHeaderView(groups[section].groupName, reuseIdentifier: "header")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let vi = FAQDetailsViewController()
         vi.detail = groups[indexPath.section].questions[indexPath.row].detail
         self.navigationController?.pushViewController(vi, animated: true)
    }
 
    
}
