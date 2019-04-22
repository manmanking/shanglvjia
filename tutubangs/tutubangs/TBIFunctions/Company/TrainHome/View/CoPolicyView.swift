//
//  CoPolicyView.swift
//  shop
//
//  Created by TBI on 2018/2/9.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class CoPolicyView: UIView {

    fileprivate var baseBackgroundView:UIView = UIView()
    
    
    let  titleLabel = UILabel(text:"", color: TBIThemeWhite, size: 17)
    
    let  subTitleLabel = UILabel(text:"", color: TBIThemeWhite, size: 14)
    
    let  contentLabel = UILabel(text:"", color: TBIThemeWhite, size: 14)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView () {
        baseBackgroundView.backgroundColor = TBIThemeBackgroundViewPolicyColor
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        baseBackgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(32)
        }
        baseBackgroundView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(30)
        }
        contentLabel.numberOfLines = 0
        baseBackgroundView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(subTitleLabel.snp.bottom).offset(25)
            make.left.right.equalToSuperview().inset(30)
        }
        
        baseBackgroundView.addOnClickListener(target: self, action: #selector(cancelButtonAction))
    }
    
    func fullData (title:String,subTitle:String,content:String) {
        titleLabel.text    = title
        subTitleLabel.text = subTitle
        contentLabel.text  = content
    }
    
    
    @objc fileprivate func cancelButtonAction() {
        self.removeFromSuperview()
    }
}
