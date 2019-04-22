//
//  PBaseInfoBillCell.swift
//  shanglvjia
//
//  Created by tbi on 23/08/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit

class PBaseInfoBillCell: UITableViewCell{

    typealias ProvincePickerResultBlock = (String,String,String)->Void
    
    public  var provincePickerResultBlock:ProvincePickerResultBlock!
    
    let bgView:UIView = UIView()
    var billView:UIView = UIView()
    var personalView:UIView = UIView()
    var companyView:UIView = UIView()
    
    var currentBtn:UIButton = UIButton()
    ///公司 or 个人
    typealias CompanyOrPersonalBlock = (NSInteger)->Void
    public var companyOrPersonalBlock : CompanyOrPersonalBlock!
    
    var personalName = UITextView()
    var companyHeader = UITextView()
    var companyTaxNum = UITextView()
    var companyBankName = UITextView()
    var companyBankNum = UITextView()
    var companyAddress = UITextView()
    var companyPhone = UITextView()
    
    var addressCity = UITextView()
    var addressStreet = UITextView()

    
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
    
        bgView.backgroundColor = TBIThemeWhite
        bgView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        
        billTopView(type:0)
        personalBillView()
        
    }
    
    func fillCell(type:NSInteger){
        
        CommonTool.removeSubviews(onBgview: billView)
        billTopView(type:type)
        if type == 0{
            personalBillView()
        }else{
            companyBillView()
        }
        
    }
    ///发票 固定三行
    func billTopView(type:NSInteger){
        ///let leftArr:[String] = ["邮寄地址","详细信息"]
        let leftArr:[String] = ["邮寄地址","详细信息","发票信息"]
        bgView.addSubview(billView)
        billView.frame = CGRect(x:15,y:0,width:Int(ScreenWindowWidth-15),height:45*(type == 0 ? 4 : 9))
        for i in 0...leftArr.count-1{
            let view:FillBillView = FillBillView.init(frame: CGRect(x:0,y:45*i,width:Int(ScreenWindowWidth-15),height:45))
            if i<2{
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
                        make.left.equalTo(80*(i+1))
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
    ///个人发票信息
    func personalBillView(){
        billView.addSubview(personalView)
        CommonTool.removeSubviews(onBgview: personalView)
        personalView.frame = CGRect(x:0,y:45*3,width:Int(ScreenWindowWidth-15),height:45)
        let view:FillBillView = FillBillView.init(frame: CGRect(x:0,y:0,width:Int(ScreenWindowWidth-15),height:45))
        view.fillBillViewData(title: "姓名")
        //--view.rightField.delegate = self
        view.rightField.zw_limitCount = 5
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
        
        if textField == personalName{
            return len<=20
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


