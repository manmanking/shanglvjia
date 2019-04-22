//
//  MineHomeViewController.swift
//  shop
//
//  Created by manman on 2017/4/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SwiftyJSON

 let mineHomeTableViewHeaderViewIdentify = "mineHomeTableViewHeaderViewIdentify"

class MineHomeViewController: CompanyBaseViewController{

    
    let mineHomeTableViewCellIdentify = "mineHomeTableViewCellIdentify"
    let mineHomenomalCellIdentify = "mineHomenomalCellIdentify"
    
  
    
    private var tableView = UITableView()
    
    var userDetail:UserDetail?
    
    fileprivate var userInfo:LoginResponse?
    
    let twoRow = [["imgName":"ic_opinion","title":"mine.feedback"],["imgName":"ic_faq","title":"mine.common.problems"],["imgName":"ic_service","title":"mine.contact.customer"]]
    
    let threeRow = [["imgName":"ic_scan","title":"mine.scan"],["imgName":"ic_about","title":"mine.about"],["imgName":"ic_set","title":"mine.setting"]]
   
    var oneRow = [["imgName":"ic_link","title":"mine.company.binding.account"]]
    
    private lazy var headerView: MineHomeHeaderView = {
        let headerView = MineHomeHeaderView()
        headerView.frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 166)
        return headerView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setUIViewAutolayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setUserInfo()
        tableView.reloadData()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func  setUserInfo(){
        userInfo = DBManager.shareInstance.userDetailDraw()
        if  userInfo != nil{
            headerView.userNameLabel.text = "尊贵的会员"
            let imgView = headerView.unregisteredImage.subviews.first as! UIImageView
            imgView.image = UIImage(named: "ic_login_image")
            let phone:String = userInfo?.busLoginInfo.userName ?? ""
            headerView.loginLabel.setTitle(phone, for: UIControlState.normal)
            headerView.loginLabel.isEnabled = false
            if oneRow.count == 3 {
                oneRow[1] = ["imgName":"","title":"账号 : " + (userInfo?.busLoginInfo.userBaseInfo.mobiles.first ?? "") ]
                oneRow[2] = ["imgName":"","title":"邮箱 : " + (userInfo?.busLoginInfo.userBaseInfo.emails.first ?? "") ]
            }
            tableView.rectForHeader(inSection: 0)
            tableView.reloadSections([0], with: UITableViewRowAnimation.none)
        }else {
            userInfo = nil
            headerView.userNameLabel.text = "HELLO"
            headerView.loginLabel.setTitle("登录/注册", for: UIControlState.normal)
            headerView.loginLabel.isEnabled = true
            let imgView = headerView.unregisteredImage.subviews.first as! UIImageView
            imgView.image = UIImage(named: "ic_unregistered_image")
            oneRow.removeAll()
            oneRow.append(["imgName":"ic_link","title":"mine.company.binding.account"])
            //tableView.reloadData()
            tableView.rectForHeader(inSection: 0)
            tableView.reloadSections([0], with: UITableViewRowAnimation.none)
        }
    }
    
