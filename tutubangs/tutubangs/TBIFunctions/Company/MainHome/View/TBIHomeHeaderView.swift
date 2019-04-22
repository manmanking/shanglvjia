//
//  TBIHomeHeaderView.swift
//  shop
//
//  Created by manman on 2017/4/11.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SnapKit

class TBIHomeHeaderView: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    fileprivate var baseBackgroundView = TBIBaseView()
    
    
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(baseBackgroundView)
        
        baseBackgroundView.backgroundColor = UIColor.white
        baseBackgroundView.debugMessage(debugTitle:"我是标题")
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        setCustomUIViewAutolayout()
        
        
        
    }
    
    func setCustomUIViewAutolayout() {
        
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
