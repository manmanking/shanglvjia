//
//  NewMineHomeViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/6.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import Moya

class PersonalMineHomeViewController: PersonalBaseViewController{

    private var tableView = UITableView()
    
    private var topView:PersonalNavbarTopView = PersonalNavbarTopView()
    
    fileprivate var userInfo:LoginResponse?
    
    fileprivate let bag = DisposeBag()
    
    let cellArr = [[["imgName":"ic_user_company","title":"绑定企业账号"]],[["imgName":"ic_user_profile","title":"基本信息"],["imgName":"ic_user_cs","title":"联系客服"]],[["imgName":"ic_user_us","title":"关于我们"]]]
    
    private lazy var headerView: PersonalMineHomeHeader = {
        let headerView = PersonalMineHomeHeader()
        headerView.frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 283)
        headerView.integralLabel.addTarget(self, action: #selector(gotoIntegralListVC), for: UIControlEvents.touchUpInside)
        return headerView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        setUserInfo()
        tableView.reloadData()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        ///请求订单数
        getOrderCount()
        getIntegralDetail()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setUIViewAutolayout()
        initTopView()
        
    }

    //MARK:- 定制视图
    func setUIViewAutolayout() {
        //tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.separatorStyle = .none
        tableView.tableHeaderView =  headerView
        tableView.estimatedRowHeight = 50
        tableView.register(PersonalMineHomeCell.self, forCellReuseIdentifier: "PersonalMineHomeCell")
        tableView.register(MineHomeTableViewFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: mineHomeTableViewHeaderViewIdentify)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(-24)
        }
        
    }
    func  setUserInfo(){
        userInfo = DBManager.shareInstance.userDetailDraw()
        if  userInfo != nil{
            let imgView = headerView.unregisteredImage.subviews.first as! UIImageView
            imgView.image = UIImage(named: "ic_login_image")
            let phone:String = userInfo?.cusLoginInfo.userName ?? ""
            headerView.loginLabel.setTitle(phone, for: UIControlState.normal)
            headerView.loginLabel.isEnabled = false
//            tableView.rectForHeader(inSection: 0)
//            tableView.reloadSections([0], with: UITableViewRowAnimation.none)
            weak var weakSelf = self
            headerView.clickBlock = {(btnName) in
            
                let vc = PersonalOrderListViewController()
                vc.isBack = true
                vc.orderStatus = "0"
                if btnName == "待订妥"{
                   vc.orderStatus = "3"
                }
                if btnName == "待支付"{
                    vc.orderStatus = "2"
                }
                weakSelf?.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            userInfo = nil
            headerView.loginLabel.setTitle("登录/注册", for: UIControlState.normal)
            headerView.loginLabel.isEnabled = true
            let imgView = headerView.unregisteredImage.subviews.first as! UIImageView
            imgView.image = UIImage(named: "ic_unregistered_image")
            //tableView.reloadData()
//            tableView.rectForHeader(inSection: 0)
//            tableView.reloadSections([0], with: UITableViewRowAnimation.none)
        }
    }
    func getOrderCount(){
        weak var weakSelf = self
        PersonalOrderServices.sharedInstance
            .getOrderCount()
            .subscribe { (json) in
                switch json {
                case .next(let result):
                    printDebugLog(message: result)
                    if result == "0"{
                        weakSelf?.headerView.payLabel.isHidden = true
                    }else{
                          weakSelf?.headerView.payLabel.isHidden = false
                        weakSelf?.headerView.payLabel.text = "\(result)   "
                    }
                    
                case .error(_):
                    break
                case .completed:
                    break
                }
            }.disposed(by: self.bag)
    }
    func getIntegralDetail()
    {
        let userId:String = DBManager.shareInstance.userDetailDraw()?.cusLoginInfo.userId ?? ""
        
        weak var weakSelf = self
        PersonalOrderServices.sharedInstance
            .getIntegralDetail(userId:userId)
            .subscribe { (json) in
                switch json {
                case .next(let result):
                    printDebugLog(message: result)
                    weakSelf?.headerView.integralLabel.setTitle("当前积分:\(result["points"])", for: UIControlState.normal)
                case .error(_):
                    break
                case .completed:
                    break
                }
            }.disposed(by: self.bag)
    }
    
    func gotoIntegralListVC(){
        let vc = PIntegralDetialViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            var tempFrame = headerView.bgImageView.frame
            tempFrame.origin.y = offsetY
            tempFrame.size.height = 283 - offsetY
            headerView.bgImageView.frame = tempFrame
        }
    }

    func initTopView() {
        topView.frame = CGRect(x:0,y:0,width:Int(ScreenWindowWidth),height:kNavigationHeight)
        topView.leftButton.setImage(UIImage(named:"ic_user_set"), for: UIControlState.normal)
        topView.rightButton.setImage(UIImage(named:"ic_scanning"), for: UIControlState.normal)
        topView.leftButton.addTarget(self, action: #selector(leftButtonClick), for: UIControlEvents.touchUpInside)
        topView.rightButton.addTarget(self, action: #selector(intoNextScanView), for: UIControlEvents.touchUpInside)
        self.view.addSubview(topView)
    }
    
    func leftButtonClick(){
        let vc = PersonalSettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
extension PersonalMineHomeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalMineHomeCell",for: indexPath) as! PersonalMineHomeCell
        cell.setCellWithArray(array: cellArr[indexPath.row] as NSArray)
        weak var weakSelf = self
        cell.clickBlock = {(btnName) in
            if btnName == "绑定企业账号"
            {
                let changeVC:ChanegePsdViewController = ChanegePsdViewController()
                changeVC.type = "bindNum"
                weakSelf?.navigationController?.pushViewController(changeVC, animated: true)
            }
//            if btnName == "绑定身份证"
//            {
//                let changeVC:BindingCardViewController = BindingCardViewController()
//                weakSelf?.navigationController?.pushViewController(changeVC, animated: true)
//            }
            if btnName == "基本信息"
            {
                let changeVC:PersonalBaseInfoViewController = PersonalBaseInfoViewController()
                
                weakSelf?.navigationController?.pushViewController(changeVC, animated: true)
            }
            if btnName == "联系客服"
            {
                UIApplication.shared.openURL(NSURL(string :"tel://022-81267008")! as URL)
                ///weakSelf?.navigationController?.pushViewController(EnterpriseHotLineController(), animated: true)
            }
            if btnName == "关于我们"
            {
                let vc = AboutOurHomeController()
                weakSelf?.navigationController?.pushViewController(vc, animated: true)
            }
            
           
        }
        return cell
    }
    /// 扫一扫登陆
    func intoNextScanView() {
         weak var weakSelf = self
        let scanQRView = PGGCodeScanning()
        scanQRView.returnBlock={  (string) in
            printDebugLog(message: string)
            //请求
            weakSelf?.scanLogin(code:string!)
            
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
