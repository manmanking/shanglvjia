//
//  PriceInfoCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/21.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PriceInfoCell: UITableViewCell {

    var nameLabel = UILabel(text:"",color:TBIThemePrimaryTextColor,size:14)
    var priceLabel = UILabel(text:"",color:TBIThemeRedColor,size:14)
    var personLabel = UILabel(text:"",color:TBIThemePrimaryTextColor,size:14)
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
    
    func creatCellUI() {
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(priceLabel)
        self.contentView.addSubview(personLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.top.bottom.equalTo(0)
            make.width.equalTo(280)
        }
        personLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.right.equalTo(-13)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.right.equalTo(personLabel.snp.left)
        }
    }
}
