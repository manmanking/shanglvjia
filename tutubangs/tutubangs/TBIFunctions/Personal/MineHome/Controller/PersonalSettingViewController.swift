//
//  PersonalSettingViewController.swift
//  shanglvjia
//
//  Created by tbi on 30/09/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage



class PersonalSettingViewController: PersonalBaseViewController {

    fileprivate let bag = DisposeBag()
    fileprivate let tableView = UITableView()
    ///3720 个人账号登录----我的---设置--隐去修改企业密码 ----全员测试提出
    fileprivate let settingMessage = ["版本说明","清除缓存"]
    fileprivate var logoutIsEnable:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.setNavigationColor()
        setBlackTitleAndNavigationColor(title:"设置")
        
        guard DBManager.shareInstance.userDetailDraw() != nil else {
            logoutIsEnable = false
            return
        }
        
        if DBManager.shareInstance.userDetailDraw() == nil {
            logoutIsEnable = false
        }else
        {
            logoutIsEnable = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
extension PersonalSettingViewController: UITableViewDelegate,UITableViewDataSource{
    
    func initView(){
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: settingNomalCellIdentify)
        self.view.addSubview(tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return settingMessage.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        } else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 10))
        view.backgroundColor = TBIThemeBaseColor
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingNomalCellIdentify)!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if indexPath.section == 0 {
            let textLabel:UILabel = UILabel(text:settingMessage[indexPath.row], color: TBIThemePrimaryTextColor, size: 16)
            let rightImg:UIImageView = UIImageView(imageName: "ic_right_gray")
            cell.addSubview(textLabel)
            cell.addSubview(rightImg)
            rightImg.snp.makeConstraints{(make) in
                make.right.equalTo(-15)
                make.centerY.equalToSuperview()
            }
            textLabel.snp.makeConstraints{(make) in
                make.left.equalTo(15)
                make.centerY.equalToSuperview()
            }
            if indexPath.row == 0 {
                let line:UILabel = UILabel(color: TBIThemeGrayLineColor)
                cell.addSubview(line)
                line.snp.makeConstraints{ make in
                    make.right.equalTo(0)
                    make.left.equalTo(15)
                    make.height.equalTo(1)
                    make.bottom.equalToSuperview()
                }
            }
        } else {
            let logOutLabel:UILabel = UILabel(text:NSLocalizedString("mine.logout.bottom", comment: "退出当前帐号"), color: TBIThemeRedColor, size: 18)
            //用户没有登陆
            if DBManager.shareInstance.userDetailDraw() == nil {
                logOutLabel.textColor = TBIThemeGrayLineColor
            }
            cell.addSubview(logOutLabel)
            logOutLabel.snp.makeConstraints{ make in
                make.center.equalToSuperview()
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.section == 0 {
            
            
            switch indexPath.row
            {
            case 0:
                self.navigationController?.pushViewController(VersionDescriptionViewController(), animated: true)
                break
//            case 1:
//                let changeVC:ChanegePsdViewController = ChanegePsdViewController()
//                changeVC.type = "changePwd"
//                self.navigationController?.pushViewController(changeVC, animated: true)
//                break
            case 1:
                UserDefaults.standard.removeObject(forKey: CitySearchType.flightAirport.rawValue)
                UserDefaults.standard.removeObject(forKey: CitySearchType.hotelCity.rawValue)
                UserDefaults.standard.removeObject(forKey: CitySearchType.flightCity.rawValue)
                UserDefaults.standard.removeObject(forKey: CitySearchType.trainCity.rawValue)
                UserDefaults.standard.removeObject(forKey: CitySearchType.trainCity.rawValue + "hot")
                self.alertView(title: "提示", message: "清除成功")
                break
            default:
                break
            }
            
        } else if indexPath.section == 1 { //退出登录
            
            if logoutIsEnable {
                print("退出登录")
                UIApplication.shared.applicationIconBadgeNumber = 0
//                SDWebImageManager.shared().imageCache?.clearDisk(onCompletion: {
//                    printDebugLog(message: "清空缓存")
//                })
                intoLoginView()
            }
            
            
        }
    }
    
    func intoLoginView() {
        logoutAction()
        
    }
    
    
    func logoutAction() {
        
        DBManager.shareInstance.userDetailDelete()
        deleteJPushAlias()
        let loginView = LoginSVViewController()
        self.navigationController?.pushViewController(loginView, animated: true)
    }
    
    func logoutActionOld() {
        
        let userDetail = UserService.sharedInstance.userDetail()
        if userDetail == nil {
            return
        }
        
        PersonalType = true
        UserDefaults.standard.removeObject(forKey: USERINFO)
        UserService.sharedInstance.logout()
            .subscribe{ event in
                if case .next(let e) = event {
                    //登出的时候要清除热线电话
                    UserDefaults.standard.removeObject(forKey: HOTLINE)
                    print("=====成功======")
                    print(e)
                }
                if case .error(let e) = event {
                    print("=====失败======")
                    print(e)
                }
            }.disposed(by: bag)
        let companyAccountView = CompanyAccountViewController()
        companyAccountView.title = "企业账号登录"
        self.navigationController?.pushViewController(companyAccountView, animated: true)
    }
    
}

