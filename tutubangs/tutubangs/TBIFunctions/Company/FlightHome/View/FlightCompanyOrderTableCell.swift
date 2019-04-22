//
//  FlightCompanyOrderTableCell.swift
//  shop
//
//  Created by TBI on 2017/5/24.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftDate

//违背差标cell
class FlightContraryOrderTableCell: UITableViewCell {
    
    
    typealias FlightContraryOrderTableDispolicyBlock = ()->Void
    
    public var flightContraryOrderTableDispolicyBlock:FlightContraryOrderTableDispolicyBlock!
    
    let contraryLabel = UILabel(text: "违背政策", color: TBIThemePrimaryTextColor, size: 13)
    
    let contraryField = UITextField(placeholder: "",fontSize: 13)
    
    let messageTitleLabel = UILabel(text: "违背原因", color: TBIThemePrimaryTextColor, size: 13)
    
    let messageContentLabel = UILabel(text: "违背原因", color: TBIThemePrimaryTextColor, size: 13)
    
    let contraryDefaultTip:String = "输入违背原因"
    
    let messageField = UITextField(placeholder: "输入违背原因",fontSize: 13)
    
    let remarkDefaultTip:String = "添加备注"
    let violateReasonDefaultTip:String = "输入违背原因"
    
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(contraryLabel)
        addSubview(contraryField)
        addSubview(messageTitleLabel)
        addSubview(messageContentLabel)
        addSubview(line)
        
        contraryLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalTo(22)
        }
        contraryField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-23)
            make.centerY.equalTo(22)
        }
        line.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.right.equalTo(-23)
            make.height.equalTo(0.5)
            make.top.equalTo(44)
        }
        messageTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalTo(66)
        }
        //messageField.delegate = self
        
//        messageField.addOnClickListener(target: self, action: #selector(messageViolateReasonAction))
//        messageField.snp.makeConstraints { (make) in
//            make.left.equalTo(100)
//            make.right.equalTo(-23)
//            make.centerY.equalTo(66)
//        }
        
        messageContentLabel.addOnClickListener(target: self, action: #selector(messageViolateReasonAction))
        messageContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-23)
            make.centerY.equalTo(66)
        }
        
    }
    
    func fillDataSources(reason:String) {
//        contraryField.text = describe
        contraryField.textColor = TBIThemeRedColor
        contraryField.isUserInteractionEnabled = false
        if reason.isEmpty == false  {
            messageContentLabel.text = reason
        }else{
            messageContentLabel.text = violateReasonDefaultTip
        }
        
        messageContentLabel.textColor = TBIThemeRedColor
//        messageField.attributedPlaceholder = NSAttributedString(string:contraryDefaultTip,attributes:[NSForegroundColorAttributeName: TBIThemeRedColor])
    }
    func fillDataSourcesTrain(reason:String) {
        //        contraryField.text = describe
        messageTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalTo(22)
        }
        messageContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-23)
            make.centerY.equalTo(22)
        }
        contraryField.isHidden=true
        contraryLabel.isHidden=true
        line.isHidden=true
        if reason.isEmpty == false {
            messageContentLabel.text = reason
        }else{
            messageContentLabel.text = violateReasonDefaultTip
        }
        
        messageContentLabel.textColor = TBIThemeRedColor
