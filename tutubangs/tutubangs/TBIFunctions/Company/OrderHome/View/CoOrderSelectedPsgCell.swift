//
//  CoOrderSelectedPsgCell.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/14.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CoOrderSelectedPsgCell: UITableViewCell {

    
    var topTitleLabel:UILabel!
    var subTitleLabel:UILabel!
    
    var rightCheckImgView:UIImageView!
    
    
    
    override func awakeFromNib() {
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
        let contentView = UIView()
        //contentView.backgroundColor = .red
        self.contentView.addSubview(contentView)
        contentView.snp.makeConstraints{(make)->Void in
            make.left.top.right.bottom.equalTo(0)
        }
        
        topTitleLabel = UILabel(text: "TTTop", color: TBIThemePrimaryTextColor, size: 17)
        contentView.addSubview(topTitleLabel)
        topTitleLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(30)
            make.top.equalTo(20)
            //make.bottom.equalTo(-20)
        }
        
        subTitleLabel = UILabel(text: "subbbbb", color: TBIThemeTipTextColor, size: 13)
        contentView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(30)
            make.top.equalTo(topTitleLabel.snp.bottom).offset(5)
        }
        
        
        
        let line1dpView = UIView()
        line1dpView.backgroundColor = TBIThemeGrayLineColor
        contentView.addSubview(line1dpView)
        line1dpView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            make.height.equalTo(1)
            make.bottom.equalTo(0)
        }
        
//
        rightCheckImgView = UIImageView()
        //rightCheckImgView.backgroundColor = .red
        contentView.addSubview(rightCheckImgView)
        rightCheckImgView.snp.makeConstraints{(make)->Void in
            make.centerY.equalToSuperview()
            make.right.equalTo(-20)
            make.width.height.equalTo(20)
        }
        
        
    }

    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
