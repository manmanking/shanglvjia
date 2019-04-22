//
//  TBIAlertView2.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/12.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class TBIAlertView2: UIView
{
    var titleStr = "title ^_^"
    var dataSource:[(key:String,value:String)] = []
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        //setDataSource()
        //initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    //测试时使用
    func setDataSource() -> Void
    {
        for i in 0..<7
        {
            dataSource.append(("key\(i)","value\(i)"))
        }
    }
    

    func initView() -> Void
    {
        let baseBackgroundView = UIView()
        baseBackgroundView.backgroundColor = TBIThemeBackgroundViewColor
        baseBackgroundView.addOnClickListener(target: self, action: #selector(cancelButtonAction))
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        
        let alertContentView = UIView()
        self.addSubview(alertContentView)
        alertContentView.layer.cornerRadius = 7
        alertContentView.backgroundColor = .white
        alertContentView.snp.makeConstraints{(make)->Void in
            make.center.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        //头部的标题
        let topContentView = UIView()
        alertContentView.addSubview(topContentView)
        topContentView.snp.makeConstraints{(make)->Void in
            make.left.right.top.equalTo(0)
            make.height.equalTo(60)
        }
        
        let topTitleLabel = UILabel(text: titleStr, color: TBIThemePrimaryTextColor, size: 17)
        topContentView.addSubview(topTitleLabel)
        topTitleLabel.snp.makeConstraints{(make)->Void in
            make.center.equalToSuperview()
        }
        
        //分割线
        let bigSegLine = UIView()
        alertContentView.addSubview(bigSegLine)
        bigSegLine.backgroundColor = TBIThemeGrayLineColor
        bigSegLine.snp.makeConstraints{(make)->Void in
            make.left.right.equalToSuperview()
            make.top.equalTo(topContentView.snp.bottom)
            make.height.equalTo(1)
        }
        
        
        //下面的内容
        let subContentScrollView = UIScrollView()
        alertContentView.addSubview(subContentScrollView)
        subContentScrollView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(bigSegLine.snp.bottom).offset(30)
            make.bottom.equalTo(-80)
            
            make.height.equalTo(205)
        }
        
        
        let subContentView = UIView()
        subContentScrollView.addSubview(subContentView)
        subContentView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            
            //MARK: ^_^   *******
            make.width.equalTo(subContentScrollView.snp.width)
        }
        
        
        var lastItemView:UIView! = nil
        for i in 0..<dataSource.count
        {
            let mItem = dataSource[i]
    
            let itemContent = UIView()
            //itemContent.backgroundColor = .blue
            subContentView.addSubview(itemContent)
            itemContent.snp.makeConstraints{(make)->Void in
                make.left.equalTo(30)
                make.right.equalTo(-30)
            
                if i == 0
                {
                    make.top.equalTo(0)
                }
                else
                {
                    make.top.equalTo(lastItemView.snp.bottom).offset(20)
                }
                
                if i == dataSource.count-1
                {
                    make.bottom.equalTo(0)
                }
            }
            lastItemView = itemContent
            
            let keyLabel = UILabel(text: mItem.key, color: TBIThemePrimaryTextColor, size: 16)
            itemContent.addSubview(keyLabel)
            keyLabel.snp.makeConstraints{(make)->Void in
                make.left.top.right.equalTo(0)
            }
            
            let valueLabel = UILabel(text: mItem.value, color: TBIThemeTipTextColor, size: 13)
            valueLabel.numberOfLines = -1
            //valueLabel.backgroundColor = .red
            itemContent.addSubview(valueLabel)
            valueLabel.snp.makeConstraints{(make)->Void in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.top.equalTo(keyLabel.snp.bottom).offset(5)
                make.bottom.equalTo(0)
            }
        }
        
        
    }
    
    
    
    
    
    func cancelButtonAction() {
        self.removeFromSuperview()
    }
    
    
    
}





