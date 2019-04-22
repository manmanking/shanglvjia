//
//  PricesDetailTableViewCell.swift
//  shanglvjia
//
//  Created by manman on 2018/8/14.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PricesDetailTableViewCell: UITableViewCell {

    private let leftTitleLable:UILabel = UILabel()
    private let midTitleLable:UILabel = UILabel()
    private let rightTitleLable:UILabel = UILabel()
  
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       self.contentView.backgroundColor = TBIThemeWhite
        setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUIViewAutolayout() {
        self.contentView.addSubview(leftTitleLable)
        leftTitleLable.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview()
        }
        self.contentView.addSubview(midTitleLable)
        midTitleLable.snp.makeConstraints { (make) in
            make.left.equalTo(leftTitleLable.snp.right).offset(4)
            make.top.bottom.equalToSuperview()
        }
        rightTitleLable.textColor = TBIThemeRedColor
        self.contentView.addSubview(rightTitleLable)
        rightTitleLable.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview()
        }
  
    }
    
    func fillDataSources(leftTitle:String,midTitle:String,rightTitle:String) {
     
        if leftTitle.isEmpty == false {
            leftTitleLable.isHidden = false
            leftTitleLable.text = leftTitle
        }else {
            leftTitleLable.isHidden = true
        }
        if midTitle.isEmpty == false{
            midTitleLable.isHidden = false
            midTitleLable.text = midTitle
        }else{
            midTitleLable.isHidden = true
        }
        
        if rightTitle.isEmpty == false {
            rightTitleLable.isHidden = false
            rightTitleLable.text = rightTitle
        }else{
            rightTitleLable.isHidden = true
        }
        
    }
    
    
    
    
    
}
