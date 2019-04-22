//
//  UpdatePasswordViewCell.swift
//  shop
//
//  Created by zhanghao on 2017/7/21.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import UIKit


class UpdatePasswordView:UIView {
    let oldPwLabel = UILabel(text:"旧密码", color: TBIThemeMinorTextColor, size: 15)
    let newPwLabel = UILabel(text:"输入新密码", color: TBIThemeMinorTextColor, size: 15)
    let againPwLabel = UILabel(text:"再次输入新密码", color: TBIThemeMinorTextColor, size: 15)
    
    let oldPwTextField = CustomTextField(fontSize:16)
    let newPwTextField = CustomTextField(fontSize:16)
    let againPwTextField = CustomTextField(fontSize:16)
    
    var oldAlarmLabel = UILabel(text:"", color: TBIThemeRedColor, size: 12)
    var newAlarmLabel = UILabel(text:"", color: TBIThemeRedColor, size: 12)
    var againAlarmLabel = UILabel(text:"", color: TBIThemeRedColor, size: 12)
    
    let submitButton = UIButton(title:"确认修改",titleColor: TBIThemeMinorTextColor,titleSize: 19)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //初始化数据
    func initView() -> Void {
        self.backgroundColor = TBIThemeMinorColor
        self.addSubview(oldPwLabel)
        self.addSubview(oldPwTextField)
        self.addSubview(newPwLabel)
        self.addSubview(newPwTextField)
        self.addSubview(againPwLabel)
        self.addSubview(againPwTextField)
        self.addSubview(submitButton)
        
        self.addSubview(oldAlarmLabel)
        self.addSubview(newAlarmLabel)
        self.addSubview(againAlarmLabel)
        self.backgroundColor = UIColor(hexString:"F5F5F9")
        oldPwTextField.backgroundColor = TBIThemeWhite
        newPwTextField.backgroundColor = TBIThemeWhite
        againPwTextField.backgroundColor = TBIThemeWhite
        oldPwTextField.isSecureTextEntry = true
        newPwTextField.isSecureTextEntry = true
        againPwTextField.isSecureTextEntry = true
        oldPwLabel.snp.makeConstraints{ make in
            make.left.equalTo(15)
            make.top.equalTo(10)
        }
        oldPwTextField.placeholder = "8个以上字符，包含大小写字母和数字"
        oldPwTextField.snp.makeConstraints{make in
            make.left.right.equalTo(0)
            make.top.equalTo(oldPwLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        oldAlarmLabel.isHidden = true
        oldAlarmLabel.text = "格式不符"
        oldAlarmLabel.snp.makeConstraints{ make in
            make.right.equalTo(-15)
            make.top.equalTo(oldPwLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        newPwLabel.snp.makeConstraints{make in
            make.left.equalTo(15)
            make.top.equalTo(oldPwTextField.snp.bottom).offset(5)
            make.height.equalTo(40)
        }
        newPwTextField.placeholder = "8个以上字符，必须包含大小写字母和数字"
        newPwTextField.snp.makeConstraints{make in
            make.left.right.equalTo(0)
            make.top.equalTo(newPwLabel.snp.bottom).offset(3)
            make.height.equalTo(40)
        }
        newAlarmLabel.isHidden = true
        newAlarmLabel.text = "格式不符"
        newAlarmLabel.snp.makeConstraints{ make in
            make.right.equalTo(-15)
            make.top.equalTo(newPwLabel.snp.bottom).offset(3)
            make.height.equalTo(40)
        }
        
        againPwLabel.snp.makeConstraints{make in
            make.left.equalTo(15)
            make.top.equalTo(newPwTextField.snp.bottom).offset(5)
            make.height.equalTo(40)
        }
        againPwTextField.placeholder = "同新密码输入一样"
        againPwTextField.snp.makeConstraints{make in
            make.left.right.equalTo(0)
            make.top.equalTo(againPwLabel.snp.bottom).offset(3)
            make.height.equalTo(40)
        }
        againAlarmLabel.isHidden = true
        againAlarmLabel.text = "密码输入不一致"
        againAlarmLabel.snp.makeConstraints{ make in
            make.right.equalTo(-15)
            make.top.equalTo(againPwLabel.snp.bottom).offset(3)
            make.height.equalTo(40)
        }
        
        submitButton.layer.cornerRadius = 5
        submitButton.backgroundColor = UIColor(hexString: "E5E5E5")
        submitButton.setTitleColor(UIColor(hexString:"BBBBBB"), for: UIControlState.disabled)
        submitButton.setTitleColor(UIColor(hexString:"BBBBBB"), for: UIControlState.normal)
        submitButton.snp.makeConstraints{make in
            make.top.equalTo(againPwTextField.snp.bottom).offset(25)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(47)
        }
    }
}