    //MARK:- 定制视图
    func setUIViewAutolayout() {
        //tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = TBIThemeBaseColor 
        tableView.separatorStyle = .none
        tableView.tableHeaderView =  headerView
        //tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: mineHomenomalCellIdentify)
        tableView.register(MineHomeTableViewCell.self, forCellReuseIdentifier: mineHomeTableViewCellIdentify)
        tableView.register(MineHomeTableViewFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: mineHomeTableViewHeaderViewIdentify)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(-24)
        }
        headerView.userNameLabel.addOnClickListener(target: self, action: #selector(loginClick(tap:)))
        headerView.unregisteredImage.addOnClickListener(target: self, action: #selector(loginClick(tap:)))
        headerView.loginLabel.addOnClickListener(target: self, action: #selector(loginClick(tap:)))
        weak var weakSelf = self
        headerView.mineHomeHeaderViewScanBlock = { _ in
            weakSelf?.intoNextScanView()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            var tempFrame = headerView.bgImageView.frame
            tempFrame.origin.y = offsetY
            tempFrame.size.height = 166 - offsetY
            headerView.bgImageView.frame = tempFrame
        }
    }
  
    
    /// 扫一扫登陆
    func intoNextScanView() {
//        let scanQRView = ScanQRCodeViewController()
//        self.navigationController?.pushViewController(scanQRView, animated: true)
        let scanQRView = PGGCodeScanning()
        scanQRView.returnBlock={  (string) in
            printDebugLog(message: string)
            //请求
            self.scanLogin(code:string!)
            
        }
        self.navigationController?.pushViewController(scanQRView, animated: true)
    }
    
    func scanLogin(code:String) {
        showLoadingView()
        weak var weakSelf = self
        _ = MyOrderListService.sharedInstance
            .scanQrcode(code: code)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let e):
                    printDebugLog(message: e.mj_keyValues())
                    
                    let alertController = UIAlertController(title: "提示", message: "成功", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "确定", style: .default){ action in
                        alertController.removeFromParentViewController()
                        weakSelf?.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(okAction)
                    weakSelf?.present(alertController, animated: true)
                    
                case .error(let e):
                    printDebugLog(message: e)
                    let alertController = UIAlertController(title: "提示", message: "扫码失败，请稍后再试", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "确定", style: .default){ action in
                        alertController.removeFromParentViewController()
                        weakSelf?.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(okAction)
                    weakSelf?.present(alertController, animated: true)
                    
                case .completed:
                    printDebugLog(message: "completed")
                }
        }
    }
    
    

}

extension  MineHomeViewController: UITableViewDelegate,UITableViewDataSource{
    
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1{
            return 0
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
      
        let footerView:MineHomeTableViewFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: mineHomeTableViewHeaderViewIdentify) as! MineHomeTableViewFooterView
        return footerView
    }

    
    //MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 1
//        }
        if section == 0 {
            return oneRow.count
        }
        if section == 1{
            return twoRow.count
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if indexPath.section == 0 {
//            let cell = initCell()
//
//            return cell
//        }else
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: mineHomeTableViewCellIdentify,for: indexPath) as! MineHomeTableViewCell
            cell.initOneCell(imgName:oneRow[indexPath.row]["imgName"]!,title:oneRow[indexPath.row]["title"]!, index: indexPath.row,count:oneRow.count,isCompanny: true)//userDetail?.companyUser?.parId == nil ? false:
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: mineHomeTableViewCellIdentify,for: indexPath) as! MineHomeTableViewCell
            var showLine:Bool = true
            
//            if  indexPath.row == twoRow.count - 1 {
//                showLine = false
//            }else {
//                showLine = true
//            }
            showLine = true
            
