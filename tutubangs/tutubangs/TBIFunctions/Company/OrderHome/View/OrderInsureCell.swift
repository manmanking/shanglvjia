//
//  OrderInsureCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/15.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class OrderInsureCell: UITableViewCell {

    var leftLabel = UILabel(text: "基本信息", color: UIColor.gray, size: 15)
    var rightLabel = UILabel(text: "基本信息", color: TBIThemePrimaryTextColor, size: 15)
    //线
    var bottomLineLabel = UILabel()
    
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
        self.backgroundColor=TBIThemeWhite;
        self.selectionStyle=UITableViewCellSelectionStyle.none
        creatCellUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func creatCellUI() {
        self.contentView.addSubview(leftLabel)
        self.contentView.addSubview(rightLabel)
        bottomLineLabel.backgroundColor=TBIThemeBaseColor
        self.contentView.addSubview(bottomLineLabel)
        
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.top.equalTo(0)
            make.width.equalTo(75)
            make.height.equalTo(44)
        }
        rightLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftLabel.snp.right).offset(13)
            make.top.equalTo(leftLabel.snp.top)
            make.right.equalToSuperview().offset(-18)
            make.bottom.equalToSuperview().offset(-1)
            
        }
        bottomLineLabel.snp.makeConstraints { (make) in
            make.top.equalTo(leftLabel.snp.bottom).offset(-1)
            make.left.equalTo(leftLabel)
            make.height.equalTo(1)
            make.width.equalTo(ScreenWindowWidth-13)
            make.bottom.equalToSuperview()
        }
    }
    func setCell(leftStr:String,rightStr:String)  {
        leftLabel.text=leftStr
        rightLabel.text=rightStr .isEmpty ? " " : rightStr
    }
}
