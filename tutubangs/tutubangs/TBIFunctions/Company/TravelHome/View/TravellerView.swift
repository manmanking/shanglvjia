//
//  TravellerView.swift
//  shop
//
//  Created by TBI on 2017/7/5.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class TravellerHeaderView: UIView {
    
    let addBtn = UIButton()
    
    init () {
        let frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 64)
        super.init(frame: frame)
        addBtn.setImage(UIImage.init(named:"ic_add"), for: UIControlState.normal)
        addBtn.setTitle(" 新增旅客", for: UIControlState.normal)
        addBtn.setTitleColor(TBIThemeBlueColor, for: UIControlState.normal)
        addBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        addBtn.backgroundColor = TBIThemeWhite
        addBtn.layer.cornerRadius = 4
        addSubview(addBtn)
        addBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(10)
            make.height.equalTo(44)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class TravellerFooterView: UIView {
    
    let okBtn = UIButton(title: "确定", titleColor: TBIThemeWhite, titleSize: 18)
    
    init () {
        let frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 84)
        super.init(frame: frame)
        okBtn.backgroundColor = TBIThemeOrangeColor
        okBtn.layer.cornerRadius = 5
        addSubview(okBtn)
        okBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(30)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TravellerFootersView: UIView {
    
    let okBtn = UIButton(title: "确定", titleColor: TBIThemeWhite, titleSize: 18)
    
    init () {
        let frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 80)
        super.init(frame: frame)
        okBtn.backgroundColor = TBIThemeOrangeColor
        //okBtn.layer.cornerRadius = 5
        addSubview(okBtn)
        okBtn.snp.makeConstraints { (make) in
           make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class TravellerPersonView: UIView {
    
    let nameChi:TravellerEditorCellView = TravellerEditorCellView(title: "中文姓名" ,placeholder:"输入中文姓名",required: true)
    
    let nameEng:TravellerEditorCellView = TravellerEditorCellView(title: "英文姓名" ,placeholder:"输入英文姓名",required: false)
    
    let phone:TravellerEditorCellView = TravellerEditorCellView(title: "手机号码" ,placeholder:"输入手机号码",required: true)
    
    let idCard:TravellerEditorCellView = TravellerEditorCellView(title: "身份证号码" ,placeholder:"输入身份证号码",required: true)
    
    let passport:TravellerEditorCellView = TravellerEditorCellView(title: "护照号码" ,placeholder:"输入护照号码",required: false)
    
    let country:TravellerEditorCellView = TravellerEditorCellView(title: "国籍" ,placeholder:"输入国籍",required: false)
    
    let gender:TravellerSelectCellView = TravellerSelectCellView(title: "性别" ,placeholder:"请选择性别")
    
    let birthday:TravellerSelectCellView = TravellerSelectCellView(title: "出生日期" ,placeholder:"请选择出生日期")
    
    let travelType:TravellerRadioCellView = TravellerRadioCellView(title:"类型",textOne:"成人",textTwo:"儿童")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    func fillCell(model:TravellerForm?){
        nameChi.textField.text = model?.nameChi.value
        nameEng.textField.text = model?.nameEng.value
        phone.textField.text = model?.phone.value
        idCard.textField.text = model?.idCard.value
        passport.textField.text = model?.passport.value
        country.textField.text = model?.country.value
        gender.textField.text = model?.gender == 0 ? "男":"女"
        birthday.textField.text = model?.birthday
        if model?.travelType == 1 {
            travelType.oneButton.isSelected = true
        }else if model?.travelType == 2 {
            travelType.twoButton.isSelected = true
        }else {
             travelType.oneButton.isSelected = true
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView(){
        addSubview(nameChi)
        nameChi.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(44)
        }
        addSubview(nameEng)
        nameEng.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(nameChi.snp.bottom)
            make.height.equalTo(44)
        }
        addSubview(phone)
        phone.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(nameEng.snp.bottom)
            make.height.equalTo(44)
        }
        addSubview(idCard)
        idCard.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(phone.snp.bottom)
            make.height.equalTo(44)
        }
        addSubview(passport)
        passport.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(idCard.snp.bottom)
            make.height.equalTo(44)
        }
        addSubview(country)
        country.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(passport.snp.bottom)
            make.height.equalTo(44)
        }
        addSubview(gender)
        gender.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(country.snp.bottom)
            make.height.equalTo(44)
        }
        addSubview(birthday)
        birthday.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(gender.snp.bottom)
            make.height.equalTo(44)
        }
        addSubview(travelType)
        travelType.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(birthday.snp.bottom)
            make.height.equalTo(44)
        }
    }
    
}


class TravellerEditorCellView: UIView {
    
    let  titleLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let  requiredLabel = UILabel(text: "*", color: TBIThemeOrangeColor, size: 13)
    
    let  line = UILabel(color: TBIThemeGrayLineColor)
    
    let  rightImg = UIImageView(imageName: "ic_right_gray")
    
    let  textField = UITextField(placeholder: "",fontSize: 13)
    
    init(title: String ,placeholder:String,required:Bool) {
        let frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 44)
        super.init(frame: frame)
        self.backgroundColor = TBIThemeWhite
        titleLabel.text = title
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        if required {
            requiredLabel.isHidden = false
        }else {
            requiredLabel.isHidden = true
        }
        addSubview(requiredLabel)
        requiredLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right)
        }
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
        textField.placeholder = placeholder
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TravellerSelectCellView: UIView {
    
    let  titleLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let  line = UILabel(color: TBIThemeGrayLineColor)
    
    let  rightImg = UIImageView(imageName: "ic_right_gray")
    
    let  textField = UITextField(placeholder: "",fontSize: 13)
    
    init(title: String ,placeholder:String) {
        let frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 44)
        super.init(frame: frame)
        textField.isUserInteractionEnabled = false
        self.backgroundColor = TBIThemeWhite
        titleLabel.text = title
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
        textField.placeholder = placeholder
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
        }
        addSubview(rightImg)
        rightImg.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TravellerRadioCellView: UIView {
    
    let  titleLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let  requiredLabel = UILabel(text: "*", color: TBIThemeOrangeColor, size: 13)
    
    //
    let oneButton = UIButton()
    
    let oneLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    //
    let twoButton = UIButton()
    
    let twoLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    
    init(title:String,textOne:String,textTwo:String) {
        let frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 44)
        super.init(frame: frame)
        oneButton.setImage(UIImage.init(named: "ic_radio_not selected"), for: UIControlState.normal)
        oneButton.setImage(UIImage.init(named: "ic_radio_selected"), for: UIControlState.selected)
        twoButton.setImage(UIImage.init(named: "ic_radio_not selected"), for: UIControlState.normal)
        twoButton.setImage(UIImage.init(named: "ic_radio_selected"), for: UIControlState.selected)
        
        
        self.backgroundColor = TBIThemeWhite
        titleLabel.text = title
        oneLabel.text = textOne
        twoLabel.text = textTwo
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        addSubview(requiredLabel)
        requiredLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right)
        }
        addSubview(oneButton)
        oneButton.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.centerY.equalToSuperview()
        }
        addSubview(oneLabel)
        oneLabel.snp.makeConstraints { (make) in
            make.left.equalTo(oneButton.snp.right).offset(3)
            make.centerY.equalToSuperview()
        }
        addSubview(twoButton)
        twoButton.snp.makeConstraints { (make) in
            make.left.equalTo(160)
            make.centerY.equalToSuperview()
        }
        addSubview(twoLabel)
        twoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(twoButton.snp.right).offset(3)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