//        messageField.attributedPlaceholder = NSAttributedString(string:contraryDefaultTip,attributes:[NSForegroundColorAttributeName: TBIThemeRedColor])
    }
    func fillDataSourcesRemark(reason:String) {
        //        contraryField.text = describe
        messageTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalTo(22)
        }
        messageField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-23)
            make.centerY.equalTo(22)
        }
        contraryField.isHidden=true
        contraryLabel.isHidden=true
        line.isHidden=true
        if reason.isEmpty == false {
            messageField.text = reason
        }else{
            messageField.text = ""
        }
        messageTitleLabel.text = "添加备注"
        messageField.textColor = TBIThemePrimaryTextColor
        messageField.attributedPlaceholder = NSAttributedString(string:"请添加订单备注",attributes:[NSForegroundColorAttributeName: TBIThemePlaceholderColor])
    }
    
    func fillDataSources(reason:String,describe:String) {
        contraryLabel.isHidden = false
        contraryField.text = describe
        contraryField.textColor = TBIThemeRedColor
        contraryField.isUserInteractionEnabled = false
        if reason.isEmpty == false {
            messageContentLabel.text = reason
        }else{
            messageContentLabel.text = violateReasonDefaultTip
        }
       // messageField.text = reason//model?.reason.value
        messageContentLabel.textColor = TBIThemeRedColor
//        messageField.attributedPlaceholder = NSAttributedString(string:contraryDefaultTip,attributes:[NSForegroundColorAttributeName: TBIThemeRedColor])
    }
    
    func oldFillCell(model:CoOldFlightForm.Create?,describe:String) {
        contraryField.text = describe
        contraryField.textColor = TBIThemeRedColor
        contraryField.isUserInteractionEnabled = false
        messageField.text = model?.reason.value
        messageField.textColor = TBIThemeRedColor
        messageField.attributedPlaceholder = NSAttributedString(string:contraryDefaultTip,attributes:[NSForegroundColorAttributeName: TBIThemeRedColor])
    }
    func newFillCell(model:CoNewFlightForm.Create?,describe:String) {
        contraryField.text = describe
        contraryField.textColor = TBIThemeRedColor
        contraryField.isUserInteractionEnabled = false
        messageField.text = model?.reason.value
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func messageViolateReasonAction() {
        if flightContraryOrderTableDispolicyBlock != nil {
            flightContraryOrderTableDispolicyBlock()
        }
    }
    
    
    
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//
//        guard messageTitleLabel.text == violateReasonDefaultTip else {
//            return true
//        }
//        textField.resignFirstResponder()
//        if flightContraryOrderTableDispolicyBlock != nil {
//            flightContraryOrderTableDispolicyBlock()
//        }
//
//
//        return false
//
//
//    }
    
    
    

}

// 企业联系人信息
class FlightCompanyContactTableCell: UITableViewCell {
    
    
    typealias FlightCompanyContactBlock = ()->Void
    
    public var flightCompanyContactBlock:FlightCompanyContactBlock!
    
    let nameLabel = UILabel(text: "联系人", color: TBIThemePrimaryTextColor, size: 13)
    
    
    private var intoDetailFlageImageView = UIImageView()
    //let nameField = UITextField(placeholder: "输入联系人姓名",fontSize: 13)
    
    let nameContentLabel:UILabel =  UILabel() //UITextField(placeholder: "输入联系人姓名",fontSize: 13)
    
    let phoneLabel = UILabel(text: "手机号码", color: TBIThemePrimaryTextColor, size: 13)
    
    let phoneField = UITextField(placeholder: "输入手机号码",fontSize: 13)
    
    let emailLabel = UILabel(text: "邮箱", color: TBIThemePrimaryTextColor, size: 13)
    
    let emailField = UITextField(placeholder: "输入邮箱",fontSize: 13)
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    let emailLine = UILabel(color: TBIThemeGrayLineColor)
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(nameLabel)
        //addSubview(nameField)
        addSubview(phoneLabel)
        addSubview(phoneField)
        addSubview(line)
        addSubview(emailLabel)
        addSubview(emailField)
        addSubview(emailLine)
        phoneField.keyboardType = UIKeyboardType.numberPad
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalTo(22)
        }
