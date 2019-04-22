//
//  OrderRecordCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/10.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class OrderRecordCell: UITableViewCell {

    var timeLabel = UILabel(text:"时间",color:TBIThemePrimaryTextColor,size:15)
    var nameLabel = UILabel(text:"时间",color:TBIThemePrimaryTextColor,size:15)
    var stateLabel = UILabel(text:"时间",color:TBIThemePrimaryTextColor,size:15)


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
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(stateLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.top.equalTo(12)
            make.height.equalTo(15)
            make.bottom.equalToSuperview().offset(0)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.right).offset(17)
            make.top.equalTo(timeLabel.snp.top)
            make.height.equalTo(timeLabel.snp.height)
        }
        stateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(17)
            make.top.equalTo(timeLabel.snp.top)
            make.height.equalTo(timeLabel.snp.height)
        }
    }
    
    func setCellWithModel(leftStr:String,middleStr:String,rightStr:String)  {
        timeLabel.text=leftStr
        nameLabel.text=middleStr
        stateLabel.text=rightStr
        if rightStr == "已拒绝"
        {
            stateLabel.textColor = TBIThemeRedColor
        }else{
            stateLabel.textColor = TBIThemePrimaryTextColor
        }
    }
}
