//
//  AboutOurHomeController.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/22.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

//关于我们主界面
class AboutOurHomeController: CompanyBaseViewController
{
    let contentYOffset:CGFloat = 0//20+44
    
    var myContentView:UIView! = nil
    var myTableView:UITableView! = nil
    
    var dataSource:[String] = ["关于津旅商务","服务条款","免责声明","隐私政策"]

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = TBIThemeBaseColor
        DBManager.shareInstance.currentActivePersonal()
        initView()
    }

    func initView() -> Void
    {
        //设置Navgation的头部
        setBlackTitleAndNavigationColor(title:"关于我们")
        navigationController?.setNavigationBarHidden(false, animated: false)
       
        
        
        //设置Content内容
        myContentView = UIView(frame: CGRect(x: 0, y: 1 + contentYOffset, width: ScreenWindowWidth, height: ScreentWindowHeight - contentYOffset))
        self.view.addSubview(myContentView)
        
        myTableView = UITableView()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = TBIThemeBaseColor
        self.myContentView.addSubview(myTableView)
        myTableView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(10)
            make.bottom.equalTo(0)
        }
        
        myTableView.tableFooterView = UIView()
        myTableView.separatorStyle = .none
        myTableView.rowHeight = UITableViewAutomaticDimension
        myTableView.estimatedRowHeight = 44
    }
    override func backButtonAction(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AboutOurHomeController:UITableViewDelegate,UITableViewDataSource
{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = AboutOurHomerCell(style: .default, reuseIdentifier: "a")
        
        cell.leftLabel.text = dataSource[indexPath.row]
        if indexPath.row == dataSource.count - 1
        {
            cell.bottomSegView.isHidden = true
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("^_^   indexPath = \(indexPath)")
        
        switch indexPath.row
        {
        case 0:    //关于津旅商务
            //print("^_^  关于津旅商务")
            let vc = AboutOurController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 1:    //服务条款
            //print("^_^ 服务条款")
            let vc = AboutOurDetailsShowTextController()
            vc.navTitleStr = "服务条款"
            vc.titleStr = "服务条款"
            
            vc.fileNameStr = "service_terms.html"
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
            
        case 2:    //免责声明
            //print("^_^ 免责声明")
            let vc = AboutOurDetailsShowTextController()
            vc.navTitleStr = "免责声明"
            vc.titleStr = "免责声明"
            
            vc.fileNameStr = "no_response.html"
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 3:    //隐私政策
            //print("^_^ 隐私政策")
            let vc = AboutOurDetailsShowTextController()
            vc.navTitleStr = "隐私政策"
            vc.titleStr = "隐私政策"
            
            vc.fileNameStr = "privacy_policy.html"
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            print("^_^ default")
        }
        
        
        
    }
}

