//
//  SuccessOrderView.swift
//  shop
//
//  Created by TBI on 2017/7/10.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class SuccessOrderView: UIView {
    
    
    typealias ReturnHomeBlock = ()->Void
    
    public  var returnHomeBlock:ReturnHomeBlock!
    
    fileprivate let bgView:UIView = UIView()
    
    fileprivate var img =  UIImageView(imageName:"ic_ rocket")
    
    fileprivate var title:UILabel = UILabel(text: "您的预订已提交成功", color: TBIThemeOrangeColor, size: 18)
    
    fileprivate var message:UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    private let returnHomeButton:UIButton  = UIButton(title: "返回首页",titleColor: TBIThemeWhite,titleSize: 16)

    init(titleText: String,messageText: String) {
        let frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight)
        super.init(frame: frame)
        title.text = titleText
        message.text = messageText//"马上为您确定余票情况,请您保持手机\(text)畅通,谢谢!"
        message.numberOfLines = 2
        message.lineBreakMode = .byTruncatingTail
        self.backgroundColor = TBIThemeBackgroundViewColor
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius  = 7
        bgView.backgroundColor = TBIThemeWhite
        returnHomeButton.backgroundColor = TBIThemeBlueColor
        returnHomeButton.layer.cornerRadius = 2
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.width.equalTo(250)
            make.center.equalToSuperview()
        }
        bgView.addSubview(img)
        img.snp.makeConstraints { (make) in
            make.width.height.equalTo(140)
            make.top.equalTo(36)
            make.centerX.equalToSuperview()
        }
        bgView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(img.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
        }
        bgView.addSubview(message)
        message.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(title.snp.bottom).offset(13)
        }
        bgView.addSubview(returnHomeButton)
        returnHomeButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(44)
            make.top.equalTo(message.snp.bottom).offset(13)
            make.bottom.equalTo(-15)
        }
        returnHomeButton.addTarget(self, action: #selector(returnHomeClick(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    
    func returnHomeClick(sender:UIButton) {
        self.removeFromSuperview()
        returnHomeBlock()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
