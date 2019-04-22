//
//  TravelHomeCollectionViewCell.swift
//  shop
//
//  Created by TBI on 2017/7/11.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class TravelHomeCollectionReusableView: UICollectionReusableView {
    
    fileprivate let  titleImgView = UIImageView(imageName: "")
    
    fileprivate let  rightImgView = UIImageView(imageName: "ic_right_blue")
    
    fileprivate let  line = UILabel(color: TBIThemeBaseColor)
    
    let  moreLabel = UILabel(text: "更多", color: TBIThemeBlueColor, size: 13)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(10)
        }
        addSubview(titleImgView)
        titleImgView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview().offset(5)
            make.height.equalTo(20)
            make.width.equalTo(96)
        }
        addSubview(moreLabel)
        moreLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(5)
            make.right.equalTo(-26)
        }
        addSubview(rightImgView)
        rightImgView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview().offset(5)
            make.width.equalTo(6)
            make.height.equalTo(8)
        }
        
    }
    
    func fillCell(model:TravelAdvResponse?) {
        titleImgView.sd_setImage(with:  URL.init(string: model?.imgUrl ?? ""))
        if model?.more == nil || model?.more == ""{
            moreLabel.isHidden = true
        }else {
            moreLabel.isHidden = false
        }
        
        let tintImage =  UIImage.init(named: "ic_right_blue")
        let color =  (model?.color ?? "#FFFFFF").isEmpty ? "#FFFFFF":model?.color
        let newImage = tintImage?.imageWithTintColor(color: UIColor.init(hexString: color ?? "#FFFFFF")!)
        rightImgView.image = newImage
        moreLabel.textColor = UIColor.init(hexString: color ?? "#FFFFFF")
        moreLabel.tag = Int(model?.more ?? "6") ?? 6
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TravelHomeCollectionViewCell: UICollectionViewCell {
    
    let  imgView = UIImageView(imageName: "")
    
    let  titleLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    let  message:UILabel = UILabel(text: "", color: TBIThemeMinorTextColor, size: 12)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(130)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imgView.snp.bottom).offset(7)
            make.left.equalToSuperview()
        }
        addSubview(message)
        message.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalTo(2)
        }
    }
    
    
    func fillCell(model:TravelAdvResponse?) {
        imgView.sd_setImage(with:  URL.init(string: model?.imgUrl ?? ""))
        titleLabel.text = model?.title
        message.text = model?.subtitle
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
