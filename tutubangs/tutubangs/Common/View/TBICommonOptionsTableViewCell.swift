//
//  TBICommonOptionsTableViewCell.swift
//  shop
//
//  Created by TBI on 2017/6/21.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class TBICommonOptionsTableViewCell: UITableViewCell {

    private let backGroundview = UIView()
    private let bottomLine = UILabel()
    private let titleLabel = UILabel()
    private let selectedButton = UIButton()
    private var cellIndex:NSInteger = 0
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backGroundview.backgroundColor = UIColor.white
        self.contentView.addSubview(backGroundview)
        backGroundview.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUIViewAutolayout() {
        selectedButton.isUserInteractionEnabled = false
        titleLabel.text = ""
        titleLabel.textColor = UIColor.black
        backGroundview.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.left.equalToSuperview().inset(15)
            make.width.equalToSuperview().inset(30)
        }
        selectedButton.setImage(UIImage.init(named: "squareUnselected"), for: UIControlState.normal)
        selectedButton.setImage(UIImage.init(named: "squareSelected"), for: UIControlState.selected)
        backGroundview.addSubview(selectedButton)
        selectedButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        bottomLine.backgroundColor = TBIThemeGrayLineColor
        backGroundview.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
            
        }
    }
    
    
    func cellConfig(title:String,selected:Bool,index:NSInteger) {
        titleLabel.text = title
        cellIndex = index
        if selected {
            selectedButton.isSelected = selected
        }else
        {
            selectedButton.isSelected = selected
        }
    }
    
    


}
