//
//  TravelListTableViewCell.swift
//  shop
//
//  Created by TBI on 2017/6/26.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class TravelListTableViewCell: UITableViewCell {
    
    let imgUrlView:UIImageView = UIImageView()
    
    //title
    let title: UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    //热度图标
    let hotImg:UIImageView = UIImageView(imageName:"ic_hot")
    
    //热度
    let hotText: UILabel = UILabel(text: "", color: TBIThemeOrangeColor, size: 11)
    
    //售价
    let salePriceText: UILabel = UILabel(text: "", color: TBIThemeOrangeColor, size: 20)
    
    let priceTitle: UILabel = UILabel(text: "原价", color: TBIThemeMinorTextColor, size: 11)
    
    let priceText: UILabel = UILabel(text: "", color: TBIThemeMinorTextColor, size: 11)
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillCell(model:TravelListItem?){
        if model?.productFlag == .tbi {
            hotImg.isHidden = false
            hotText.isHidden = false
            priceTitle.isHidden = false
            priceText.isHidden = false
        }else if model?.productFlag == .cits {
            hotImg.isHidden = true
            hotText.isHidden = true
            priceTitle.isHidden = true
            priceText.isHidden = true
        }
        title.text = model?.productName
        imgUrlView.sd_setImage(with: URL.init(string: model?.imgUrl ?? ""), placeholderImage: UIImage(named: "bg_default_travel"))
        //imgUrlView.sd_setImage(with: URL.init(string: model?.imgUrl ?? ""))
        hotText.text = model?.hot
        
        let salePrice = NSMutableAttributedString(string:"¥\(String(format: "%.0f", model?.salePrice ?? 0))起")
        salePrice.addAttributes([NSForegroundColorAttributeName :TBIThemeOrangeColor, NSFontAttributeName : UIFont.systemFont( ofSize: 13.0)],range: NSMakeRange(0,1))
        salePrice.addAttributes([NSForegroundColorAttributeName :TBIThemeOrangeColor, NSFontAttributeName : UIFont.systemFont( ofSize: 20.0)],range: NSMakeRange(1,salePrice.length - 1))
        salePrice.addAttributes([NSForegroundColorAttributeName :TBIThemeMinorTextColor, NSFontAttributeName : UIFont.systemFont( ofSize: 11.0)],range: NSMakeRange(salePrice.length - 1, 1))
        salePriceText.attributedText = salePrice
        
        //        let attr = NSMutableAttributedString(string: "¥4500")
        //        attr.addAttributes([NSForegroundColorAttributeName :TBIThemeMinorTextColor, NSFontAttributeName : UIFont.systemFont(ofSize: 11.0)],range: NSMakeRange(0,2))
        //        attr.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(value: 1), range: NSMakeRange(1 , attr.length - 2 ))
        
        let attr =  NSAttributedString(string: "¥\(String(describing: model?.price ?? 0))",attributes: [NSStrikethroughStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue])
        priceText.attributedText = attr
    }
    
    func initView(){
        title.numberOfLines = 2
        title.lineBreakMode = .byTruncatingTail
        
        addSubview(imgUrlView)
        imgUrlView.snp.makeConstraints({ (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.width.height.equalTo(72)
        })
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(imgUrlView.snp.right).offset(10)
            make.top.equalTo(10)
            make.right.equalTo(-15)
        }
        addSubview(hotImg)
        hotImg.snp.makeConstraints { (make) in
            make.left.equalTo(imgUrlView.snp.right).offset(10)
            make.top.equalTo(title.snp.bottom).offset(4)
        }
        addSubview(hotText)
        hotText.snp.makeConstraints { (make) in
            make.left.equalTo(hotImg.snp.right).offset(2)
            make.top.equalTo(title.snp.bottom).offset(4)
        }
        addSubview(priceText)
        priceText.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10)
            make.right.equalTo(-15)
        }
        addSubview(priceTitle)
        priceTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(priceText.snp.centerY)
            make.right.equalTo(priceText.snp.left)
        }
        addSubview(salePriceText)
        salePriceText.snp.makeConstraints { (make) in
            //make.bottom.equalTo(-15)
            make.bottom.equalTo(priceText.snp.top).offset(-5)
            make.right.equalTo(-15)
        }
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
    }

}


