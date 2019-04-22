//
//  TravelOrderTableViewCell.swift
//  shop
//
//  Created by TBI on 2017/7/4.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SwiftDate

class TravelOrderHeaderTableViewCell: UIView {
    
    let  img = UIImageView(imageName: "ic_travel")
    
    let  productTitle = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    let  line = UILabel(color: TBIThemeGrayLineColor)
    
    let  productTypeTitle = UILabel(text: "产品类型", color: TBIThemePrimaryTextColor, size: 13)
    
    let  productType = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let  productDateTitle = UILabel(text: "出行日期", color: TBIThemePrimaryTextColor, size: 13)
    
    let  productDate = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let  purchaseQuantity = UILabel(text: "购买数量", color: TBIThemePrimaryTextColor, size: 13)
    
    init (listOne:[[String:Any]] ,listTwo:[[String:Any]],productType:String?,saleDate:DateInRegion?,title:String?) {
        let height = (listOne.count + listTwo.count) * 23
        let frame = CGRect(x: 0, y: 0, width: Int(ScreenWindowWidth), height: 135 + height)
        super.init(frame: frame)
        self.backgroundColor = TBIThemeWhite
        addSubview(img)
        img.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.height.width.equalTo(14)
            make.top.equalTo(14)
        }
        productTitle.text = title
        productTitle.numberOfLines = 2
        productTitle.lineBreakMode = .byTruncatingTail
        addSubview(productTitle)
        productTitle.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(11)
            make.left.equalTo(img.snp.right).offset(3)
        }
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(0.5)
            make.top.equalTo(productTitle.snp.bottom).offset(12)
        }
        addSubview(productTypeTitle)
        productTypeTitle.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(line.snp.bottom).offset(13)
        }
        self.productType.text = productType
        addSubview(self.productType)
        self.productType.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-15)
            make.top.equalTo(line.snp.bottom).offset(13)
        }
        addSubview(productDateTitle)
        productDateTitle.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(productTypeTitle.snp.bottom).offset(8)
        }
        productDate.text = saleDate?.string(custom: "yyyy年MM月dd日")
        addSubview(productDate)
        productDate.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.top.equalTo(self.productType.snp.bottom).offset(8)
        }
        addSubview(purchaseQuantity)
        purchaseQuantity.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(productDateTitle.snp.bottom).offset(8)
        }
        for index in 0..<listOne.count {
            let priceTitle: UILabel = UILabel(text: listOne[index]["title"] as? String ?? "", color: TBIThemePrimaryTextColor, size: 13)
            addSubview(priceTitle)
            priceTitle.snp.makeConstraints({ (make) in
                make.left.equalTo(100)
                make.centerY.equalTo(purchaseQuantity.snp.centerY).offset(index * 23)
            })
            let price = Int(listOne[index]["price"] as? Double ?? 0)
            let priceText: UILabel = UILabel(text: "¥\(String(describing: price))", color: TBIThemeOrangeColor, size: 13)
            addSubview(priceText)
            priceText.snp.makeConstraints({ (make) in
                make.right.equalTo(-15)
                make.centerY.equalTo(purchaseQuantity.snp.centerY).offset(index * 23)
            })
            let numberText: UILabel = UILabel(text: "X\(String(describing: listOne[index]["number"] ?? 0))", color: TBIThemeOrangeColor, size: 13)
            addSubview(numberText)
            numberText.snp.makeConstraints({ (make) in
                make.left.equalTo(210)
                make.centerY.equalTo(purchaseQuantity.snp.centerY).offset(index * 23)
            })
        }
        for index in 0..<listTwo.count {
            
            let priceTitle: UILabel = UILabel(text: listTwo[index]["title"] as? String ?? "", color: TBIThemePrimaryTextColor, size: 13)
            addSubview(priceTitle)
            priceTitle.snp.makeConstraints({ (make) in
                make.left.equalTo(100)
                make.centerY.equalTo(purchaseQuantity.snp.centerY).offset((index + listOne.count) * 23)
            })
            let price = Int(listTwo[index]["price"] as? Double ?? 0)
            let priceText: UILabel = UILabel(text: "¥\(String(describing: price))", color: TBIThemeOrangeColor, size: 13)
            addSubview(priceText)
            priceText.snp.makeConstraints({ (make) in
                make.right.equalTo(-15)
                make.centerY.equalTo(purchaseQuantity.snp.centerY).offset((index + listOne.count) * 23)
            })
            let numberText: UILabel = UILabel(text: "X\(String(describing: listTwo[index]["number"] ?? 0))", color: TBIThemeOrangeColor, size: 13)
            addSubview(numberText)
            numberText.snp.makeConstraints({ (make) in
                make.left.equalTo(210)
                make.centerY.equalTo(purchaseQuantity.snp.centerY).offset((index + listOne.count) * 23)
            })

        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class TravelOrderFooterTableViewCell: UITableViewCell {
    
    let protocolButton = UIButton()
    
    let leftMessageLabel = UILabel(text: "已经阅读并同意", color: TBIThemePlaceholderTextColor, size: 11)
    
    let rightMessageLabel = UILabel(text: "服务协议", color: TBIThemeLinkColor, size: 11)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = TBIThemeBaseColor
//        let titleStr = "已经阅读并同意服务协议"
//        let protocolButton_OC = titleStr as NSString
//        let mutAttributeStr = NSMutableAttributedString.init(string:titleStr)
//        let rangeLeft:NSRange =  protocolButton_OC.range(of: "已经阅读并同意")
//        let rangeRight:NSRange =  protocolButton_OC.range(of: "服务协议")
//        mutAttributeStr.addAttribute(NSForegroundColorAttributeName, value:TBIThemePlaceholderTextColor, range:rangeLeft )
//        mutAttributeStr.addAttribute(NSForegroundColorAttributeName, value:TBIThemeLinkColor, range: rangeRight)
//        
//        let protocolTitle:UILabel = UILabel()
//        protocolTitle.attributedText = mutAttributeStr
//        protocolTitle.font = UIFont.systemFont(ofSize: 11)
//        protocolTitle.adjustsFontSizeToFitWidth = true
//        self.contentView.addSubview(protocolTitle)
//        protocolTitle.snp.makeConstraints({ (make) in
//            make.top.bottom.equalToSuperview()
//            make.centerX.equalToSuperview()
//            
//        })
        addSubview(leftMessageLabel)
        leftMessageLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview().offset(-22)
        }
        
        addSubview(rightMessageLabel)
        rightMessageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftMessageLabel.snp.right)
            make.centerY.equalTo(leftMessageLabel.snp.centerY)
        }
        
        
        protocolButton.setImage(UIImage.init(named:"round_check_fill"), for: UIControlState.normal)
          protocolButton.setImage(UIImage.init(named:"round_check_fill_selected"), for: UIControlState.selected)
        //protocolButton.setAttributedTitle(mutAttributeStr, for: UIControlState.normal)
        protocolButton.backgroundColor = TBIThemeBaseColor
        protocolButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        protocolButton.setEnlargeEdgeWithTop(0, left: 0, bottom: 0, right: 80)
        //protocolButton.addTarget(self, action: #selector(protocolButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        addSubview(protocolButton)
        protocolButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.height.width.equalTo(14)
            make.right.equalTo(leftMessageLabel.snp.left).offset(-5)
        }


    }
    //设置按钮状态
    func fillCell(flag:Bool){
        protocolButton.isSelected = flag
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// 旅游出行人信息
class TravelTitleTableCell: UITableViewCell {
    
    let titleLabel = UILabel(text: "出行人信息", color: TBIThemeMinorTextColor, size: 13)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




// 旅游出行人信息
class TravelPersonTableCell: UITableViewCell {

    let titleLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let rightImg = UIImageView(imageName: "ic_right_gray")
    
    let nameText = UITextField(placeholder: "选择出行人",fontSize: 13)
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        nameText.isUserInteractionEnabled = false
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        addSubview(nameText)
        nameText.snp.makeConstraints { (make) in
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
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    func fillCell(title:String,name:String,index:Int) {
        if index == 1 {
            line.snp.updateConstraints({ (make) in
                make.left.right.equalTo(0)
            })
        }
        nameText.text = name
        titleLabel.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 旅游联系人信息
class TravelContactTableCell: UITableViewCell {
    
    let titleLabel = UILabel(text: "联系人信息", color: TBIThemeMinorTextColor, size: 13)
    
    let nameLabel = UILabel(text: "联系人", color: TBIThemePrimaryTextColor, size: 13)
    
    let nameField = UITextField(placeholder: "输入联系人姓名",fontSize: 13)
    
    let phoneLabel = UILabel(text: "手机号码", color: TBIThemePrimaryTextColor, size: 13)
    
    let phoneField = UITextField(placeholder: "输入手机号码",fontSize: 13)
    
    let nameline = UILabel(color: TBIThemeGrayLineColor)
    
    let phoneLine = UILabel(color: TBIThemeGrayLineColor)
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        phoneField.keyboardType = UIKeyboardType.numberPad
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(18.5)
        }
        addSubview(nameline)
        nameline.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(37)
            make.height.equalTo(0.5)
        }
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(59.5)
        }
        addSubview(nameField)
        nameField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.centerY.equalTo(59.5)
        }
        addSubview(phoneLine)
        phoneLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(81.5)
            make.height.equalTo(0.5)
        }

        addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(104.5)
        }
        
        addSubview(phoneField)
        phoneField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.centerY.equalTo(104.5)
        }
        
        
    }
    func fillCell(model:TravelForm.OrderSpecialInfo?) {
        nameField.text = model?.contactName.value
        phoneField.text = model?.contactPhone.value
        
    }
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


