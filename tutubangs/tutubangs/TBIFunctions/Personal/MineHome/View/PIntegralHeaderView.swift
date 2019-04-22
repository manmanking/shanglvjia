//
//  PIntegralHeaderView.swift
//  shanglvjia
//
//  Created by tbi on 07/09/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit

class PIntegralHeaderView: UIView {

    private let bgImageView = UIImageView()
    private let desLabel = UILabel.init(text: "当前积分", color: UIColor.black, size: 14)
    public let integralLabel = UILabel.init(text: "", color: UIColor.black, size: 50)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        self.addSubview(bgImageView)
        self.addSubview(desLabel)
        self.addSubview(integralLabel)
        
        bgImageView.image = UIImage(named:"bg_integral")
        bgImageView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)
        }
        
        desLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        
        integralLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(desLabel)
            make.centerY.equalTo(desLabel).offset(45)
        }
    }

}
