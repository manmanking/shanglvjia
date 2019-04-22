//
//  VisaSectionHeaderView.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/18.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class VisaSectionHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let bgView:UIView = UIView()
    let titleLabel:UILabel = UILabel.init(text: "", color: PersonalThemeMajorTextColor, size: 14)
    let blueLine:UILabel = UILabel()
    let bottomLine:UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = TBIThemeBaseColor
        self.addSubview(bgView)
        bgView.addSubview(titleLabel)
        bottomLine.backgroundColor = TBIThemeGrayLineColor
        bgView.addSubview(bottomLine)
        blueLine.backgroundColor = PersonalThemeDarkColor
        bgView.addSubview(blueLine)
        bgView.backgroundColor = TBIThemeWhite
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(45)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.bottom.equalToSuperview()
        }
        blueLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.height.equalTo(2)
            make.bottom.equalToSuperview()
        }
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(blueLine)
            make.height.equalTo(1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