// 报销title
class TravelTitleInvoiceTableCell: UITableViewCell {
    
    let titleLabel = UILabel(text: "报销凭证", color: TBIThemeMinorTextColor, size: 13)
    
    let rightSwitch = UISwitch()
    
    func fillCell(invoiceFlag:Int) {
        if invoiceFlag == 0 {
            rightSwitch.isOn = false
        }else {
            rightSwitch.isOn = true
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        addSubview(rightSwitch)
        rightSwitch.snp.makeConstraints{ make in
            make.right.equalTo(-15)
            make.width.equalTo(48)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class TravelInvoiceTableCell:UITableViewCell {
    
    
    let topLine = UILabel(color: TBIThemeGrayLineColor)
    
    let typeLabel = UILabel(text: "凭证类型", color: TBIThemePrimaryTextColor, size: 13)
    
    //个人
    let personalButton = UIButton()
    
    let personalLabel = UILabel(text: "个人", color: TBIThemePrimaryTextColor, size: 13)
    
    //公司
    let companyButton = UIButton()
    
    let companyLabel = UILabel(text: "公司", color: TBIThemePrimaryTextColor, size: 13)
    
    
    //let typeTextLabel = UILabel(text: "行程单", color: TBIThemePrimaryTextColor, size: 13)
    
    let typeLine = UILabel(color: TBIThemeGrayLineColor)
    
    let invoiceLabel = UILabel(text: "发票抬头", color: TBIThemePrimaryTextColor, size: 13)
    
    let invoiceField = UITextField(placeholder: "输入发票抬头",fontSize: 13)
    
    let invoiceLine = UILabel(color: TBIThemeGrayLineColor)
    
    let courierLabel = UILabel(text: "配送方式", color: TBIThemePrimaryTextColor, size: 13)
    
    let courierTextLabel = UILabel(text: "快递 ¥10", color: TBIThemePrimaryTextColor, size: 13)
    
    let courierLine = UILabel(color: TBIThemeGrayLineColor)
    
    let nameLabel = UILabel(text: "收件人", color: TBIThemePrimaryTextColor, size: 13)
    
    let nameField = UITextField(placeholder: "输入收件人姓名",fontSize: 13)
    
    let nameLine = UILabel(color: TBIThemeGrayLineColor)
    
    let phoneLabel = UILabel(text: "手机号码", color: TBIThemePrimaryTextColor, size: 13)
    
    let phoneField = UITextField(placeholder: "输入手机号码",fontSize: 13)
    
    let phoneLine = UILabel(color: TBIThemeGrayLineColor)
    
    //let cityLabel = UILabel(text: "所在地区", color: TBIThemePrimaryTextColor, size: 13)
    
    //let cityField = UITextField(placeholder: "输入所在地区",fontSize: 13)
    
    //let cityLine = UILabel(color: TBIThemeGrayLineColor)
    
    let addressLabel = UILabel(text: "详细地址", color: TBIThemePrimaryTextColor, size: 13)
    
    //let addressField = UITextField(placeholder: "输入详细地址",fontSize: 13)
    
    let addressField = UITextView()
    
    var addressPlaceHolderLabel = UILabel(text: "输入详细地址", color: TBIThemePlaceholderColor, size: 13)
    
    func fillCell(invoice:TravelForm.OrderSpecialInfo.Invoice?,logistics:TravelForm.OrderSpecialInfo.Logistics?){
        if invoice?.invoiceType  == "1"{
            personalButton.isSelected = true
            companyButton.isSelected = false
        }else {
            personalButton.isSelected = false
            companyButton.isSelected = true
        }
        invoiceField.text = invoice?.invoiceTitle.value
        nameField.text = logistics?.logisticsName.value
        phoneField.text = logistics?.logisticsPhone.value
        addressField.text = logistics?.logisticsAddress.value
        
        if (addressField.text == nil) || (addressField.text == "")
        {
            self.addressPlaceHolderLabel.text = "输入详细地址"
        }
        else
        {
            self.addressPlaceHolderLabel.text = ""
        }

    
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        personalButton.setImage(UIImage.init(named: "ic_radio_not selected"), for: UIControlState.normal)
        personalButton.setImage(UIImage.init(named: "ic_radio_selected"), for: UIControlState.selected)
        personalButton.isSelected = true
        
        companyButton.setImage(UIImage.init(named: "ic_radio_not selected"), for: UIControlState.normal)
        companyButton.setImage(UIImage.init(named: "ic_radio_selected"), for: UIControlState.selected)
        
       //phoneField.attributedPlaceholder = NSAttributedString(string:"输入手机号码",attributes:[NSForegroundColorAttributeName: TBIThemePrimaryWarningColor])
        
        addSubview(topLine)
        addSubview(typeLabel)
        addSubview(courierLabel)
        addSubview(invoiceLine)
        addSubview(invoiceLabel)
        addSubview(invoiceField)
        addSubview(courierTextLabel)
        addSubview(nameLabel)
        addSubview(nameField)
        addSubview(phoneLabel)
        addSubview(phoneField)
//        addSubview(cityLabel)
//        addSubview(cityField)
        addSubview(addressLabel)
        addSubview(addressField)
        addSubview(typeLine)
        addSubview(courierLine)
        addSubview(nameLine)
        addSubview(phoneLine)
//        addSubview(cityLine)
        phoneField.keyboardType = UIKeyboardType.numberPad
        topLine.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        typeLine.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(0.5)
            make.top.equalTo(44)
        }
        invoiceLine.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(0.5)
            make.top.equalTo(typeLine.snp.bottom).offset(44)
        }
        courierLine.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(0.5)
            make.top.equalTo(invoiceLine.snp.bottom).offset(44)
        }
        nameLine.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(0.5)
            make.top.equalTo(courierLine.snp.bottom).offset(44)
        }
        phoneLine.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(0.5)
            make.top.equalTo(nameLine.snp.bottom).offset(44)
        }
//        cityLine.snp.makeConstraints { (make) in
//            make.left.equalTo(15)
//            make.right.equalTo(-15)
//            make.height.equalTo(0.5)
//            make.top.equalTo(phoneLine.snp.bottom).offset(44)
//        }
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(22)
        }
        
        
        addSubview(personalButton)
        addSubview(companyButton)
        addSubview(personalLabel)
        addSubview(companyLabel)
        personalButton.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.centerY.equalTo(22)
        }
        personalLabel.snp.makeConstraints { (make) in
            make.left.equalTo(personalButton.snp.right).offset(3)
            make.centerY.equalTo(22)
        }
        
        companyButton.snp.makeConstraints { (make) in
            make.left.equalTo(160)
            make.centerY.equalTo(22)
        }
        companyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(companyButton.snp.right).offset(3)
            make.centerY.equalTo(22)
        }
        
        invoiceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(typeLabel.snp.centerY).offset(44)
        }
        invoiceField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-15)
            make.centerY.equalTo(typeLabel.snp.centerY).offset(44)
        }

        courierLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(invoiceLabel.snp.centerY).offset(44)
        }
        courierTextLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-15)
            make.centerY.equalTo(invoiceField.snp.centerY).offset(44)
        }
        
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(courierLabel.snp.centerY).offset(44)
        }
        nameField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-15)
            make.centerY.equalTo(courierTextLabel.snp.centerY).offset(44)
        }
        phoneLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(nameLabel.snp.centerY).offset(44)
        }
        phoneField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-15)
            make.centerY.equalTo(nameField.snp.centerY).offset(44)
        }
        
