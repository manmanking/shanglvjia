//
//  PSepcialFlightListCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/2.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PSepcialFlightListCell: UITableViewCell {

    private let leaveCityLabel = UILabel.init(text: "天津", color: PersonalThemeMajorTextColor, size: 16)
    private let arriveCityLabel = UILabel.init(text: "天津", color: PersonalThemeMajorTextColor, size: 16)
    private let timeLabel = UILabel.init(text: "2018-10-01至2018-10-07", color: PersonalThemeMajorTextColor, size: 12)
    private let lineLabel = UILabel()
    private var moneyLabel = UILabel.init(text: "", color: TBIThemePrimaryWarningColor, size: 20)
     private var arrowImageView = UIImageView()
//    var noChangeLabel = UILabel.init(text: " 不可改 ", color: PersonalThemeBlueColor, size: 10)
    private var noExitLabel = UILabel.init(text: " 退改规则 ", color: PersonalThemeDarkColor, size: 10)
    private var countLabel = UILabel.init(text: "", color: PersonalThemeMajorTextColor, size: 10)
    
    public var codeImage = UIImageView()
     public var lowImage = UIImageView()
    
    fileprivate var eiString:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = TBIThemeWhite
        self.selectionStyle = .none
        creatView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func creatView(){
        self.addSubview(leaveCityLabel)
        self.addSubview(arriveCityLabel)
        self.addSubview(lineLabel)
        self.addSubview(moneyLabel)
        self.addSubview(arrowImageView)
        self.addSubview(timeLabel)
//        self.addSubview(noChangeLabel)
        self.addSubview(noExitLabel)
        self.addSubview(countLabel)
        self.addSubview(codeImage)
        self.addSubview(lowImage)
        
        lineLabel.backgroundColor = TBIThemeGrayLineColor
        lineLabel.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(1)
        }
        
        codeImage.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview().offset(-15)
            make.height.width.equalTo(19)
        }
        
        leaveCityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(codeImage.snp.right).offset(10)
            make.centerY.equalTo(codeImage)
        }
        
        arrowImageView.image = UIImage(named:"ic_air_to")
        arrowImageView.snp.makeConstraints { (make) in
            make.left.equalTo(leaveCityLabel.snp.right).offset(20)
            make.centerY.equalTo(leaveCityLabel)
            make.width.equalTo(18)
        }
        
        arriveCityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(arrowImageView.snp.right).offset(20)
            make.centerY.equalTo(leaveCityLabel)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leaveCityLabel.snp.left)
            make.centerY.equalToSuperview().offset(15)
        }
        
//        countLabel.snp.makeConstraints { (make) in
//            make.right.equalToSuperview().inset(15)
//            make.bottom.equalTo(leaveCityLabel).offset(-3)
//        }
        
        moneyLabel.snp.makeConstraints { (make) in
            //make.right.equalTo(countLabel.snp.left).offset(-5)
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(leaveCityLabel)
        }
        
        noExitLabel.layer.cornerRadius = 2.0
        noExitLabel.clipsToBounds = true
        noExitLabel.layer.borderColor = PersonalThemeDarkColor.cgColor
        noExitLabel.layer.borderWidth = 1.0
        noExitLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.bottom.equalTo(timeLabel)
            make.height.equalTo(15)
        }
        noExitLabel.addOnClickListener(target: self, action: #selector(noExitLabelClick(tap:)))
       
        lowImage.image = UIImage(named:"lowprice")
        lowImage.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(65)
            make.height.equalTo(16)
            make.right.equalToSuperview()
        }
//        noChangeLabel.layer.cornerRadius = 2.0
//        noChangeLabel.clipsToBounds = true
//        noChangeLabel.layer.borderColor = PersonalThemeBlueColor.cgColor
//        noChangeLabel.layer.borderWidth = 1.0
//        noChangeLabel.snp.makeConstraints { (make) in
//            make.right.equalTo(noExitLabel.snp.left).offset(-5)
//            make.bottom.equalTo(timeLabel)
//            make.height.equalTo(15)
//        }
    }
    func fillCellData(model:PSpecialFlightListModel.BaseFlightProductListVo){
        let moneyAttrs = NSMutableAttributedString(string:"¥ " + model.saleRate.TwoOfTheEffectiveFraction())
        moneyAttrs.addAttributes([ NSFontAttributeName : UIFont.systemFont(ofSize: 12)],range: NSMakeRange(0,1))
        moneyLabel.attributedText = moneyAttrs
        
        leaveCityLabel.text = model.departure
        arriveCityLabel.text = model.destination
        
        if model.saleStartTime.isEmpty || model.saleEndTime.isEmpty{
            timeLabel.text = "全年"
        }else{
            timeLabel.text = model.saleStartTime + "至" + model.saleEndTime
        }        
        
        codeImage.image = UIImage(named:model.companyCode)
        
        if model.tripType == "0"{
            arrowImageView.image = UIImage(named:"ic_air_to")
        }else{
            arrowImageView.image = UIImage(named:"ic_air_roundtrip")
        }
    
        
        if model.productType == "A"{
            let countAttrs = NSMutableAttributedString(string:"剩" + model.stock.stringValue + "张")
            countAttrs.addAttributes([ NSForegroundColorAttributeName : TBIThemeRedColor],range: NSMakeRange(1,model.stock.stringValue.count))
            countLabel.attributedText = countAttrs
        }else{
            countLabel.text = ""
            ///特价
        }
        
        eiString = model.eiRule
    }
    func noExitLabelClick(tap:UITapGestureRecognizer){
        popPersonalNewAlertView(content: eiString, titleStr:"退改规则", btnTitle: "我知道了")
    }
}
