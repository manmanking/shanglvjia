//
//  CityHistoryHeaderSection.swift
//  shanglvjia
//
//  Created by manman on 2018/6/27.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class CityHistoryHeaderSection: UITableViewHeaderFooterView {

    
    typealias CityHistoryHeaderSectionDeleteBlock = ()->Void
    
    public var cityHistoryHeaderSectionDeleteBlock:CityHistoryHeaderSectionDeleteBlock!
    
    private let baseBackgroundView:UIView = UIView()
    
    private let titleLabel:UILabel = UILabel()
    
    private let titleTipDefault:String = "历史记录"
    
    private let deleteButton:UIButton = UIButton()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.backgroundColor = TBIThemeBaseColor
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUIViewAutolayout() {
        titleLabel.text = titleTipDefault
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = TBIThemePlaceholderTextColor
        baseBackgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.width.equalTo(100)
        }
        
        deleteButton.setImage(UIImage.init(named: "ic_ashbin"), for: UIControlState.normal)
        deleteButton.addTarget(self, action: #selector(deleteAction(sender:)), for: UIControlEvents.touchUpInside)
        baseBackgroundView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(14)
            make.height.equalTo(14)
        }
        
    }
    
    
    func deleteAction(sender:UIButton) {
        if cityHistoryHeaderSectionDeleteBlock != nil {
            cityHistoryHeaderSectionDeleteBlock()
        }
    }
    
    

}
