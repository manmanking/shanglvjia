//
//  TBIAlertView.swift
//  shop
//
//  Created by manman on 2017/5/26.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class TBIAlertView: UIView {
    
    private var alertDataSource:[[(title:String,content:String)]] = Array()
    private var baseBackgroundView:UIView = UIView()
    private var subBackgroundView:UIView = UIView()
    private var titleContentLabel:UILabel = UILabel()
    private var titleDescriptionLabel:UILabel = UILabel()
    private var descriptionContentLabel:UILabel = UILabel()
    private var cancelButton:UIButton = UIButton()
    private let LeftMarginBaseView = 35
    private let LeftMarginSubBaseView = 15
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //背景 可修改背景透明度
        baseBackgroundView.backgroundColor = TBIThemeBackgroundViewColor
        baseBackgroundView.addOnClickListener(target: self, action: #selector(cancelButtonAction))
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        //内容背景
        subBackgroundView.backgroundColor = UIColor.white
        subBackgroundView.layer.cornerRadius = 7
        subBackgroundView.clipsToBounds = true
        self.addSubview(subBackgroundView)
        subBackgroundView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(35)
            make.centerY.equalToSuperview()
        }
       
        setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUIViewAutolayout() {
        // 关闭按钮  位置 右上角
        cancelButton.setImage(UIImage.init(named:"close"), for: UIControlState.normal)
        cancelButton.addTarget(self, action: #selector( cancelButtonAction), for: UIControlEvents.touchUpInside)
        subBackgroundView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(14)
            make.right.equalToSuperview().inset(LeftMarginSubBaseView)
            make.width.height.equalTo(16)
        }
    }
    func setDataSources(dataSource:[[(title:String,content:String)]]) {
            //alertDataSource = dataSource
            fillDataSource(dataSources:dataSource)
    }
    var offsetY = 0
    private func fillDataSource(dataSources:[[(title:String,content:String)]]) {
        
        
        titleContentLabel.text = dataSources[0][0].title
        titleContentLabel.textColor = TBIThemePrimaryTextColor
        titleContentLabel.textAlignment = NSTextAlignment.center
        titleContentLabel.layer.borderWidth = 0.5
        titleContentLabel.layer.borderColor = TBIThemeGrayLineColor.cgColor
        titleContentLabel.font = UIFont.systemFont( ofSize: 16)
        subBackgroundView.addSubview(titleContentLabel)
        titleContentLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        for index in 1..<dataSources.count
        {
            
            let titleLabel:UILabel = UILabel.init(text: dataSources[index][0].title, color: TBIThemePrimaryTextColor, size: 14)
            subBackgroundView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints({ (make) in
                make.left.right.equalToSuperview().inset(LeftMarginSubBaseView)
                make.top.equalToSuperview().offset(44 + 10  + offsetY + (index - 1) * 20)
                make.height.equalTo(14)
            })
            let contentLabel = UILabel.init(text: dataSources[index][0].content, color: TBIThemePrimaryTextColor, size: 13)
            contentLabel.numberOfLines = 0
            subBackgroundView.addSubview(contentLabel)
            contentLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
                make.left.right.equalToSuperview().inset(LeftMarginSubBaseView)
            })
            
            if index == dataSources.count - 1 {
                contentLabel.snp.remakeConstraints({ (make) in
                    make.top.equalTo(titleLabel.snp.bottom).offset(10)
                    make.left.right.equalToSuperview().inset(LeftMarginSubBaseView)
                    make.bottom.equalToSuperview().inset(15)
                })
            }
            layoutIfNeeded()
            offsetY = Int(titleLabel.frame.height + contentLabel.frame.height)
        }
    }
    
    
    
    func cancelButtonAction() {
        self.removeFromSuperview()
    }
    
    
    
    

}