            cell.initAllCell(imgName:twoRow[indexPath.row]["imgName"]!,title:twoRow[indexPath.row]["title"]!,index:indexPath.row, isShowBottomLine:showLine )
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: mineHomeTableViewCellIdentify,for: indexPath) as! MineHomeTableViewCell
            var showLine:Bool = true
            
            if  indexPath.row == threeRow.count - 1 {
                showLine = false
            }else {
                showLine = true
            }
            
            
            
            cell.initAllCell(imgName:threeRow[indexPath.row]["imgName"]!,title:threeRow[indexPath.row]["title"]!,index:indexPath.row, isShowBottomLine: showLine)
            return cell
        }

        
    }
    
   
    //初始化第一行cell
    func  initCell() -> UITableViewCell{
        let cell = UITableViewCell()
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let journeyView = UIView(frame: CGRect(x: 0, y: 0, width: (ScreenWindowWidth-2)/3, height: 90))//行程view
        let orderView = UIView(frame: CGRect(x:  (ScreenWindowWidth-2)/3+1, y: 0, width: (ScreenWindowWidth-2)/3, height: 90))//订单view
        let waitPayView = UIView(frame: CGRect(x: ScreenWindowWidth-(ScreenWindowWidth-2)/3, y: 0, width: (ScreenWindowWidth-2)/3, height: 90))//待支付view
        let journeyLabel = UILabel(text: NSLocalizedString("mine.journey", comment: "我的行程"),color: TBIThemeMinorTextColor,size: 13)
        let orderLabel = UILabel(text: NSLocalizedString("mine.order", comment: "我的订单"),color: TBIThemeMinorTextColor,size: 13)
        let waitPayLabel = UILabel(text: NSLocalizedString("mine.wait.pay", comment: "待支付"),color: TBIThemeMinorTextColor,size: 13)
        
        let journeyImg = UIImageView(imageName: "ic_trip_2")
        let orderImg   = UIImageView(imageName: "ic_order_2")
        let waitPayImg = UIImageView(imageName: "ic_wallet")
        
      
        cell.addSubview(journeyView)
        cell.addSubview(orderView)
        cell.addSubview(waitPayView)
        
        journeyView.addSubview(journeyLabel)
        journeyView.addSubview(journeyImg)
        orderView.addSubview(orderLabel)
        orderView.addSubview(orderImg)
        waitPayView.addSubview(waitPayLabel)
        waitPayView.addSubview(waitPayImg)
        journeyLabel.snp.makeConstraints{(make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-15)
        }
        orderLabel.snp.makeConstraints{(make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-15)
        }
        waitPayLabel.snp.makeConstraints{(make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-15)
        }
        
        journeyImg.snp.makeConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(14)
        }
        orderImg.snp.makeConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(14)
        }
        waitPayImg.snp.makeConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(14)
        }
        
        journeyView.addOnClickListener(target: self, action: #selector(journeyClick(tap:)))
        orderView.addOnClickListener(target: self, action: #selector(orderClick(tap:)))
        waitPayView.addOnClickListener(target: self, action: #selector(waitPayClick(tap:)))
    
        return cell
       
    }
    
    //MARK:- UITableViewDelegat
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return 90
//        } else
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 44
            }
            return 36.5
        } else if indexPath.section == 1 {
            return 44
        } else {
            return 44
        }
    }
    
    // MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 1 {
            if indexPath.row == 0 {
//                let userDetail = UserService.sharedInstance.userDetail()
//                //用户没有登陆
//                if userDetail == nil {
//                    self.alertView(title: "提示", message: "请您先登陆再提交宝贵意见")
//                    return
//                }
                self.navigationController?.pushViewController(FeedbackViewController(), animated: true)
            }else if indexPath.row == 1 {
                self.navigationController?.pushViewController(CommonProblemsViewController(), animated: true)
            }else if indexPath.row == 2 {
                 getHotLine()
            }else if indexPath.row == 3
            {
                // 进入家属维护
                self.navigationController?.pushViewController(FamilyListViewController(), animated: true)
            }
            
        }
        if indexPath.section == 0 && indexPath.row == 0 {
            if userInfo?.busLoginInfo.userBaseInfo.uid != nil {
                if oneRow.count == 1 {
                    oneRow.append(["imgName":"","title":"账号 : " + (userInfo?.busLoginInfo.userBaseInfo.mobiles.first  ?? "") ])
                    oneRow.append(["imgName":"","title":"邮箱 : " + (userInfo?.busLoginInfo.userBaseInfo.emails.first ?? "") ])
                }else {
                    oneRow.remove(at: 1)
                    oneRow.remove(at: 1)
                }
                tableView.reloadSections([0], with: UITableViewRowAnimation.automatic)
            }else
            {
                if userInfo == nil {
                    self.alertView(title: "提示", message: "请您先登陆")
                }
//                let companyAccountView =
//                    CompanyAccountViewController()
//                companyAccountView.title = bingCompanyAccount
//                self.navigationController?.pushViewController(companyAccountView, animated: true)
                
            }
            
        }
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                let vc = SweepBookingViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 1 {
                let vc = AboutOurHomeController()
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 2 {
                let vc = SettingViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
        
    }
    
    
    func journeyClick(tap:UITapGestureRecognizer){
        _ = self.navigationController?.popToRootViewController(animated: false)
        let tabbarView:BaseTabBarController = UIApplication.shared.keyWindow?.rootViewController as!BaseTabBarController
        tabbarView.selectedIndex = 1
        print("我的行程")
    }
    func orderClick(tap:UITapGestureRecognizer){
        _ = self.navigationController?.popToRootViewController(animated: false)
        let tabbarView:BaseTabBarController = UIApplication.shared.keyWindow?.rootViewController as!BaseTabBarController
        tabbarView.selectedIndex = 2
        print("我的订单")
    }
    func waitPayClick(tap:UITapGestureRecognizer){
        if self.islogin() {
            self.navigationController?.pushViewController(UnpayOrdersControllerViewController(), animated: true)
        }
    }
    func loginClick(tap:UITapGestureRecognizer){
        if  userInfo == nil{
            navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.pushViewController(CompanyAccountViewController(), animated: true)
        }
    }
   
 

}
