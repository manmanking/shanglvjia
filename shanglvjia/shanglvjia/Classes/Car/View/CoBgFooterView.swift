//
//  CoBgFooterView.swift
//  shop
//
//  Created by TBI on 2018/1/22.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class CoBgFooterView: UIView {

    fileprivate  let  leftLine = UILabel(color: TBIThemeFooterColor)
    
    fileprivate let   titleLabel:UILabel = UILabel(text: "专属客服·为您护航", color: TBIThemeFooterColor, size: 12)
    
    fileprivate  let  rightLine = UILabel(color: TBIThemeFooterColor)
    
    fileprivate let   customerLabel:UILabel = UILabel(text: "022-81267008", color: TBIThemeFooterColor, size: 10)
    
    fileprivate let   customerLabelTwo:UILabel = UILabel(text: "022-81267008", color: TBIThemeFooterColor, size: 10)
    
    fileprivate let   customerImage = UIImageView(imageName: "ic_service_tel")
    
    //fileprivate let   timeImage = UIImageView(imageName: "ic_service_time")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    func initView () {
//        addSubview(timeImage)
//        timeImage.snp.makeConstraints { (make) in
//            make.bottom.equalTo(-30)
//            make.centerX.equalToSuperview().offset(-45)
//            make.height.width.equalTo(14)
//        }
        addSubview(customerLabelTwo)
        customerLabelTwo.snp.makeConstraints { (make) in
            make.bottom.equalTo(-30)
            make.centerX.equalToSuperview().offset(10)
        }
        addSubview(customerImage)
        customerImage.snp.makeConstraints { (make) in
            make.bottom.equalTo(-33)
            make.right.equalTo(customerLabelTwo.snp.left).offset(-10)
            make.height.width.equalTo(24)
        }
        addSubview(customerLabel)
        customerLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(customerLabelTwo.snp.top).offset(-7)
            make.centerX.equalToSuperview().offset(10)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(customerLabel.snp.top).offset(-16)
            make.centerX.equalToSuperview()
        }
        addSubview(leftLine)
        leftLine.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalTo(titleLabel.snp.left).offset(-15)
            make.height.equalTo(0.5)
            make.width.equalTo(76)
        }
        addSubview(rightLine)
        rightLine.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.left.equalTo(titleLabel.snp.right).offset(15)
            make.height.equalTo(0.5)
            make.width.equalTo(76)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
