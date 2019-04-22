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
    public var bottomLine = UILabel()
//    fileprivate var percentLabel = UILabel.init(text: "出签率", color: TBIThemePrimaryWarningColor, size: 12)
    //fileprivate var qiLabel = UILabel.init(text: "起", color: TBIThemeMinorTextColor, size: 10)
    fileprivate var moneyLabel = UILabel.init(text: "", color: TBIThemePrimaryWarningColor, size: 20)
    
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
    }
}
