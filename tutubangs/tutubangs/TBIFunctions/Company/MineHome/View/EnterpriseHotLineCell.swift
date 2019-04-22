//
//  EnterpriseHotLineCell.swift
//  shop
//
//  Created by zhanghao on 2017/7/14.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation

class EnterpriseHotLineCell : UITableViewCell {
    var myContentView:UIView! = nil
    var leftLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 16)
    var rightLabel = UILabel(text: "", color: TBIThemeMinorTextColor, size: 16)
    var rightImage = UIImageView(imageName: "ic_right_gray")
    let bottomSegView = UIView()
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView() -> Void {
        myContentView = UIView()
        self.contentView.addSubview(myContentView)
        myContentView.snp.makeConstraints{(make)->Void in
            make.left.right.top.bottom.equalTo(0)
            make.height.equalTo(44)
        }
        myContentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints{(make) ->Void in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        myContentView.addSubview(rightLabel)
        rightLabel.snp.makeConstraints{(make)->Void in
            make.right.equalTo(-30)
            make.centerY.equalToSuperview()
        }
        myContentView.addSubview(rightImage)
        rightImage.snp.makeConstraints{(make)->Void in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
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
