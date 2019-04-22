//
//  SwiftLoginView.swift
//  shanglvjia
//
//  Created by manman on 2018/3/28.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    
    typealias LoginViewExchangeLoginTypeBlock  = (String)->Void

    typealias LoginViewLoginBlock = (String,String,String)->Void
    
    typealias LoginViewGetVerifyCodeBlock = (String)->Void
    
    
    public var loginViewExchangeLoginTypeBlock:LoginViewExchangeLoginTypeBlock!
    
    public var loginViewLoginBlock:LoginViewLoginBlock!
    
    public var loginViewGetVerifyCodeBlock:LoginViewGetVerifyCodeBlock!
    
    private let countDownMAX:NSInteger = 60
    
    private let countDown:TBICountDown = TBICountDown()
    
    private let baseBackgroundView:UIView = UIView()
    
    private let swiftTitleLabel:UILabel = UILabel()
    
    private let swiftTitleTipDefault:String = "个人版"
    
    private let swiftTitleImage:UIImageView = UIImageView.init(imageName: "ic_car_pickup")
    
    private let accountTitleLabel:UILabel = UILabel()
    
    private let accountTitleImage:UIImageView = UIImageView.init(imageName: "ic_car_pickup")
    
    private let accountTitleTip:String = "商务版"
    
    ///背景图
    private let bgImageView:UIImageView = UIImageView()
    ///眼睛
    private let seeButton : UIButton = UIButton()
    /// 登录按钮
    private let loginButton:UIButton = UIButton()
    
    private let verifyCodeButton:UIButton = UIButton()
    
    /// 公司代码
    private let companyCodeTextField:UITextField = UITextField()
    
    /// 账号  手机号
    private let phoneTextField:UITextField = UITextField()
    
    /// 密码 验证码
    private let verifyCodeTextField:UITextField = UITextField()
    
    private let beforeFirstBottomLine:UILabel = UILabel()
    
    private let firstBottomLine:UILabel = UILabel()
    
    private let secondBottomLine:UILabel = UILabel()
    
    /// 快捷登录 手机号码
    private var swiftPhone:String = ""
    
    /// 快捷登录 验证码
    private var swiftVerifyCode:String = ""
    
    /// 公司代码
    private var companyCode:String = ""
    
    /// 公司账号
    private var companyAccount:String = ""
    
    /// 公司密码
    private var companyPassword:String = ""
    
    private var loginViewLoginType:LoginViewLoginType = LoginViewLoginType.SwiftLogin
    
    private let phonePlaceHolderTipDefault:String = "手机号"
    private let verifyCodeButtonPlaceHolderTipDefault:String = "获取验证码"
    private let companyCodePlaceHolderTipDefault:String = "公司代码"
    private let companyAccountPlaceHolderTipDefault:String = "用户名"
    private let companyPasswordPlaceHolderTipDefault:String = "密码"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(baseBackgroundView)
        baseBackgroundView.backgroundColor = TBIThemeWhite
        baseBackgroundView.snp.remakeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        setUIViewAutoLayout()
    }
    
   private  func setUIViewAutoLayout() {
    
        ///背景图
        bgImageView.backgroundColor = TBIThemeWhite
        bgImageView.image = UIImage(named:"bg_login")
        baseBackgroundView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.height.equalTo(kNavigationHeight + 120)
            make.top.left.right.equalTo(0)
        }
    
    //翻转图片的方向
    let selectImage = UIImage(named:"ic_car_pickup")
    let flipImageOrientation = ((selectImage?.imageOrientation.rawValue)! + 4) % 8
    let flipImage =  UIImage.init(cgImage: (selectImage?.cgImage)!, scale: (selectImage?.scale)!, orientation: UIImageOrientation(rawValue: flipImageOrientation)!)
    accountTitleImage.image = flipImage
    baseBackgroundView.addSubview(accountTitleImage)
    accountTitleImage.isHidden = true
    accountTitleImage.snp.makeConstraints { (make) in
        make.top.equalToSuperview().offset(kNavigationHeight + 78)
        make.right.equalToSuperview()
        make.width.equalToSuperview().dividedBy(2)
        make.height.equalTo(50)
    }
        ///商务版
        accountTitleLabel.textAlignment = NSTextAlignment.center
        accountTitleLabel.text = accountTitleTip
        accountTitleLabel.textColor = TBIThemeWhite
        accountTitleLabel.addOnClickListener(target: self, action:#selector(loginTypeChange(type:)))
        accountTitleLabel.font = UIFont.systemFont(ofSize: 16)
        baseBackgroundView.addSubview(accountTitleLabel)
        accountTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kNavigationHeight + 78)
            make.right.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(50)
        }
    
    
        baseBackgroundView.addSubview(swiftTitleImage)
        swiftTitleImage.isHidden = false
        swiftTitleImage.snp.makeConstraints { (make) in
            make.top.equalTo(accountTitleLabel)
            make.left.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(accountTitleLabel)
        }
        ///快捷登录
        swiftTitleLabel.textAlignment = NSTextAlignment.center
        swiftTitleLabel.addOnClickListener(target: self, action: #selector(loginTypeChange(type:)))
        swiftTitleLabel.text = swiftTitleTipDefault
        swiftTitleLabel.textColor = PersonalThemeDarkColor
        swiftTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        baseBackgroundView.addSubview(swiftTitleLabel)
        swiftTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(accountTitleLabel)
            make.left.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(accountTitleLabel)
        }
        swiftTitleLabel.layer.cornerRadius = 8
        swiftTitleLabel.clipsToBounds = true
    
    
    
        setAccountLoginView()
        companyCodeTextField.isHidden = true
        seeButton.isHidden = true
        setSwiftLoginView()
        
        loginButton.setTitleColor(TBIThemeWhite, for: UIControlState.normal)
        loginButton.setTitle("登录", for: UIControlState.normal)
        loginButton.layer.cornerRadius = 5
        loginButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        loginButton.clipsToBounds=true
        loginButton.addTarget(self, action: #selector(loginAction), for: UIControlEvents.touchUpInside)
    
        baseBackgroundView.addSubview(loginButton)
        loginButton.snp.remakeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
    
    }
    //快捷登录 视图 配置
   private func setSwiftLoginView() {
    
        phoneTextField.textColor = TBIThemePrimaryTextColor
        phoneTextField.placeholder = phonePlaceHolderTipDefault
        phoneTextField.font = UIFont.systemFont(ofSize: 16)
        baseBackgroundView.addSubview(phoneTextField)
        phoneTextField.snp.remakeConstraints { (make) in
            make.top.equalTo(swiftTitleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
    
        firstBottomLine.backgroundColor = TBIThemeGrayLineColor
        baseBackgroundView.addSubview(firstBottomLine)
        firstBottomLine.snp.remakeConstraints { (make) in
            make.top.equalTo(phoneTextField.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(0.5)
        }
        
        verifyCodeTextField.textColor = TBIThemePrimaryTextColor
        verifyCodeTextField.placeholder = verifyCodeButtonPlaceHolderTipDefault
        verifyCodeTextField.font = UIFont.systemFont(ofSize: 16)
        baseBackgroundView.addSubview(verifyCodeTextField)
        verifyCodeTextField.snp.remakeConstraints { (make) in
            make.top.equalTo(firstBottomLine.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(30)
            make.right.equalToSuperview().inset(100)
            make.height.equalTo(40)
        }
    
        secondBottomLine.backgroundColor = TBIThemeGrayLineColor
        baseBackgroundView.addSubview(secondBottomLine)
        secondBottomLine.snp.remakeConstraints { (make) in
            make.top.equalTo(verifyCodeTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(0.5)
        }
        
        
        verifyCodeButton.setTitle(verifyCodeButtonPlaceHolderTipDefault, for: UIControlState.normal)
        verifyCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
//        verifyCodeButton.layer.cornerRadius = 13
//        verifyCodeButton.setBackgroundImage(UIImage (named: "btn_gradient"), for: UIControlState.normal)
//        verifyCodeButton.clipsToBounds=true
//        verifyCodeButton.setTitleColor(TBIThemeWhite, for: UIControlState.normal)
        verifyCodeButton.setBackgroundImage(UIImage (named: ""), for: UIControlState.normal)
        verifyCodeButton.setTitleColor(PersonalThemeDarkColor, for: UIControlState.normal)
    
        verifyCodeButton.addTarget(self, action: #selector(getVerifyCodeAction), for: UIControlEvents.touchUpInside)
        baseBackgroundView.addSubview(verifyCodeButton)
        verifyCodeButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(verifyCodeTextField.snp.centerY)
            make.right.equalToSuperview().inset(30)
            make.width.equalTo(76)
            make.height.equalTo(26)
        }
    }
    
    
    //账号登录 视图 配置
    private func setAccountLoginView() {
     
        companyCodeTextField.textColor = TBIThemePrimaryTextColor
        companyCodeTextField.placeholder = companyCodePlaceHolderTipDefault
        companyCodeTextField.font = UIFont.systemFont(ofSize: 16)
        baseBackgroundView.addSubview(companyCodeTextField)
        companyCodeTextField.snp.remakeConstraints { (make) in
            make.top.equalTo(swiftTitleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
        
        beforeFirstBottomLine.backgroundColor = TBIThemeGrayLineColor
        baseBackgroundView.addSubview(beforeFirstBottomLine)
        beforeFirstBottomLine.snp.remakeConstraints { (make) in
            make.top.equalTo(companyCodeTextField.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(0.5)
        }
        
        
        phoneTextField.textColor = TBIThemePrimaryTextColor
        phoneTextField.placeholder = companyAccountPlaceHolderTipDefault
        phoneTextField.font = UIFont.systemFont(ofSize: 16)
        baseBackgroundView.addSubview(phoneTextField)
        phoneTextField.snp.remakeConstraints { (make) in
            make.top.equalTo(beforeFirstBottomLine.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
        
        let firstBottomLine:UILabel = UILabel()
        firstBottomLine.backgroundColor = TBIThemeGrayLineColor
        baseBackgroundView.addSubview(firstBottomLine)
        firstBottomLine.snp.remakeConstraints { (make) in
            make.top.equalTo(phoneTextField.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(0.5)
        }
        
        verifyCodeTextField.textColor = TBIThemePrimaryTextColor
        verifyCodeTextField.placeholder = companyPasswordPlaceHolderTipDefault
        verifyCodeTextField.font = UIFont.systemFont(ofSize: 16)
        baseBackgroundView.addSubview(verifyCodeTextField)
        verifyCodeTextField.snp.remakeConstraints { (make) in
            make.top.equalTo(firstBottomLine.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(30)
            make.right.equalToSuperview().inset(100)
            make.height.equalTo(40)
        }
        ///密码可见
        baseBackgroundView.addSubview(seeButton)
        seeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        seeButton.setImage(UIImage(named:"psd_nosee"), for: UIControlState.normal)
        seeButton.setImage(UIImage(named:"psd_see"), for: UIControlState.selected)
        seeButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(verifyCodeTextField)
            make.right.equalTo(phoneTextField)
            make.left.equalTo(verifyCodeTextField.snp.right)
        }
        seeButton.addTarget(self, action: #selector(seeButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        
        let secondBottomLine:UILabel = UILabel()
        secondBottomLine.backgroundColor = TBIThemeGrayLineColor
        baseBackgroundView.addSubview(secondBottomLine)
        secondBottomLine.snp.remakeConstraints { (make) in
            make.top.equalTo(verifyCodeTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(0.5)
        }
        
        
        verifyCodeButton.setTitle(verifyCodeButtonPlaceHolderTipDefault, for: UIControlState.normal)
        verifyCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        verifyCodeButton.layer.cornerRadius = 13
        verifyCodeButton.setTitleColor(TBIThemeWhite, for: UIControlState.normal)
        verifyCodeButton.addTarget(self, action: #selector(getVerifyCodeAction), for: UIControlEvents.touchUpInside)
        baseBackgroundView.addSubview(verifyCodeButton)
        verifyCodeButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(verifyCodeTextField.snp.centerY)
            make.right.equalToSuperview().inset(30)
            make.width.equalTo(70)
            make.height.equalTo(26)
        }
     
        
    }
    //MARK:---------setter  getter ----
    
    func getPhoneContent() -> String {
        return phoneTextField.text ?? ""
    }
    
    func getVerifyCodeContent() -> String {
        return verifyCodeTextField.text ?? ""
    }
    
    func swiftLoginFillDataSources() {
        
        companyCodeTextField.isHidden = true
        verifyCodeButton.isHidden = false
        seeButton.isHidden = true
        companyCode = companyCodeTextField.text ?? ""
        companyAccount = phoneTextField.text ?? ""
        companyPassword = verifyCodeTextField.text ?? ""
//        swiftTitleLabel.textColor = TBIThemeDarkBlueColor
        swiftTitleLabel.font=UIFont.boldSystemFont(ofSize: 16)
//        accountTitleLabel.textColor = TBIThemePlaceholderColor
        accountTitleLabel.font=UIFont.systemFont(ofSize: 16)
        phoneTextField.text = swiftPhone
        verifyCodeTextField.text = ""
        verifyCodeTextField.isSecureTextEntry = false
        ///换颜色
        swiftTitleImage.isHidden = false
        swiftTitleLabel.textColor = PersonalThemeDarkColor
        accountTitleImage.isHidden = true
        accountTitleLabel.textColor = TBIThemeWhite
        setSwiftLoginView()
//        if countDown.countDownStatus()  {
//            verifyCodeButton.backgroundColor = TBIThemePlaceholderColor
//        }else {verifyCodeButton.setBackgroundImage(UIImage (named: "btn_gradient"), for: UIControlState.normal) }
        if countDown.countDownStatus()  {
            verifyCodeButton.setTitleColor(TBIThemePlaceholderColor, for: UIControlState.normal)
        }else {verifyCodeButton.setTitleColor(PersonalThemeDarkColor, for: UIControlState.normal) }
        
    }
    func companyLoginFillDataSources() {
        companyCodeTextField.isHidden = false
        verifyCodeButton.isHidden = true
        seeButton.isHidden = false
        swiftPhone = phoneTextField.text ?? ""
        swiftVerifyCode = verifyCodeTextField.text ?? ""
//        swiftTitleLabel.textColor = TBIThemePlaceholderColor
        swiftTitleLabel.font=UIFont.systemFont(ofSize: 16)
//        accountTitleLabel.textColor = TBIThemeDarkBlueColor
        accountTitleLabel.font=UIFont.boldSystemFont(ofSize: 16)
        phoneTextField.text = companyAccount
        companyCodeTextField.text = companyCode
        verifyCodeTextField.text = ""
        verifyCodeTextField.isSecureTextEntry = true
        ///换颜色
        accountTitleImage.isHidden = false
        accountTitleLabel.textColor = PersonalThemeDarkColor
        swiftTitleImage.isHidden = true
        swiftTitleLabel.textColor = TBIThemeWhite
        setAccountLoginView()
    }
    
    /// 获得登录方式
    func getLoginViewLoginType()->LoginViewLoginType {
        return loginViewLoginType
    }
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneTextField.resignFirstResponder()
        verifyCodeTextField.resignFirstResponder()
    }
    
    
    
    
    //MARK:--------Action---------
    @objc private func getVerifyCodeAction(sender:UIButton) {
        printDebugLog(message: "获取验证码")
        guard phoneTextField.text?.count == 11 && (phoneTextField.text?.validate(ValidateType.phone) ?? false) == true else {
            return
        }
        if loginViewGetVerifyCodeBlock != nil {
            loginViewGetVerifyCodeBlock(phoneTextField.text ?? "")
        }
        
        countDown.startCounting(seconds:countDownMAX)
        weak var weakSelf = self
        sender.isEnabled = false
//        sender.backgroundColor = TBIThemePlaceholderColor
        sender.setTitleColor(TBIThemePlaceholderColor, for: UIControlState.normal)
        
        countDown.countDownSecondIntervalBlcok = { remainInterval in
            weakSelf?.verifyCodeButton.setTitle(remainInterval.description + "S", for: UIControlState.normal)
            if remainInterval == 0 {
                weakSelf?.verifyCodeButton.isEnabled = true
//                weakSelf?.verifyCodeButton.setBackgroundImage(UIImage (named: "btn_gradient"), for: UIControlState.normal)
                weakSelf?.verifyCodeButton.setTitleColor(TBIThemeDarkBlueColor, for: UIControlState.normal)
                weakSelf?.verifyCodeButton.setTitle(weakSelf?.verifyCodeButtonPlaceHolderTipDefault, for: UIControlState.normal)
                
            }
        }
        
    }
    
    func loginAction() {
        
        if loginViewLoginType == LoginViewLoginType.SwiftLogin {
            guard phoneTextField.text?.validate(ValidateType.phone) == true && verifyCodeTextField.text?.count == 6 else {
                return
            }
        }else
        {
            guard companyCodeTextField.text?.isEmpty == false && phoneTextField.text?.isEmpty == false && verifyCodeTextField.text?.isEmpty == false else {
                return
            }
        }
        
        
        printDebugLog(message: "登录")
        if loginViewLoginBlock  != nil {
            loginViewLoginBlock(phoneTextField.text ?? "",verifyCodeTextField.text ?? "",companyCodeTextField.text ?? "")
        }
    }
    
    
    /// 切换 登录方式
    func loginTypeChange(type:UITapGestureRecognizer) {
        
        let tmpLabel:UILabel = type.view as! UILabel
        
        if loginViewExchangeLoginTypeBlock != nil {
            var typeStr:String = ""
            if type == swiftTitleLabel { typeStr = "swift"}
            loginViewExchangeLoginTypeBlock(typeStr)
        }
        
        phoneTextField.resignFirstResponder()
        verifyCodeTextField.resignFirstResponder()
        companyCodeTextField.resignFirstResponder()
        
        switch tmpLabel {
        case swiftTitleLabel:
            loginViewLoginType = LoginViewLoginType.SwiftLogin
            swiftLoginFillDataSources()
        case accountTitleLabel:
            loginViewLoginType = LoginViewLoginType.AccountLogin
            companyLoginFillDataSources()
        default:
            break
        }
    }
    
    enum LoginViewLoginType:NSInteger {
        case SwiftLogin = 1
        case AccountLogin = 2
    }
    
    func seeButtonClick(sender:UIButton) {
        if sender.isSelected{
            verifyCodeTextField.isSecureTextEntry = true
        }else{
            verifyCodeTextField.isSecureTextEntry = false
        }
        
        sender.isSelected = !sender.isSelected
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
