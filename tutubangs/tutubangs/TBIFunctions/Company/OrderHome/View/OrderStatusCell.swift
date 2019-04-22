//
//  OrderStatusCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/15.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class OrderStatusCell: UITableViewCell {

    var statusImage = UIImageView(imageName:"ic_progress_bar_a")
    var statusLabelOne = UILabel.init(text: "计划中", color: UIColor.gray, size: 13)
    var statusLabelTwo = UILabel.init(text: "审批中", color: UIColor.gray, size: 13)
    var statusLabelThree = UILabel.init(text: "待订妥", color: UIColor.gray, size: 13)
    var statusLabelFour = UILabel.init(text: "已订妥", color: UIColor.gray, size: 13)

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
        self.contentView.addSubview(statusImage)
        self.contentView.addSubview(statusLabelOne)
        self.contentView.addSubview(statusLabelTwo)
        self.contentView.addSubview(statusLabelThree)
        self.contentView.addSubview(statusLabelFour)
        statusImage.snp.makeConstraints { (make) in
            make.top.equalTo(18)
            make.height.equalTo(28)
            make.centerX.equalToSuperview()
            make.width.equalTo(295)
        }
        statusLabelOne.snp.makeConstraints { (make) in
            make.centerX.equalTo(statusImage.snp.centerX).offset(-135)
            make.height.equalTo(20)
            make.top.equalTo(statusImage.snp.bottom)
            make.bottom.equalToSuperview()
        }
        statusLabelTwo.snp.makeConstraints { (make) in
            make.centerX.equalTo(statusImage.snp.centerX).offset(-40)
            make.height.equalTo(statusLabelOne)
            make.top.equalTo(statusLabelOne.snp.top)
            make.bottom.equalToSuperview()

        }
        statusLabelThree.snp.makeConstraints { (make) in
            make.centerX.equalTo(statusImage.snp.centerX).offset(45)
            make.height.equalTo(statusLabelOne)
            make.top.equalTo(statusLabelOne.snp.top)
            make.bottom.equalToSuperview()

        }
        statusLabelFour.snp.makeConstraints { (make) in
            make.centerX.equalTo(statusImage.snp.centerX).offset(135)
            make.height.equalTo(statusLabelOne)
            make.top.equalTo(statusLabelOne.snp.top)
            make.bottom.equalToSuperview()

        }
    }
    
    func setCellWithStatus(status:String)  {
    
        let nameStr = status == "1" ? "ic_progress_bar_a" :  status == "2" ? "ic_progress_bar_b" : status == "3" ? "ic_progress_bar_c" : status == "4" ? "ic_progress_bar_d" :  "ic_progress_bar_bg"
        statusImage.image=UIImage(named: nameStr)
        if status == "5" {
            statusLabelFour.text="已退订"
        }
    }

}
