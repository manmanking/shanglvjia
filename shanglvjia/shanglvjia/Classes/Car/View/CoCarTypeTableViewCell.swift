//
//  CoCarTypeTableViewCell.swift
//  shop
//
//  Created by TBI on 2018/1/22.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class CoCarTypeScrollTableViewCell: UITableViewCell {
    
        var coCarTypeListener:CoCarTypeListener!
    
        let scrollView :UIScrollView = UIScrollView()
        
        var listView:[CoCarTypeCellView] = []
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            initView()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func initView () {
            self.contentView.addSubview(scrollView)
            scrollView.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(95)
                make.top.bottom.equalToSuperview().inset(15)
            }
        }
        
        func fullCell (data:[(carType:String,carImage:String)],selectdIndex:Int) {
            
            //是否显示水平滚动条
            scrollView.showsHorizontalScrollIndicator = false
            listView.removeAll()
            scrollView.subviews.forEach{$0.removeFromSuperview()}
            
            for index in 0..<data.count {
                let view = CoCarTypeCellView()
                view.initView(data: data[index])
                if index == selectdIndex {
                   view.selectd()
                }
                scrollView.addSubview(view)
                view.tag = index
                listView.append(view)
                view.addOnClickListener(target: self, action: #selector(click(tap:)))
            }
            
            for index in 0..<listView.count {
                
                listView[index].snp.makeConstraints({ (make) in
                    make.bottom.top.equalToSuperview()
                    make.height.equalTo(95)
                    make.width.equalTo((ScreenWindowWidth - 55)/2)
                    if index > 0 {
                        make.left.equalTo(listView[index - 1].snp.right).offset(15)
                    }else {
                        make.left.equalTo(20)
                    }
                    if index == listView.count - 1 {
                        make.right.equalTo(-20)
                    }
                })
            }
        }
        
        func click(tap:UITapGestureRecognizer){
            let vi = tap.view as? CoCarTypeCellView
            for index in 0..<listView.count {
                if vi?.tag == index{
                    listView[index].selectd()
                }else {
                    listView[index].normal()
                }
            }
            coCarTypeListener.onClickListener(row: vi?.tag ?? 0)
        }
        
    }
    
    class CoCarTypeCellView: UIView {
        
        let title:UILabel = UILabel(text: "五人座公务用车", color: TBIThemePrimaryTextColor, size: 11)
        
        let carTypeImage = UIImageView.init(imageName: "ic_car_crown")
        
        let selectImage = UIImageView.init(imageName: "ic_car_sel")
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            //initView()
        }
        
        func initView (data:(carType:String,carImage:String)) {
            self.layer.cornerRadius = 6
            self.backgroundColor = TBIThemeNormalBaseColor
            self.addSubview(selectImage)
            selectImage.isHidden = true
            selectImage.snp.makeConstraints { (make) in
                make.top.right.equalToSuperview()
            }
            carTypeImage.image = UIImage(named: data.carImage)
            self.addSubview(carTypeImage)
            carTypeImage.snp.makeConstraints { (make) in
                make.top.equalTo(15)
                make.height.equalTo(40)
                make.width.equalTo(100)
                make.centerX.equalToSuperview()
            }
            title.text = data.carType
            self.addSubview(title)
            title.snp.makeConstraints { (make) in
                make.top.equalTo(carTypeImage.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
            }
           
        }
        
        func selectd () {
            self.backgroundColor = TBIThemeSelectBaseColor
            selectImage.isHidden = false
        }
        
        func normal () {
            self.backgroundColor = TBIThemeNormalBaseColor
            selectImage.isHidden = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
}

class CoCarTypeDetailTableViewCell: UITableViewCell {
    
    
    let titleLabel:UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 12)
    
    let typeImage = UIImageView(imageName: "")
    
    let numberLabel:UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 11)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView (){
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalToSuperview()
        }
        self.contentView.addSubview(typeImage)
        typeImage.snp.makeConstraints { (make) in
            make.right.equalTo(-45)
            make.bottom.equalToSuperview()
            make.height.width.equalTo(20)
        }
        self.contentView.addSubview(numberLabel)
        numberLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(typeImage.snp.centerY)
        }
    }
    
    func fullCell(data:(title:String,image:String,number:String)) {
        titleLabel.text = data.title
        numberLabel.text = data.number
        typeImage.image = UIImage(named: data.image)
    }
    
}


class CoCarTypeDetailMessageTableViewCell: UITableViewCell {
    
    
    let  imgView = UIImageView(imageName: "ic_hotel_remark")
    
    let  messageLabel = UILabel(text: "车辆空间说明均指正常情况,请乘客根据实际情况选择适合的车辆。", color: TBIThemePrimaryTextColor, size: 10)
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView (){
        
        self.contentView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-15)
            make.width.height.equalTo(14)
        }
        
        self.contentView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(imgView.snp.centerY)
            make.left.equalTo(imgView.snp.right).offset(8)
        }
    }
    
    
}

class CoCarTableViewFooterView: UITableViewHeaderFooterView {
    
    let submitButton:UIButton = UIButton(title: "预订",titleColor: TBIThemeWhite,titleSize: 20)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initView()
        self.contentView.backgroundColor = TBIThemeBaseColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView () {
        submitButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        submitButton.clipsToBounds = true
        submitButton.layer.cornerRadius  = 5
        self.contentView.addSubview(submitButton)
        submitButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.top.equalTo(30)
        }
    }
    
    
}

