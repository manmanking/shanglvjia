//
//  OrderDetailLabelCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/9.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class OrderDetailLabelCell: UITableViewCell {

    var leftLabel = UILabel(text: "基本信息", color: UIColor.gray, size: 15)
    var rightLabel = UILabel(text: "基本信息", color: TBIThemePrimaryTextColor, size: 15)
    
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
    
    func creatCellUI(){
        rightLabel.numberOfLines=0
        self.contentView.addSubview(leftLabel)
        self.contentView.addSubview(rightLabel)
        
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.top.equalTo(12)
            make.width.equalTo(75)
            make.height.equalTo(15)
        }
        rightLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftLabel.snp.right).offset(13)
            make.top.equalTo(leftLabel.snp.top)
            make.right.equalToSuperview().offset(-18)
            make.bottom.equalToSuperview().offset(0)
           
        }
    }
    
    func setCell(leftStr:String,rightStr:String)  {
        leftLabel.text=leftStr
        rightLabel.text=rightStr .isEmpty ? " " : rightStr
    }
}
