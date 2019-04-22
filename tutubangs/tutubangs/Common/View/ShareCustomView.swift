//
//  ShareCustomView.swift
//  shop
//
//  Created by manman on 2017/7/17.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class ShareCustomView: UIView {
    typealias ShareCustomViewTypeBlock = (String)->Void
    
    
    public var shareCustomViewTypeBlock:ShareCustomViewTypeBlock!
    private let baseBackgroundView:UIView = UIView()
    private let subBaseBackgroundView:UIView = UIView()
    
    private let titleForViewLabel:UILabel = UILabel()
    
    private let cancelButton:UIButton = UIButton()
    private let bottomMargin:NSInteger = 11
    
    private let wechatButton:UIButton = UIButton()
    private let wechatTitle:UILabel = UILabel()
    
    private let wechatTimeButton:UIButton = UIButton()
    private let wechatTimeTitle:UILabel = UILabel()
    
    private let qqButton:UIButton = UIButton()
    private let qqTitle:UILabel = UILabel()
    
    
    
    override init(frame:CGRect)
    {
        super.init(frame:frame)
        baseBackgroundView.addOnClickListener(target: self, action: #selector(cancel))
        baseBackgroundView.backgroundColor = UIColor.black
        baseBackgroundView.alpha = 0.4
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        subBaseBackgroundView.backgroundColor = UIColor.white
        self.addSubview(subBaseBackgroundView)
        subBaseBackgroundView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(175)
        }
       
        setShareViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setShareViewAutolayout() {
       
        titleForViewLabel.text = "分享到"
        titleForViewLabel.textAlignment = NSTextAlignment.center
        titleForViewLabel.font = UIFont.systemFont( ofSize: 14)
        titleForViewLabel.textColor = TBIThemePrimaryTextColor
        subBaseBackgroundView.addSubview(titleForViewLabel)
        titleForViewLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(15)
        }
        wechatButton.setImage(UIImage.init(named: "ic_weixin_round"), for: UIControlState.normal)
        wechatButton.addTarget(self, action: #selector(wechatButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        subBaseBackgroundView.addSubview(wechatButton)
        wechatButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(50)
            make.left.equalToSuperview().inset((ScreenWindowWidth - 44 * 3 ) / 4)
            make.width.height.equalTo(44)
        }
        wechatTitle.adjustsFontSizeToFitWidth = true
        wechatTitle.text = "微信"
        wechatTitle.textAlignment = NSTextAlignment.center
        wechatTitle.font = UIFont.systemFont( ofSize: 11)
        wechatTitle.textColor = TBIThemePrimaryTextColor
        subBaseBackgroundView.addSubview(wechatTitle)
        wechatTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(wechatButton)
            make.top.equalTo(wechatButton.snp.bottom).offset(bottomMargin)
            make.height.equalTo(15)
        }
        
        
        wechatTimeButton.setImage(UIImage.init(named: "ic_circle_of_friends"), for: UIControlState.normal)
        wechatTimeButton.addTarget(self, action: #selector(wechatTimeButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        subBaseBackgroundView.addSubview(wechatTimeButton)
        wechatTimeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(50)
            make.left.equalTo(wechatButton.snp.right).offset((ScreenWindowWidth - 44 * 3 ) / 4)
            make.width.height.equalTo(44)
        }
        wechatTimeTitle.adjustsFontSizeToFitWidth = true
        wechatTimeTitle.text = "朋友圈"
        wechatTimeTitle.font = UIFont.systemFont( ofSize: 11)
        wechatTimeTitle.textColor = TBIThemePrimaryTextColor
        subBaseBackgroundView.addSubview(wechatTimeTitle)
        wechatTimeTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(wechatTimeButton)
            make.top.equalTo(wechatTimeButton.snp.bottom).offset(bottomMargin)
            make.height.equalTo(15)
        }
        
        qqButton.setImage(UIImage.init(named: "ic_qq_round"), for: UIControlState.normal)
        qqButton.addTarget(self, action: #selector(qqButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        subBaseBackgroundView.addSubview(qqButton)
        qqButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(50)
            make.left.equalTo(wechatTimeButton.snp.right).offset((ScreenWindowWidth - 44 * 3 ) / 4)
            make.width.height.equalTo(44)
        }
        qqTitle.adjustsFontSizeToFitWidth = true
        qqTitle.text = "QQ"
        qqTitle.font = UIFont.systemFont( ofSize: 11)
        qqTitle.textColor = TBIThemePrimaryTextColor
        subBaseBackgroundView.addSubview(qqTitle)
        qqTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(qqButton)
            make.top.equalTo(qqButton.snp.bottom).offset(bottomMargin)
            make.height.equalTo(15)
        }
        
        cancelButton.setTitle("取消", for: UIControlState.normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelButton.setTitleColor(TBIThemePrimaryTextColor, for: UIControlState.normal)
        cancelButton.layer.borderWidth = 0.5
        cancelButton.layer.borderColor = TBIThemeGrayLineColor.cgColor
        cancelButton.addTarget(self, action: #selector(cancelButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        subBaseBackgroundView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().offset(-1)
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        
        
        
        
    }
    
    
    
    func wechatButtonAction(sender:UIButton) {
        
        
        shareCustomViewTypeBlock("1")
        cancel()
    }
    
    
    func wechatTimeButtonAction(sender:UIButton) {
        shareCustomViewTypeBlock("2")
        cancel()
    }
    
    
    func qqButtonAction(sender:UIButton) {
        shareCustomViewTypeBlock("3")
        cancel()
    }
    
    
    func cancelButtonAction(sender:UIButton) {
        shareCustomViewTypeBlock("")
        cancel()
    }
    
    
    func cancel()  {
        self.removeFromSuperview()
    }
    

}
