//
//  CoOrderDetailsCellViewTrain.swift
//  shop
//
//  Created by TBI on 2018/1/9.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class CoOrderDetailsCellViewTrain: UITableViewCell {
    
    fileprivate let  bgHeaderView = UIView()
    
    fileprivate let  bgContentView = UIView()
    
    fileprivate let  bgDetailView = CoOrderDetailsCellContentViewTrain()
    
    fileprivate let  bgFooterView = UIView()
    
    fileprivate let  titleLabel = UILabel(text: "火车票", color: TBIThemeMinorTextColor, size: 14)
    
    fileprivate let  statusLabel = UILabel(text: "待确认", color: TBIThemeBlueColor, size: 14)
    
    fileprivate let  flagButton = UIButton()
    
    fileprivate let  topLine = UILabel(color: TBIThemeGrayLineColor)
    
    fileprivate let  buttomLine = UILabel(color: TBIThemeGrayLineColor)
    
    fileprivate let  addressLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 17)
    
    fileprivate let  timeLabel = UILabel(text: "", color: TBIThemeMinorTextColor, size: 14)
    
    let  priceLabel = UILabel(text: "", color: TBIThemeOrangeColor, size: 20)
    
    let  deleteButton = UIButton.init(title: "删除订单", titleColor: TBIThemeRedColor, titleSize: 12)
    
     public var indexPath:IndexPath!
    
    //cell显示隐藏的delegate
    public var cellShowHideListener:OnTableCellShowHideListener!
    
    static let TRAIN_SHOWHIDE_DETAILS = "TRAIN_SHOWHIDE_DETAILS"
    
    static let TRAIN_DEL_ORDER = "TRAIN_DEL_ORDER"
    
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
        cellShowHideListener.onShowHide(tableCell: self, flagStr: CoOrderDetailsCellViewTrain.TRAIN_SHOWHIDE_DETAILS, indexPath: indexPath)
    }
    
    //删除订单的btn
    func delOrderClk(sender:UIButton)
    {
        cellShowHideListener.onShowHide(tableCell: self, flagStr: CoOrderDetailsCellViewTrain.TRAIN_DEL_ORDER, indexPath: indexPath)
    }
    
    
    // 审批隐藏删除按钮
    func deleteButtonHidden(){
        deleteButton.isHidden = true
    }
    
    func fullCell (isShow:Bool,model:CoNewOrderDetail.TrainVo){
        statusLabel.text = model.bookedTrainStatus.description
        statusLabel.textColor = model.bookedTrainStatus.color
        addressLabel.text = "\(model.fromStationNameCn) - \(model.toStationNameCn)"
        //priceLabel.text = "¥ \(model.spAmount)"
        let totolFe = Double(model.totalFee)
        if  totolFe?.truncatingRemainder(dividingBy: 1) == 0 {
            priceLabel.text = "¥\(Int(totolFe ?? 0))"
        }else {
            priceLabel.text = "¥\(model.totalFee)"
        }
        let start = model.startTime.string(custom: "MM-dd  HH:mm")
        let end = model.startTime.day == model.endTime.day ? model.endTime.string(custom: "HH:mm") : model.endTime.string(custom: "MM-dd  HH:mm")
        timeLabel.text = "\(start)出发 | \(end)到达"
        bgDetailView.fullCell(model: model)
        
        var refundHeight = 0
        if model.refundAmount == 0 {
            refundHeight = 0
        }else {
            refundHeight = 45
        }
        
        if isShow {
            flagButton.isSelected = true
            bgDetailView.isHidden = false
            bgDetailView.snp.updateConstraints({ (make) in
                make.height.equalTo(257 + 30 + refundHeight  + model.passengers.count * 117) //142
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

class CoOrderDetailsCellContentViewTrain:UIView {
    
    fileprivate let  cellLine = UILabel(color: TBIThemeBaseColor)
    
    fileprivate let  trainsTitleLabel = UILabel(text: "车次", color: TBIThemeMinorTextColor, size: 14)
    
    fileprivate let  trainsLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    fileprivate let  timeTitleLabel = UILabel(text: "运行时长", color: TBIThemeMinorTextColor, size: 14)
    
    fileprivate let  timeLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    fileprivate let  seatTitleLabel = UILabel(text: "坐席", color: TBIThemeMinorTextColor, size: 14)
    
    fileprivate let  seatLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    fileprivate let  priceTitleLabel = UILabel(text: "车票费用", color: TBIThemeMinorTextColor, size: 14)
    
    fileprivate let  priceLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    
//    fileprivate let  sendTitleLabel = UILabel(text: "送票费", color: TBIThemeMinorTextColor, size: 14)
//
//    fileprivate let  sendLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    fileprivate let  feeTitleLabel = UILabel(text: "手续费", color: TBIThemeMinorTextColor, size: 14)
    
    fileprivate let  feeLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    fileprivate let  countTitleLabel = UILabel(text: "合计", color: TBIThemePrimaryTextColor, size: 14)
    
    fileprivate let  countLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    /// 退票费用
    fileprivate let  refundCellView = CoOrderRefundCellViewTrain()
    
    // 联系人
    fileprivate let  contactView = CoOrderDetailsCellContactViewCar()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    func fullCell (model:CoNewOrderDetail.TrainVo) {
        //sendLabel.text = model.deliveryFee
        if model.deliveryFee == "" {
            feeLabel.text = ""
        }else {
            feeLabel.text = "¥\(model.deliveryFee)"
        }
        countLabel.text = "¥\(model.totalFee)"
        countLabel.font = UIFont.boldSystemFont(ofSize: 15)
        countTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        trainsLabel.text = model.checi
        let hour = model.runTime / 60 < 1 ? 0:Int(model.runTime/60)
        let minutes = model.runTime - hour * 60
        timeLabel.text = hour == 0 ? "\(minutes)分":"\(hour)时\(minutes)分"
        seatLabel.text = model.siteCode
        if  model.spAmount.truncatingRemainder(dividingBy: 1) == 0 {
            priceLabel.text = "¥\(Int(model.spAmount))"
        }else {
            priceLabel.text = "¥\(model.spAmount)"
        }
        refundCellView.fullCell(refundPrice: "\(model.refundAmount)")
        
        contactView.fullCellTrain(model: model)
        for view in self.subviews {
            if view is CoOrderDetailsCellPersonViewTrain {
                view.removeFromSuperview()
            }
        }
        var refundHeight = 0
        if model.refundAmount == 0 {
            refundHeight = 0
            refundCellView.isHidden = true
        }else {
            refundCellView.isHidden = false
            refundHeight = 45
        }
        
        for index in 0..<model.passengers.count {
            let passView =  CoOrderDetailsCellPersonViewTrain ()
            self.addSubview(passView)
            passView.fullCell(model: model.passengers[index])
            passView.snp.makeConstraints({ (make) in
                make.top.equalTo(140 + 30 + refundHeight + index * 116)
                make.left.right.equalToSuperview()
                make.height.equalTo(116)
            })
            
        }
        
    }
    
    func initView () {
//        cellLine.layer.shadowOpacity = 0.3
//        cellLine.layer.shadowColor = UIColor.black.cgColor
//        cellLine.layer.shadowOffset  = CGSize(width: 0, height: 2)
//        cellLine.layer.shadowRadius = 2
        addSubview(cellLine)
        cellLine.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(3)
        }
      
        
        addSubview(trainsTitleLabel)
        trainsTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(25)
        }
        addSubview(trainsLabel)
        trainsLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(25)
        }
        addSubview(timeTitleLabel)
        timeTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(trainsTitleLabel.snp.bottom).offset(5)
        }
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(timeTitleLabel.snp.centerY)
        }
        addSubview(seatTitleLabel)
        seatTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(timeTitleLabel.snp.bottom).offset(5)
        }
        addSubview(seatLabel)
        seatLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(seatTitleLabel.snp.centerY)
        }
        addSubview(priceTitleLabel)
        priceTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(seatTitleLabel.snp.bottom).offset(5)
        }
        addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(priceTitleLabel.snp.centerY)
        }
        