//        nameField.snp.makeConstraints { (make) in
//            make.left.equalTo(100)
//            make.right.equalTo(-23)
//            make.centerY.equalTo(22)
//        }
        
        nameContentLabel.font = UIFont.systemFont(ofSize: 13)
        nameContentLabel.addOnClickListener(target: self, action: #selector(nameContentAction))
        nameContentLabel.textColor = TBIThemePrimaryTextColor
        addSubview(nameContentLabel)
        nameContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-23)
            make.centerY.equalTo(22)
        }
        
        intoDetailFlageImageView.image = UIImage.init(named: "ic_right_gray")
        addSubview(intoDetailFlageImageView)
        intoDetailFlageImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(23)
            make.centerY.equalTo(nameContentLabel)
            make.height.equalTo(14)
            make.width.equalTo(8)
        }
        line.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(0.5)
            make.top.equalTo(44)
        }
        phoneLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalTo(66)
        }
        phoneField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-23)
            make.centerY.equalTo(66)
        }
        emailLine.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(0.5)
            make.top.equalTo(88)
        }
        emailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalTo(110)
        }
        emailField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-23)
            make.centerY.equalTo(110)
        }
        
    }
    
    func fillDataSources(name:String,phone:String,email:String ) {
        //nameField.text = name
        nameContentLabel.text = name
        phoneField.text = phone
        emailField.text = email
    }
    
    
    func fillCell(model:CoOldFlightForm.Create?) {
        //nameField.text = model?.linkmanName.value
        phoneField.text = model?.linkmanMobile.value
        emailField.text = model?.linkmanEmail.value
    }
    func newFillCell(model:CoNewFlightForm.Create?) {
        //nameField.text = model?.linkmanName.value
        phoneField.text = model?.linkmanMobile.value
        emailField.text = model?.linkmanEmail.value
    }

    
    func nameContentAction() {
        if flightCompanyContactBlock != nil {
            flightCompanyContactBlock()
        }
        
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FlightSectionHeaderTableCell: UITableViewCell {
    
    let titleLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let contentLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let rightSwitch = UISwitch()
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = TBIThemeWhite
        addSubview(titleLabel)
        addSubview(contentLabel)
        addSubview(rightSwitch)
        addSubview(line)
        
        titleLabel.snp.makeConstraints{ make in
            make.left.equalTo(23)
            make.centerY.equalToSuperview()
        }
        contentLabel.snp.makeConstraints{ make in
            make.left.equalTo(titleLabel.snp.right).offset(3)
            make.centerY.equalToSuperview()
        }
        rightSwitch.snp.makeConstraints{ make in
            make.right.equalTo(-23)
            make.width.equalTo(48)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        line.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
    }
    
    func fillDataSources(title: String,price:String,copies: Int,insuranceAll:Bool) {
        let message = NSMutableAttributedString(string:"¥\(price)/人X\(copies)份")
        message.addAttributes([NSForegroundColorAttributeName :TBIThemePlaceholderTextColor, NSFontAttributeName : UIFont.systemFont( ofSize: 13)],range: NSMakeRange(0,message.length))
        message.addAttributes([NSForegroundColorAttributeName : TBIThemeRedColor, NSFontAttributeName : UIFont.systemFont( ofSize: 13)],range: NSMakeRange(6,1))
        contentLabel.attributedText = message
        titleLabel.text = title
        rightSwitch.isHidden = false
        contentLabel.isHidden = false
        if insuranceAll{
            rightSwitch.isOn = true
        }else {
            rightSwitch.isOn = false
        }
    }
    
    
    //初始化数据
    func fillCell(title: String,copies: Int,insuranceAll:Bool) {
        
        if title == "航空意外险"{
            let message = NSMutableAttributedString(string:"¥20/人X\(copies)份")
            message.addAttributes([NSForegroundColorAttributeName :TBIThemePlaceholderTextColor, NSFontAttributeName : UIFont.systemFont( ofSize: 13)],range: NSMakeRange(0,message.length))
            message.addAttributes([NSForegroundColorAttributeName : TBIThemeRedColor, NSFontAttributeName : UIFont.systemFont( ofSize: 13)],range: NSMakeRange(6,1))
            contentLabel.attributedText = message
            titleLabel.text = title
            rightSwitch.isHidden = false
            contentLabel.isHidden = false
            if insuranceAll{
                rightSwitch.isOn = true
            }else {
                rightSwitch.isOn = false
            }
        }else {
            let message = NSMutableAttributedString(string:title)
            message.addAttributes([NSForegroundColorAttributeName :TBIThemePrimaryTextColor, NSFontAttributeName : UIFont.systemFont(ofSize: 13.0)],range: NSMakeRange(0,message.length))
            message.addAttributes([NSForegroundColorAttributeName : TBIThemeRedColor, NSFontAttributeName : UIFont.systemFont(ofSize: 13.0)],range: NSMakeRange(5,1))
            titleLabel.attributedText = message
            rightSwitch.isHidden = true
            contentLabel.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//企业入住人信息
class FlightCompanyPersonTableCell: UITableViewCell {
    
    let nameLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let cardLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let rightImg = UIImageView(imageName: "ic_right_gray")
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(nameLabel)
        addSubview(cardLabel)
        addSubview(rightImg)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.top.equalTo(12)
        }
        cardLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        rightImg.snp.makeConstraints{ make in
            make.right.equalTo(-23)
            make.centerY.equalToSuperview()
            make.height.equalTo(14)
            make.width.equalTo(8)
        }
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(0.5)
        }
    }
    func fillCell(model: Traveller,certNo: String,index:Int) {
        if index == 1 {
            line.isHidden  = true
        }else {
            line.isHidden  = false
        }
        nameLabel.text = model.name
        let certificate = model.certificates.first{ $0.type == 1} ?? model.certificates.first
        cardLabel.text = certNo.isNotEmpty ? certNo : certificate?.number
    }
    
    // add by manman on 2018-03-27
    // start of line
    func fillDataSourcs(passenger:QueryPassagerResponse,cellIndex:NSInteger) {
        if cellIndex == 1 {
            line.isHidden  = true
        }else {
            line.isHidden  = false
        }
        nameLabel.text = passenger.name
       
        let certificate =  passenger.certInfos.map { (element) -> String in
            if element.certType == "1" || element.certType == "2" {
                return element.certNo
            }else {
                return ""
            }
        }
        if certificate.count > 0 {
            cardLabel.text = certificate.first
        }else {
            cardLabel.text = ""
        }
        
        
    }
    
    
    
    
    // end of line
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//保险信息
class FlightCompanyInsuranceTableCell: UITableViewCell {
    
    let nameLabel = UILabel(text: "受保客户", color: TBIThemePrimaryTextColor, size: 13)
    
    let nameContentLabel =  UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let birthdayLabel = UILabel(text: "出生日期", color: TBIThemePrimaryTextColor, size: 13)
    
    let birthdayContentLabel =  UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let sexLabel = UILabel(text: "客户性别", color: TBIThemePrimaryTextColor, size: 13)
    
    let sexContentLabel =  UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let startLabel = UILabel(text: "去", color: TBIThemeMinorTextColor, size: 13)
    
    let returnLabel = UILabel(text: "返", color: TBIThemeMinorTextColor, size: 13)
    
    let startButtom   = UIButton()
    
    let returnButtom   = UIButton()
    
    let birthdayEdit    = UIButton()
    
    let sexEdit     = UIButton()
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        startButtom.setImage(UIImage.init(named: "squareUnselected"), for: UIControlState.normal)
        startButtom.setImage(UIImage.init(named: "squareSelected"), for: UIControlState.selected)
        returnButtom.setImage(UIImage.init(named: "squareUnselected"), for: UIControlState.normal)
        returnButtom.setImage(UIImage.init(named: "squareSelected"), for: UIControlState.selected)
        birthdayEdit.setImage(UIImage.init(named: "ic_edit"), for: UIControlState.normal)
        sexEdit.setImage(UIImage.init(named: "ic_edit"), for: UIControlState.normal)
        birthdayEdit.setEnlargeEdgeWithTop(10 ,left: 10, bottom: 10, right: 10)
        sexEdit.setEnlargeEdgeWithTop(10 ,left: 10, bottom: 10, right: 10)
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.top.equalTo(20)
            make.height.equalTo(13)
        }
        addSubview(nameContentLabel)
        nameContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.top.equalTo(20)
            make.height.equalTo(13)
        }
        addSubview(birthdayLabel)
        birthdayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.height.equalTo(13)
        }
        addSubview(birthdayContentLabel)
        birthdayContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.top.equalTo(nameContentLabel.snp.bottom).offset(20)
            make.height.equalTo(13)
        }
        addSubview(sexLabel)
        sexLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.top.equalTo(birthdayLabel.snp.bottom).offset(20)
            make.height.equalTo(13)
        }
        addSubview(sexContentLabel)
        sexContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.top.equalTo(birthdayContentLabel.snp.bottom).offset(20)
            make.height.equalTo(13)
        }
        addSubview(returnButtom)
        returnButtom.snp.makeConstraints { (make) in
            make.right.equalTo(-23)
            make.height.width.equalTo(20)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }
        addSubview(returnLabel)
        returnLabel.snp.makeConstraints { (make) in
            make.right.equalTo(returnButtom.snp.left).offset(-5)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }
        addSubview(startButtom)
        startButtom.snp.makeConstraints { (make) in
            make.right.equalTo(returnLabel.snp.left).offset(-5)
            make.height.width.equalTo(20)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }
        addSubview(startLabel)
        startLabel.snp.makeConstraints { (make) in
            make.right.equalTo(startButtom.snp.left).offset(-5)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }
        addSubview(birthdayEdit)
        birthdayEdit.snp.makeConstraints { (make) in
            make.right.equalTo(-23)
            make.height.width.equalTo(20)
            make.centerY.equalTo(birthdayLabel.snp.centerY)
        }
        addSubview(sexEdit)
        sexEdit.snp.makeConstraints { (make) in
            make.right.equalTo(-23)
            make.height.width.equalTo(20)
            make.centerY.equalTo(sexLabel.snp.centerY)
        }
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview().inset(23)
            make.bottom.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //---------------- NEWOBT ----------------
    func fillDataSources(insuranceAll:Bool,tripType:NSInteger,expiredSevenInterval:Bool,passenger:QueryPassagerResponse) {
        
        startButtom.isSelected  = insuranceAll
        returnButtom.isSelected = insuranceAll
        birthdayContentLabel.text = passenger.birthday
        nameContentLabel.text  = passenger.name
        sexContentLabel.text = passenger.sex == "M" ? "男" : "女"
        if tripType == 2 {//往返
            if !expiredSevenInterval{//不超过7天
                startLabel.text = "去+返"
                //returnButtom.isSelected = false
                returnButtom.isHidden = true
                returnLabel.isHidden = true
                startLabel.snp.remakeConstraints { (make) in
                    make.right.equalTo(returnButtom.snp.left).offset(-5)
                    make.centerY.equalTo(nameLabel.snp.centerY)
                }
                startButtom.snp.remakeConstraints { (make) in
                    make.right.equalTo(-23)
                    make.height.width.equalTo(20)
                    make.centerY.equalTo(nameLabel.snp.centerY)
                }
            }
        }else {
            //returnButtom.isSelected = false
            returnButtom.isHidden = true
            returnLabel.isHidden = true
            startLabel.isHidden = true
            startButtom.snp.remakeConstraints { (make) in
                make.right.equalTo(-23)
                make.height.width.equalTo(20)
                make.centerY.equalTo(nameLabel.snp.centerY)
            }
            
        }
        
        
    }
    
    
    
    
    //设置保险是否默认全选
    func newFillCell(insuranceAll:Bool,insuranceDays:Bool,model:CoNewFlightForm.Create.Passenger,personModel:Traveller) {
        startButtom.isSelected  = model.depInsurance
        returnButtom.isSelected = model.rtnInsurance
        birthdayContentLabel.text = model.birthday
        nameContentLabel.text  = personModel.name
        sexContentLabel.text = model.gender == "M" ? "男" : "女"
        if searchModel.type == 2{//往返
            if !insuranceDays{//不超过7天
                startLabel.text = "去+返"
                //returnButtom.isSelected = false
                returnButtom.isHidden = true
                returnLabel.isHidden = true
                startLabel.snp.remakeConstraints { (make) in
                    make.right.equalTo(returnButtom.snp.left).offset(-5)
                    make.centerY.equalTo(nameLabel.snp.centerY)
                }
                startButtom.snp.remakeConstraints { (make) in
                    make.right.equalTo(-23)
                    make.height.width.equalTo(20)
                    make.centerY.equalTo(nameLabel.snp.centerY)
                }
            }
        }else {
            //returnButtom.isSelected = false
            returnButtom.isHidden = true
            returnLabel.isHidden = true
            startLabel.isHidden = true
            startButtom.snp.remakeConstraints { (make) in
                make.right.equalTo(-23)
                make.height.width.equalTo(20)
                make.centerY.equalTo(nameLabel.snp.centerY)
            }
            
        }
    }
    
    //设置保险是否默认全选
    func fillCell(insuranceAll:Bool,insuranceDays:Bool,model:CoOldFlightForm.Create.Passenger,personModel:Traveller) {
        startButtom.isSelected  = model.depInsurance
        returnButtom.isSelected = model.rtnInsurance
        birthdayContentLabel.text = model.birthday
        nameContentLabel.text  = personModel.name
        sexContentLabel.text = model.gender == "M" ? "男" : "女"
        if searchModel.type == 2{//往返
            if !insuranceDays{//不超过7天
                startLabel.text = "去+返"
                //returnButtom.isSelected = false
                returnButtom.isHidden = true
                returnLabel.isHidden = true
                startLabel.snp.remakeConstraints { (make) in
                    make.right.equalTo(returnButtom.snp.left).offset(-5)
                    make.centerY.equalTo(nameLabel.snp.centerY)
                }
                startButtom.snp.remakeConstraints { (make) in
                    make.right.equalTo(-23)
                    make.height.width.equalTo(20)
                    make.centerY.equalTo(nameLabel.snp.centerY)
                }
            }
        }else {
            //returnButtom.isSelected = false
            returnButtom.isHidden = true
            returnLabel.isHidden = true
            startLabel.isHidden = true
            startButtom.snp.remakeConstraints { (make) in
                make.right.equalTo(-23)
                make.height.width.equalTo(20)
                make.centerY.equalTo(nameLabel.snp.centerY)
            }

        }
    }
    
    
    

    

}
//修改乘客信息cell
class FlightModifyPersonTableCell: UITableViewCell {
    
