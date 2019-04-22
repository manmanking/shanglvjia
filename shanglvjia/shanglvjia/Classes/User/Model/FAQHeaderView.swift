//
//  FQAHeaderView.swift
//  shop
//
//  Created by akrio on 2017/5/1.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class FAQHeaderView: UITableViewHeaderFooterView {
    let titleLabel:UILabel = UILabel(text: "2222", color: UIColor(r:136 ,g:136 ,b:136 ), size: 14)
    init(_ title:String,reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        titleLabel.text = title
        self.addSubview(titleLabel)
        self.contentView.backgroundColor = UIColor(r: 245, g: 245, b: 249)
        titleLabel.snp.makeConstraints{make in
            make.left.equalTo(15)
            make.centerY.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