//        addSubview(sendTitleLabel)
//        sendTitleLabel.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().inset(15)
//            make.top.equalTo(priceTitleLabel.snp.bottom).offset(5)
//        }
//        addSubview(sendLabel)
//        sendLabel.snp.makeConstraints { (make) in
//            make.right.equalToSuperview().inset(15)
//            make.centerY.equalTo(sendTitleLabel.snp.centerY)
//        }
        
        addSubview(feeTitleLabel)
        feeTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(priceTitleLabel.snp.bottom).offset(5)
        }
        addSubview(feeLabel)
        feeLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(feeTitleLabel.snp.centerY)
        }
        addSubview(countTitleLabel)
        countTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(feeTitleLabel.snp.bottom).offset(5)
        }
        addSubview(countLabel)
        countLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(countTitleLabel.snp.centerY)
        }
        
        addSubview(contactView)
        contactView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(115)
        }
        addSubview(refundCellView)
        refundCellView.snp.makeConstraints { (make) in
            make.top.equalTo(countLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class CoOrderRefundCellViewTrain:UIView {
        
        fileprivate let  line = UILabel(color: TBIThemeGrayLineColor)
        
        fileprivate let  refundTitleLabel = UILabel(text: "退票金额", color: TBIThemeMinorTextColor, size: 14)
        
        fileprivate let  refundLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            initView()
        }
        
        func initView() {
            addSubview(line)
            line.snp.makeConstraints { (make) in
                make.top.equalTo(0)
                make.left.right.equalToSuperview().inset(15)
                make.height.equalTo(0.5)
            }
            addSubview(refundTitleLabel)
            refundTitleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(15)
                make.centerY.equalToSuperview()
            }
            addSubview(refundLabel)
            refundLabel.snp.makeConstraints { (make) in
                make.right.equalToSuperview().inset(15)
                make.centerY.equalTo(refundTitleLabel.snp.centerY)
            }
            
        }
        
        func fullCell (refundPrice:String) {
            refundLabel.text = "¥\(refundPrice)"
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class CoOrderDetailsCellPersonViewTrain:UIView {
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
        
        func fullCell (model:CoNewOrderDetail.TrainVo.TrainPassenger) {
            nameLabel.text = model.name
            phoneLabel.text = model.mobile
            if model.certType == 1 {
                cardTitleLabel.text = "身份证件"
            }else if model.certType == 2 {
                cardTitleLabel.text = "护照"
            }else {
                cardTitleLabel.text = ""
            }
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
