//
//  FlightSelectPersonTableViewCell.swift
//  shop
//
//  Created by TBI on 2017/6/6.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class FlightSelectPersonTableViewCell: UITableViewCell {

    let titleLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let buttom   = UIButton()
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buttom.setImage(UIImage.init(named: "squareUnselected"), for: UIControlState.normal)
        buttom.setImage(UIImage.init(named: "squareSelected"), for: UIControlState.selected)
        buttom.isUserInteractionEnabled = false
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        addSubview(buttom)
        buttom.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    func fillCell(model:UserDetail.Customer?,index: IndexPath) {
        if index.row == 0 {
           line.isHidden = true
        }
        titleLabel.text = (model?.name ?? "") + "("+("\(model?.cardNo ?? "")")+")"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
