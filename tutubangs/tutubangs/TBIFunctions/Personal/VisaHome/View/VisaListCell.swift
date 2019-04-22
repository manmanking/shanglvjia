//
//  VisaListCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/11.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class VisaListCell: UITableViewCell {

    fileprivate var visaImageView = UIImageView()
    fileprivate var visaTitleLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 14)
    fileprivate var visaDesLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 13)
    public var bottomLine = UILabel()
//    fileprivate var percentLabel = UILabel.init(text: "出签率", color: TBIThemePrimaryWarningColor, size: 12)
    //fileprivate var qiLabel = UILabel.init(text: "起", color: TBIThemeMinorTextColor, size: 10)
    fileprivate var moneyLabel = UILabel.init(text: "", color: TBIThemePrimaryWarningColor, size: 20)
    
    ///fileprivate var customLabel = UILabel.init(text: " 专属客服 ", color: PersonalThemeNormalColor, size: 10)
    ///fileprivate var visaStyleLabel = UILabel.init(text: " 预付 ", color: PersonalThemeBlueColor, size: 10)
    
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
        self.addSubview(visaImageView)
        self.addSubview(visaTitleLabel)
        self.addSubview(bottomLine)
//        self.addSubview(percentLabel)
        //self.addSubview(qiLabel)
        self.addSubview(moneyLabel)
        self.addSubview(visaDesLabel)
        
        visaImageView.layer.cornerRadius = 2
        visaImageView.clipsToBounds = true
        visaImageView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(112)
            make.height.equalTo(60)
        }
        visaTitleLabel.numberOfLines = 0
        visaTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(visaImageView)
        }
        
        visaDesLabel.numberOfLines = 1
        visaDesLabel.snp.makeConstraints { (make) in
            make.left.equalTo(visaTitleLabel)
            make.top.equalTo(visaTitleLabel.snp.bottom).offset(5)
        }
        
        bottomLine.backgroundColor = TBIThemeGrayLineColor
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        ///
//        percentLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(visaTitleLabel)
//            make.bottom.equalTo(visaImageView)
//        }
//        qiLabel.snp.makeConstraints { (make) in
//            make.right.equalTo(visaTitleLabel)
//            make.bottom.equalTo(visaImageView)
//        }
        ///
        moneyLabel.snp.makeConstraints { (make) in
            make.right.equalTo(visaTitleLabel.snp.right)
            make.bottom.equalTo(visaImageView.snp.bottom)
        }

    }
    func fillDataSources(model:VisaProductListResponse.BaseVisaProductListVo) {
//        moneyLabel.text = "¥899"
//        percentLabel.text = "出签率 100%"
        let moneyAttrs = NSMutableAttributedString(string:"¥" + model.saleRate.TwoOfTheEffectiveFraction())
        moneyAttrs.addAttributes([ NSFontAttributeName : UIFont.systemFont(ofSize: 12)],range: NSMakeRange(0,1))
        moneyLabel.attributedText = moneyAttrs
        
//        let percentAttrs = NSMutableAttributedString(string:"出签率 100%")
//        percentAttrs.addAttributes([NSForegroundColorAttributeName : TBIThemeMinorTextColor],range: NSMakeRange(0,3))
//        percentLabel.attributedText = percentAttrs
        
        ///visaImageView.sd_setImage(with: URL.init(string: model.pic), placeholderImage: UIImage(named: "bg_default_travel"))
        visaTitleLabel.text = model.visaName
        
        visaDesLabel.text = model.visaTitleS
        
        CommonTool.removeSubviews(onBgview: self.contentView)
        var stringArray : [String] = Array()
        var widthArray : [CGFloat] = Array()
        for str in model.hotTypes{
            stringArray.append(str)
        }
        for str in model.visaTypes{
            stringArray.append(str)
        }
        if stringArray.count > 0{
            var originX:CGFloat = 15
            for i in 0...stringArray.count-1{
                let styleStr =  " " + stringArray[i] + " "
                let styleLabel = UILabel.init(text: styleStr, color: PersonalThemeNormalColor, size: 10)
                widthArray.append(styleStr.getTextWidth(font: UIFont.systemFont(ofSize: 10), height: 15))
                self.contentView.addSubview(styleLabel)
                styleLabel.layer.cornerRadius = 2.0
                styleLabel.clipsToBounds = true
                styleLabel.layer.borderColor = PersonalThemeNormalColor.cgColor
                styleLabel.layer.borderWidth = 1.0
                if i>0{
                    originX = originX + 5 + widthArray[i-1]
                }
                styleLabel.frame = CGRect(x:originX,y:70,width:widthArray[i],height:15)

                if i > model.hotTypes.count - 1{
                    styleLabel.layer.borderColor = PersonalThemeBlueColor.cgColor
                    styleLabel.textColor = PersonalThemeBlueColor
                }else{
                    styleLabel.layer.borderColor = PersonalThemeNormalColor.cgColor
                    styleLabel.textColor = PersonalThemeNormalColor
                }
            }
        }
        
    }
}
