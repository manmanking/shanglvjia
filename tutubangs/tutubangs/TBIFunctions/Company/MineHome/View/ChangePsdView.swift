//
//  ChangePsdView.swift
//  shanglvjia
//
//  Created by tbi on 2018/6/19.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class ChangePsdView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let oldPwLabel = UILabel(text:"    旧密码", color: TBIThemePrimaryTextColor, size: 15)
    let newPwLabel = UILabel(text:"    新密码", color: TBIThemePrimaryTextColor, size: 15)
    let againPwLabel = UILabel(text:"    确认新密码", color: TBIThemePrimaryTextColor, size: 15)
    //线
    var firstLineLabel = UILabel()
    //线
    var secondLLabel = UILabel()
    
    let oldPwTextField = CustomTextField(fontSize:16)
    let newPwTextField = CustomTextField(fontSize:16)
    let againPwTextField = CustomTextField(fontSize:16)
    
    let submitButton = UIButton(title:"",titleColor: TBIThemeWhite,titleSize: 16)
    
    
    ///验证码
     typealias BindViewGetVerifyCodeBlock = (String)->Void
    public var bindViewGetVerifyCodeBlock:BindViewGetVerifyCodeBlock!
    private let countDownMAX:NSInteger = 60
    
    private let countDown:TBICountDown = TBICountDown()
    let verifyCodeButton:UIButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()  {
        self.backgroundColor = TBIThemeBaseColor
        self.addSubview(oldPwLabel)
        self.addSubview(oldPwTextField)
        self.addSubview(newPwLabel)
        self.addSubview(newPwTextField)
        self.addSubview(againPwLabel)
        self.addSubview(againPwTextField)
        self.addSubview(submitButton)
        self.addSubview(firstLineLabel)
        self.addSubview(secondLLabel)
        
        oldPwTextField.backgroundColor = TBIThemeWhite
        newPwTextField.backgroundColor = TBIThemeWhite
        againPwTextField.backgroundColor = TBIThemeWhite
        oldPwLabel.backgroundColor = TBIThemeWhite
        newPwLabel.backgroundColor = TBIThemeWhite
        againPwLabel.backgroundColor = TBIThemeWhite
        oldPwTextField.isSecureTextEntry = true
        newPwTextField.isSecureTextEntry = true
        againPwTextField.isSecureTextEntry = true
        
        oldPwLabel.textAlignment = NSTextAlignment.left
        oldPwLabel.snp.makeConstraints{ make in
            make.left.equalTo(0)
            make.top.equalTo(10)
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        oldPwTextField.placeholder = "当前登录密码"
        oldPwTextField.snp.makeConstraints{make in
            make.right.equalTo(0)
            make.left.equalTo(oldPwLabel.snp.right)
            make.top.equalTo(oldPwLabel.snp.top)
            make.height.equalTo(oldPwLabel.snp.height)
        }
        
        firstLineLabel.backgroundColor = TBIThemeBaseColor
        firstLineLabel.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.right.equalTo(0)
            make.height.equalTo(1)
            make.bottom.equalTo(oldPwTextField.snp.bottom)
        }
        
        newPwLabel.textAlignment = NSTextAlignment.left
        newPwLabel.snp.makeConstraints{ make in
            make.left.equalTo(oldPwLabel.snp.left)
            make.top.equalTo(oldPwLabel.snp.bottom)
            make.width.equalTo(oldPwLabel.snp.width)
            make.height.equalTo(oldPwLabel.snp.height)
        }
        newPwTextField.placeholder = "6-20位字母、数字"
        newPwTextField.snp.makeConstraints{make in
            make.right.equalTo(0)
            make.left.equalTo(newPwLabel.snp.right)
            make.top.equalTo(newPwLabel.snp.top)
            make.height.equalTo(newPwLabel.snp.height)
        }
        
        secondLLabel.backgroundColor = TBIThemeBaseColor
        secondLLabel.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.right.equalTo(0)
            make.height.equalTo(1)
            make.bottom.equalTo(newPwTextField.snp.bottom)
        }
        
        againPwLabel.textAlignment = NSTextAlignment.left
        againPwLabel.snp.makeConstraints{ make in
            make.left.equalTo(newPwLabel.snp.left)
            make.top.equalTo(newPwLabel.snp.bottom)
            make.width.equalTo(newPwLabel.snp.width)
            make.height.equalTo(newPwLabel.snp.height)
        }
        againPwTextField.placeholder = "再次输入新密码"
        againPwTextField.snp.makeConstraints{make in
            make.right.equalTo(0)
            make.left.equalTo(againPwLabel.snp.right)
            make.top.equalTo(againPwLabel.snp.top)
            make.height.equalTo(againPwLabel.snp.height)
        }
        
        submitButton.setTitle("完成", for: UIControlState.normal)
        submitButton.layer.cornerRadius = 4
        submitButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        submitButton.clipsToBounds=true
        submitButton.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(48)
            make.top.equalTo(againPwTextField.snp.bottom).offset(30)
        }
    }
    
    func bindBusinessNum() {
        oldPwLabel.text = "    公司"
        newPwLabel.text = "    商务账号"
        againPwLabel.text = "    密码"
        oldPwTextField.placeholder = "请输入您的公司代码"
        oldPwTextField.isSecureTextEntry = false
        newPwTextField.isSecureTextEntry = false
        newPwTextField.placeholder = "请输入您的商务代码"
        againPwTextField.placeholder = "请输入您的密码"
        submitButton.setTitle("绑定", for: UIControlState.normal)
        let userInfo:LoginResponse? = DBManager.shareInstance.userDetailDraw()
        oldPwTextField.text = userInfo?.busLoginInfo.userBaseInfo.corpCode
        newPwTextField.text = userInfo?.busLoginInfo.userBaseInfo.loginName
        ///如果已经绑定企业账号。仅展示
        if (oldPwTextField.text?.isNotEmpty)!{
            againPwLabel.isHidden = true
            againPwTextField.isHidden = true
            submitButton.isHidden = true
            oldPwTextField.isEnabled = false
            newPwTextField.isEnabled = false
        }
    }
    
    func changeBaseInfo() {
        oldPwLabel.text = "    姓名"
        newPwLabel.text = "    性别"
        oldPwTextField.placeholder = "请输入您的姓名"
        newPwTextField.placeholder = "请选择您的性别"
        oldPwTextField.isSecureTextEntry = false
        newPwTextField.isSecureTextEntry = false
        newPwTextField.addOnClickListener(target: self, action: #selector(selectSexClick(tap: )))
        
        againPwLabel.isHidden = true
        againPwTextField.isHidden = true
        submitButton.setTitle("保存", for: UIControlState.normal)
        submitButton.snp.remakeConstraints { (make) in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(48)
            make.top.equalTo(newPwTextField.snp.bottom).offset(30)
        }
    }
    func bindPersonal() {
        oldPwLabel.text = "    手机号"
        newPwLabel.text = "    验证码"
        oldPwTextField.placeholder = "请输入您的手机号"
        oldPwTextField.keyboardType = UIKeyboardType.numberPad
        newPwTextField.placeholder = ""
        oldPwTextField.isSecureTextEntry = false
        newPwTextField.isSecureTextEntry = false
        newPwTextField.keyboardType = UIKeyboardType.numberPad
        
        againPwLabel.isHidden = true
        againPwTextField.isHidden = true
        submitButton.setTitle("绑定", for: UIControlState.normal)
        submitButton.snp.remakeConstraints { (make) in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(48)
            make.top.equalTo(newPwTextField.snp.bottom).offset(30)
        }
        
        verifyCodeButton.setTitle("获取验证码", for: UIControlState.normal)
        verifyCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
         verifyCodeButton.layer.cornerRadius = 2
         verifyCodeButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
         verifyCodeButton.clipsToBounds=true
         verifyCodeButton.setTitleColor(TBIThemeWhite, for: UIControlState.normal)
        
        verifyCodeButton.addTarget(self, action: #selector(getVerifyCodeAction), for: UIControlEvents.touchUpInside)
        newPwTextField.addSubview(verifyCodeButton)
        verifyCodeButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(newPwTextField.snp.centerY)
            make.right.equalToSuperview().inset(15)
            make.width.equalTo(76)
            make.height.equalTo(26)
        }
        if countDown.countDownStatus()  {
            verifyCodeButton.setTitleColor(TBIThemePlaceholderColor, for: UIControlState.normal)
        }else {verifyCodeButton.setTitleColor(TBIThemeWhite, for: UIControlState.normal) }
    }
    //MARK:--------getVerifyCodeAction Action---------
    @objc private func getVerifyCodeAction(sender:UIButton) {
        printDebugLog(message: "获取验证码")
        guard oldPwTextField.text?.count == 11 && (oldPwTextField.text?.validate(ValidateType.phone) ?? false) == true else {
            return
        }
        if bindViewGetVerifyCodeBlock != nil {
            bindViewGetVerifyCodeBlock(oldPwTextField.text ?? "")
        }
        countDown.startCounting(seconds:countDownMAX)
        
        weak var weakSelf = self
        sender.isEnabled = false
        sender.backgroundColor = TBIThemePlaceholderColor
        countDown.countDownSecondIntervalBlcok = { remainInterval in
            weakSelf?.verifyCodeButton.setTitle(remainInterval.description + "S", for: UIControlState.normal)
            if remainInterval == 0 {
                weakSelf?.verifyCodeButton.isEnabled = true
                                weakSelf?.verifyCodeButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
                weakSelf?.verifyCodeButton.setTitle("获取验证码", for: UIControlState.normal)
                
            }
        }
        
    }
    //MARK:--------修改性别---------
    func selectSexClick(tap:UITapGestureRecognizer){
        weak var weakSelf = self
        let titleArr:[String] = ["男","女"]
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.rowHeight = 80
        roleView.fontSize = UIFont.systemFont(ofSize: 18)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            weakSelf?.newPwTextField.text = titleArr[cellIndex]
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
    }
    
    //MARK:-------出行人信息--------
    func updateLeavePeople(){
        oldPwLabel.text = "    姓名"
        newPwLabel.text = "    证件类型"
        oldPwTextField.placeholder = "请输入您的姓名"
        newPwTextField.placeholder = "请选择证件类型"
        againPwLabel.text = "    证件号"
        againPwTextField.placeholder = "请输入证件号码"
        oldPwTextField.isSecureTextEntry = false
        newPwTextField.isSecureTextEntry = false
        againPwTextField.isSecureTextEntry = false
        newPwTextField.addOnClickListener(target: self, action: #selector(selectIDTypeClick(tap: )))
        
        let arrowImage = UIImageView()
        newPwTextField.addSubview(arrowImage)
        arrowImage.image = UIImage(named:"ic_right_gray")
        arrowImage.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(23)
            make.centerY.equalToSuperview()
        }
        
        submitButton.setTitle("完成", for: UIControlState.normal)

    }
    func selectIDTypeClick(tap:UITapGestureRecognizer){
        weak var weakSelf = self
        self.endEditing(true)
        let titleArr:[String] = ["身份证","护照"]
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.rowHeight = 80
        roleView.fontSize = UIFont.systemFont(ofSize: 18)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            weakSelf?.newPwTextField.text = titleArr[cellIndex]
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
    }

}
