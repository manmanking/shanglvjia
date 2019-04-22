//
//  TBINumberRecordView.swift
//  shop
//
//  Created by manman on 2017/7/6.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class TBINumberRecordView: UIView {

    typealias TBINumberRecordViewResultBlock = (NSInteger)->Void
    public var numberRecordViewResultBlock:TBINumberRecordViewResultBlock!
    public var minNum:NSInteger = 0
    public var maxNum:NSInteger = 0
    public var currentNum:NSInteger = 0
    
    
    private var baseBackgroundView:UIView = UIView()
    private var subBaseBackgroundView:UIView = UIView()
    private var resultNumber:NSInteger = 0
    private let subtractBtn = UIButton(title: "-", titleColor: TBIThemePlaceholderTextColor, titleSize: 16)
    private let numberText: UILabel = UILabel(text: "0", color: TBIThemePrimaryTextColor, size: 14)
    private let addBtn = UIButton(title: "+", titleColor: TBIThemePlaceholderTextColor, titleSize: 16)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(baseBackgroundView)
        baseBackgroundView.backgroundColor = UIColor.white
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        baseBackgroundView.addSubview(subBaseBackgroundView)
        subBaseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        setUIViewAutolayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUIViewAutolayout() {
    
        addBtn.layer.cornerRadius = 2
        addBtn.layer.borderWidth = 0.5
        addBtn.layer.borderColor = TBIThemePlaceholderTextColor.cgColor
        addBtn.addTarget(self, action: #selector(addButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        baseBackgroundView.addSubview(addBtn)
        addBtn.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(baseBackgroundView.snp.height)
        }
        subtractBtn.layer.borderWidth = 0.5
        subtractBtn.layer.cornerRadius = 2
        subtractBtn.layer.borderColor = TBIThemePlaceholderTextColor.cgColor
        subtractBtn.addTarget(self, action: #selector(subtractButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        baseBackgroundView.addSubview(subtractBtn)
        subtractBtn.snp.makeConstraints { (make) in
           make.top.left.bottom.equalToSuperview()
            make.width.equalTo(baseBackgroundView.snp.height)
        }
        numberText.layer.borderWidth = 0.5
        numberText.layer.borderColor = TBIThemePlaceholderTextColor.cgColor
        numberText.textAlignment = .center
        numberText.text = currentNum.description
        numberText.backgroundColor = TBIThemeWhite
        baseBackgroundView.addSubview(numberText)
        numberText.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.left.equalTo(subtractBtn.snp.right).offset(-1)
            make.right.equalTo(addBtn.snp.left).offset(1)
        }
        if minNum >= maxNum {
            maxNum = NSInteger.init(0)
            minNum = maxNum
        }
        resultNumber = minNum
        
    }
    
    func reloadDataSource(min:NSInteger,current:NSInteger?,max:NSInteger?) {
        
        if min != nil {
            self.minNum = min
        }else
        {
            self.minNum = 0
        }
        if current != nil {
            self.currentNum = current!
        }else
        {
            self.currentNum = 0
        }
        
    }
    
    
    
    func addButtonAction(sender:UIButton) {
        resultNumber += 1
        adjustRecord()
    }
    
    
    func subtractButtonAction(sender:UIButton) {
        
        resultNumber -= 1
        guard resultNumber >= minNum  else {
            resultNumber += 1
            return
        }
        adjustRecord()
    }
    func verifyMINORMAX() {
        if minNum >= maxNum {
            
        }
    }
    
    
    func adjustRecord() {
        numberText.text = resultNumber.description
        numberRecordViewResultBlock(resultNumber)
    }
    
   
}
