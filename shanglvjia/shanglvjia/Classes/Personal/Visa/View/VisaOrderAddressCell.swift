//
//  VisaOrderAddressCell.swift
//  shanglvjia
//
//  Created by tbi on 27/08/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit

class VisaOrderAddressCell: UITableViewCell {

    private var currentBtn:UIButton = UIButton()
    private let bgView:UIView = UIView()
    
    ///公司 or 个人
    typealias CompanyOrPersonalBlock = (NSInteger)->Void
    public var companyOrPersonalBlock : CompanyOrPersonalBlock!
    
    ///地址
    typealias ProvincePickerResultBlock = (String,String,String)->Void
    public  var provincePickerResultBlock:ProvincePickerResultBlock!
    
    var addressCity = UITextView()
    var addressStreet = UITextView()
    
    let  gtSwitch = UISwitch()
    
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
            make.right.bottom.top.equalToSuperview()
            make.left.equalTo(15)
        }
        self.contentView.addSubview(gtSwitch)
        gtSwitch.onTintColor = PersonalThemeNormalColor
        gtSwitch.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(22)
        }
        gtSwitch.isHidden = true
    }
    func fillCell(type:NSInteger){
        CommonTool.removeSubviews(onBgview: bgView)
        ///领取方式 签证
        billTopView(type:type)
    }
    
    ///自提或快递 固定三行
    func billTopView(type:NSInteger){
        let leftArr:[String] = type == 0 ? ["领取方式","自提地址","自提时间"]:["领取方式","邮寄地址","详细信息"]
        
        for i in 0...leftArr.count-1{
            let view:FillBillView = FillBillView.init(frame: CGRect(x:0,y:45*i,width:Int(ScreenWindowWidth-15),height:45))
            
            if i == 0{
                view.rightField.isHidden = true
                /// 个人 公司
                let buttonArr:[String] = ["自提","快递(顺丰到付)",]
                for i in 0...buttonArr.count-1{
                    let typeButton:UIButton = UIButton.init(title: buttonArr[i], titleColor: PersonalThemeMajorTextColor, titleSize: 15)
                    typeButton.setImage(UIImage(named:"visa_pay_noselect"), for: UIControlState.normal)
                    typeButton.setImage(UIImage(named:"visa_pay_select"), for: UIControlState.selected)
                    view.addSubview(typeButton)
                    typeButton.tag = i
                    typeButton.setTitle("  \(buttonArr[i])", for: .normal)
                    typeButton.snp.makeConstraints({ (make) in
                        make.left.equalTo(75*(i+1))
                        make.centerY.equalTo(view.billLeftLabel)
                        make.width.equalTo((i==1 ? 150:80))
                    })
                    if i == type{
                        typeButton.isSelected = true
                        currentBtn = typeButton
                    }
                    typeButton.addTarget(self, action: #selector(selectBillType(sender:)), for: UIControlEvents.touchUpInside)
                    
                }
            }else{
                
                 view.rightField.isHidden = false
                
                if type == 1{
                    view.rightField.isUserInteractionEnabled = true
                }else{
                    view.rightField.isUserInteractionEnabled = false
                }
                
                if i==1{
                    if type == 1{
                        let addArrowImage = UIImageView()
                        view.addSubview(addArrowImage)
                        addArrowImage.image = UIImage(named:"ic_right_gray")
                        addArrowImage.snp.makeConstraints { (make) in
                            make.right.equalToSuperview().inset(23)
                            make.centerY.equalToSuperview()
                        }
                        
                        //view.placeHolderLabel.text =  "请选择省／市／区"
                        view.rightField.zw_placeHolder = "请选择省／市／区"
                        view.rightField.addOnClickListener(target: self, action: #selector(selectAddress(tap: )))
                        addressCity = view.rightField
                    }else{
                        view.rightField.text = "天津市和平区南京路183号世纪都会21层津旅商务签证组"
                    }
                    
                }
                if i == 2{
                    if type == 1{
                        view.rightField.zw_placeHolder = "街道门牌等"
                        view.rightField.zw_limitCount = 100
                        addressStreet = view.rightField
                    }else{
                        view.rightField.text = "法定工作日9:30-16:00"
                    }
                    
                }
            }
            
            view.fillBillViewData(title:leftArr[i])
            bgView.addSubview(view)
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
    ///行程单 到付
    func fillCellExpress(type:Bool){
        CommonTool.removeSubviews(onBgview: bgView)
        ///个人还是公司
        billTopViewExpress(type:type)
        gtSwitch.isHidden = false
         gtSwitch.isOn = type
    }
    ///自提或快递 固定三行
    func billTopViewExpress(type:Bool){
        let leftArr:[String] = (type == false ? ["行程单"]:["行程单","邮寄地址","详细信息"])
        
        for i in 0...leftArr.count-1{
            let view:FillBillView = FillBillView.init(frame: CGRect(x:0,y:45*i,width:Int(ScreenWindowWidth-15),height:45))
            
            if i == 0{
                //view.rightField.isEnabled = false
                view.rightField.isEditable = false
                view.rightField.text = "快递(顺丰到付)"
            }else{
                
                if i==1{
                    let addArrowImage = UIImageView()
                    view.addSubview(addArrowImage)
                    addArrowImage.image = UIImage(named:"ic_right_gray")
                    addArrowImage.snp.makeConstraints { (make) in
                        make.right.equalToSuperview().inset(23)
                        make.centerY.equalToSuperview()
                    }
                    
                    //view.placeHolderLabel.text =  "请选择省／市／区"
                    view.rightField.zw_placeHolder = "请选择省／市／区"
                    view.rightField.addOnClickListener(target: self, action: #selector(selectAddress(tap: )))
                    addressCity = view.rightField
                }
                if i == 2{
                    //--view.rightField.delegate = self
                    view.rightField.zw_placeHolder = "街道门牌等"
                    view.rightField.zw_limitCount = 100
                    addressStreet = view.rightField
                }
            }
            
            view.fillBillViewData(title:leftArr[i])
            bgView.addSubview(view)
        }
    }
    
    /// 选择 地址
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
        return len<=100
        
    }
    

}
