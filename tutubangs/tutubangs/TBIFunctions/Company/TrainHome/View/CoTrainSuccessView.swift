//
//  CoTrainSuccessView.swift
//  shop
//
//  Created by TBI on 2018/1/5.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftDate

class CoTrainSuccessView: UIView {
    
    typealias TrainSuccessBlock = ()->Void
    
    public var trainSuccessBlock:TrainSuccessBlock!
    
    fileprivate var baseBackgroundView:UIView = UIView()
    
    fileprivate var bgView:UIView = UIView()
    
    fileprivate  let successImg:UIImageView = UIImageView(imageName:"ic_success")
    
    fileprivate  let oneLabel = UILabel(text: "占座成功", color: TBIThemePrimaryTextColor, size: 15)
    
    fileprivate  let twoLabel = UILabel(text: "座位将保留至15:23", color: TBIThemeOrangeColor, size: 15)
    
    fileprivate  let threeLabel = UILabel(text: "如有问题请您第一时间联系客服组,谢谢!", color: TBIThemeMinorTextColor, size: 12)
    
    fileprivate  let fourLabel = UILabel(text: "请您注意接听022-8126开头的电话,谢谢!", color: TBIThemeMinorTextColor, size: 12)
    
    fileprivate  let line = UILabel(color: TBIThemeGrayLineColor)
    
    let okButton = UIButton(title: "确定",titleColor: TBIThemeBlueColor,titleSize: 18)
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    func initView () {
        let time = DateInRegion() + 30.minutes
        twoLabel.text =  "请您在" + time.string(custom: "HH:mm") + "前完成本单的审批,超时占座将自动取消"
        baseBackgroundView.backgroundColor = TBIThemeBackgroundViewColor
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        bgView.backgroundColor = TBIThemeWhite
        bgView.layer.cornerRadius = 5
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.height.equalTo(316)
            make.width.equalTo(270)
            make.center.equalToSuperview()
        }
        bgView.addSubview(successImg)
        successImg.snp.makeConstraints { (make) in
            make.top.equalTo(50)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(60)
        }
//        bgView.addSubview(oneLabel)
//        oneLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(successImg.snp.bottom).offset(50)
//            make.centerX.equalToSuperview()
//        }
        twoLabel.numberOfLines = 0
        bgView.addSubview(twoLabel)
        twoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(successImg.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
        bgView.addSubview(threeLabel)
        threeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(twoLabel.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
        }
        bgView.addSubview(fourLabel)
        fourLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(threeLabel.snp.bottom)
        }
        fourLabel.isHidden = true
        bgView.addSubview(okButton)
        okButton.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(50)
        }
        bgView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(okButton.snp.top)
            make.height.equalTo(0.5)
        }
        baseBackgroundView.addOnClickListener(target: self, action: #selector(cancelButtonAction))
        okButton.addTarget(self, action: #selector(okayButtonAction(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    func  ininMsg (text:String) {
        oneLabel.text = text
    }
    @objc fileprivate func okayButtonAction(sender:UIButton) {
        self.removeFromSuperview()
        trainSuccessBlock()
    }
    
    @objc fileprivate func cancelButtonAction() {
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
