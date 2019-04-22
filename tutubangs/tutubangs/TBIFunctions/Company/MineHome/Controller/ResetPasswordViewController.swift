//
//  ResetPasswordViewController.swift
//  shop
//
//  Created by manman on 2017/4/20.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift

let resetPasswordTableViewCellIdentify = "resetPasswordTableViewCellIdentify"

class ResetPasswordViewController: CompanyBaseViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {
    var verifyCode = ""
    var userName = ""
    
    private var okayButton = UIButton()
    private var tableView = UITableView()
    private var companyAccountTextField = UITextField()
    private var accountTextField = UITextField()
    private var passwordTextField = UITextField()
    private let bag = DisposeBag()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        // Do any additional setup after loading the view.
        
        //self.navigationItem.hidesBackButton = true
        setTitle(titleStr:"设置新密码")
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
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: resetPasswordTableViewCellIdentify)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: resetPasswordTableViewCellIdentify)
        cell?.backgroundColor = TBIThemeBaseColor
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        //第一行。账号
        if indexPath.row == 0 {
            
            companyAccountTextField = UITextField()
            companyAccountTextField.tintColor = UIColor.blue
            companyAccountTextField.delegate = self
            companyAccountTextField.placeholder = "请输入新密码"
            companyAccountTextField.isSecureTextEntry = true
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
            passwordTextField.delegate = self
            passwordTextField.isSecureTextEntry = true
            passwordTextField.tintColor = UIColor.blue
            passwordTextField.placeholder = "请再次输入新密码"
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
        
        
        if indexPath.row == 2 {
            cell?.contentView.backgroundColor = TBIThemeBaseColor
        }
        
        
        
        //第三行 登录按钮
        if indexPath.row == 3 {
            
            okayButton.layer.cornerRadius = 5
            okayButton.backgroundColor = TBIThemeBlueColor
            
            okayButton.setTitle("完成", for: UIControlState.normal)
            okayButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
            okayButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            okayButton.addTarget(self, action: #selector(okayButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            cell?.contentView.addSubview(okayButton)
            okayButton.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.left.right.equalToSuperview().inset(15)
            })
            
            //初步判断 是否为正确手机号
            let usernameValid = companyAccountTextField.rx.text.orEmpty.asObservable().map{ $0.characters.count >= 6}
            let varifyCodeValid = passwordTextField.rx.text.orEmpty.asObservable().map{
                $0.characters.count >= 6
            }
    
            Observable
                .combineLatest([usernameValid,varifyCodeValid]){
                    $0.reduce(true){$0&&$1}
                }
                .do(onNext: { validate in
                    if validate {
                        self.okayButton.backgroundColor = TBIThemeBlueColor
                    }else {
                        self.okayButton.backgroundColor = UIColor.gray
                    }
                })
                .bind(to: okayButton.rx.isEnabled)
                .addDisposableTo(bag)
            
            
            
            
            
            
            return cell!
        }
        
        return cell!
    }
    
    
    //MARK:- Action
    
    
    func okayButtonAction(sender:UIButton) {
        printDebugLog(message: "okayButtonAction ...")
        resignLocalFirstResponder()
        showLoadingView()
        weak var weakSelf = self
        let userInfo = ModifyPasswordUserForm(userName:userName,passWord:(passwordTextField.text?.description)!,verifyCode:verifyCode)
        UserService.sharedInstance
            .modifyPassword(userInfo)
            .subscribe{ event in
                
                weakSelf?.hideLoadingView()
                if case .next(let e) = event {
                    print("=====成功======")
                    print(e)
                    weakSelf?.intoMainView(from: "修改密码")
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
        
        
        
        
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.characters.count == 20 && string != "" {
            showSystemAlertView(titleStr: "提示", message: "必须为6-20个字符")
            return false
        }
        return true
    }
    
    
    private func resignLocalFirstResponder()
    {
        companyAccountTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        accountTextField.resignFirstResponder()
    }
    
    override func backButtonAction(sender: UIButton) {
        printDebugLog(message: "backButtonAction ...")
        resignLocalFirstResponder()
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
