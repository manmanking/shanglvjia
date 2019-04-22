//
//  CoOrderDetailsCellViewCar.swift
//  shop
//
//  Created by TBI on 2018/1/10.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class CoOrderDetailsCellViewCar: UITableViewCell {
    
    fileprivate let  bgHeaderView = UIView()
    
    fileprivate let  bgContentView = UIView()
    
    fileprivate let  bgDetailView = CoOrderDetailsCellContentViewCar()
    
    fileprivate let  bgFooterView = UIView()
    
    fileprivate let  titleLabel = UILabel(text: "专车", color: TBIThemeMinorTextColor, size: 14)
    
    fileprivate let  statusLabel = UILabel(text: "待确认", color: TBIThemeBlueColor, size: 14)
    
    fileprivate let  flagButton = UIButton()
    
    fileprivate let  topLine = UILabel(color: TBIThemeGrayLineColor)
    
    fileprivate let  buttomLine = UILabel(color: TBIThemeGrayLineColor)
    
    fileprivate let  addressLabel = UILabel(text: "接机", color: TBIThemePrimaryTextColor, size: 17)
    
    fileprivate let  timeLabel = UILabel(text: "", color: TBIThemeMinorTextColor, size: 14)
    
    let  priceLabel = UILabel(text: "¥1200", color: TBIThemeOrangeColor, size: 20)
    
    let  deleteButton = UIButton.init(title: "删除订单", titleColor: TBIThemeRedColor, titleSize: 12)
    
    public var indexPath:IndexPath!
    
    //cell显示隐藏的delegate
    public var cellShowHideListener:OnTableCellShowHideListener!
    
    static let CAR_SHOWHIDE_DETAILS = "CAR_SHOWHIDE_DETAILS"
    
    static let CAR_DEL_ORDER = "CAR_DEL_ORDER"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    func initView () {
        self.contentView.backgroundColor = TBIThemeBaseColor
        self.bgHeaderView.backgroundColor = TBIThemeWhite
        self.contentView.addSubview(bgHeaderView)
        bgHeaderView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.width.equalTo(ScreenWindowWidth)
            make.height.equalTo(44)
        }
        bgHeaderView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        bgHeaderView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        bgHeaderView.addSubview(topLine)
        topLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        self.bgContentView.backgroundColor = TBIThemeWhite
        self.contentView.addSubview(bgContentView)
        bgContentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(bgHeaderView.snp.bottom)
            make.width.equalTo(ScreenWindowWidth)
            make.height.equalTo(90)
        }
        flagButton.setImage(UIImage(named: "ic_c_down"), for: UIControlState.normal)
        flagButton.setImage(UIImage(named: "ic_c_upward"), for: UIControlState.selected)
        bgContentView.addSubview(flagButton)
        flagButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        bgContentView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().inset(15)
        }
        bgContentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(addressLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().inset(15)
        }
        self.bgDetailView.backgroundColor = TBIThemeWhite
        self.contentView.addSubview(bgDetailView)
        bgDetailView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(bgContentView.snp.bottom)
            make.height.equalTo(0)
            make.width.equalTo(ScreenWindowWidth)
        }
        self.bgFooterView.backgroundColor = TBIThemeWhite
        self.contentView.addSubview(bgFooterView)
        bgFooterView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(bgDetailView.snp.bottom)
            make.height.equalTo(44)
            make.width.equalTo(ScreenWindowWidth)
            make.bottom.equalToSuperview().inset(10.5)
        }
        bgFooterView.addSubview(buttomLine)
        buttomLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        bgFooterView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        deleteButton.layer.cornerRadius = 3
        deleteButton.layer.borderWidth = 1
        deleteButton.layer.borderColor = TBIThemeRedColor.cgColor
        bgFooterView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.width.equalTo(78)
            make.height.equalTo(28)
            make.centerY.equalToSuperview()
        }
        flagButton.setEnlargeEdgeWithTop(20 ,left: 20, bottom: 20, right:20)
        flagButton.addTarget(self, action: #selector(click(sender:)), for: UIControlEvents.touchUpInside)
        deleteButton.setEnlargeEdgeWithTop(20 ,left: 20, bottom: 20, right:20)
        deleteButton.addTarget(self, action:  #selector(delOrderClk(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    //展开收起
    func click(sender:UIButton){
        cellShowHideListener.onShowHide(tableCell: self, flagStr: CoOrderDetailsCellViewCar.CAR_SHOWHIDE_DETAILS, indexPath: indexPath)
    }
    
    //删除订单的btn
    func delOrderClk(sender:UIButton)
    {
        cellShowHideListener.onShowHide(tableCell: self, flagStr: CoOrderDetailsCellViewCar.CAR_DEL_ORDER, indexPath: indexPath)
    }
    
    func deleteButtonHidden () {
        deleteButton.isHidden = true
    }
    
    func fullCell (isShow:Bool,model:CoNewOrderDetail.CarVo){
        statusLabel.text = model.bookedCarStatus.description
        statusLabel.textColor = model.bookedCarStatus.color
        addressLabel.text = model.orderType.description
        //priceLabel.text = "¥ \(model.totalAmount)"
        if model.totalAmount == 0 {
            priceLabel.text = ""
        }else {
            if  model.totalAmount.truncatingRemainder(dividingBy: 1) == 0 {
                priceLabel.text = "¥\(Int(model.totalAmount))"
            }else {
                priceLabel.text = "¥\(model.totalAmount)"
            }
        }
        
        let start = model.startTime.string(custom: "MM-dd  HH:mm")
        timeLabel.text = "\(start)出发"
        bgDetailView.fullCell(model: model)
        if isShow {
            flagButton.isSelected = true
            bgDetailView.isHidden = false
            bgDetailView.snp.updateConstraints({ (make) in
                make.height.equalTo(324 + model.passengers.count * 115)
            })
        }else {
            flagButton.isSelected = false
            bgDetailView.isHidden = true
            bgDetailView.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class CoOrderDetailsCellContentViewCar:UIView {
    
    fileprivate let  cellLine = UILabel(color: TBIThemeBaseColor)
    
    fileprivate let  startTitleLabel = UILabel(text: "出发地", color: TBIThemeMinorTextColor, size: 14)
    
    fileprivate let  startLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    fileprivate let  endTitleLabel = UILabel(text: "目的地", color: TBIThemeMinorTextColor, size: 14)
    
    fileprivate let  endLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    fileprivate let  nameTitleLabel = UILabel(text: "司机姓名", color: TBIThemeMinorTextColor, size: 14)
    
    fileprivate let  nameLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    fileprivate let  phoneTitleLabel = UILabel(text: "司机手机号", color: TBIThemeMinorTextColor, size: 14)
    
    fileprivate let  phoneLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    fileprivate let  numberTitleLabel = UILabel(text: "车牌号", color: TBIThemeMinorTextColor, size: 14)
    
    fileprivate let  numberLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    fileprivate let  bgPersonView = UIView()
    
    /// 联系人view
    fileprivate let  contactView = CoOrderDetailsCellContactViewCar()
    
    fileprivate let  applyLine = UILabel(color: TBIThemeGrayLineColor)
    
    fileprivate let  applyNameTitleLabel = UILabel(text: "报销人", color: TBIThemeMinorTextColor, size: 14)
    
    fileprivate let  applyNameLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    func fullCell (model:CoNewOrderDetail.CarVo) {
        startLabel.text = model.startAddress
        endLabel.text = model.endAddress
        
        if model.bookedCarStatus == .success {
            nameLabel.text = model.driverName
            phoneLabel.text = model.driverPhone
            numberLabel.text = model.driverNO
        }else {
            nameLabel.text = model.bookedCarStatus.description
            phoneLabel.text = model.bookedCarStatus.description
            numberLabel.text = model.bookedCarStatus.description
        }
        
        
        applyNameLabel.text = model.expenseName
        contactView.fullCell(model: model)
        for view in self.subviews {
            if view is CoOrderDetailsCellPersonViewCar {
                view.removeFromSuperview()
            }
        }
        for index in 0..<model.passengers.count {
            let passView =  CoOrderDetailsCellPersonViewCar ()
            self.addSubview(passView)
            passView.fullCell(model: model.passengers[index])
            passView.snp.makeConstraints({ (make) in
                make.top.equalTo(140 + index * 116)
                make.left.right.equalToSuperview()
                make.height.equalTo(116)
            })

        }
        
    }
    
    func initView () {
        addSubview(cellLine)
        cellLine.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(3)
        }
        
        
        addSubview(startTitleLabel)
        startTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(25)
        }
        addSubview(startLabel)
        startLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(25)
        }
        addSubview(endTitleLabel)
        endTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(startTitleLabel.snp.bottom).offset(5)
        }
        addSubview(endLabel)
        endLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(endTitleLabel.snp.centerY)
        }
        
        addSubview(nameTitleLabel)
        nameTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(endTitleLabel.snp.bottom).offset(5)
        }
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(nameTitleLabel.snp.centerY)
        }
        addSubview(phoneTitleLabel)
        phoneTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(nameTitleLabel.snp.bottom).offset(5)
        }
        addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(phoneTitleLabel.snp.centerY)
        }
        addSubview(numberTitleLabel)
        numberTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(phoneTitleLabel.snp.bottom).offset(5)
        }
        addSubview(numberLabel)
        numberLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(numberTitleLabel.snp.centerY)
        }
        
        addSubview(applyLine)
        applyLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview().inset(65)
        }
        
        addSubview(applyNameTitleLabel)
        applyNameTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(25)
        }
        addSubview(applyNameLabel)
        applyNameLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(applyNameTitleLabel.snp.centerY)
        }
        
        addSubview(contactView)
        contactView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(applyLine.snp.top)
            make.height.equalTo(115)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class CoOrderDetailsCellPersonViewCar:UIView {
        fileprivate let  line = UILabel(color: TBIThemeGrayLineColor)
        
        fileprivate let  nameTitleLabel = UILabel(text: "乘车人", color: TBIThemeMinorTextColor, size: 14)
        
        fileprivate let  nameLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
        
        fileprivate let  phoneTitleLabel = UILabel(text: "联系手机", color: TBIThemeMinorTextColor, size: 14)
        
        fileprivate let  phoneLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
        
        fileprivate let  cardTitleLabel = UILabel(text: "", color: TBIThemeMinorTextColor, size: 14)
        
        fileprivate let  cardLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            initView()
        }
        
        func fullCell (model:CoNewOrderDetail.CarVo.CarPassenger) {
            nameLabel.text = model.name
            phoneLabel.text = model.mobile
            if model.certType == 1 {
                cardTitleLabel.text = "身份证件"
            }else if model.certType == 2 {
                cardTitleLabel.text = "护照"
            }else {
                cardTitleLabel.text = ""
            }
            //cardTitleLabel.text = model.certType == 1 ? "身份证":"护照"
            cardLabel.text = model.certNo
        }
        func initView () {
            addSubview(line)
            line.snp.makeConstraints { (make) in
                make.top.equalTo(0)
                make.left.right.equalToSuperview().inset(15)
                make.height.equalTo(0.5)
            }
            
            addSubview(nameTitleLabel)
            nameTitleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(line.snp.bottom).offset(25)
            }
            addSubview(nameLabel)
            nameLabel.snp.makeConstraints { (make) in
                make.right.equalToSuperview().inset(15)
                make.centerY.equalTo(nameTitleLabel.snp.centerY)
            }
            
            addSubview(phoneTitleLabel)
            phoneTitleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(nameTitleLabel.snp.bottom).offset(5)
            }
            addSubview(phoneLabel)
            phoneLabel.snp.makeConstraints { (make) in
                make.right.equalToSuperview().inset(15)
                make.centerY.equalTo(phoneTitleLabel.snp.centerY)
            }
            
            addSubview(cardTitleLabel)
            cardTitleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(phoneTitleLabel.snp.bottom).offset(5)
            }
            addSubview(cardLabel)
            cardLabel.snp.makeConstraints { (make) in
                make.right.equalToSuperview().inset(15)
                make.centerY.equalTo(cardTitleLabel.snp.centerY)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    

}

