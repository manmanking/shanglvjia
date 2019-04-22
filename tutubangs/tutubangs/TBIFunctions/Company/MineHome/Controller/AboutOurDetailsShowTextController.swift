//
//  AboutOurDetailsShowTextController.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/22.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class AboutOurDetailsShowTextController: CompanyBaseViewController
{
    let contentYOffset:CGFloat = 20 + 44
    var myContentView:UIView! = nil
    
    //显示内容的Label
    var contentLabel:UILabel!
    
    var navTitleStr = "navTitleStr"
    
    //设置文件📁的名字
    var fileNameStr = ""
    var titleStr = "标题"
    var contentStr = "内容"
    
    var mWebView:UIWebView! = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //self.automaticallyAdjustsScrollViewInsets = false
        
        initView()
        
    }
    override func backButtonAction(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func initView() -> Void
    {
        //设置Navgation的头部
        setBlackTitleAndNavigationColor(title:navTitleStr)
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.view.backgroundColor=TBIThemeWhite
        
        //fileNameStr = "aaa.html"
        //读取文本的内容
        let filePath = Bundle.main.path(forResource: fileNameStr, ofType: nil)
//        do
//        {contentStr = try String(contentsOfFile: filePath!, encoding: .utf8)}
//        catch let discription
//        {print(discription)}
        
        //设置内容
        myContentView = UIView()
        self.view.addSubview(myContentView)
        myContentView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        mWebView = UIWebView()
        mWebView.backgroundColor = .white
        myContentView.addSubview(mWebView)
        mWebView.snp.makeConstraints{(make)->Void in
            make.left.equalTo(0)   //20
            make.right.equalTo(0)  //-20
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        mWebView.loadRequest(URLRequest(url: URL(fileURLWithPath: filePath!)))
        
        
    }
}










