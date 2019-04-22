//
//  TravelDestinationColllectionViewCell.swift
//  shop
//
//  Created by TBI on 2017/7/11.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class TravelDestinationColllectionReusableView: UICollectionReusableView {
    
    
    fileprivate let line = UILabel(color: TBIThemeBlueColor)
    
    fileprivate let  titleLabel = UILabel(text: "热门", color: TBIThemeMinorTextColor, size: 14)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(2)
            make.height.equalTo(14)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(line.snp.right).offset(5)
        }
    }
    
    func fillCell(title:String){
        titleLabel.text = title
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TravelDestinationHotColllectionViewCell: UICollectionViewCell {
    
    let baseView = UIView()
    
    let  imgView = UIImageView(imageName: "Home_Personal_Hotline_3")
    
    let  bgView = UIView()
    
    let  titleLabel = UILabel(text: "", color: TBIThemeWhite, size: 14)
    
    let  message:UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseView.layer.cornerRadius = 5
        baseView.layer.masksToBounds = true
        addSubview(baseView)
        baseView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        baseView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        bgView.backgroundColor = TBIThemeBackgroundHotColor
        baseView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        message.textAlignment = .center
        message.backgroundColor = TBIThemeBaseColor
        baseView.addSubview(message)
        message.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(30)
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

class TravelDestinationRegionColllectionViewCell: UICollectionViewCell {
    
    let  titleLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.layer.cornerRadius = 5
        titleLabel.layer.masksToBounds = true
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = TBIThemeBaseColor
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    func fillCell(title:String?) {
        titleLabel.text = title
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
