//
//  ChanegePsdViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/6/19.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class ChanegePsdViewController: CompanyBaseViewController {

    fileprivate let bag = DisposeBag()
    var type:String = ""
    let updatePasswordView:ChangePsdView  =  ChangePsdView()
    
    var oldPwText:String = ""
    var newPwText:String = ""
    var againPwText:String = ""
    
    typealias fillLeavePeopleModelBlock = (VisaOrderAddResquest.BaseVisaPassengerVo) -> Void
     public var fillPeopleModelBlock:fillLeavePeopleModelBlock!
    var leavePeopleModel = VisaOrderAddResquest.BaseVisaPassengerVo()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = TBIThemeBaseColor
        
         initView ()
    }
    override func viewWillAppear(_ animated: Bool) {
        if type == "changePwd"{
            setBlackTitleAndNavigationColor(title: "修改企业密码")
        }else if type == "changeBaseInfo"{
            setBlackTitleAndNavigationColor(title: "基本信息")
        }else if type == "selectLeavePeople"{
            setBlackTitleAndNavigationColor(title: "出行人信息")
        }else if type == "bindPersonal"{
            setBlackTitleAndNavigationColor(title: "绑定个人版")
        }
        else
        {
            setBlackTitleAndNavigationColor(title: "绑定企业账号")
        }
    }
    override func backButtonAction(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initView()  {
        updatePasswordView.frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight)
        self.view.addSubview(updatePasswordView)
        if type == "changePwd"{
           updatePasswordView.submitButton.addTarget(self,action:#selector(submitButtonAction(sender:)),for: UIControlEvents.touchUpInside)
        }else if type == "changeBaseInfo"{
            updatePasswordView.changeBaseInfo();            updatePasswordView.submitButton.addTarget(self,action:#selector(changeBaseInfoButtonAction(sender:)),for: UIControlEvents.touchUpInside)
        }else if type == "selectLeavePeople"{
            updatePasswordView.updateLeavePeople();
           updatePasswordView.oldPwTextField.text = leavePeopleModel.vpName
            updatePasswordView.againPwTextField.text = leavePeopleModel.vpPassportno
            updatePasswordView.submitButton.addTarget(self,action:#selector(leavePeopleButtonAction(sender:)),for: UIControlEvents.touchUpInside)
        }else if type == "bindPersonal"{
            updatePasswordView.bindPersonal();
            weak var weakSelf = self
            updatePasswordView.bindViewGetVerifyCodeBlock = { phone in
                weakSelf?.getVerifyCodeNET(phone: phone)
            }
            updatePasswordView.submitButton.addTarget(self,action:#selector(bindPersonalButtonAction(sender:)),for: UIControlEvents.touchUpInside)
        }else{
            updatePasswordView.bindBusinessNum();            updatePasswordView.submitButton.addTarget(self,action:#selector(bindButtonAction(sender:)),for: UIControlEvents.touchUpInside)
        }
    }

    //绑定
    func bindButtonAction(sender:UIButton){
        guard updatePasswordView.oldPwTextField.text?.isEmpty == false && updatePasswordView.newPwTextField.text?.isEmpty == false && updatePasswordView.againPwTextField.text?.isEmpty == false  else {
            showSystemAlertView(titleStr: "提示", message: "请填写正确账号信息")
            return
        }
        self.view.endEditing(true)
       
        
        personalAccountBindCompanyAccount()
        
    }
    //修改基本信息
    func changeBaseInfoButtonAction(sender:UIButton){
        self.view.endEditing(true)
        oldPwText = updatePasswordView.oldPwTextField.text!
        newPwText = updatePasswordView.newPwTextField.text!
        printDebugLog(message: newPwText)
        printDebugLog(message: oldPwText)
        
    }
    ///修改企业密码
    func submitButtonAction(sender:UIButton) {
        self.view.endEditing(true)
        oldPwText = updatePasswordView.oldPwTextField.text!
        newPwText = updatePasswordView.newPwTextField.text!
        againPwText = updatePasswordView.againPwTextField.text!
        
        if newPwText.count < 6 || newPwText.count > 20{
            showSystemAlertView(titleStr: "提示", message: "密码格式错误")
            return
        }
        if newPwText != againPwText{
            showSystemAlertView(titleStr: "提示", message: "输入的新密码不一致")
            return
        }
        
        showLoadingView()
        weak var weakSelf = self
        let form = EditPasswordComanyForm(newPassword: newPwText, newPasswordAgain: againPwText, oldPassword: oldPwText)
        UserService.sharedInstance
            .editCompanyPwd(form)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    print(element)
                    let alertController = UIAlertController(title: "提示", message: element.msg, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "确定", style: .default){ action in                        
                        if element.status == "0"
                        {
                            weakSelf?.navigationController?.popViewController(animated: true)
                        }else{
                            alertController.removeFromParentViewController()
                        }
                    }
                    alertController.addAction(okAction)
                    weakSelf?.present(alertController, animated: true)
                   
                    
                case .error(let error):
                    weakSelf?.hideLoadingView()
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
        }
       
    }
    
    //出行人信息
    func leavePeopleButtonAction(sender:UIButton) {
        leavePeopleModel.vpName = updatePasswordView.oldPwTextField.text!
        leavePeopleModel.vpPassportno = updatePasswordView.againPwTextField.text!
        if fillPeopleModelBlock != nil{
            fillPeopleModelBlock(leavePeopleModel)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:------NET------
    
    /// 新版 个人版 个人版 绑定 企业账号
    func personalAccountBindCompanyAccount() {
        //resignLocalFirstResponder()
        showLoadingView()
        weak var weakSelf = self
        let request:BindBusAccountRequest = BindBusAccountRequest()
        request.userId = DBManager.shareInstance.userDetailDraw()?.cusLoginInfo.userId ?? ""
        request.corpCode = updatePasswordView.oldPwTextField.text ?? ""
        request.loginName = updatePasswordView.newPwTextField.text ?? ""
        request.pwd = updatePasswordView.againPwTextField.text ?? ""
        
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
    
    //MARK: 绑定个人账号
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
    ///绑定个人
    func bindPersonalButtonAction(sender:UIButton){
        
    }
    
    
}

