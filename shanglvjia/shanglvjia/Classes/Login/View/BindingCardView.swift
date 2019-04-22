//
//  BindingCardView.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/5.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class BindingCardView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let idLabel = UILabel(text:"身份证号", color: UIColor.gray , size: 13)
    let oldPwTextField = CustomTextField(fontSize:16)
    let submitButton = UIButton(title:"",titleColor: TBIThemeWhite,titleSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        self.backgroundColor = TBIThemeBaseColor
        self.addSubview(idLabel)
        self.addSubview(oldPwTextField)
        self.addSubview(submitButton)
        
         oldPwTextField.backgroundColor = TBIThemeWhite
         idLabel.textAlignment = NSTextAlignment.left
        
        idLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(6)
            make.height.equalTo(25)
        }
        oldPwTextField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(idLabel.snp.bottom).offset(6)
            make.height.equalTo(44)
        }
        
        submitButton.layer.cornerRadius = 4
        submitButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        submitButton.clipsToBounds=true
        submitButton.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(46)
            make.top.equalTo(oldPwTextField.snp.bottom).offset(20)
        }
    }
    func bindCard(cardNum:String)  {
        if cardNum.isEmpty{
          ///绑定
            submitButton.setTitle("绑定", for: UIControlState.normal)
        }else{
          ///解绑
            submitButton.setTitle("解除绑定", for: UIControlState.normal)
            oldPwTextField.isEnabled = false
            oldPwTextField.text = cardNum
        }
    }
}