//        cityLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(15)
//            make.centerY.equalTo(phoneLabel.snp.centerY).offset(44)
//        }
//        cityField.snp.makeConstraints { (make) in
//            make.left.equalTo(100)
//            make.right.equalTo(-15)
//            make.centerY.equalTo(phoneField.snp.centerY).offset(44)
//        }
//        addressLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(15)
//            make.centerY.equalTo(phoneLabel.snp.centerY).offset(44)
//        }
//        addressField.snp.makeConstraints { (make) in
//            make.left.equalTo(100)
//            make.right.equalTo(-15)
//            make.centerY.equalTo(phoneField.snp.centerY).offset(44)
//        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(phoneLabel.snp.centerY).offset(44)
        }
        addressField.snp.makeConstraints { (make) in
            make.left.equalTo(95)
            make.right.equalTo(-15)
            make.centerY.equalTo(phoneField.snp.centerY).offset(56)
            make.height.greaterThanOrEqualTo(56)
        }
        
        addressField.textColor = TBIThemePrimaryTextColor
        addressField.font = UIFont.systemFont(ofSize: 13)
        addressField.delegate = self
      
        //设置diyDemandContentTextView的placeHolderText
        addressField.addSubview(addressPlaceHolderLabel)
        addressPlaceHolderLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(5)
            make.top.equalTo(8)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension TravelInvoiceTableCell:UITextViewDelegate
{
    public func textViewDidChange(_ textView: UITextView)
    {
        if (textView.text == nil) || (textView.text == "")
        {
            self.addressPlaceHolderLabel.text = "输入详细地址"
        }
        else
        {
            self.addressPlaceHolderLabel.text = ""
        }
    }
}
