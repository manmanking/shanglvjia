//
//  BingPersonalAccountViewController.swift
//  shop
//
//  Created by manman on 2017/4/18.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class BingPersonalAccountViewController: CompanyBaseViewController ,UITableViewDataSource,UITableViewDelegate{
    private let bag = DisposeBag()
    private var tableView = UITableView()
    private var surePasswordTextField = UITextField()
    private var passwordTextField = UITextField()
    private var phoneTextField = UITextField()
    private var verifyCodeTextField = UITextField()
    private var verifyCodeButton = UIButton()
    fileprivate var shutDownTime:Timer!
    fileprivate var shutDownInt:Int = shutDownMax
    private var numberRow:Int = 6
    
    
    /// 新需求  企业登录 无绑定手机号的 在绑定手机号时 不需要填写密码
    public var newDemand:Bool = false
    
    public var mobilePhone:String = ""
    public var  companyInfo:CompanyBindPersonForm?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        // Do any additional setup after loading the view.
        
        setTitle(titleStr: "绑定个人账号")
        if newDemand == true {
            numberRow = 4
        }
        
        //self.navigationItem.hidesBackButton = true
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
    
    
    
    //MARK:-UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
            
        case 4:
            return 30
            
            
        case 5:
            return 47
            
            
        default:
            return 44
            
        }
    }
    
    //MARK:- UITableViewDataSources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberRow
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentify)
        cell?.backgroundColor = TBIThemeBaseColor
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        //第一行。账号
        if indexPath.row == 0 {
            
            phoneTextField.tintColor = UIColor.blue
            phoneTextField.placeholder = "请输入手机号码"
            phoneTextField.font = UIFont.systemFont(ofSize: 16)
            cell?.contentView.addSubview(phoneTextField)
            phoneTextField.snp.makeConstraints({ (make) in
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
            
            verifyCodeTextField.placeholder = "请输入短信验证码"
            verifyCodeTextField.font = UIFont.systemFont(ofSize: 16)
            cell?.contentView.addSubview(verifyCodeTextField)
            verifyCodeTextField.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.width.equalToSuperview().dividedBy(1.6)
                make.left.equalToSuperview().offset(15)
            })
            
            
            verifyCodeButton.layer.cornerRadius = 3
            verifyCodeButton.tag = 11
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
            let usernameValid = phoneTextField.rx.text.orEmpty.asObservable().map{ $0.characters.count == 11 }
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
            let bottomLine = UILabel()
            bottomLine.backgroundColor = TBIThemeGrayLineColor
            cell?.contentView.addSubview(bottomLine)
            bottomLine.snp.makeConstraints({ (make) in
                make.bottom.equalToSuperview()
                make.height.equalTo(1)
                make.left.equalTo(15)
                make.right.equalToSuperview()
            })
            if numberRow == 4 {
                bottomLine.backgroundColor = UIColor.white
                if phoneTextField.text?.isEmpty == false {
                    self.shutDownRegular(button: verifyCodeButton)
                }
                
            }else
            {
                bottomLine.backgroundColor = TBIThemeGrayLineColor
            }
            
            
            
            cell?.contentView.backgroundColor = UIColor.white
            
            return cell!
        }
        
        
        if indexPath.row == 2  && numberRow == 6{
            
            passwordTextField.tintColor = UIColor.blue
            passwordTextField.placeholder = "请输入密码"
            passwordTextField.isSecureTextEntry = true
            passwordTextField.font = UIFont.systemFont(ofSize: 16)
            cell?.contentView.addSubview(passwordTextField)
            passwordTextField.snp.makeConstraints({ (make) in
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
        
        if indexPath.row == 3  && numberRow == 6{
            
            surePasswordTextField.tintColor = UIColor.blue
            surePasswordTextField.isSecureTextEntry = true
            surePasswordTextField.placeholder = "请再次输入密码"
            surePasswordTextField.font = UIFont.systemFont(ofSize: 16)
            cell?.contentView.addSubview(surePasswordTextField)
            surePasswordTextField.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.right.equalToSuperview()
                make.left.equalToSuperview().offset(15)
                
            })
            
            cell?.contentView.backgroundColor = UIColor.white
            
            return cell!
        }
        
        
        
        if indexPath.row == 4 || indexPath.row == 2 {
            cell?.contentView.isHidden = true
            cell?.contentView.backgroundColor = TBIThemeBaseColor
            return cell!
        }
        
        
        //第三行 登录按钮
        if indexPath.row == 5  || indexPath.row == 3{
            
            let bingButton = UIButton()
            bingButton.layer.cornerRadius = 5
            bingButton.setTitle("绑定", for: UIControlState.normal)
            bingButton.backgroundColor = TBIThemeBlueColor
            bingButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            bingButton.addTarget(self, action: #selector(bingButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            cell?.contentView.backgroundColor = TBIThemeBaseColor
            cell?.contentView.addSubview(bingButton)
            bingButton.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.left.right.equalToSuperview().inset(15)
                
            })
            
            
            return cell!
        }
        
        return cell!
    }
    
    
    
    //MARK:- Action
    //1008:已注册用户不用显示密码直接绑定
    func verifyCodeButtonAction(sender:UIButton) {
        //verifyCodeButton.isUserInteractionEnabled = false
        printDebugLog(message: "verifyCodeButtonAction ...")
        showLoadingView()
        resignLocalFirstResponder()
        weak var weakSelf = self
        UserService.sharedInstance.getverificationCode(tel: phoneTextField.text!, type: CodeType.binding)
            .subscribe{ (event) in
                weakSelf?.hideLoadingView()
                if case .next(let e) = event {
                    print("=====成功======")
                    print(e)
                    
                    if weakSelf?.numberRow == 4 && weakSelf?.newDemand == false
                    {
                        weakSelf?.numberRow = 6
                        weakSelf?.tableView.reloadData()
                    }
                    
                    self.shutDownRegular(button: sender)
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
                            
                            if code == 1008
                            {
                                weakSelf?.numberRow = 4
                                weakSelf?.tableView.reloadData()
                                
                            }else if code == 1023
                            {
                                weakSelf?.showSystemAlertView(titleStr: "提示", message: message)
                            }
                            
                            
                            
                            
                        default :
                            printDebugLog(message: "into here ...")
                        }
                    }
                    
                }
            }.disposed(by:bag)

        
    }
    
    
    func bingButtonAction(sender:UIButton) {
        printDebugLog(message: "bingButtonAction ...")
        
        if verifyCodeTextField.text?.isEmpty == true {
            showSystemAlertView(titleStr: "提示", message: "请输入验证码")
            return
        }
        
        if  numberRow == 6 {
            if passwordTextField.text != surePasswordTextField.text || passwordTextField.text?.isEmpty == true
            {
                showSystemAlertView(titleStr: "提示", message: "密码不一致")
                return
                
            }
        }
        
       
        
        
        
        resignLocalFirstResponder()
        companyInfo?.userName = phoneTextField.text!
        companyInfo?.verifyCode = verifyCodeTextField.text!
        companyInfo?.passWord = passwordTextField.text!
        showLoadingView()
        weak var weakSelf = self
        UserService.sharedInstance
            .companyBindPerson(companyInfo!)
            .subscribe { (event) in
            weakSelf?.hideLoadingView()
            if case .next(let e) = event {
                print("=====成功======")
                print(e)
                //企业账号标志
                PersonalType = false
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
                        
                        weakSelf?.showSystemAlertView(titleStr: "提示", message: "失败")
                        
                    case .serverException(let code,let message):
                        print(message)
                        weakSelf?.showSystemAlertView(titleStr: "提示", message: message)
                        
                    default :
                        printDebugLog(message: "into here ...")
                    }
                }
                
            }
        }.disposed(by:bag)
        
    }
    
    
    
    func shutDownRegular(button:UIButton) {
        
        phoneTextField.isEnabled = false
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
//        DispatchQueue.main.async(execute: {
            button.setTitle(String(format: "重发(%d)",self.shutDownInt), for: UIControlState.disabled)
            button.backgroundColor = TBIThemeGrayLineColor
//        })
        
//        let tmpButton:UIButton = self.tableView.viewWithTag(11) as! UIButton
//        tmpButton.setTitle(String(format: "重发(%d)",self.shutDownInt), for: UIControlState.disabled)
        //tmpButton.backgroundColor = TBIThemeGrayLineColor
        if self.shutDownInt <= 0 {
            timer.invalidate()
            button.isEnabled = true
            button.setTitle("发送验证码", for: UIControlState.disabled)
            phoneTextField.isEnabled = true
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
        surePasswordTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        verifyCodeTextField.resignFirstResponder()
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
