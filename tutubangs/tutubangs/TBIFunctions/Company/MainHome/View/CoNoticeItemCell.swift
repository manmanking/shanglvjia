//
//  CoNoticeItemCell.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/20.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CoNoticeItemCell: UITableViewCell
{

    let myContentView = UIView()
    
    var topLeftBigTitle:UILabel! = nil
    var topRightDateLabel:UILabel! = nil
    var bottomRightsubTitle:UILabel! = nil
    
    var rightArrowView:UIImageView!
    
    
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
    
    func initView() -> Void {
        print("^_^   initView")
        self.addSubview(myContentView)
        myContentView.snp.makeConstraints{(make)->Void in
            make.left.right.top.equalTo(0)
            
            make.bottom.equalTo(0)
        }
        
        let leftImageView = UIImageView(imageName: "ic_c_news")
        myContentView.addSubview(leftImageView)
        leftImageView.snp.makeConstraints{(make)->Void in
            make.left.equalTo(20)
            make.top.equalTo(25)
            make.bottom.equalTo(-25)
            
            make.width.height.equalTo(50)
        }
        
        let rightContainerView = UIView()
        myContentView.addSubview(rightContainerView)
        rightContainerView.snp.makeConstraints{(make)->Void in
            make.left.equalTo(leftImageView.snp.right).offset(15)
            make.right.equalTo(-20)
            
            make.centerY.equalToSuperview()
        }
        
        topLeftBigTitle = UILabel(text: "大韩XXXXXXXXX", color: TBIThemePrimaryTextColor, size: 16)
        rightContainerView.addSubview(topLeftBigTitle)
        topLeftBigTitle.snp.makeConstraints{(make)->Void in
            make.left.top.equalTo(0)
        }
        
        topRightDateLabel = UILabel(text: "03-28", color: TBIThemeTipTextColor, size: 13)
        rightContainerView.addSubview(topRightDateLabel)
        topRightDateLabel.snp.makeConstraints{(make)->Void in
            make.right.equalTo(0)
            
            make.bottom.equalTo(topLeftBigTitle.snp.bottom)
        }
        
        //topLeftBigTitle设置大标题距离右侧的距离
        topLeftBigTitle.snp.makeConstraints{(make)->Void in
            make.right.equalTo(-50)
        }
        
        bottomRightsubTitle = UILabel(text: "在天津XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", color: TBIThemeTipTextColor, size: 13)
        rightContainerView.addSubview(bottomRightsubTitle)
        bottomRightsubTitle.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(topLeftBigTitle.snp.bottom).offset(10)
            
            make.bottom.equalTo(0)
        }
        
        
        //最右侧的箭头➡️
        rightArrowView = UIImageView(imageName: "ic_right_gray")
        myContentView.addSubview(rightArrowView)
        rightArrowView.snp.makeConstraints{(make)->Void in
            make.right.equalTo(-20)
            make.centerY.equalToSuperview()
        }
        rightArrowView.isHidden = true
        
        let bottomSegLine = UIView()
        bottomSegLine.backgroundColor = TBIThemeGrayLineColor
        myContentView.addSubview(bottomSegLine)
        bottomSegLine.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.bottom.equalToSuperview()
            
            make.height.equalTo(1)
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
