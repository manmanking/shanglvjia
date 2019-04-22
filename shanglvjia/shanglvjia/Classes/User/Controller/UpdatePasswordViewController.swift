//
//  UpdatePasswordViewController.swift
//  shop
//
//  Created by TBI on 2017/7/21.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class UpdatePasswordViewController: CompanyBaseViewController  {
    fileprivate let bag = DisposeBag()
    let updatePasswordView:UpdatePasswordView  =  UpdatePasswordView()
    
    var oldPwText:String = ""
    var newPwText:String = ""
    var againPwText:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.setNavigationColor()
        setNavigation(title:"修改密码")
        initView ()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
        
    }

    
}

extension UpdatePasswordViewController: UITextFieldDelegate{
    func initView () {
        updatePasswordView.frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight)
        self.view.addSubview(updatePasswordView)
        updatePasswordView.submitButton.addTarget(self,action:#selector(submitButtonAction(sender:)),for: UIControlEvents.touchUpInside)
        updatePasswordView.oldPwTextField.delegate = self
        updatePasswordView.newPwTextField.delegate = self
        updatePasswordView.againPwTextField.delegate = self
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField){
        if textField == updatePasswordView.oldPwTextField {
            if updatePasswordView.oldAlarmLabel.isHidden == false{
                updatePasswordView.oldAlarmLabel.isHidden = true
            }
        }
        if textField == updatePasswordView.newPwTextField {
            if updatePasswordView.newAlarmLabel.isHidden == false{
                updatePasswordView.newAlarmLabel.isHidden = true
            }
        }
        if textField == updatePasswordView.againPwTextField {
            if updatePasswordView.againAlarmLabel.isHidden == false{
                updatePasswordView.againAlarmLabel.isHidden = true
            }
        }
    }
    
    /// 用户结束输入回掉
    public func textFieldDidEndEditing(_ textField: UITextField){
        if textField == updatePasswordView.oldPwTextField {
            oldPwText = textField.text!
//            if oldPwText.characters.count < 8 {
//                print("小于8个字符是不行的")
//                updatePasswordView.oldAlarmLabel.isHidden = false
//            }
//            if getTarStr(orSrt: oldPwText) == false {
//                print("输入的文字不完美啊")
//                updatePasswordView.oldAlarmLabel.isHidden = false
//            }
        }
        if textField == updatePasswordView.newPwTextField {
            newPwText = textField.text!
            if oldPwText == newPwText {
                print("大哥 你是故意输成一样的吗")
                updatePasswordView.newAlarmLabel.isHidden = false
            }
            if getTarStr(orSrt: newPwText) == false {
                print("输入的文字不完美啊")
                updatePasswordView.newAlarmLabel.isHidden = false
            }
        }
        if textField == updatePasswordView.againPwTextField {
            againPwText = textField.text!
            if againPwText != newPwText {
                print("输入的不一样啊")
                updatePasswordView.againAlarmLabel.isHidden = false
            }
        }
        
        
        
        
        if oldPwText.characters.count > 0 && newPwText.characters.count > 0 && againPwText.characters.count > 0
            && newPwText.characters.count == againPwText.characters.count
            && updatePasswordView.oldAlarmLabel.isHidden == true
            && updatePasswordView.newAlarmLabel.isHidden == true
            && updatePasswordView.againAlarmLabel.isHidden == true{
            updatePasswordView.submitButton.backgroundColor = TBIThemeBlueColor
            updatePasswordView.submitButton.setTitleColor(TBIThemeWhite, for: UIControlState.normal)
            updatePasswordView.submitButton.isEnabled = true
        }else{
            updatePasswordView.submitButton.backgroundColor = UIColor(hexString: "E5E5E5")
            updatePasswordView.submitButton.setTitleColor(UIColor(hexString:"BBBBBB"), for: UIControlState.disabled)
            updatePasswordView.submitButton.isEnabled = false
        }
        
        
        
        
        
        
        
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == updatePasswordView.oldPwTextField {
            if range.length == 0{
                oldPwText = textField.text! + string
            }else {
                oldPwText = oldPwText.substring(to: oldPwText.characters.index(oldPwText.endIndex, offsetBy: -1))
            }
        }
        if textField == updatePasswordView.newPwTextField {
            if range.length == 0{
                newPwText = textField.text! + string
            }else {
                newPwText = newPwText.substring(to: newPwText.characters.index(newPwText.endIndex, offsetBy: -1))
            }
        }
        if textField == updatePasswordView.againPwTextField {
            if range.length == 0{
                againPwText = textField.text! + string
            }else {
                againPwText = againPwText.substring(to: againPwText.characters.index(againPwText.endIndex, offsetBy: -1))
            }
        }
        
//        print(oldPwText.characters.count)
//        print(newPwText.characters.count)
//        print(againPwText.characters.count)
//        print(newPwText)
//        print(againPwText)
//        print(range.location)
//        print(range.length)
//        print(updatePasswordView.oldAlarmLabel.isHidden)
//        print(updatePasswordView.newAlarmLabel.isHidden)
//        print(updatePasswordView.againAlarmLabel.isHidden)
        
      
        return true
    }
    
    
    
    
    func getTarStr(orSrt:String) -> Bool {
        var daxie:Bool = false
        var xiaoxie:Bool = false
        var shuzi:Bool = false
        
        for scalar in orSrt.unicodeScalars {
            if scalar.value >= 65 && scalar.value <= 90 {
                daxie = true
            }
            if scalar.value >= 97 && scalar.value <= 122 {
                xiaoxie = true
            }
            if scalar.value >= 48 && scalar.value <= 57 {
                shuzi = true
            }
        }
        
        if daxie && xiaoxie && shuzi {
            return true
        }else{
            return false
        }
    }
    
    func submitButtonAction(sender:UIButton) {
        showLoadingView()
        weak var weakSelf = self
        guard UserService.sharedInstance.userDetail() != nil else {
            return
        }
        
        
        let form = EditPasswordUserForm(userName: (UserService.sharedInstance.userDetail()?.userName)!, passWord: newPwText, oldPassword: oldPwText)
        UserService.sharedInstance
            .editPw(form)
            .subscribe{ event in
                
                weakSelf?.hideLoadingView()
                if case .next(let e) = event {
                    print("=====成功======")
                    print(e)
                    self.intoMainView(from: "修改密码")
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
}