class SpecialListTableViewCell: UITableViewCell {
    
    let imgUrlView:UIImageView = UIImageView()
    
    //title
    let title: UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    //热度图标
    let hotImg:UIImageView = UIImageView(imageName:"ic_hot")
    
    //热度
    let hotText: UILabel = UILabel(text: "", color: TBIThemeOrangeColor, size: 11)
    
    //售价
    let salePriceText: UILabel = UILabel(text: "", color: TBIThemeOrangeColor, size: 20)
    
    let priceTitle: UILabel = UILabel(text: "原价", color: TBIThemeMinorTextColor, size: 11)
    
    let priceText: UILabel = UILabel(text: "", color: TBIThemeMinorTextColor, size: 11)
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillCell(model:TravelListItem?){
        title.text = model?.productName
        imgUrlView.sd_setImage(with: URL.init(string: model?.imgUrl ?? ""), placeholderImage: UIImage(named: "bg_default_travel"))
        imgUrlView.sd_setImage(with: URL.init(string: model?.imgUrl ?? ""))
        hotText.text = model?.hot
        
        let salePrice = NSMutableAttributedString(string:"¥\(String(format: "%.0f", model?.salePrice ?? 0))起")
        salePrice.addAttributes([NSForegroundColorAttributeName :TBIThemeOrangeColor, NSFontAttributeName : UIFont.systemFont( ofSize: 13.0) ],range: NSMakeRange(0,1))
        salePrice.addAttributes([NSForegroundColorAttributeName :TBIThemeOrangeColor, NSFontAttributeName : UIFont.systemFont( ofSize: 20.0) ],range: NSMakeRange(1,salePrice.length - 1))
        salePrice.addAttributes([NSForegroundColorAttributeName :TBIThemeMinorTextColor, NSFontAttributeName : UIFont.systemFont( ofSize: 11.0) ],range: NSMakeRange(salePrice.length - 1, 1))
        salePriceText.attributedText = salePrice
        
//                let attr = NSMutableAttributedString(string: "¥4500")
//                attr.addAttributes([NSForegroundColorAttributeName :TBIThemeMinorTextColor, NSFontAttributeName : UIFont.systemFont(ofSize: 11.0)],range: NSMakeRange(0,2))
//                attr.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(value: 1), range: NSMakeRange(1 , attr.length - 2 ))
        
        
        let price:String = (model?.price?.OneOfTheEffectiveFraction())!
        let attr =  NSAttributedString(string: ("¥" + price ),attributes: [NSStrikethroughStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue])
        priceText.attributedText = attr
    }
    
    func initView(){
        title.numberOfLines = 2
        title.lineBreakMode = .byTruncatingTail
        
        addSubview(imgUrlView)
        imgUrlView.snp.makeConstraints({ (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.width.height.equalTo(72)
        })
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(imgUrlView.snp.right).offset(10)
            make.top.equalTo(10)
            make.right.equalTo(-15)
        }
        addSubview(hotImg)
        hotImg.snp.makeConstraints { (make) in
            make.left.equalTo(imgUrlView.snp.right).offset(10)
            make.top.equalTo(title.snp.bottom).offset(4)
        }
        addSubview(hotText)
        hotText.snp.makeConstraints { (make) in
            make.left.equalTo(hotImg.snp.right).offset(2)
            make.top.equalTo(title.snp.bottom).offset(4)
        }
        addSubview(priceText)
        priceText.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10)
            make.right.equalTo(-15)
        }
        addSubview(priceTitle)
        priceTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(priceText.snp.centerY)
            make.right.equalTo(priceText.snp.left)
        }
        addSubview(salePriceText)
        salePriceText.snp.makeConstraints { (make) in
            make.bottom.equalTo(priceText.snp.top).offset(3)
            make.right.equalTo(-15)
        }
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
    }
    
}
