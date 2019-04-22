//
//  PTravelListCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/25.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PTravelListCell: UITableViewCell {

    fileprivate var visaImageView = UIImageView()
    fileprivate var visaTitleLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 14)
    fileprivate var bottomLine = UILabel()
//    fileprivate var percentLabel = UILabel.init(text: "出签率", color: TBIThemePrimaryWarningColor, size: 12)
//    fileprivate var qiLabel = UILabel.init(text: "起", color: TBIThemeMinorTextColor, size: 10)
    fileprivate var moneyLabel = UILabel.init(text: "", color: TBIThemePrimaryWarningColor, size: 20)
    fileprivate var goCityLabel = UILabel.init(text: "", color: TBIThemeWhite, size: 8)
    
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
//        self.addSubview(qiLabel)
        self.addSubview(moneyLabel)
        visaImageView.addSubview(goCityLabel)
        
        visaImageView.layer.cornerRadius = 2
        visaImageView.clipsToBounds = true
        visaImageView.backgroundColor = UIColor.red
        visaImageView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(112)
            make.height.equalTo(74)
        }
        visaTitleLabel.numberOfLines = 2
        visaTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(visaImageView.snp.right).offset(16)
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
            make.right.equalTo(visaTitleLabel)
            make.bottom.equalTo(visaImageView)
        }
     
//        goCityLabel.addCorner(byRoundingCorners: [ UIRectCorner.bottomRight], radii: 3)
        goCityLabel.backgroundColor = TBIThemeBackgroundViewColor
//        goCityLabel.layer.cornerRadius = 3.0
//        goCityLabel.clipsToBounds = true
        goCityLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.height.equalTo(15)
        }
       
    }
    func fillDataSources(model:PTravelProductListResponse.BaseTravelProductListVo) {
      
        let moneyAttrs = NSMutableAttributedString(string:"¥" + model.minPrice)
        moneyAttrs.addAttributes([ NSFontAttributeName : UIFont.systemFont(ofSize: 12)],range: NSMakeRange(0,1))
        moneyLabel.attributedText = moneyAttrs
        
//        let percentAttrs = NSMutableAttributedString(string:"剩余 " + model.stockCount.description)
//        percentAttrs.addAttributes([NSForegroundColorAttributeName : TBIThemeMinorTextColor],range: NSMakeRange(0,2))
//        percentLabel.attributedText = percentAttrs
        
        let encodedStr = model.pic.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = URL.init(string: encodedStr!)
        
        visaImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "bg_default_travel"))
        visaTitleLabel.text = model.name
        
        goCityLabel.text = "  \(model.deptCN)出发  "
        
    }
    

}

