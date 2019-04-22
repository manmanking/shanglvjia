//
//  LoginSVViewController.swift
//  shanglvjia
//
//  Created by manman on 2018/3/28.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit


class LoginSVViewController: BaseViewController {

    private let loginView:LoginView = LoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        setTitle(titleStr: "")
        LoginPageVisable = true
        self.view.backgroundColor = TBIThemeWhite
        setUIViewAutoLayout()
    }
    
    func setUIViewAutoLayout() {
        
        self.view.addSubview(loginView)
        loginView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(0)
            make.left.right.equalToSuperview()
            make.height.equalTo(330 + kNavigationHeight + 70)
        }
        weak var weakSelf = self
        loginView.loginViewLoginBlock = { phone,verifyCode,corpCode in
            weakSelf?.loginAction(phone: phone, verifyCode: verifyCode, corpCode: corpCode)
            //weakSelf?.swiftLogin(phone: phone, verifyCode: verifyCode)
            //weakSelf?.loginNewOBTNET(phone: phone,verifyCode: verifyCode)
        }
        loginView.loginViewGetVerifyCodeBlock = { phone in
            weakSelf?.getVerifyCodeNET(phone: phone)
        }
        loginView.loginViewExchangeLoginTypeBlock = { type in
            
            
        }
//        let a = [2,5,7,8,10];
//        let b = [1,4,6,8,9];
        //printDebugLog(message: mergeList(a: a, b: b))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.star()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.extendedLayoutIncludesOpaqueBars = true
        LoginPageVisable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.reset()
        LoginPageVisable = false
    }
    
    
    func mergeList(a:[NSInteger],b:[NSInteger]) -> [NSInteger] {
        
        var result:[NSInteger] = Array()
        
        var  i:NSInteger = 0,j = 0,k = 0
        
        while (i < a.count && j < b.count) {
            if a[i] < b[j] {
                
                result[k] = a[i]
                k += 1
                i += 1
                print(result)
            }else{
                result[k] = a[i]
                k += 1
                i += 1
            }
        }
        
        while i < a.count {
            result[k] = a[i];
            k += 1
            i += 1
        }
        while(j < b.count){
            
            result[k] = b[j];
            k += 1
            j += 1
        }
        return result;
        
    }
    
    func loginviewChangeType(type:String) {
        var height:NSInteger = 250
        if type != "swift" {
           height = 310
        }
        loginView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().inset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(height)
        }
    }
    
    
    func loginAction(phone:String,verifyCode:String,corpCode:String) {
        let loginType:LoginView.LoginViewLoginType  = loginView.getLoginViewLoginType()
        switch loginType {
        case .SwiftLogin:
//            swiftLogin(phone: phone, verifyCode: verifyCode)
            verifyCodeNET(phone: phone, code: verifyCode)
        case .AccountLogin:
            loginByPwd(account: phone, password: verifyCode, corpCode: corpCode)
        default:
            break
        }
    }
    
    
    func showBingIdCardView(userId:String) {
        let bingIdCardView = BindingCardViewController()
        bingIdCardView.userId = userId
        self.navigationController?.pushViewController(bingIdCardView, animated: true)
    }
    
    
    // MARK:---------NET--------
    
    func swiftLogin(phone:String,verifyCode:String) {
        printDebugLog(message: "")
        showLoadingView()
        weak var weakSelf = self
        _ = LoginServices.sharedInstance
            .swiftLogin(phone: phone, verifyCode: verifyCode)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let result):
                    //0：登录成功，-1：验证码错误或过期，1：未绑定用户
                    if result.busLoginInfo.status == "0"
                    {
                        printDebugLog(message:result.mj_keyValues())
                        DBManager.shareInstance.userDetailStore(userDetail: result)
                        printDebugLog(message: DBManager.shareInstance.userDetailDraw()?.mj_keyValues())
                        weakSelf?.intoMainView(from: "企业账号登录")
                    }else
                    {
                        let companyView = CompanyAccountViewController()
                        companyView.phoneNo = phone
                        companyView.verifyCode = verifyCode
                        self.navigationController?.pushViewController(companyView, animated: true)
                    }
                case .error(let error):
                     try? weakSelf?.validateHttp(error)
                    
                case .completed:
                    printDebugLog(message: "completed")
                }
        }
    }
    
    
    
    
    /// 登录
    func loginNewOBTNET( account:String,password:String,corpCode:String) {
        
        printDebugLog(message: "")
        showLoadingView()
        weak var weakSelf = self
        let loginInfo:LoginSVModel = LoginSVModel()
        loginInfo.fromApp = "1"
        loginInfo.password = password
        loginInfo.userName = account
        loginInfo.corpCode = corpCode
        _ = LoginServices.sharedInstance
            .loginSVLoginNoOBT(loginInfo)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let e):
                    printDebugLog(message: e.mj_keyValues())
                    DBManager.shareInstance.currentActiveCompany()
                    DBManager.shareInstance.userDetailStore(userDetail: e)
                    
                    printDebugLog(message: DBManager.shareInstance.userDetailDraw()?.mj_keyValues())
                    weakSelf?.intoMainView(from: "企业账号登录")
                case .error(let error):
                    printDebugLog(message: error)
                    try? weakSelf?.validateHttp(error)
                    
                case .completed:
                    printDebugLog(message: "completed")
                }
            }
        
    }
    
    //MARK: -新版
    /// 获取验证码
    func getVerifyCodeNET(phone:String) {
        printDebugLog(message: "")
        showLoadingView()
        weak var weakSelf = self
        _ = LoginServices.sharedInstance
            .getCodeNew(phone: phone)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let e):
                    printDebugLog(message: e.mj_keyValues())
                   weakSelf?.showSystemAlertView(titleStr: "提示", message: "验证码发送成功 \(e)")
                case .error(let e):
                    printDebugLog(message: e)
                    
                case .completed:
                    printDebugLog(message: "completed")
                }
        }
        
    }
    /// 验证验证码 手机号验证码登陆
    func verifyCodeNET(phone:String,code:String) {
        printDebugLog(message: "")
        showLoadingView()
        weak var weakSelf = self
        let request:[String:Any] = ["phoneNo":phone,"code":code]
        _ = LoginServices.sharedInstance
            .vertifyCodeNew(request: request)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let e):
                    printDebugLog(message: e.mj_keyValues())
                    
                    if e.cusLoginInfo.userStatus == "1" {
                        weakSelf?.showBingIdCardView(userId: e.cusLoginInfo.userId)
                        return
                    }
                    weakSelf?.setJPushAlias(phone:phone)
                    weakSelf?.setJpushTag()
                    DBManager.shareInstance.userDetailStore(userDetail: e)
                    DBManager.shareInstance.currentActivePersonal()
                    printDebugLog(message: DBManager.shareInstance.userDetailDraw()?.mj_keyValues())
                    weakSelf?.intoMainView(from: "企业账号登录")
                    ///跳到个人版首页
                case .error(let e):
                    printDebugLog(message: e)
                    try? weakSelf?.validateHttp(e)
                case .completed:
                    printDebugLog(message: "completed")
                }
        }
    }
    /// 登录
    func loginByPwd( account:String,password:String,corpCode:String) {
        
        printDebugLog(message: "")
        showLoadingView()
        weak var weakSelf = self
        let request:[String:Any] = ["corpCode":corpCode,"userName":account,"fromApp":"1","password":password]
        _ = LoginServices.sharedInstance
            .loginByPwd(request: request)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let e):
                    printDebugLog(message: e.mj_keyValues())
                    DBManager.shareInstance.currentActiveCompany()
                    DBManager.shareInstance.userDetailStore(userDetail: e)
                    
                    if DBManager.shareInstance.getCurrentAccountRight() != DBManager.AccountAllRight.Only_Company {
                        weakSelf?.setJpushTag()
                        weakSelf?.setJPushAlias(phone:e.cusLoginInfo.phoneNo)
                    }
                    
                    printDebugLog(message: DBManager.shareInstance.userDetailDraw()?.mj_keyValues())
                    weakSelf?.intoMainView(from: "企业账号登录")
                case .error(let error):
                    printDebugLog(message: error)
                    try? weakSelf?.validateHttp(error)
                    
                case .completed:
                    printDebugLog(message: "completed")
                }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
