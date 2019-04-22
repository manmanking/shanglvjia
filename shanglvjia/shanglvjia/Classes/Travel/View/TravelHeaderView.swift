//
//  TravelHeaderView.swift
//  shop
//
//  Created by TBI on 2017/6/30.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class TravelHeaderOneView: UITableViewHeaderFooterView {

    fileprivate let titleLabel = UILabel(text: "选择数量", color: TBIThemeMinorTextColor, size: 13)
    
    fileprivate let line = UILabel(color: TBIThemeBaseColor)

    fileprivate let bgView:UIView = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        bgView.backgroundColor = TBIThemeWhite
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(10)
        }
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(10)
            make.height.equalTo(37)
        }
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        
    }
    func fillCell (title:String){
        titleLabel.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}


class TravelHeaderTwoView: UITableViewHeaderFooterView {
    
    fileprivate var titleLabel = UILabel(text: "选择单房差", color: TBIThemeMinorTextColor, size: 13)
    
    fileprivate var messageLabel = UILabel(text: "(每间房间入住两人,若不想与他人拼房,请选择单房差)", color: TBIThemePlaceholderTextColor, size: 11)
    
    let line = UILabel(color: TBIThemeBaseColor)
    
    let bgView:UIView = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        bgView.backgroundColor = TBIThemeWhite
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(10)
        }
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(10)
            make.height.equalTo(50)
        }
        
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview().offset(-8)
        }
        bgView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview().offset(8)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
