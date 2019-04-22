//
//  TravelCategoryTableViewCell.swift
//  shop
//
//  Created by TBI on 2017/6/30.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class TravelCategoryTableViewCell: UITableViewCell {

    
    let priceTitle: UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let priceText: UILabel = UILabel(text: "", color: TBIThemeOrangeColor, size: 13)
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    
    let subtractBtn = UIButton(title: "-", titleColor: TBIThemePrimaryTextColor, titleSize: 16)
    
    let numberText: UILabel = UILabel(text: "0", color: TBIThemePrimaryTextColor, size: 14)
    
    let addBtn = UIButton(title: "+", titleColor: TBIThemePrimaryTextColor, titleSize: 16)
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    func fillCell(model:[String:Any], stock:Int) {
        priceTitle.text = model["title"] as? String
        let price = Int(model["price"] as? Double ?? 0)
        priceText.text = "¥\(String(describing: price))"
        var number = (model["number"] as? Int) ?? 0
        if stock == 0
        {
            number = 0
        }
        numberText.text = String(describing: number)
        
        if number == 0 {
            subtractBtn.isEnabled = false
            subtractBtn.setTitleColor(TBIThemePlaceholderTextColor, for: .normal)
        }else {
            subtractBtn.isEnabled = true
            subtractBtn.setTitleColor(TBIThemePrimaryTextColor, for: .normal)
        }
        print(stock)
        if number >= stock{
            addBtn.isEnabled = false
            addBtn.setTitleColor(TBIThemePlaceholderTextColor, for: .normal)
        }else {
            addBtn.isEnabled = true
            addBtn.setTitleColor(TBIThemePrimaryTextColor, for: .normal)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initView() {
        subtractBtn.layer.borderWidth = 0.5
        subtractBtn.layer.cornerRadius = 2
        subtractBtn.layer.borderColor = TBIThemePlaceholderTextColor.cgColor
        addBtn.layer.cornerRadius = 2
        addBtn.layer.borderWidth = 0.5
        addBtn.layer.borderColor = TBIThemePlaceholderTextColor.cgColor
        numberText.layer.borderWidth = 0.5
        numberText.layer.borderColor = TBIThemePlaceholderTextColor.cgColor
        numberText.textAlignment = .center
        numberText.backgroundColor = TBIThemeWhite
        addSubview(addBtn)
        addBtn.setEnlargeEdgeWithTop(10 ,left: 10, bottom: 10, right:10)
        subtractBtn.setEnlargeEdgeWithTop(10 ,left: 10, bottom: 10, right:10)
        addBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(21)
            make.height.equalTo(20)
        }
        addSubview(subtractBtn)
        subtractBtn.snp.makeConstraints { (make) in
            make.right.equalTo(addBtn.snp.left).offset(-31)
            make.centerY.equalToSuperview()
            make.width.equalTo(21)
            make.height.equalTo(20)
        }
        addSubview(numberText)
        numberText.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.left.equalTo(subtractBtn.snp.right).offset(-1)
            make.right.equalTo(addBtn.snp.left).offset(1)
        }
        
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        addSubview(priceTitle)
        priceTitle.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
        }
        addSubview(priceText)
        priceText.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(100)
        }
        
    }
}

class TravelMessageTableViewCell: UITableViewCell {
    
    let  img = UIImageView(imageName: "ic_hotel_remark")
    
    let  message = UILabel(text: "您提交订单后,专属服务人员会确认库存和价格,然后与您联系。", color: TBIThemePlaceholderTextColor, size: 11)
    
    let line = UILabel(color: TBIThemeBaseColor)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(10)
        }
        addSubview(img)
        img.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview().offset(5)
            make.height.width.equalTo(10)
        }
        addSubview(message)
        message.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.centerY.equalToSuperview().offset(5)
        }
    }
}
