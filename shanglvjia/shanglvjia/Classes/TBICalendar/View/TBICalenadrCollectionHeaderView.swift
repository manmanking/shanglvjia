//
//  TBICalenadrCollectionHeaderView.swift
//  shop
//
//  Created by manman on 2017/7/12.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class TBICalenadrCollectionHeaderView: UICollectionReusableView {
   
    
    var monthLable:UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
//    var sunday:UILabel = UILabel(text: "日", color: TBIThemeBlueColor, size: 16)
//    
//    var monday:UILabel = UILabel(text: "一", color: TBIThemePrimaryTextColor, size: 16)
//    
//    var tuesday:UILabel = UILabel(text: "二", color: TBIThemePrimaryTextColor, size: 16)
//    
//    var wednesday:UILabel = UILabel(text: "三", color: TBIThemePrimaryTextColor, size: 16)
//    
//    var thursday:UILabel = UILabel(text: "四", color: TBIThemePrimaryTextColor, size: 16)
//    
//    var friday:UILabel = UILabel(text: "五", color: TBIThemePrimaryTextColor, size: 16)
//    
//    var saturday:UILabel = UILabel(text: "六", color: TBIThemeBlueColor, size: 16)
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor = TBIThemeMinorColor
        monthLable.textAlignment = NSTextAlignment.center
//        sunday.textAlignment = .center
//        monday.textAlignment = .center
//        tuesday.textAlignment = .center
//        wednesday.textAlignment = .center
//        thursday.textAlignment = .center
//        friday.textAlignment = .center
//        saturday.textAlignment = .center
        monthLable.backgroundColor = TBIThemeMinorColor
        addSubview(monthLable)
        monthLable.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(-15)
            make.right.equalToSuperview().offset(15)
            
            make.height.equalTo(30)
        }
//        addSubview(line)
//        line.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(-15)
//            make.right.equalToSuperview().offset(15)
//            make.bottom.equalToSuperview().inset(0.5)
//            make.height.equalTo(0.5)
//        }
//        addSubview(sunday)
//        sunday.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().inset(30)
//            make.left.bottom.equalToSuperview()
//            make.width.equalToSuperview().dividedBy(7)
//            
//        }
//        addSubview(monday)
//        monday.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().inset(30)
//            make.bottom.equalToSuperview()
//            make.width.equalToSuperview().dividedBy(7)
//            make.left.equalTo(sunday.snp.right)
//        }
//        addSubview(tuesday)
//        tuesday.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().inset(30)
//            make.bottom.equalToSuperview()
//            make.width.equalToSuperview().dividedBy(7)
//            make.left.equalTo(monday.snp.right)
//        }
//        addSubview(wednesday)
//        wednesday.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().inset(30)
//            make.bottom.equalToSuperview()
//            make.width.equalToSuperview().dividedBy(7)
//            make.left.equalTo(tuesday.snp.right)
//        }
//        addSubview(thursday)
//        thursday.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().inset(30)
//            make.bottom.equalToSuperview()
//            make.width.equalToSuperview().dividedBy(7)
//            make.left.equalTo(wednesday.snp.right)
//            
//        }
//        addSubview(friday)
//        friday.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().inset(30)
//            make.bottom.equalToSuperview()
//            make.width.equalToSuperview().dividedBy(7)
//            make.left.equalTo(thursday.snp.right)
//        }
//        addSubview(saturday)
//        saturday.snp.makeConstraints { (make) in
//           make.top.equalToSuperview().inset(30)
//            make.bottom.equalToSuperview()
//            make.width.equalToSuperview().dividedBy(7)
//            make.left.equalTo(friday.snp.right)
//        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillDataSources(title:String)  {
        monthLable.text = title
    }
    
    
    
    
}
