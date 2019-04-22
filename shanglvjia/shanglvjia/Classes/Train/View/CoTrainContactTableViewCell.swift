//
//  CoTrainContactTableViewCell.swift
//  shop
//
//  Created by TBI on 2018/1/4.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class CoTrainContactTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let nameLabel: UITextField = UITextField(placeholder: "",fontSize: 13)
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.bottom.top.equalToSuperview()
            make.right.equalTo(50)
        }
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    func fillCell(index:Int,model:CoTrainCommitForm.ContactInfo?) {
        if index == 0 {
            titleLabel.text = "姓名"
            nameLabel.placeholder = "请输入姓名"
            nameLabel.text = model?.contactName.value
        }else if index == 1 {
            titleLabel.text = "手机"
            nameLabel.placeholder = "请输入手机"
            nameLabel.text = model?.contactPhone.value
        }else {
            titleLabel.text = "邮箱"
            nameLabel.placeholder = "请输入邮箱"
            nameLabel.text = model?.contactEmail.value
        }
    }
    
    func carFillCell(index:Int,model:CoCarForm.CarPassenger?) {
        if index == 0 {
            titleLabel.text = "姓名"
            nameLabel.placeholder = "请输入姓名"
            nameLabel.text = model?.name
            nameLabel.isUserInteractionEnabled = false
        }else if index == 1 {
            nameLabel.isUserInteractionEnabled = true
            titleLabel.text = "手机号码"
            nameLabel.placeholder = "请输入手机号码"
            nameLabel.text = model?.phone.value
        }
    }
}

class CoTrainContactFooter: UITableViewHeaderFooterView {
    
    
    let submitButton:UIButton = UIButton(title: "完成",titleColor: TBIThemeWhite,titleSize: 18)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        submitButton.backgroundColor = TBIThemeBlueColor
        submitButton.titleLabel?.textAlignment = .center
        submitButton.layer.cornerRadius = 3
        addSubview(submitButton)
        submitButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(30)
            make.height.equalTo(47)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