    let titleLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let contentLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let rightImg = UIImageView(imageName: "ic_right_gray")

    let line = UILabel(color: TBIThemeGrayLineColor)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.centerY.equalToSuperview()
        }
        addSubview(rightImg)
        rightImg.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.right.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

//出差单cell
class FlightTravelTableCell: UITableViewCell {
    
    //起始日期
    let oneCell = UIView()
    
    let startDateLabel = UILabel(text: "出差时间", color: TBIThemePrimaryTextColor, size: 13)
    
    let startDateContentLabel = UITextField(placeholder: "",fontSize: 13)
    
    let startDateRightImg = UIImageView(imageName: "ic_right_gray")
    
    let startDateLine = UILabel(color: TBIThemeGrayLineColor)
    
    //结束日期
    let twoCell = UIView()
    
    let endDateLabel = UILabel(text: "返程时间", color: TBIThemePrimaryTextColor, size: 13)
    
    let endDateContentLabel = UITextField(placeholder: "",fontSize: 13)
    
    let endDateRightImg = UIImageView(imageName: "ic_right_gray")
    
    let endDateLine = UILabel(color: TBIThemeGrayLineColor)
    
    //出差地点
    let threeCell = UIView()
    
    let cityLabel = UILabel(text: "出差地点", color: TBIThemePrimaryTextColor, size: 13)
    
