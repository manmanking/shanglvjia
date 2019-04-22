//
//  CompanyAccountViewController.swift
//  shop
//
//  Created by manman on 2017/4/14.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

import RxSwift

enum LoginButtonState {
    case LoginState
    case BingState
}


let companyAccountLogin = "企业账号登录"
let bingCompanyAccount  = "绑定公司账号"


let companyAccountTableViewCellIdentify = "companyAccountTableViewCellIdentify"

class CompanyAccountViewController: CompanyBaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    public var phoneNo:String = ""
    
    public var verifyCode:String = ""
    
    private var loginButton = UIButton()
    private var tableView = UITableView()
    //公司代码
    private var companyAccountTextField = UITextField()
    //用户名
    private var accountTextField = UITextField()
    //密码
    private var passwordTextField = UITextField()
    private let bag = DisposeBag()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setTitle(titleStr: self.title ?? bingCompanyAccount)
        self.view.backgroundColor = TBIThemeBaseColor
        setNavigationBgColor(color:TBIThemeWhite)
        setBlackTitleAndNavigationColor(title: self.title ?? bingCompanyAccount)
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        
//        navigationController?.setNavigationBarHidden(false, animated: false)
//        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,
//                                         action: nil)
//        self.navigationItem.leftBarButtonItem = leftBarBtn
        
