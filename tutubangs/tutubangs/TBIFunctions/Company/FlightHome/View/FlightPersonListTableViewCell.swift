//
//  FlightPersonListTableViewCell.swift
//  shop
//
//  Created by TBI on 2017/7/28.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class FlightPersonListTableViewCell: UITableViewCell {

    let  selectBtn = UIButton()
    
    let  updateBtn = UIButton()
    
    let  deleteBtn = UIButton()
    
    let  nameLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let  cardLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let  line = UILabel(color: TBIThemeGrayLineColor)
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectBtn.setImage(UIImage.init(named: "unselectedSquare"), for: UIControlState.normal)
        selectBtn.setImage(UIImage.init(named: "squareSelected"), for: UIControlState.selected)
        updateBtn.setImage(UIImage.init(named: "ic_edit"), for: UIControlState.normal)
        deleteBtn.setImage(UIImage.init(named: "ic_delete_grey"), for: UIControlState.normal)
        selectBtn.isUserInteractionEnabled = false
        updateBtn.setEnlargeEdgeWithTop(30 ,left: 40, bottom: 30, right: 20)
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        addSubview(selectBtn)
        selectBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.height.width.equalTo(20)
            make.centerY.equalToSuperview()
        }
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(45)
            make.centerY.equalToSuperview().offset(-11)
        }
        addSubview(cardLabel)
        cardLabel.snp.makeConstraints { (make) in
            make.left.equalTo(45)
            make.centerY.equalToSuperview().offset(11)
        }
        addSubview(updateBtn)
        updateBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
            make.height.width.equalTo(20)
        }
    }
    
    func fillCell(model:TravellerListItem?,index:Int){
        nameLabel.text = model?.nameChi
        cardLabel.text = model?.idCard
        //选中cell
        if  model?.selectFlag ?? false {
            selectBtn.isSelected = true
        }else {
            selectBtn.isSelected = false
        }
        if index == 0 {
            line.isHidden = true
        }else {
            line.isHidden = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
