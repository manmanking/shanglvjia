//
//  CoTrainPassengerTableViewCell.swift
//  shop
//
//  Created by TBI on 2018/1/4.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class CoTrainPassengerTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let nameLabel: UITextField = UITextField(placeholder: "",fontSize: 13)
    
    let rightImg:UIImageView = UIImageView(imageName:"ic_right_gray")
    
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
        rightImg.isHidden = true
        addSubview(rightImg)
        rightImg.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
        }
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    func fillCell(index:Int,model:CoTrainCommitForm.SubmitTrainInfo.PassengerInfo?) {
        if index == 0 {
            titleLabel.text = "姓名"
            nameLabel.textColor = TBIThemeMinorTextColor
            nameLabel.text = model?.passengerName
            nameLabel.isUserInteractionEnabled  = false
        }else if index == 1 {
            titleLabel.text = "证件类型"
            rightImg.isHidden = false
            nameLabel.text = model?.passportTypeseId == "1" ? "身份证":"护照"
            nameLabel.textColor = TBIThemePrimaryTextColor
            nameLabel.isUserInteractionEnabled  = false
        }else {
            titleLabel.text = "证件号码"
            nameLabel.textColor = TBIThemePrimaryTextColor
            nameLabel.isUserInteractionEnabled  = true
            nameLabel.placeholder = "请输入证件号码"
            nameLabel.text = model?.passportNo.value
        }
    }
    
}

class CoTrainPassengerFooter: UITableViewHeaderFooterView {
    
        
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
