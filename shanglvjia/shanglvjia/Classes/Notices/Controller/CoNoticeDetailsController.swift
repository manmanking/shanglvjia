//
//  CoNoticeDetailsController.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/20.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CoNoticeDetailsController: CompanyBaseViewController {
    
    /// 公告数据
    var noticeList:[NoticeInfoResponse.TbiNotice] = []
    
    /// 选中的第几条公告
    var currentIndexPage = 0
    
    
    var myContentView:CoNoticeDetailsView!
    let contentYOffset:CGFloat = 20+44

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setNavigationBackButton(backImage: "")
        self.view.backgroundColor = .white
        initView()
    }
    
    func initView() -> Void
    {
        myContentView = CoNoticeDetailsView(frame: CGRect(x: 0, y: contentYOffset, width: ScreenWindowWidth, height: ScreentWindowHeight - contentYOffset))
        self.view.addSubview(myContentView)
        
        myContentView.preItemPage.addOnClickListener(target: self, action: #selector(prePageClk))
        myContentView.nextItemPage.addOnClickListener(target: self, action: #selector(nextPageClk))
        
        setContentView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        initNavigation(title:"公告详情",bgColor:TBIThemeBlueColor,alpha:0,isTranslucent:false)
        setBlackTitleAndNavigationColor(title:"公告详情")
    }
    
    
    func setContentView() -> Void
    {
        let currentNotice:NoticeInfoResponse.TbiNotice = noticeList[currentIndexPage]
        
        myContentView.topBigTitle.text = currentNotice.noticeName
        myContentView.topBigTitle.textAlignment = .center
        myContentView.topBigTitle.numberOfLines = -1
        let startDate:String = convertDateToFormatterDate(date:currentNotice.noticeStartTime )
        myContentView.publicTimeLabel.text = "发布时间:" + startDate
            //"\(currentNotice.noticeStartTime) - \(currentNotice.noticeEndTime)"
        
//        myContentView.publicTimeLabel.text = "发布时间:" + "\(currentNotice.pubDate.year)-\(numChangeTwoDigital(num: currentNotice.pubDate.month))-\(numChangeTwoDigital(num: currentNotice.pubDate.day))"
        myContentView.contentLabel.text = CommonTool.replace(CommonTool.replace(currentNotice.noticeText, withInstring: "<p>", withOut: "") , withInstring: "</p>", withOut: "") 
        
        let preIndex:Int = (currentIndexPage == 0) ? (noticeList.count - 1) : (currentIndexPage - 1)
        let nextIndex:Int = (currentIndexPage+1) % noticeList.count
        
        myContentView.preItemPage.bottomRightsubTitle.text = noticeList[preIndex].noticeName
        myContentView.nextItemPage.bottomRightsubTitle.text = noticeList[nextIndex].noticeName
        
        if currentIndexPage == 0 && myContentView.preItemPage.isHidden == false {
            myContentView.snp.remakeConstraints({ (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(ScreentWindowHeight - contentYOffset - 100)
            })
            myContentView.preItemPage.isHidden = true
            myContentView.preItemPage.snp.remakeConstraints({ (make) in
                make.left.right.top.equalTo(1)
                make.height.equalTo(1)
            })
            
        }else
        {
            myContentView.snp.remakeConstraints({ (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(ScreentWindowHeight - contentYOffset)
            })
            myContentView.preItemPage.snp.remakeConstraints({ (make) in
                make.left.right.top.equalTo(1)
                make.height.equalTo(100)
            })
            myContentView.preItemPage.isHidden = false
        }
        if currentIndexPage == noticeList.count - 1 && myContentView.nextItemPage.isHidden == false {
            myContentView.nextItemPage.isHidden = true
        }else
        {
            myContentView.nextItemPage.isHidden = false
        }
        
       
    }
    
    
    //***********************************
    //将<10的数转换为01的形式
    func numChangeTwoDigital(num:Int) -> String
    {
        if num<10
        {
            return "0\(num)"
        }
        
        return "\(num)"
    }
    
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func convertDateToFormatterDate(date:String) -> String {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let timeInterval:TimeInterval = TimeInterval(date)! / 1000
        let date:Date = Date.init(timeIntervalSince1970: timeInterval)
        let result:String = dateFormatter.string(from: date)
        return result
    }
}

extension CoNoticeDetailsController
{
    //TODO:上一篇
    func prePageClk() -> Void
    {
        //print("^_^ prePageClk")
        let preIndex:Int = (currentIndexPage == 0) ? (noticeList.count - 1) : (currentIndexPage - 1)
        
        self.showLoadingView()
        //延时1秒执行
        let time: TimeInterval = 1.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time)
        {
            //code
            self.hideLoadingView()
            self.currentIndexPage = preIndex
            self.setContentView()
        }
    }
    
    //TODO:下一篇
    func nextPageClk() -> Void
    {
        //print("^_^ nextPageClk")
        let nextIndex:Int = (currentIndexPage+1) % noticeList.count
        
        self.showLoadingView()
        //延时1秒执行
        let time: TimeInterval = 1.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time)
        {
            //code
            self.hideLoadingView()
            self.currentIndexPage = nextIndex
            self.setContentView()
        }
    }
}