//        if self.title == bingCompanyAccount {
//            setNavigationRightButton(title: "跳过")
//        }
        setCustomUIAutolayout()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- 页面布局
    
    func setCustomUIAutolayout()
    {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: companyAccountTableViewCellIdentify)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.bottom.right.equalToSuperview()
            
        }
        
    }
    
    
    //MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
            
        case 3:
            return 30
            
            
        case 4:
            return 47
            
            
        default:
            return 44
            
        }
        
    }
    
    
    //MARK:- UITableViewDataSources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.title == companyAccountLogin {
           return 5
        }
        return 6
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: companyAccountTableViewCellIdentify)
        cell?.backgroundColor = TBIThemeBaseColor
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        //第一行。账号
        if indexPath.row == 0 {
            
            companyAccountTextField = UITextField()
            companyAccountTextField.tintColor = UIColor.blue
            companyAccountTextField.placeholder = "请输入公司代码"
            companyAccountTextField.font = UIFont.systemFont(ofSize: 16)
            cell?.contentView.addSubview(companyAccountTextField)
            companyAccountTextField.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.right.equalToSuperview()
                make.left.equalToSuperview().offset(15)
                
            })
            
            let bottomLine = UILabel()
            bottomLine.backgroundColor = TBIThemeGrayLineColor
            cell?.contentView.addSubview(bottomLine)
            bottomLine.snp.makeConstraints({ (make) in
                make.bottom.equalToSuperview()
                make.height.equalTo(0.5)
                make.left.equalTo(15)
                make.right.equalToSuperview()
            })
            
            cell?.contentView.backgroundColor = UIColor.white
            
            return cell!
        }
        
        //第二行 密码
        if indexPath.row == 1 {
            
            accountTextField = UITextField()
            accountTextField.tintColor = UIColor.blue
            accountTextField.placeholder = "请输入用户名"
            //accountTextField.text = DEBUG_Account
            accountTextField.font = UIFont.systemFont(ofSize: 16)
            cell?.contentView.addSubview(accountTextField)
            accountTextField.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.right.equalToSuperview()
                make.left.equalToSuperview().offset(15)
                
            })
            
            let bottomLine = UILabel()
            bottomLine.backgroundColor = TBIThemeGrayLineColor
            cell?.contentView.addSubview(bottomLine)
            bottomLine.snp.makeConstraints({ (make) in
                make.bottom.equalToSuperview()
                make.height.equalTo(0.5)
                make.left.equalTo(15)
                make.right.equalToSuperview()
            })
            
            cell?.contentView.backgroundColor = UIColor.white
            
            return cell!
        }
        //第二行 密码
        if indexPath.row == 2 {
            
            passwordTextField = UITextField()
            passwordTextField.tintColor = UIColor.blue
            passwordTextField.placeholder = "请输入密码"
            passwordTextField.isSecureTextEntry = true
            //passwordTextField.text = DEBUG_Account_Password
            passwordTextField.font = UIFont.systemFont(ofSize: 16)
            cell?.contentView.addSubview(passwordTextField)
            passwordTextField.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.right.equalToSuperview()
                make.left.equalToSuperview().offset(15)
                
            })
            cell?.contentView.backgroundColor = UIColor.white
            
            
            return cell!
        }
        
        
        if indexPath.row == 3 {
            cell?.contentView.backgroundColor = TBIThemeBaseColor
        }
        
        
        
        //第三行 登录按钮
        if indexPath.row == 4 {
            
            loginButton.layer.cornerRadius = 5
            //loginButton.backgroundColor = TBIThemeBlueColor
            
            if self.title == companyAccountLogin {
                setLoginButtonState(state: LoginButtonState.LoginState)
                //初步判断 是否为正确手机号
                
                let companyValid = companyAccountTextField.rx.text.orEmpty.asObservable().map{
                    $0.characters.count > 0
                }
                let usernameValid = accountTextField.rx.text.orEmpty.asObservable().map{ $0.characters.count > 0 }
                let verifyCodeValid = passwordTextField.rx.text.orEmpty.asObservable().map{
                    $0.characters.count > 0 }
                Observable
                    .combineLatest([companyValid,usernameValid,verifyCodeValid]){ $0.reduce(true){$0&&$1}}
                    .do(onNext: { validate in
                        if validate {
                            self.loginButton.backgroundColor = TBIThemeBlueColor
                        }else {
                            self.loginButton.backgroundColor = UIColor.gray
                        }
                    })
                    .bind(to: loginButton.rx.isEnabled)
                    .addDisposableTo(bag)
                
                
                
                
                
            }else
            {
                setLoginButtonState(state: LoginButtonState.BingState)
                
                //初步判断 是否为正确手机号
                
                let companyValid = companyAccountTextField.rx.text.orEmpty.asObservable().map{
                    $0.characters.count > 0
                }
                let usernameValid = accountTextField.rx.text.orEmpty.asObservable().map{ $0.characters.count > 0 }
                let verifyCodeValid = passwordTextField.rx.text.orEmpty.asObservable().map{
                    $0.characters.count > 0 }
                Observable
                    .combineLatest([companyValid,usernameValid,verifyCodeValid]){ $0.reduce(true){$0&&$1}}
                    .do(onNext: { validate in
                        if validate {
                            self.loginButton.backgroundColor = TBIThemeBlueColor
                        }else {
                            self.loginButton.backgroundColor = UIColor.gray
                        }
                    })
                    .bind(to: loginButton.rx.isEnabled)
                    .addDisposableTo(bag)
                
                
                
                
            }
            
            cell?.contentView.addSubview(loginButton)
            loginButton.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.left.right.equalToSuperview().inset(15)
            })
            
            return cell!
        }
        //第三行 登录按钮
        if indexPath.row == 5 {
            
            let label = UILabel()
            label.text = "绑定公司账号即可使用差旅服务"
            label.font = UIFont.systemFont(ofSize: 14)
            label.textAlignment = NSTextAlignment.center
            label.textColor = TBIThemePlaceholderTextColor
            
            cell?.contentView.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.top.equalTo(5)
                make.left.right.equalToSuperview().inset(10)
                make.bottom.equalTo(5)
            })
            return cell!
        }
        return cell!
    }
    
    
    
    
    func setLoginButtonState(state:LoginButtonState) {
       
        switch state {
            
        case .LoginState:
            loginButton.setTitle("登录", for: UIControlState.normal)
            loginButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
            loginButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            loginButton.addTarget(self, action: #selector(loginButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            break
            
        case .BingState:
            loginButton.setTitle("绑定", for: UIControlState.normal)
            loginButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
            loginButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            loginButton.addTarget(self, action: #selector(bingCompanyButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            break
            
        }
    }
    
    
    
    //MARK:- 企业登录
    
    
    func loginButtonAction(sender:UIButton) {
        //oldLoginNET()
        loginNewOBTNET()
        
        }
    
    ///快捷登录 绑定公司账号
    func bindingCompanyAccount() {
        printDebugLog(message: "")
        resignLocalFirstResponder()
        showLoadingView()
        weak var weakSelf = self
        let companyCode = companyAccountTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let userName = accountTextField.text ?? ""
        _ = LoginServices.sharedInstance
            .bindingCompanyAccount(userName: userName, corpCode:companyCode, password: password, verifyCode:verifyCode , phoneNo:phoneNo )
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let e):
                    printDebugLog(message: e.mj_keyValues())
                    DBManager.shareInstance.userDetailStore(userDetail: e)
                    printDebugLog(message: DBManager.shareInstance.userDetailDraw()?.mj_keyValues())
                    weakSelf?.intoMainView(from: "企业账号登录")
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                    
                case .completed:
                    break
                }
        }
    }
    
    
    /// 新版 个人版 个人版 绑定 企业账号
    func personalAccountBindCompanyAccount() {
        resignLocalFirstResponder()
        showLoadingView()
        weak var weakSelf = self
        let request:BindBusAccountRequest = BindBusAccountRequest()
        request.corpCode = companyAccountTextField.text ?? ""
        request.pwd = passwordTextField.text ?? ""
        request.loginName = accountTextField.text ?? ""
        _ = LoginServices.sharedInstance
            .personalAccountBindingCompanyAccount(request: request)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let e):
                    printDebugLog(message: e.mj_keyValues())
                    DBManager.shareInstance.userDetailStore(userDetail: e)
                    DBManager.shareInstance.currentActivePersonal()
                    printDebugLog(message: DBManager.shareInstance.userDetailDraw()?.mj_keyValues())
                    weakSelf?.intoMainView(from: "企业账号登录")
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                    
                case .completed:
                    break
                }
        }
    }
    
    
    
    func loginNewOBTNET() {
        printDebugLog(message: "")
        resignLocalFirstResponder()
        showLoadingView()
        weak var weakSelf = self
        let loginInfo:LoginSVModel = LoginSVModel() //CompanyLoginUserForm(userName: DEBUG_Account,passWord: DEBUG_Account_Password,companyCode:"1")
        loginInfo.fromApp = "1"
        loginInfo.password = passwordTextField.text ?? ""
        loginInfo.userName = accountTextField.text ?? ""
        _ = UserService.sharedInstance
            .loginSVLoginNoOBT(loginInfo)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let e):
                    printDebugLog(message: e.mj_keyValues())
                    DBManager.shareInstance.userDetailStore(userDetail: e)
                    printDebugLog(message: DBManager.shareInstance.userDetailDraw()?.mj_keyValues())
                     weakSelf?.intoMainView(from: "企业账号登录")
                case .error(let e):
                    printDebugLog(message: e)
                    
                case .completed:
                    printDebugLog(message: "completed")
                }
                
                
            }.disposed(by: bag)
        
    }
    
    
    func oldLoginNET() {
        printDebugLog(message: "loginButtonAction ...")
        resignLocalFirstResponder()
        showLoadingView()
        weak var weakSelf = self
        let userInfo = CompanyLoginUserForm(userName: (accountTextField.text?.description)!,passWord: (passwordTextField.text?.description)!,companyCode: (companyAccountTextField.text?.description)!)
        UserService.sharedInstance
            .companyLogin(userInfo)
            .subscribe{ event in
                
                weakSelf?.hideLoadingView()
                if case .next(let e) = event {
                    print("=====成功======")
                    //MARK:---  添加判断 是否绑定个人
                    // a .若没有绑定个人 则跳转到企业绑定个人页面
                    // b. 若已经绑定个人账号 则获取 账号的详细 信息
                    //校验是否为 企业账号
                    PersonalType = false
                    print(e)
                    weakSelf?.intoMainView(from: "企业账号登录")
                }
                if case .error(let e) = event {
                    print("=====失败======")
                    print(e)
                    
                    if let error = e as? HttpError
                    {
                        switch error
                        {
                        case .timeout:
                            
                            self.showSystemAlertView(titleStr: "提示", message: "失败")
                            
                        case .serverException(let code,let message):
                            print(message)
                            self.showSystemAlertView(titleStr: "提示", message: message)
                        case .companyNotBindUser(_,let user):
                            print(user)
                            // 跳转到 企业绑定个人页面
                            
                            
                            let userDetail = UserService.sharedInstance.userDetail()
                            print(userDetail?.companyUser?.mobile)
                            let bingPerson = BingPersonalAccountViewController()
                            bingPerson.companyInfo = user
                            bingPerson.newDemand = true
                            weakSelf?.navigationController?.pushViewController(bingPerson, animated: true)
                            
                        default :
                            printDebugLog(message: "into here ...")
                        }
                        
                        
                        
                        
                    }
                    
                    
                }
            }.disposed(by: bag)
        
    }
    
    
    func bingCompanyButtonAction(sender:UIButton) {
        //personalAccountBindCompanyAccount()
        bindingCompanyAccount()
        return
       // bindingCompanyAccountOld()
    }
    
    func bindingCompanyAccountOld() {
        
        printDebugLog(message: "绑定公司账号")
        resignLocalFirstResponder()
        showLoadingView()
        weak var weakSelf = self
        //UserService.sharedInstance.userDetail()?.id
        let userInfo = PersonBindCompanyForm(userName: (accountTextField.text?.description)!,passWord: (passwordTextField.text?.description)!,companyCode: (companyAccountTextField.text?.description)!,id:(UserService.sharedInstance.userDetail()?.id)!)
        print(userInfo)
        UserService.sharedInstance
            .personBindCompany(userInfo)
            .subscribe{ event in
                
                weakSelf?.hideLoadingView()
                if case .next(let e) = event {
                    print("=====成功======")
                    print(e)
                    weakSelf?.intoMainView(from: "绑定公司账号")
                    
                }
                if case .error(let e) = event {
                    print("=====失败======")
                    print(e)
                    if let error = e as? HttpError
                    {
                        switch error
                        {
                        case .timeout:
                            
                            self.showSystemAlertView(titleStr: "提示", message: "失败")
                            
                        case .serverException(let code,let message):
                            print(message)
                            self.showSystemAlertView(titleStr: "提示", message: message)
                            
                        default :
                            printDebugLog(message: "into here ...")
                        }
                        
                        
                        
                        
                    }
                    
                    
                    
                }
            }.disposed(by: bag)
        
    }
    
    
    
    private func resignLocalFirstResponder()
    {
        companyAccountTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        accountTextField.resignFirstResponder()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LoginPageVisable = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        LoginPageVisable = false
    }
    
    override func rightButtonAction(sender: UIButton) {
        printDebugLog(message: "rightButtonAction ...")
        resignFirstResponder()
        // 添加逻辑
        //验证通过后进入主页面
        intoMainView(from: "跳过")
    }
    
    override func backButtonAction(sender: UIButton) {
        printDebugLog(message: "backButtonAction ...")
        resignFirstResponder()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
