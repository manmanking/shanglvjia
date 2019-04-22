//
//  TrainViolateReasonTableViewCell.swift
//  shanglvjia
//
//  Created by manman on 2018/6/20.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class TrainViolateReasonTableViewCell: UITableViewCell {
    
    
    typealias TrainViolateReasonTableViewBlock = ()->Void
    
    public var trainViolateReasonTableViewBlock:TrainViolateReasonTableViewBlock!

    private var baseBackgroundView:UIView = UIView()
    
    private let titleLabel:UILabel = UILabel()
    private let rightLabel:UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(baseBackgroundView)
        baseBackgroundView.backgroundColor = TBIThemeWhite
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        setUIViewAutolayout()
    }
    
    
    func setUIViewAutolayout() {
        
        titleLabel.textColor = UIColor.gray
        titleLabel.text = "违背原因"
        titleLabel.font=UIFont.systemFont(ofSize: 15)
        baseBackgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.width.equalTo(90)
        }
        

        rightLabel.textColor = TBIThemeRedColor
        rightLabel.addOnClickListener(target: self, action: #selector(rightBlockAction))
        rightLabel.textAlignment = NSTextAlignment.right
        rightLabel.font = UIFont.systemFont(ofSize: 13)
        baseBackgroundView.addSubview(rightLabel)
        rightLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.left.equalTo(titleLabel.snp.right).offset(5)
        }
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func fillDataSources(title:String,content:String,right:String) {
        rightLabel.text = right
        
    }
    
    
    func rightBlockAction() {
        
    }

}
