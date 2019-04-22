//
//  VisaBillCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/18.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class VisaBillCell: UITableViewCell,UITextFieldDelegate {
    
    var leftLabel = UILabel(text: "发票", color: UIColor.gray, size: 15)
    let  gtSwitch = UISwitch()
    let bgView:UIView = UIView()
    var billView:UIView = UIView()
    var personalView:UIView = UIView()
    var companyView:UIView = UIView()
    var travelView:UIView = UIView()
    
    var currentBtn:UIButton = UIButton()
    ///公司 or 个人
    typealias CompanyOrPersonalBlock = (NSInteger)->Void
    public var companyOrPersonalBlock : CompanyOrPersonalBlock!
    ///发票类型
    typealias BillTypeReturnBlock = (String,String)->Void
    public var billTypeReturnBlock : BillTypeReturnBlock!
    
    ///地址
    typealias ProvincePickerResultBlock = (String,String,String)->Void
    public  var provincePickerResultBlock:ProvincePickerResultBlock!
    
    var personalName = UITextView()
    var companyHeader = UITextView()
    var companyTaxNum = UITextView()
    var companyBankName = UITextView()
    var companyBankNum = UITextView()
    var companyAddress = UITextView()
    var companyPhone = UITextView()
    
    var addressCity = UITextView()
    var addressStreet = UITextView()
    
    fileprivate var billNameStr = ""
    fileprivate var billTypeStr = ""
    fileprivate var typeTitleArr:[String] = Array()
    fileprivate var typeValueArr:[String] = Array()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor=TBIThemeWhite
        self.selectionStyle=UITableViewCellSelectionStyle.none
        creatCellUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func creatCellUI(){
        self.contentView.addSubview(bgView)
        bgView.addSubview(leftLabel)
        bgView.backgroundColor = TBIThemeWhite
        bgView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(0)
            make.width.equalTo(75)
            make.height.equalTo(45)
        }
        self.addSubview(gtSwitch)
        gtSwitch.onTintColor = PersonalThemeNormalColor
        gtSwitch.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(leftLabel)
        }
        
        
    }
    
    ///* 酒店/旅游/签证：电子发票，纸质发票
    ///定投机票：电子发票0，纸质发票1
    ///特价及BSP机票：行程单
    func fillCell(isBill:Bool,type:NSInteger,billName:String,billType:String,typeArr:[String],valueArr:[String]){
        billNameStr = billName
        billTypeStr = billType
        typeTitleArr = typeArr
        typeValueArr = valueArr
        
        gtSwitch.isOn = isBill
        if isBill{
            billView.isHidden = false
        }else{
            billView.isHidden = true
        }
        CommonTool.removeSubviews(onBgview: billView)
        ///个人还是公司
        billTopView(type:type)
        ///如果第一个是行程单的话
        if billTypeStr == "电子发票" || billTypeStr == "纸质发票"{
            if type == 0{
                personalBillView()
            }else{
                companyBillView()
            }
        }
        
        if billTypeStr != "电子发票" && billTypeStr != "前台索要"{
            ///邮寄地址
            travelListView()
        }
        
    }
    ///发票 固定三行
    func billTopView(type:NSInteger){
        var leftArr:[String] = ["发票种类","发票内容","发票类型"]
        bgView.addSubview(billView)
        ///
        var rowNum:Int = 0
        if billTypeStr != "电子发票"{
            rowNum = (type == 0 ? 6 : 11)
            if billTypeStr == "行程单"{
                rowNum = 3
            }
            if billTypeStr == "前台索要"{
                rowNum = 1
                leftArr = ["发票种类"]
            }
        }
        else{
            rowNum = (type == 0 ? 4 : 9)
        }
        billView.frame = CGRect(x:15,y:45,width:Int(ScreenWindowWidth-15),height:45*rowNum)
        
        for i in 0...leftArr.count-1{
            let view:FillBillView = FillBillView.init(frame: CGRect(x:0,y:45*i,width:Int(ScreenWindowWidth-15),height:45))
            if i<2{
                view.rightField.text = i == 0 ? billTypeStr : billNameStr
                if i==0{
                    ///点击选择电子发票纸质发票
                    view.rightField.addOnClickListener(target: self, action: #selector(selectBillsType(tap:)))
                }else{
                    //view.rightField.isEnabled = false
                    view.rightField.isEditable = false
                }
                
            }else{
                view.rightField.isHidden = true
                /// 个人 公司
                let buttonArr:[String] = ["个人","公司",]
                for i in 0...buttonArr.count-1{
                    let typeButton:UIButton = UIButton.init(title: buttonArr[i], titleColor: PersonalThemeMajorTextColor, titleSize: 15)
                    typeButton.setImage(UIImage(named:"visa_pay_noselect"), for: UIControlState.normal)
                    typeButton.setImage(UIImage(named:"visa_pay_select"), for: UIControlState.selected)
                    view.addSubview(typeButton)
                    typeButton.tag = i
                    typeButton.setTitle("  \(buttonArr[i])", for: .normal)
                    typeButton.snp.makeConstraints({ (make) in
                        make.left.equalTo(i == 0 ? 75 : 145)
                        make.centerY.equalTo(view.billLeftLabel)
                        make.width.equalTo(80)
                    })
                    if i == type{
                        typeButton.isSelected = true
                        currentBtn = typeButton
                    }
                    typeButton.addTarget(self, action: #selector(selectBillType(sender:)), for: UIControlEvents.touchUpInside)
                    
                }
            }
            view.fillBillViewData(title:leftArr[i])
            billView.addSubview(view)
        }
    }
    ///选择 个人还是公司
    func selectBillType(sender:UIButton){
        currentBtn.isSelected = false
        sender.isSelected = true
        currentBtn = sender
        
        if companyOrPersonalBlock != nil{
            companyOrPersonalBlock(sender.tag)
        }
    }
    func selectBillsType(tap:UITapGestureRecognizer){
        weak var weakSelf = self
        self.endEditing(true)
        //let titleArr:[String] = ["电子发票","纸质发票"]
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.rowHeight = 44
        roleView.fontSize = UIFont.systemFont(ofSize: 18)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            let tf:UITextView = tap.view as! UITextView
            tf.text = weakSelf?.typeTitleArr[cellIndex]
            if weakSelf?.billTypeReturnBlock != nil
            {
                weakSelf?.billTypeReturnBlock((weakSelf?.typeTitleArr[cellIndex])!,(weakSelf?.typeValueArr[cellIndex])!)
                
            }
            
            ///不是电子发票的时候显示的值
            if weakSelf?.typeTitleArr[cellIndex] != "电子发票"{
                weakSelf?.travelListView()
            }else{
                weakSelf?.travelView.removeFromSuperview()
            }
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: typeTitleArr, flageImage: nil)
    }
    ///个人发票信息
    func personalBillView(){
        billView.addSubview(personalView)
        CommonTool.removeSubviews(onBgview: personalView)
        personalView.frame = CGRect(x:0,y:45*3,width:Int(ScreenWindowWidth-15),height:45)
        let view:FillBillView = FillBillView.init(frame: CGRect(x:0,y:0,width:Int(ScreenWindowWidth-15),height:45))
        view.fillBillViewData(title: "姓名")
        //--view.rightField.delegate = self
        view.rightField.zw_limitCount = 40
        personalName = view.rightField
        personalView.addSubview(view)
    }
    ///公司发票信息
    func companyBillView(){
        billView.addSubview(companyView)
        CommonTool.removeSubviews(onBgview: companyView)
        let titleArr:[String] = ["发票抬头","纳税人识别号","开户银行","银行账户","公司地址","电话号码"]
        companyView.frame = CGRect(x:0,y:45*3,width:Int(ScreenWindowWidth-15),height:45*titleArr.count)
        for i in 0...titleArr.count-1{
            let view:FillBillView = FillBillView.init(frame: CGRect(x:0,y:45*i,width:Int(ScreenWindowWidth-15),height:45))
            view.fillBillViewData(title: titleArr[i])
            
            //--view.rightField.delegate = self
            if i == 0{
                view.rightField.zw_limitCount = 60
                companyHeader = view.rightField
            }
            if i == 1{
                view.rightField.zw_limitCount = 30
                companyTaxNum = view.rightField
            }
            if i == 2{
                view.rightField.zw_limitCount = 50
                companyBankName = view.rightField
            }
            if i == 3{
                view.rightField.zw_limitCount = 40
                companyBankNum = view.rightField
            }
            if i == 4{
                view.rightField.zw_limitCount = 200
                companyAddress = view.rightField
            }
            if i == 5{
                companyPhone = view.rightField
                companyPhone.keyboardType = .numberPad
            }
            
            companyView.addSubview(view)
        }
        
    }
    
    func travelListView(){
        billView.addSubview(travelView)
        travelView.backgroundColor = TBIThemeWhite
        CommonTool.removeSubviews(onBgview: travelView)
        let leftArr:[String] = ["邮寄地址","详细信息"]
        travelView.frame = CGRect(x:0,y:Int(billView.frame.size.height-90),width:Int(ScreenWindowWidth-15),height:45*2)
        for i in 0...leftArr.count-1{
            let view:FillBillView = FillBillView.init(frame: CGRect(x:0,y:45*i,width:Int(ScreenWindowWidth-15),height:45))
            view.fillBillViewData(title: leftArr[i])
            //--view.placeHolderLabel.text = i == 0 ? "请选择省／市／区" : "街道门牌等"
            view.rightField.zw_placeHolder = i == 0 ? "请选择省／市／区" : "街道门牌等"
            if i == 0{
                let addArrowImage = UIImageView()
                view.addSubview(addArrowImage)
                addArrowImage.image = UIImage(named:"ic_right_gray")
                addArrowImage.snp.makeConstraints { (make) in
                    make.right.equalToSuperview().inset(23)
                    make.centerY.equalToSuperview()
                }
                view.rightField.addOnClickListener(target: self, action: #selector(selectAddress(tap: )))
                addressCity = view.rightField
                
            }
            if i == 1{
                addressStreet = view.rightField
            }
            travelView.addSubview(view)
        }
    }
    
    func selectAddress(tap:UITapGestureRecognizer){
        
        weak var weakSelf = self
        let cityPicker = SelectCityPickerView(frame: ScreenWindowFrame)
        cityPicker.cityPickerResultBlock = {(province,city,area)in
            weakSelf?.addressCity.text = province + city + area
            if weakSelf?.provincePickerResultBlock != nil{
                weakSelf?.provincePickerResultBlock(province,city,area)
            }
        }
        KeyWindow?.addSubview(cityPicker)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = textField.text!
        let len = text.count + string.count - range.length
        ///bug3289
        if textField == personalName{
            return len<=5
        }
        if textField == companyHeader{
            return len<=30
        }
        if textField == companyTaxNum{
            return len<=15
        }
        if textField == companyBankName{
            return len<=10
        }
        if textField == companyBankNum{
            return len<=20
        }
        
        return len<=100
        
    }
    
    
}
class FillBillView : UIView{
    let billLineLabel = UILabel()
    let billLeftLabel:UILabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 15)
    //let rightField = CustomTextField(fontSize: 15)
    
    let rightField = UITextView.init()
    
    let placeHolderLabel = UILabel(text: "", color: TBIThemeTipTextColor, size: 15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(billLeftLabel)
        addSubview(billLineLabel)
        addSubview(rightField)
        
        billLineLabel.backgroundColor = TBIThemeBaseColor
        billLineLabel.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(1)
        }
        billLeftLabel.numberOfLines = 2
        billLeftLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(0)
            make.height.equalTo(45)
            make.width.equalTo(80)
        }
        
        rightField.showsVerticalScrollIndicator = false
        rightField.bounces = false
        rightField.snp.makeConstraints { (make) in
            make.left.equalTo(billLeftLabel.snp.right)
            make.top.equalTo(billLeftLabel.snp.top).offset(1)
            make.height.equalTo(44)
            make.right.equalToSuperview().inset(15)
        }
        rightField.allowsEditingTextAttributes = false
        rightField.font = UIFont.systemFont(ofSize: 15)
        rightField.textContainerInset = UIEdgeInsetsMake(6, 0, 0, 0)
        rightField.contentInset = UIEdgeInsetsMake(7, 0, 0, 0);
        //设置UITextView的placeHolderText
        
        rightField.addSubview(placeHolderLabel)
        //placeHolderLabel.backgroundColor = UIColor.brown
        placeHolderLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(0)
            make.centerY.equalTo(22)
        }
    }
    func fillBillViewData(title:String){
        billLeftLabel.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
// 企业联系人信息
class VisaContactCell: UITableViewCell {
    
    
    typealias VisaContactCellBlock = ()->Void
    
    public var visaContactBlock:VisaContactCellBlock!
    
    let nameLabel = UILabel(text: "联系人", color: UIColor.gray, size: 15)
    
    
    //    private var intoDetailFlageImageView = UIImageView()
    let nameField = UITextField(placeholder: "输入联系人姓名",fontSize: 15)
    
    //    let nameContentLabel:UILabel =  UILabel() //UITextField(placeholder: "输入联系人姓名",fontSize: 13)
    
    let phoneLabel = UILabel(text: "手机号码", color: UIColor.gray, size: 15)
    
    let phoneField = UITextField(placeholder: "输入手机号码",fontSize: 15)
    
    let emailLabel = UILabel(text: "邮箱", color: UIColor.gray, size: 15)
    
    let emailField = UITextField(placeholder: "输入邮箱",fontSize: 15)
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    let emailLine = UILabel(color: TBIThemeGrayLineColor)
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        addSubview(nameLabel)
        addSubview(nameField)
        addSubview(phoneLabel)
        addSubview(phoneField)
        addSubview(line)
        addSubview(emailLabel)
        addSubview(emailField)
        addSubview(emailLine)
        phoneField.keyboardType = UIKeyboardType.numberPad
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(22)
        }
        //nameField.delegate = self
        nameField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-23)
            make.centerY.equalTo(nameLabel)
        }
        nameField.addTarget(self, action: #selector(textFieldDidChange(_:)), for:  UIControlEvents.editingChanged)
        
        //        nameContentLabel.font = UIFont.systemFont(ofSize: 13)
        //        nameContentLabel.addOnClickListener(target: self, action: #selector(nameContentAction))
        //        nameContentLabel.textColor = TBIThemePrimaryTextColor
        //        addSubview(nameContentLabel)
        //        nameContentLabel.snp.makeConstraints { (make) in
        //            make.left.equalTo(100)
        //            make.right.equalTo(-23)
        //            make.centerY.equalTo(22)
        //        }
        
        //        intoDetailFlageImageView.image = UIImage.init(named: "ic_right_gray")
        //        addSubview(intoDetailFlageImageView)
        //        intoDetailFlageImageView.snp.makeConstraints { (make) in
        //            make.right.equalToSuperview().inset(23)
        //            make.centerY.equalTo(nameContentLabel)
        //            make.height.equalTo(14)
        //            make.width.equalTo(8)
        //        }
        line.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(0)
            make.height.equalTo(0.5)
            make.top.equalTo(44)
        }
        phoneLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.centerY.equalTo(66)
        }
        phoneField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-23)
            make.centerY.equalTo(phoneLabel)
        }
        emailLine.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(0)
            make.height.equalTo(0.5)
            make.top.equalTo(88)
        }
        emailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.centerY.equalTo(110)
        }
        emailField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-23)
            make.centerY.equalTo(emailLabel)
        }
        
    }
    
    func fillDataSources(name:String,phone:String,email:String ) {
        nameField.text = name
        phoneField.text = phone
        emailField.text = email
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text!
        let len = text.count + string.count - range.length
        return len<=20
        
    }
    func textFieldDidChange(_ textfield : UITextField) {
        let textStr:String = textfield.text!
        if textStr.count >= 20{
            textfield.text = CommonTool.returnSubString(textStr, withStart: 0, withLenght: 20)
        }
    }
    
    ///点击姓名
    //    func nameContentAction() {
    //        if flightCompanyContactBlock != nil {
    //            flightCompanyContactBlock()
    //        }
    //
    //    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
