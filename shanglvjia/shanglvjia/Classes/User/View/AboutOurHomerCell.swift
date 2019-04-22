//
//  AboutOurHomerCell.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/22.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class AboutOurHomerCell: UITableViewCell
{

    var myContentView:UIView! = nil
    var leftLabel = UILabel(text: "XXXXXX", color: TBIThemePrimaryTextColor, size: 16)
    let bottomSegView = UIView()
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        initView()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    func initView() -> Void
    {
        myContentView = UIView()
        self.contentView.addSubview(myContentView)
        myContentView.snp.makeConstraints{(make)->Void in
            make.left.right.top.bottom.equalTo(0)
            
            make.height.equalTo(44)
        }
        
        //左侧的文字
        myContentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        //右侧的箭头 ➡️
        let rightArrowImageView = UIImageView(imageName: "ic_right_gray")
        myContentView.addSubview(rightArrowImageView)
        rightArrowImageView.snp.makeConstraints{(make)->Void in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        //最下方的分割线
        bottomSegView.backgroundColor = TBIThemeGrayLineColor
        myContentView.addSubview(bottomSegView)
        bottomSegView.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.right.equalTo(0)
            make.height.equalTo(1)
            
            make.bottom.equalTo(0)
        }
        
    }
    
}
