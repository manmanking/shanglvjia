//
//  LoginViewController.swift
//  shop
//
//  Created by manman on 2017/4/10.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SwiftyJSON

let tableViewCellIdentify = "tableViewCellIdentify"
var LoginPageVisable = false
class LoginViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate{

    
    
    private var tableView = UITableView()
    private var accountTextField = UITextField()
    private var passwordTextField = UITextField()
    private var loginButton = UIButton()
    private let bag = DisposeBag()
    
    //跳转首页标示 默认登陆是跳到首页
    var jumpFlag:Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        // Do any additional setup after loading the view.
        setTitle(titleStr: "登录")
        setNavigationBackButton(backImage: "")
        setNavigationRightButton(title: "注册")
        setCustomUIAutolayout()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LoginPageVisable = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        LoginPageVisable = false
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
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: tableViewCellIdentify)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = TBIThemeBaseColor
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.bottom.right.equalToSuperview()
        }
        
    }
    
    
    //MARK:- UITableViewDataSources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
            
        case 2:
            return 30
            
            
        case 3:
            return 47
            
            
        default:
            return 44
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentify)
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        cell?.contentView.backgroundColor = UIColor.white
        //第一行。账号
        if indexPath.row == 0 {
            
            accountTextField = UITextField()
            accountTextField.keyboardType = UIKeyboardType.numberPad
            accountTextField.backgroundColor = UIColor.white
            accountTextField.tintColor = UIColor.blue
            accountTextField.placeholder = "请输入手机号码"
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
            
            return cell!
            
        }
        
        //第二行 密码
        if indexPath.row == 1 {
            
            passwordTextField = UITextField()
            passwordTextField.backgroundColor = UIColor.white
            passwordTextField.placeholder = "请输入密码"
            passwordTextField.isSecureTextEntry = true
            passwordTextField.font = UIFont.systemFont(ofSize: 16)
            cell?.contentView.addSubview(passwordTextField)
            passwordTextField.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview()
            })
            
            return cell!
            
        }
        
        if indexPath.row == 2 {
            
            cell?.contentView.backgroundColor = TBIThemeBaseColor
            
        }
        
        //第三行 登录按钮
        if indexPath.row == 3 {
            
            loginButton.setTitle("登录", for: UIControlState.normal)
            loginButton.layer.cornerRadius = 5
//            loginButton.backgroundColor = UIColor.yellow
            loginButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            loginButton.addTarget(self, action: #selector(loginButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            
            
            cell?.contentView.addSubview(loginButton)
            loginButton.snp.makeConstraints({ (make) in
                make.top.equalToSuperview()
                make.left.right.equalToSuperview().inset(15)
                make.bottom.equalToSuperview()
            })
            let usernameValid = accountTextField.rx.text.orEmpty.map{
                $0.characters.count ==  11
            }
            let passwordValid = passwordTextField.rx.text.orEmpty.map{
                $0.characters.count > 0
            }
            Observable
                .combineLatest([usernameValid,passwordValid]){ $0.reduce(true){$0&&$1}}
                .do(onNext: { validate in
                    if validate {
                        self.loginButton.backgroundColor = TBIThemeBlueColor
                    }else {
                        self.loginButton.backgroundColor = UIColor.gray
                    }
                })
                .bind(to: loginButton.rx.isEnabled)
                .addDisposableTo(bag)

            cell?.contentView.backgroundColor = TBIThemeBaseColor
            
            return cell!
            
        }
        
        //第一行  企业登录 and forgetPassword
        if indexPath.row == 4 {
            
            let loginButton = UIButton()
            loginButton.backgroundColor = TBIThemeBaseColor
            loginButton.titleLabel?.textAlignment = NSTextAlignment.left
            loginButton.titleLabel?.adjustsFontSizeToFitWidth = true
            loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            let titleStr = "使用企业账号登录"
            let loginButton_OC = titleStr as NSString
            let mutAttributeStr = NSMutableAttributedString.init(string:"使用企业账号登录")
            let range:NSRange =  loginButton_OC.range(of: "使用企业账号登录")
            mutAttributeStr.addAttribute(NSForegroundColorAttributeName, value:TBIThemeLinkColor, range:range )
            mutAttributeStr.addAttribute(NSUnderlineStyleAttributeName, value:NSUnderlineStyle.styleSingle.hashValue, range: range)
            loginButton.setAttributedTitle(mutAttributeStr, for: UIControlState.normal)
            loginButton.setTitleColor(TBIThemeLinkColor, for: UIControlState.normal)
            loginButton.addTarget(self, action: #selector(companysLoginButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            cell?.contentView.addSubview(loginButton)
            loginButton.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(15)
            })
            
            let forgetButton = UIButton()
            forgetButton.backgroundColor = TBIThemeBaseColor
            forgetButton.titleLabel?.adjustsFontSizeToFitWidth = true
            forgetButton.setTitle("忘记密码", for: UIControlState.normal)
            forgetButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            forgetButton.titleLabel?.textAlignment = NSTextAlignment.right
            forgetButton.setTitleColor(TBIThemeLinkColor, for: UIControlState.normal)
            forgetButton.addTarget(self, action: #selector(forgetButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            cell?.contentView.addSubview(forgetButton)
            forgetButton.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.right.equalTo(-15)
            })
            
            
            cell?.contentView.backgroundColor = TBIThemeBaseColor
            
            return cell!
            
        }
        
        
        return cell!
    }
    
    
    
    //MARK:- Action
    
    
    func loginButtonAction(sender:UIButton) {
        printDebugLog(message: "loginButtonAction ...")
        resignLocalFirstResponder()
        showLoadingView()
        weak var weakSelf = self
        let userInfo = PersonalLoginUserForm(userName: (accountTextField.text?.description)!,passWord: (passwordTextField.text?.description)!)
        UserService.sharedInstance
            .personalLogin(userInfo)
            .map{UserService.sharedInstance.detail($0.components(separatedBy: "_")[0])}
            .concat()
            .subscribe{ event in
                
                weakSelf?.hideLoadingView()
                if case .next(let e) = event {
                    print("=====成功======")

                    //校验是否为 企业账号
                    if e.companyUser?.accountId != nil
                    {
                        PersonalType = false
                    }
                    if self.jumpFlag {
                        weakSelf?.intoMainView(from: "登录")
                    }else {
                        self.navigationController?.popViewController(animated: true)
                    }

                }
                if case .error(let e) = event {
                    print("=====失败======")
                    print(e)
                    
                    if let error = e as? HttpError
                    {
                        switch error
                        {
                        case .timeout:
                            
                            weakSelf?.showSystemAlertView(titleStr: "提示", message: "失败")
                            
                        case .serverException(let code,let message):
                            print(message)
                            try? weakSelf?.validateHttp(error)
                            //weakSelf?.showSystemAlertView(titleStr: "提示", message: message)
                           
                        default :
                            printDebugLog(message: "into here ...")
                        }
                        
                        
                        
                        
                    }
                    
                }
            }.disposed(by: bag)
        
        //暂时 添加测试账号
        //UserDefaults.standard.set("291_b73c4b61e6c44bc7b6ffa6c13f8fd6da", forKey: TOKEN_KEY)
    }
    
    func companysLoginButtonAction(sender:UIButton) {
        printDebugLog(message: "companysLoginButtonAction ...")
        resignLocalFirstResponder()
        let companyAccountView = CompanyAccountViewController()
        companyAccountView.title = "企业账号登录"
        self.navigationController?.pushViewController(companyAccountView, animated: true)
        
        
    }
    func forgetButtonAction(sender:UIButton) {
        printDebugLog(message: "forgetButtonAction ...")
        resignLocalFirstResponder()
        let forgetPasswordView = ForgetPasswordViewController()
        self.navigationController?.pushViewController(forgetPasswordView, animated: true)
        
    }
    
    override func rightButtonAction(sender: UIButton) {
        printDebugLog(message: "rightButtonAction ...")
        resignLocalFirstResponder()
        let registerView = RegisterViewController()
        self.navigationController?.pushViewController(registerView, animated: true)
    }
    override func backButtonAction(sender: UIButton) {
        resignLocalFirstResponder()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    private func resignLocalFirstResponder()
    {
        
        accountTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
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
