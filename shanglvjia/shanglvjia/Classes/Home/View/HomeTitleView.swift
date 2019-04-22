//
//  HomeTitleView.swift
//  shop
//
//  Created by SLMF on 2017/4/18.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class HomeTitleView: UIView {
    
    let businessButton: UIButton
    let personalButton: UIButton
    let businessLabel: UILabel
    let personalLabel: UILabel
    
    fileprivate let lineHeight = 2
    fileprivate let buttonFontSize: CGFloat = 16
    fileprivate let titleViewWidth = 188
    fileprivate let titleViewHeight = 44
    fileprivate let buttonWidth = 64
    fileprivate let buttonHeight = 16
    fileprivate let buttonBottomDistence = 12.5
    fileprivate let distenceBetweenButtons = 60
    
    init() {
   
        businessButton = UIButton.init(title: "公务出行", titleColor: .white, titleSize: buttonFontSize)
        businessButton.titleLabel?.font = UIFont.init(name: "TRENDS", size: buttonFontSize)
        personalButton = UIButton.init(title: "个人出行", titleColor: .white, titleSize: buttonFontSize)
        personalButton.titleLabel?.font = UIFont.init(name: "TRENDS", size: buttonFontSize)
        businessLabel = UILabel()
        personalLabel = UILabel()
        businessLabel.isHidden = true
        personalLabel.isHidden = true
        personalButton.isHidden = true
        super.init(frame: CGRect.init(x: 0, y: 0, width: titleViewWidth, height: titleViewHeight))
        self.addSubview(businessButton)
        self.addSubview(personalButton)
        self.addSubview(businessLabel)
        self.addSubview(personalLabel)
        personalButton.snp.makeConstraints{(make) in
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(0 - buttonBottomDistence)
        }
        businessButton.snp.makeConstraints{(make) in
            make.center.equalToSuperview()
//            make.width.equalTo(personalButton.snp.width)
//            make.height.equalTo(personalButton.snp.height)
//            make.right.equalTo(personalButton.snp.left).offset(0 - distenceBetweenButtons)
//            make.bottom.equalTo(personalButton.snp.bottom)
        }
        personalLabel.snp.makeConstraints{(make) in
            make.left.equalTo(personalButton.snp.left)
            make.width.equalTo(personalButton.snp.width)
            make.bottom.equalToSuperview()
            make.height.equalTo(lineHeight)
        }
        businessLabel.snp.makeConstraints{(make) in
            make.left.equalTo(businessButton.snp.left)
            make.width.equalTo(businessButton.snp.width)
            make.height.equalTo(lineHeight)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIButton {
    
    func active() {
        self.setTitleColor(UIColor.init(white: 1, alpha: 1), for: .normal)
    }
    
    func unActive() {
        self.setTitleColor(UIColor.init(white: 1, alpha: 0.4), for: .normal)
    }
}
