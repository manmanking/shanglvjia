//
//  PersonalAccountViewController.swift
//  shop
//
//  Created by manman on 2017/4/14.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class PersonalAccountViewController: BaseViewController,UITableViewDataSource {
    
    private var tableView = UITableView()
    private var accountTextField = UITextField()
    private var passwordTextField = UITextField()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
        setTitle(titleStr: "注册")
        self.navigationItem.hidesBackButton = true
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
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: tableViewCellIdentify)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = UIColor.lightGray
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
            
        }
        
        
        
        
    }
    
    
    //MARK:- UITableViewDataSources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentify)
        cell?.backgroundColor = UIColor.lightGray
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        //第一行。账号
        if indexPath.row == 0 {
            
            accountTextField = UITextField()
            accountTextField.tintColor = UIColor.blue
            accountTextField.placeholder = " 请输入手机号"
            accountTextField.layer.cornerRadius = 5
            accountTextField.layer.borderWidth = 2
            accountTextField.layer.borderColor = UIColor.gray.cgColor
            cell?.contentView.addSubview(accountTextField)
            accountTextField.snp.makeConstraints({ (make) in
                make.top.equalTo(5)
                make.left.right.equalToSuperview()
                make.bottom.equalTo(5)
            })
            
            
            return cell!
        }
        
        //第二行 密码
        if indexPath.row == 1 {
            
            passwordTextField = UITextField()
            passwordTextField.placeholder = " 请输入验证码"
            passwordTextField.layer.cornerRadius = 5
            passwordTextField.layer.borderWidth = 2
            passwordTextField.layer.borderColor = UIColor.gray.cgColor
            cell?.contentView.addSubview(passwordTextField)
            passwordTextField.snp.makeConstraints({ (make) in
                make.top.equalTo(5)
                make.left.right.equalToSuperview().dividedBy(1.6)
                make.bottom.equalTo(5)
            })
            
            let verifyCodeButton = UIButton()
            verifyCodeButton.setTitle("发送验证码", for: UIControlState.normal)
            verifyCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            verifyCodeButton.backgroundColor = UIColor.white
            verifyCodeButton.layer.borderColor = UIColor.lightGray.cgColor
            verifyCodeButton.layer.borderWidth = 2
            verifyCodeButton.layer.cornerRadius = 5
            
            verifyCodeButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            verifyCodeButton.addTarget(self, action: #selector(verifyCodeButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            cell?.contentView.addSubview(verifyCodeButton)
            verifyCodeButton.snp.makeConstraints({ (make) in
                make.top.equalTo(5)
                make.right.equalToSuperview()
                make.left.equalTo(passwordTextField.snp.right).offset(5)
                make.bottom.equalTo(5)
            })
            
            
            
            return cell!
        }
        
        //第三行 登录按钮
        if indexPath.row == 2 {
            
            let nextButton = UIButton()
            nextButton.setTitle("下一步", for: UIControlState.normal)
            nextButton.backgroundColor = UIColor.white
            nextButton.layer.borderColor = UIColor.lightGray.cgColor
            nextButton.layer.borderWidth = 2
            nextButton.layer.cornerRadius = 5
            
            nextButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            nextButton.addTarget(self, action: #selector(nextButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            
            
            cell?.contentView.addSubview(nextButton)
            nextButton.snp.makeConstraints({ (make) in
                make.top.equalTo(5)
                make.left.right.equalToSuperview().inset(10)
                make.bottom.equalTo(5)
            })
            
            
            return cell!
        }
        
        
        
        return cell!
    }
    
    
    
    //MARK:- Action
    
    func verifyCodeButtonAction(sender:UIButton) {
        resignLocalFirstResponder()
        printDebugLog(message: "verifyCodeButtonAction ...")
    }
    
    
    func nextButtonAction(sender:UIButton) {
        resignLocalFirstResponder()
        printDebugLog(message: "nextButtonAction ...")
        let passwordView = PasswordViewController()
        self.navigationController?.pushViewController(passwordView, animated: true)
        
    }
    
    private func resignLocalFirstResponder()
    {
        
        passwordTextField.resignFirstResponder()
        accountTextField.resignFirstResponder()
        
        
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
