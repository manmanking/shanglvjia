//
//  OrderPsgerCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/10.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class OrderPsgerCell: UITableViewCell {

    var nameLabel = UILabel(text:"乘客姓名",color:TBIThemePrimaryTextColor,size:15)
    var numLabel = UILabel(text:"证件号",color:UIColor.gray,size:13)
    var siteNumLabel = UILabel(text:"",color:UIColor.gray,size:13)
    var bottomLineLabel = UILabel()
    var rightArrow = UIImageView(imageName:"ic_right_gray")
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func creatCellUI() {
        bottomLineLabel.backgroundColor=TBIThemeGrayLineColor
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(numLabel)
        self.contentView.addSubview(siteNumLabel)
        self.contentView.addSubview(bottomLineLabel)
        self.contentView.addSubview(rightArrow)
        rightArrow.isHidden=true
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(14)
        }
        numLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(7)
        }
        siteNumLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.right.equalTo(nameLabel)
            make.top.equalTo(numLabel.snp.bottom).offset(3)
        }
        rightArrow.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(nameLabel.snp.bottom).offset(-3)
            make.width.equalTo(6)
            make.height.equalTo(10)
        }
        bottomLineLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(siteNumLabel.snp.bottom).offset(12)
            make.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
            
        }
    }
    
    func setCellWithOrderDetailModel(model:OrderDetailModel.passenger)  {
        nameLabel.text=model.psgName
        let trainSiteStr = (model.siteCodeCH.isEmpty ? "" : model.siteCodeCH + " " + model.siteInfo)
        let typeStr = model.certType == "1" ? "身份证": model.certType == "2" ?"护照":model.certType
        let numStr = typeStr + "  " + model.certNo
        numLabel.text=numStr
        siteNumLabel.text=trainSiteStr
        if model.surances.count == 0 {
            rightArrow.isHidden=true
        }else{
            rightArrow.isHidden=false
        }
    }
   
    

}
