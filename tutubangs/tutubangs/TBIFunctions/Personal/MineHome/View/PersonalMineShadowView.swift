//
//  MineShadowView.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/6.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalMineShadowView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = TBIThemeWhite
        self.layer.cornerRadius = 5;
        self.layer.shadowColor = UIColor(r:54,g:91,b:193).cgColor
        self.layer.shadowOffset = CGSize(width:3,height:3)
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowRadius = 3;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
