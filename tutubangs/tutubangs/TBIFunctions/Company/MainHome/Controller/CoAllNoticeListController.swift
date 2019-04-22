//
//  CoAllNoticeListController.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/20.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class CoAllNoticeListController: CompanyBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    public var noticeList:[NoticeInfoResponse.TbiNotice] = Array()
    private let bag = DisposeBag()
    private let tableViewCellIdentify:String = "tableViewCellIdentify"
    private let tableView:UITableView = UITableView()
    private var myContentView:CoAllNoticeListView! = nil
    private let contentYOffest:CGFloat = 20+44
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setNavigationBackButton(backImage: "")
        setUIViewAutolayout()
        
    }
    
    func setUIViewAutolayout() -> Void
    {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 2
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(CoNoticeItemCell.classForCoder(), forCellReuseIdentifier: "tableViewCellIdentify")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setWhiteTitleAndNavigationColor(title:"公告列表")
        setNavigationBackButton(backImage: "back")
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
    
    
    
    //MARK:-------------UITableViewDataSource--------
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return noticeList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let myCell:CoNoticeItemCell = CoNoticeItemCell(style: .default, reuseIdentifier: tableViewCellIdentify)
        let noticeItem:NoticeInfoResponse.TbiNotice = noticeList[indexPath.row]
        myCell.selectionStyle = UITableViewCellSelectionStyle.none
        myCell.topLeftBigTitle.text = noticeItem.noticeName
        
        myCell.topRightDateLabel.text = convertDateToFormatterDate(date: noticeItem.noticeStartTime)
            //" \(noticeItem.noticeStartTime) - \(noticeItem.noticeEndTime)"   //"\(numChangeTwoDigital(num: noticeItem.pubDate.month))" + "-" + "\(numChangeTwoDigital(num: noticeItem.pubDate.day))"
        myCell.bottomRightsubTitle.text = CommonTool.replace(CommonTool.replace(noticeItem.noticeText, withInstring: "<p>", withOut: "") , withInstring: "</p>", withOut: "") 
        
        
        return myCell
    }
    //MARK:-------------UITableViewDelegate--------
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let vc = CoNoticeDetailsController()
        vc.currentIndexPage = indexPath.row
        vc.noticeList = noticeList
        self.navigationController?.pushViewController(vc, animated: true)
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

