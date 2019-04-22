//
//  TBIBaseView.swift
//  shop
//
//  Created by manman on 2017/4/11.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit


class TBIBaseView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    fileprivate let debugTitleLabel = UILabel()
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setUIViewAutolayout()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUIViewAutolayout() {

    }
    
    func debugMessage(debugTitle:String) {
        if DEBUG {
            
            debugTitleLabel.text = debugTitle
            debugTitleLabel.textAlignment = NSTextAlignment.center
            self.addSubview(debugTitleLabel)
            debugTitleLabel.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(30)
            })
        }
    }
    
    
    
}