    let cityContentLabel = UITextField(placeholder: "",fontSize: 13)
    
    let cityLine = UILabel(color: TBIThemeGrayLineColor)
    
    //出差目的
    let fourCell = UIView()
    
    let purposeLabel = UILabel(text: "出差目的", color: TBIThemePrimaryTextColor, size: 13)
    
    let purposeContentLabel = UITextField(placeholder: "",fontSize: 13)
    
    let purposeRightImg = UIImageView(imageName: "ic_right_gray")
    
    let purposeLine = UILabel(color: TBIThemeGrayLineColor)
    
    //出差事由
    let fiveCell = UIView()
    
    let reasonLabel = UILabel(text: "出差原因", color: TBIThemePrimaryTextColor, size: 13)
    
    let reasonContentLabel = UITextField(placeholder: "",fontSize: 13)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        startDateContentLabel.isUserInteractionEnabled = false
        endDateContentLabel.isUserInteractionEnabled = false
        purposeContentLabel.isUserInteractionEnabled = false
        //起始时间
        addSubview(oneCell)
        oneCell.addSubview(startDateLabel)
        oneCell.addSubview(startDateContentLabel)
        oneCell.addSubview(startDateRightImg)
        oneCell.addSubview(startDateLine)
        oneCell.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
            make.top.equalToSuperview()
        }
        startDateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalToSuperview()
        }
        startDateContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-40)
            make.centerY.equalToSuperview()
        }
        startDateRightImg.snp.makeConstraints { (make) in
            make.right.equalTo(-23)
            make.centerY.equalToSuperview()
        }
        startDateLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
        //结束时间
        addSubview(twoCell)
        twoCell.addSubview(endDateLabel)
        twoCell.addSubview(endDateContentLabel)
        twoCell.addSubview(endDateRightImg)
        twoCell.addSubview(endDateLine)
        twoCell.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
            make.top.equalTo(oneCell.snp.bottom)
        }
        endDateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalToSuperview()
        }
        endDateContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-40)
            make.centerY.equalToSuperview()
        }
        endDateRightImg.snp.makeConstraints { (make) in
            make.right.equalTo(-23)
            make.centerY.equalToSuperview()
        }
        endDateLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
        //出差地点
        addSubview(threeCell)
        threeCell.addSubview(cityLabel)
        threeCell.addSubview(cityContentLabel)
        threeCell.addSubview(cityLine)
        threeCell.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
            make.top.equalTo(twoCell.snp.bottom)
        }
        cityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalToSuperview()
        }
        cityContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
        }
        cityLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
        //出差目的
        addSubview(fourCell)
        fourCell.addSubview(purposeLabel)
        fourCell.addSubview(purposeContentLabel)
        fourCell.addSubview(purposeRightImg)
        fourCell.addSubview(purposeLine)
        fourCell.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
            make.top.equalTo(threeCell.snp.bottom)
        }
        purposeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalToSuperview()
        }
        purposeContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-40)
            make.centerY.equalToSuperview()
        }
        purposeRightImg.snp.makeConstraints { (make) in
            make.right.equalTo(-23)
            make.centerY.equalToSuperview()
        }
        purposeLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
        //出差事由
        addSubview(fiveCell)
        fiveCell.addSubview(reasonLabel)
        fiveCell.addSubview(reasonContentLabel)
        fiveCell.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
            make.top.equalTo(fourCell.snp.bottom)
        }
        reasonLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalToSuperview()
        }
        reasonContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
        }

    }
    func fillCellData(model:ModifyAndCreateCoNewOrderFrom?) {
        if model?.departureDate.isEmpty == false {
            startDateContentLabel.text = model?.departureDate
        }
        if model?.returnDate.isEmpty == false {
                endDateContentLabel.text = model?.returnDate
        }

//        if model?.departureDate != 0 {
//            startDateContentLabel.text = DateInRegion(absoluteDate: Date(timeIntervalSince1970: Double(model?.departureDate ?? 0)/1000.0)).string(custom: "YYYY-MM-dd")
//            endDateContentLabel.text = DateInRegion(absoluteDate: Date(timeIntervalSince1970: Double(model?.returnDate ?? 0)/1000.0)).string(custom: "YYYY-MM-dd")
//        }
        cityContentLabel.text = (model?.destinations.reduce([], {$0 + [$1.value]}))?.toString()
        if model?.purpose.isEmpty == false {
            purposeContentLabel.text = model?.purpose
        }
        if model?.reason.value.isEmpty == false {
            reasonContentLabel.text = model?.reason.value
        }
        
    }
    
    func fillDataSources(model:LoginResponse.UserBaseTravelConfig,companyCode:String?) {
        if model.travelTimeRequire == "1" {//出差时间
            startDateContentLabel.attributedPlaceholder = NSAttributedString(string:"请选择(必填)",attributes:[NSForegroundColorAttributeName: TBIThemeRedColor])
            endDateContentLabel.attributedPlaceholder = NSAttributedString(string:"请选择(必填)",attributes:[NSForegroundColorAttributeName: TBIThemeRedColor])
        }else {
            startDateContentLabel.placeholder = "请选择出差时间"
            endDateContentLabel.placeholder = "请选择返程时间"
        }
        if companyCode != Toyota  && model.travelDestRequire == "1"  {//出差地点
            cityContentLabel.attributedPlaceholder = NSAttributedString(string:"请输入(必填)",attributes:[NSForegroundColorAttributeName: TBIThemeRedColor])
        }else if companyCode != Toyota && model.travelDestRequire == "0" {
            cityContentLabel.placeholder = "请输入出差地点"
        }
        
        if companyCode == Toyota {
            threeCell.isHidden = true
            fourCell.snp.removeConstraints()
            fourCell.snp.makeConstraints({ (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(44)
                make.top.equalTo(twoCell.snp.bottom)
            })
            
        }
        
        
        
        
        if model.travelPurposeRequire == "1" {//出差目的
            purposeContentLabel.attributedPlaceholder = NSAttributedString(string:"请选择(必填)",attributes:[NSForegroundColorAttributeName: TBIThemeRedColor])
        }else {
            purposeContentLabel.placeholder = "请选择出差目的"
        }
        if model.travelReasonRequire == "1" {//出差事由
            reasonContentLabel.attributedPlaceholder = NSAttributedString(string:"请输入(必填)",attributes:[NSForegroundColorAttributeName: TBIThemeRedColor])
        } else {
            reasonContentLabel.placeholder = "请输入出差原因"
        }
    }
    
    
    //填充数据
    func fillCell(model:CoNewOrderCustomConfig?, companyCode:String?) {
        if model?.travelDateFlag ?? false {//出差时间
            startDateContentLabel.attributedPlaceholder = NSAttributedString(string:"请选择(必填)",attributes:[NSForegroundColorAttributeName: TBIThemeRedColor])
            endDateContentLabel.attributedPlaceholder = NSAttributedString(string:"请选择(必填)",attributes:[NSForegroundColorAttributeName: TBIThemeRedColor])
        }else {
            startDateContentLabel.placeholder = "请选择出差时间"
            endDateContentLabel.placeholder = "请选择返程时间"
        }
        
        
        
        
        if companyCode != Toyota  && model?.travelDestFlag ?? false  {//出差地点
            cityContentLabel.attributedPlaceholder = NSAttributedString(string:"请输入(必填)",attributes:[NSForegroundColorAttributeName: TBIThemeRedColor])
        }else if companyCode != Toyota && (model?.travelDestFlag ?? false)! == false {
            cityContentLabel.placeholder = "请输入出差地点"
        }
        
        if companyCode == Toyota {
            threeCell.isHidden = true
            fourCell.snp.removeConstraints()
            fourCell.snp.makeConstraints({ (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(44)
                make.top.equalTo(twoCell.snp.bottom)
            })
            
        }
        
        
        
        
        if model?.travelTargetFlag ?? false {//出差目的
            purposeContentLabel.attributedPlaceholder = NSAttributedString(string:"请选择(必填)",attributes:[NSForegroundColorAttributeName: TBIThemeRedColor])
        }else {
            purposeContentLabel.placeholder = "请选择出差目的"
        }
        if model?.travelPurposeFlag ?? false {//出差事由
            reasonContentLabel.attributedPlaceholder = NSAttributedString(string:"请输入(必填)",attributes:[NSForegroundColorAttributeName: TBIThemeRedColor])
        } else {
            reasonContentLabel.placeholder = "请输入出差原因"
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//成本中心
class FlightCostCenterTableCell: UITableViewCell {
    
    let titleLabel = UILabel(text: "成本中心", color: TBIThemePrimaryTextColor, size: 13)
    
    let contentLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addSubview(contentLabel)
        addSubview(line)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalToSuperview()
        }
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.centerY.equalToSuperview()
        }
        line.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(23)
            make.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    //填充数据
    func fillCell(content:String,index: IndexPath) {
        contentLabel.text = content
        if index.row != 0 {
            titleLabel.isHidden = true
        }else {
            line.isHidden = true
        }
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NewFlightCostCenterTableCell: UITableViewCell {
    let titleLabel = UILabel(text: "成本中心", color: TBIThemePrimaryTextColor, size: 13)
//    let startDateRightImg = UIImageView(imageName: "ic_right_gray")
    let titleLabel2 = UILabel(text: "查看详情", color: TBIThemeBlueColor, size: 13)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addSubview(titleLabel2)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalToSuperview()
        }
        titleLabel2.snp.makeConstraints { (make) in
            make.right.equalTo(-23)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//自定义字段
class FlightCustomTableCell: UITableViewCell {
    
    let titleLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let contentField =  UITextField(placeholder: "",fontSize: 13)
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    let rightImg = UIImageView(imageName: "ic_right_gray")
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addSubview(contentField)
        addSubview(line)
        addSubview(rightImg)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.width.equalTo(75)
            make.centerY.equalToSuperview()
        }
        contentField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.centerY.equalToSuperview()
        }
        line.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        rightImg.snp.makeConstraints { (make) in
            make.right.equalTo(-23)
            make.centerY.equalToSuperview()
        }
        
    }
    
    func fillCell(model:ModifyAndCreateCoNewOrderFrom.CustomFieldPara?) {
        contentField.text = model?.value
    }
    
    //填充数据
    func fillCell(model:CoNewOrderCustomConfig.CustomField?,index: IndexPath) {
        if index.row == 0 {
           line.isHidden = true
        }
        guard let type = model?.type else {
            return
        }
        rightImg.isHidden = false
        switch type {
        case .singleSelect,.select:
            titleLabel.text = model?.title
            contentField.text = model?.selectValue.map{$0.toString()}
            contentField.isUserInteractionEnabled = false
            if model?.required ?? false{
                contentField.attributedPlaceholder = NSAttributedString(string:"请选择(必填)",attributes:[NSForegroundColorAttributeName: TBIThemeRedColor])
            }
        case .mulSelect:
            titleLabel.text = model?.title
            contentField.isUserInteractionEnabled = false
            contentField.text = model?.selectValue.map{$0.toString()}
            if model?.required ?? false{
                contentField.attributedPlaceholder = NSAttributedString(string:"请选择(必填)",attributes:[NSForegroundColorAttributeName: TBIThemeRedColor])
            }
        case .text:
            rightImg.isHidden = true
            titleLabel.text = model?.title
            contentField.text = model?.value.value
            if model?.required ?? false{
                contentField.attributedPlaceholder = NSAttributedString(string:"请输入(必填)",attributes:[NSForegroundColorAttributeName: TBIThemeRedColor])
            }
        default:
            break
        }
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
