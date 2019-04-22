//
//  HomeTabBarButtonView.swift
//  shop
//
//  Created by SLMF on 2017/4/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class HomeTabBarButtonView: UIView {
    
    let button: UIImageView
    let label: UILabel
    
    init(imageName: String, labelStr: String) {
        button = UIImageView.init(imageName: imageName)
        label = UILabel.init(text: labelStr, color: UIColor.init(r: 136, g: 136, b: 136), size: 14)
        super.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 66))
        self.backgroundColor = .white
        self.addSubview(button)
        self.addSubview(label)
        button.snp.makeConstraints{(make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(44)
        }
        label.snp.makeConstraints{(make) in
            make.top.equalTo(button.snp.bottom).offset(10)
            make.centerX.equalTo(button.snp.centerX)
            //make.left.equalToSuperview().offset(10)
        }
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
