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
    fileprivate var percentLabel = UILabel.init(text: "需出示员工证", color: PersonalThemeBlueColor, size: 12)
    fileprivate var ftmsLabel = UILabel.init(text: "", color: PersonalThemeDarkColor, size: 10)
//    fileprivate var qiLabel = UILabel.init(text: "起", color: TBIThemeMinorTextColor, size: 10)
    fileprivate var moneyLabel = UILabel.init(text: "", color: TBIThemePrimaryWarningColor, size: 20)
    fileprivate var goCityLabel = UILabel.init(text: "", color: TBIThemeWhite, size: 8)
    
    fileprivate var desString:String = ""
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
        self.addSubview(percentLabel)
//        self.addSubview(qiLabel)
        self.addSubview(moneyLabel)
        visaImageView.addSubview(goCityLabel)
        self.addSubview(ftmsLabel)
        
        visaImageView.layer.cornerRadius = 2
        visaImageView.clipsToBounds = true
        visaImageView.backgroundColor = UIColor.red
        visaImageView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(135)
            make.height.equalTo(90)
        }
        visaTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        visaTitleLabel.numberOfLines = 2
        visaTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(visaImageView.snp.right).offset(16)
            make.right.equalTo(-15)
            make.top.equalTo(visaImageView).offset(5)
        }
        bottomLine.backgroundColor = TBIThemeGrayLineColor
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        ///
        percentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(visaTitleLabel)
            make.bottom.equalTo(visaImageView).offset(-25)
            make.right.equalToSuperview().inset(13)
        }
//        qiLabel.snp.makeConstraints { (make) in
//            make.right.equalTo(visaTitleLabel)
//            make.bottom.equalTo(visaImageView)
//        }
        ///
        moneyLabel.snp.makeConstraints { (make) in
            make.right.equalTo(visaTitleLabel)
            make.bottom.equalTo(visaImageView).offset(-2)
        }
     
//        goCityLabel.addCorner(byRoundingCorners: [ UIRectCorner.bottomRight], radii: 3)
        goCityLabel.backgroundColor = TBIThemeBackgroundViewColor
        goCityLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.height.equalTo(15)
        }
        
        ftmsLabel.layer.cornerRadius = 2.0
        ftmsLabel.clipsToBounds = true
        ftmsLabel.layer.borderColor = PersonalThemeDarkColor.cgColor
        ftmsLabel.layer.borderWidth = 1.0
        ftmsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(visaTitleLabel)
            make.bottom.equalTo(visaImageView).offset(-5)
            make.height.equalTo(15)
        }
        
        ///percentLabel.isHidden = true
        ftmsLabel.isHidden = true
       
    }
    func fillDataSources(model:PTravelProductListResponse.BaseTravelProductListVo,type:String) {
      
        let moneyAttrs = NSMutableAttributedString(string:"¥" + model.minPrice)
        moneyAttrs.addAttributes([ NSFontAttributeName : UIFont.systemFont(ofSize: 12)],range: NSMakeRange(0,1))
        moneyLabel.attributedText = moneyAttrs
        
//        let percentAttrs = NSMutableAttributedString(string:"剩余 " + model.stockCount.description)
//        percentAttrs.addAttributes([NSForegroundColorAttributeName : TBIThemeMinorTextColor],range: NSMakeRange(0,2))
//        percentLabel.attributedText = percentAttrs
        
        let encodedStr = model.pic.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = URL.init(string: encodedStr!)
        
        visaImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "bg_default_travel"))
        
        goCityLabel.text = "  \(model.deptCN)出发  "
        
        if type == "2"{
            ///自由行
            ftmsLabel.isHidden = true
            percentLabel.isHidden = false
            percentLabel.text = model.stopCity
            visaTitleLabel.text = model.name + "\n" + model.sideName
            goCityLabel.isHidden = false
           
        }else{
            ///周边游
            visaTitleLabel.text = model.name
             ftmsLabel.isHidden = false
            goCityLabel.isHidden = true
            
            if model.spot.isNotEmpty{
                ftmsLabel.isHidden = false
                 ftmsLabel.text = "  \(model.spot)  "
                desString = model.spotDesc
                ftmsLabel.addOnClickListener(target: self, action: #selector(popSpotDescription(tap:)))
            }else{
                ftmsLabel.isHidden = true
                
            }
            
            if model.employee == "0"{
                percentLabel.isHidden = true
            }else{
                percentLabel.isHidden = false
                percentLabel.text = "需出示员工证"
            }
        }
        
    }
    
    func popSpotDescription(tap:UITapGestureRecognizer){
        popPersonalNewAlertView(content: desString, titleStr: "提示", btnTitle: "确定")
    }
}

