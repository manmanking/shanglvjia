//
//  PersonalHotelSubmitTipSectionView.swift
//  shanglvjia
//
//  Created by manman on 2018/8/22.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalHotelSubmitTipSectionCellView: UITableViewCell {

    private var flagImageView:UIImageView = UIImageView()
    
    private var titleLabel:UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = TBIThemeMinorColor
        setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUIViewAutolayout() {
        flagImageView.image = UIImage.init(named: "warningRed")
        self.contentView.addSubview(flagImageView)
        flagImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(14)
        }
        
        titleLabel.textColor = TBIThemeRedColor
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(flagImageView.snp.right).offset(15)
            make.top.bottom.right.equalToSuperview()
        }
        
    }
    func fillDataSources(title:String) {
        titleLabel.text = title
    }
    

}