class CoOrderDetailsCellContactViewCar:UIView {
    fileprivate let  line = UILabel(color: TBIThemeGrayLineColor)
    
    fileprivate let  nameTitleLabel = UILabel(text: "联系人", color: TBIThemeMinorTextColor, size: 14)
    
    fileprivate let  nameLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    fileprivate let  phoneTitleLabel = UILabel(text: "联系手机", color: TBIThemeMinorTextColor, size: 14)
    
    fileprivate let  phoneLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    fileprivate let  emailTitleLabel = UILabel(text: "联系邮箱", color: TBIThemeMinorTextColor, size: 14)
    
    fileprivate let  emailLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    func fullCell (model:CoNewOrderDetail.CarVo) {
        nameLabel.text = model.contactName
        phoneLabel.text = model.contactPhone
        emailLabel.text = model.contactEmail
    }
    
    func fullCellTrain (model:CoNewOrderDetail.TrainVo) {
        nameLabel.text = model.contactName
        phoneLabel.text = model.contactPhone
        emailLabel.text = model.contactEmail
    }
    func initView () {
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(0.5)
        }
        
        addSubview(nameTitleLabel)
        nameTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(line.snp.bottom).offset(25)
        }
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(nameTitleLabel.snp.centerY)
        }
        
        addSubview(phoneTitleLabel)
        phoneTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(nameTitleLabel.snp.bottom).offset(5)
        }
        addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(phoneTitleLabel.snp.centerY)
        }
        
        addSubview(emailTitleLabel)
        emailTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(phoneTitleLabel.snp.bottom).offset(5)
        }
        addSubview(emailLabel)
        emailLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(emailTitleLabel.snp.centerY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
