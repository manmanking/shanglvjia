//
//  CurrentCityTableViewCell.swift
//  shop
//
//  Created by TBI on 2017/4/24.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CurrentCityTableViewCell: UITableViewCell {
    
    var hotCityBlock:HotCityBlock?
    
    let btn = UIButton(frame: CGRect(x: 15, y: 10, width: CGFloat((ScreenWindowWidth - 30 - 15 - 10*3) / 4), height: 30))
    
    // 使用tableView.dequeueReusableCell会自动调用这个方法
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        self.backgroundColor = TBIThemeMinorColor
        btn.setTitle("-", for: .normal)
        btn.setTitleColor(TBIThemePrimaryTextColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.backgroundColor = UIColor.white
//        btn.layer.borderWidth = 0.5
//        btn.layer.borderColor = TBIThemeGrayLineColor.cgColor
        btn .addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        self.addSubview(btn)
        
    }
    func fillCell(cityName:String?){
        btn.setTitle(cityName, for: .normal)
    }
    
    
    @objc private func btnClick(btn: UIButton) {
        if btn.titleLabel?.text != "-"{
            hotCityBlock?(btn.titleLabel?.text ?? "")
        }
        
    }


}
