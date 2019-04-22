//
//  ForgetPasswordViewController.swift
//  shop
//
//  Created by manman on 2017/4/20.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift


let forgetPasswordTableViewCellIdentify = "forgetPasswordTableViewCellIdentify"

class ForgetPasswordViewController: CompanyBaseViewController ,UITableViewDataSource,UITableViewDelegate {
    
    private var tableView = UITableView()
    private var accountTextField = UITextField()
    private var passwordTextField = UITextField()
    private var verifyCodeButton = UIButton()
    private var nextButton = UIButton()
    fileprivate var shutDownTime:Timer!
    fileprivate var shutDownInt:Int = shutDownMax
    private let bag = DisposeBag()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        // Do any additional setup after loading the view.
        
        setTitle(titleStr: "忘记密码")
        //self.navigationItem.hidesBackButton = true
        setNavigationBackButton(backImage: "")
        setCustomUIAutolayout()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.resetLocalData()
    }
    
    
    func resetClearLocalData() {
        self.shutDownInt = 0
        if self.shutDownTime != nil{
            self.shutDownTime.invalidate()
            self.shutDownTime = nil
        }
        
        self.verifyCodeButton.setTitle("获取验证码", for: UIControlState.disabled);
        self.verifyCodeButton.isEnabled = false;
    }
    
    func resetLocalData() {
        self.shutDownInt = shutDownMax
        if self.accountTextField != nil  && self.accountTextField.text?.characters.count == 11 {
            
            self.verifyCodeButton.isEnabled = true;
            self.verifyCodeButton.setTitle("获取验证码", for: UIControlState.normal);
            self.verifyCodeButton.backgroundColor = TBIThemeBlueColor
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        printDebugLog(message: "viewWillDisappear ...")
        self.resetClearLocalData()
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
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: forgetPasswordTableViewCellIdentify)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.bottom.right.equalToSuperview()
            
        }
        
        
        
        
    }
    
    
    
    //MARK:-UITableViewDelegate
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
    
    //MARK:- UITableViewDataSources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: forgetPasswordTableViewCellIdentify)
        cell?.backgroundColor = TBIThemeBaseColor
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        //第一行。账号
        if indexPath.row == 0 {
            
            accountTextField = UITextField()
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
                make.height.equalTo(1)
                make.left.equalTo(15)
                make.right.equalToSuperview()
            })
            
            
            cell?.contentView.backgroundColor = UIColor.white
            
            return cell!
        }
        
        //第二行 密码
        if indexPath.row == 1 {
            
            passwordTextField = UITextField()
            passwordTextField.placeholder = "请输入短信验证码"
            passwordTextField.font = UIFont.systemFont(ofSize: 16)
            cell?.contentView.addSubview(passwordTextField)
            passwordTextField.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.width.equalToSuperview().dividedBy(1.6)
                make.left.equalToSuperview().offset(15)
            })
            
            
            verifyCodeButton.layer.cornerRadius = 3
            verifyCodeButton.setTitle("发送验证码", for: UIControlState.normal)
            verifyCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            verifyCodeButton.backgroundColor = TBIThemeBlueColor
            verifyCodeButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            verifyCodeButton.addTarget(self, action: #selector(verifyCodeButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            cell?.contentView.addSubview(verifyCodeButton)
            verifyCodeButton.snp.makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.height.equalTo(30)
                make.right.equalToSuperview().offset(-15)
                make.width.equalTo(98)
                
            })
            
            //初步判断 是否为正确手机号
            let usernameValid = accountTextField.rx.text.orEmpty.asObservable().map{ $0.characters.count == 11 }
    
            Observable
                .combineLatest([usernameValid]){ $0.reduce(true){$0&&$1}}
                .do(onNext: { validate in
                    if validate {
                        self.verifyCodeButton.backgroundColor = TBIThemeBlueColor
                    }else {
                        self.verifyCodeButton.backgroundColor = UIColor.gray
                    }
                })
                .bind(to: verifyCodeButton.rx.isEnabled)
                .addDisposableTo(bag)
            
            
            
            
            
            cell?.contentView.backgroundColor = UIColor.white
            
            return cell!
        }
        
        
        if indexPath.row == 2 {
            cell?.contentView.backgroundColor = TBIThemeBaseColor
        }
        
        
        //第三行 登录按钮
        if indexPath.row == 3 {
            
            
            nextButton.layer.cornerRadius = 5
            nextButton.setTitle("下一步", for: UIControlState.normal)
            nextButton.backgroundColor = TBIThemeBlueColor
            nextButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            nextButton.addTarget(self, action: #selector(nextButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            cell?.contentView.addSubview(nextButton)
            nextButton.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.left.right.equalToSuperview().inset(15)
                
            })
            
            //初步判断 是否为正确手机号
            let usernameValid = accountTextField.rx.text.orEmpty.asObservable().map{ $0.characters.count == 11 }
            let varifyCodeValid = passwordTextField.rx.text.orEmpty.asObservable().map{
                $0.characters.count == 6
            }
            
            Observable
                .combineLatest([usernameValid,varifyCodeValid]){ $0.reduce(true){$0&&$1}}
                .do(onNext: { validate in
                    if validate {
                        self.nextButton.backgroundColor = TBIThemeBlueColor
                    }else {
                        self.nextButton.backgroundColor = UIColor.gray
                    }
                })
                .bind(to: nextButton.rx.isEnabled)
                .addDisposableTo(bag)
            
            
            
            
            
            
            return cell!
        }
   
        return cell!
    }
    
    
    
    //MARK:- Action
    //MARK:-  获取验证码。// 这个返回值 不能是验证码
    
    func verifyCodeButtonAction(sender:UIButton) {
        printDebugLog(message: "verifyCodeButtonAction ...")
        resignLocalFirstResponder()
        showLoadingView()
        weak var weakSelf = self
        UserService.sharedInstance
            .getverificationCode(tel: (accountTextField.text?.description)!, type: CodeType.forgotPassword)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                if case .next(let e) = event {
                    print("=====成功======")
                    print(e)
                    self.shutDownRegular(button: sender)
                    self.showSystemAlertView(titleStr: "提示", message:"发送成功")
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
                            
                        case .serverException(let _,let message):
                            print(message)
                            try? weakSelf?.validateHttp(error)
                            //self.showSystemAlertView(titleStr: "提示", message: message)
                            
                        default :
                            printDebugLog(message: "into here ...")
                        }
                        
                        
                        
                        
                    }
                    
                }
            }.disposed(by: bag)
        
        
        
        
    }
    
    
    func nextButtonAction(sender:UIButton) {
        printDebugLog(message: "nextButtonAction ...")
        resignLocalFirstResponder()
        var dic:[String:Any] = Dictionary.init()
        dic["type"] = "forgot_password"
        dic["code"] = passwordTextField.text
        
        showLoadingView()
        weak var weakSelf = self
        UserService.sharedInstance
            .validationCode(tel: accountTextField.text!, parameter:dic )
            .subscribe { (event) in
                
                weakSelf?.hideLoadingView()
                if case .next(let e) = event {
                    print("=====成功======")
                    print(e)
                    self.nextView()
                    
                    //self.showSystemAlertView(titleStr: "提示", message:e)
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
                             try? weakSelf?.validateHttp(error)
                            //self.showSystemAlertView(titleStr: "提示", message: message)
                            
                        default :
                            printDebugLog(message: "into here ...")
                        }
                        
                        
                        
                        
                    }
                    
                }
        }.disposed(by:bag)
        
        
        
        
        
        
    }
    
    
    func nextView() {
        let resetPasswordView = ResetPasswordViewController()
        resetPasswordView.userName = (accountTextField.text?.description)!
        resetPasswordView.verifyCode = (passwordTextField.text?.description)!
        self.navigationController?.pushViewController(resetPasswordView, animated: true)
        
    }
    
    
    func shutDownRegular(button:UIButton) {
        
        
        button.isEnabled = false
        button.setTitle("60s", for: UIControlState.disabled)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.backgroundColor = UIColor.lightGray
        shutDownTime = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(shutDownStart(timer:)), userInfo: button, repeats: true)
        shutDownTime.fire()
    }
    
    func shutDownStart(timer:Timer) {
        printDebugLog(message: "second \(self.shutDownInt)")
        self.shutDownInt -= 1
        let  button = timer.userInfo as! UIButton
        button.setTitle(String(format: "重发(%d)",self.shutDownInt), for: UIControlState.disabled)
        button.backgroundColor = TBIThemeGrayLineColor
        if self.shutDownInt <= 0 {
            timer.invalidate()
            button.isEnabled = true
            button.backgroundColor = TBIThemeBlueColor
            self.shutDownInt = shutDownMax
        }
    }
    
    
    
    
    
    
    
    override func backButtonAction(sender: UIButton) {
        printDebugLog(message: "backButtonAction ...")
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
