//
//  SweepBookingViewController.swift
//  shop
//
//  Created by TBI on 2017/7/24.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class SweepBookingViewController: CompanyBaseViewController {
    
    fileprivate let bag = DisposeBag()
    
    fileprivate var sectionNum:NSInteger = 1
    
    fileprivate var tableView = UITableView()
    
    fileprivate let sweepBookingViewCellIdentify = "sweepBookingViewCellIdentify"
    
    fileprivate var cell:Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.setNavigationColor()
        setBlackTitleAndNavigationColor(title:"扫码下载")
         self.view.backgroundColor = TBIThemeBaseColor
        let localDayStr:String = "2018-06-18 08:30.00"
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm.ss"
        dateFormatter.timeZone = NSTimeZone.local
        let localDate:Date = dateFormatter.date(from: localDayStr)!
        if localDate.compare(Date()) == ComparisonResult.orderedAscending {
            sectionNum = 2
        }
        initTableView()
        initData ()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    

}
extension  SweepBookingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func initData () {
        UserService.sharedInstance
            .version()
            .subscribe{ event in
                if case .next(let e) = event {
                    if e.isAudit {
                        self.cell = 2
                        self.tableView.reloadData()
                    }else {
                        self.cell = 3
                        self.tableView.reloadData()
                    }
                }
                if case .error(let e) = event {
                    
                }
        }.disposed(by: bag)
    }
    
    func initTableView (){
        self.tableView.backgroundColor = TBIThemeBaseColor
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(1)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MineHomeTableViewFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: mineHomeTableViewHeaderViewIdentify)
        tableView.register(SweepBookingViewCell.self, forCellReuseIdentifier: sweepBookingViewCellIdentify)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView:MineHomeTableViewFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: mineHomeTableViewHeaderViewIdentify) as! MineHomeTableViewFooterView
        return footerView
    }
    
    // MARK: 创建cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: sweepBookingViewCellIdentify,for: indexPath) as! SweepBookingViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
//        if indexPath.section == 0 {
//            cell.fillCell(title: "微信服务号", message: "天津津旅商务", imgUrl: "qrcode_jilv")
//        }else if indexPath.section == 1 {
//            cell.fillCell(title: "IOS客户端", message: "推荐朋友扫码下载", imgUrl: "QRCodeiOS")
//        }else if indexPath.section == 2 {
//            cell.fillCell(title: "Android客户端", message: "推荐朋友扫码下载", imgUrl: "QRCodeAndroid")
//        }
        if indexPath.section == 0 {
            cell.fillCell(title: "IOS客户端", message: "推荐朋友扫码下载", imgUrl: "QRCodeiOS")
        }else if indexPath.section == 1 {
            cell.fillCell(title: "Android客户端", message: "推荐朋友扫码下载", imgUrl: "QRCodeAndroid")
        }
        return cell
    }
    // MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: row高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }

}
