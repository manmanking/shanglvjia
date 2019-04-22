//
//  CoJumpCommonFooterView.swift
//  shop
//
//  Created by TBI on 2018/1/26.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class CoJumpCommonFooterView: UIView {

    var  coBusinessTypeListener:CoBusinessTypeListener!
    
    let  oneView = CoJumpCommonFooterClickView()
    
    let  twoView = CoJumpCommonFooterClickView()
    
    let  threeView = CoJumpCommonFooterClickView()
    
    var  dataList:[(title:String,image:String,type:CoCompanyBusinessType,isClick:Bool)] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = TBIThemeWhite
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView () {
        
        addSubview(oneView)
        oneView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.bottom.equalToSuperview()
            make.width.equalTo((ScreenWindowWidth-40)/3)
        }
        addSubview(twoView)
        twoView.snp.makeConstraints { (make) in
            make.left.equalTo(oneView.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo((ScreenWindowWidth-40)/3)
        }
        addSubview(threeView)
        threeView.snp.makeConstraints { (make) in
            make.left.equalTo(twoView.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo((ScreenWindowWidth-40)/3)
        }
        oneView.addOnClickListener(target: self, action: #selector(oneClick(tap:)))
        twoView.addOnClickListener(target: self, action: #selector(twoClick(tap:)))
        threeView.addOnClickListener(target: self, action: #selector(threeClick(tap:)))
    }
    func oneClick (tap:UITapGestureRecognizer) {
        if dataList[0].isClick {
            coBusinessTypeListener.onClickListener(type: dataList[0].type)
        }
    }
    
    func twoClick (tap:UITapGestureRecognizer) {
         if dataList[1].isClick {
            coBusinessTypeListener.onClickListener(type: dataList[1].type)
        }
    }
    
    func threeClick (tap:UITapGestureRecognizer) {
         if dataList[2].isClick {
            coBusinessTypeListener.onClickListener(type: dataList[2].type)
        }
    }
    
    func fullCell (data:[(title:String,image:String,type:CoCompanyBusinessType,isClick:Bool)]) {
        self.dataList = data
        oneView.fullCell(data: data[0])
        twoView.fullCell(data: data[1])
        threeView.fullCell(data: data[2])
    }
    
    class CoJumpCommonFooterClickView: UIView {
        
        let  imageView = UIImageView()
        
        let  textLabel = UILabel(text:"", color: TBIThemeDarkBlueColor, size: 12)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            initView()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func fullCell (data:(title:String,image:String,type:CoCompanyBusinessType,isClick:Bool)) {
            textLabel.text = data.title
            imageView.image = UIImage(named: data.image)
            if data.isClick == true {
               textLabel.textColor = TBIThemeDarkBlueColor
            }else {
               textLabel.textColor = TBIThemePlaceholderColor
            }
        }
        
        func initView () {
            addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(10)
                make.width.height.equalTo(40)
            }
            addSubview(textLabel)
            textLabel.snp.makeConstraints { (make) in
                make.top.equalTo(imageView.snp.bottom)
                make.centerX.equalToSuperview()
            }
        }
    }

}
