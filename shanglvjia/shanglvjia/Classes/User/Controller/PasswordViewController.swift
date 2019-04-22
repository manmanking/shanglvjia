//
//  PasswordViewController.swift
//  shop
//
//  Created by manman on 2017/4/14.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

import RxSwift

class PasswordViewController: BaseViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {

    
    var userName = ""
    var verifyCode = ""
    
    private var tableView = UITableView()
    private var accountTextField = UITextField()
    private var passwordTextField = UITextField()
    private var registerButton = UIButton()
    private let bag = DisposeBag()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        // Do any additional setup after loading the view.
        
        setTitle(titleStr: "设置密码")
        setNavigationBackButton(backImage: "")
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
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: tableViewCellIdentify)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentify)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        //第一行。账号
        if indexPath.row == 0 {
            
            accountTextField = UITextField()
            accountTextField.backgroundColor = UIColor.white
            accountTextField.tintColor = UIColor.blue
            accountTextField.placeholder = "请输入密码"
            accountTextField.delegate  = self
            accountTextField.isSecureTextEntry = true
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
            
            return cell!
        }
        
        //第二行 密码
        if indexPath.row == 1 {
            
            passwordTextField = UITextField()
            passwordTextField.backgroundColor = UIColor.white
            passwordTextField.placeholder = "请再次输入密码"
            passwordTextField.isSecureTextEntry = true
            passwordTextField.delegate = self
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
            
            
            registerButton.layer.cornerRadius = 5
            registerButton.setTitle("注册", for: UIControlState.normal)
            registerButton.backgroundColor = TBIThemeBlueColor
            registerButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            registerButton.addTarget(self, action: #selector(registerButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            cell?.contentView.addSubview(registerButton)
            registerButton.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.left.right.equalToSuperview().inset(15)
                
            })
            
            //初步判断 是否为正确手机号
            let usernameValid = accountTextField.rx.text.orEmpty.asObservable().map{ $0.characters.count >= 6 }
            let verifyCodeValid = passwordTextField.rx.text.orEmpty.asObservable().map{
                $0.characters.count >= 6 }
//            let verify = passwordTextField.rx.text.observable.of(self.accountTextField.text)
//            .su
            Observable
                .combineLatest([usernameValid,verifyCodeValid]){ $0.reduce(true){$0&&$1}}
                .do(onNext: { validate in
                    if validate {
                        self.registerButton.backgroundColor = TBIThemeBlueColor
                    }else {
                        self.registerButton.backgroundColor = UIColor.gray
                    }
                })
                .bind(to: registerButton.rx.isEnabled)
                .addDisposableTo(bag)
            return cell!
        }

        return cell!
    }
    
    
    
    //MARK:- Action
    
    
    func registerButtonAction(sender:UIButton) {
        printDebugLog(message: "passwordButtonAction ...")
        
        guard passwordTextField.text == accountTextField.text   else {
            showSystemAlertView(titleStr: "提示", message: "再次输入密码不一致")
            return
        }
        
        resignLocalFirstResponder()
        showLoadingView()
        weak var weakSelf = self
        let userInfo = RegisterUserForm(userName: userName, passWord: (passwordTextField.text?.description)!, verifyCode: verifyCode)
        UserService.sharedInstance
            .register(userInfo)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                if case .next(let e) = event {
                    print("=====成功======")
                    print(e)
                    
                    self.intoNextView()
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
            }.disposed(by: bag)
       
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.characters.count == 20 && string != "" {
            showSystemAlertView(titleStr: "提示", message: "必须为6-20个字符")
            return false
        }
        return true
    }
    
    
    
    
    override func backButtonAction(sender: UIButton) {
        printDebugLog(message: "backButtonAction ...")
        resignLocalFirstResponder()
        _ = self.navigationController?.popViewController(animated: true)
        return
    }
    
    
    private func resignLocalFirstResponder()
    {
        accountTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
    func intoNextView() {
        
        resignLocalFirstResponder()
        let companyAccountView = CompanyAccountViewController()
        companyAccountView.title = "绑定公司账号"
        self.navigationController?.pushViewController(companyAccountView, animated: true)
        
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
