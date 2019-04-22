//
//  PsgOrderDetailsItemCell.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/21.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class PsgOrderDetailsItemCell: UIView
{
    var rightContentLabelList:[UILabel] = []
    
    //是否为往返程
    var isGoBack:Bool = true
    var orderStatue:FlightOrderDetail.FlightOrderState! = nil
    var rightItemCount:Int
    {
        if(orderStatue == .finished || orderStatue == .exit || orderStatue == .line)//往返程
        {
            if isGoBack
            {
                return 6
            }
            else  //单程
            {
                return 4
            }
        }
        else
        {
            if isGoBack
            {
                return 4
            }
            else  //单程
            {
                return 3
            }
        }
        
    }
    
    //左侧的视图
    let leftContainerView = UIView()
    let leftContentLabel = UILabel(text: "乘机人", color: TBIThemeTipTextColor, size: 13)
    
    //右侧的视图
    let rightContainerView = UIView()
    
    
    //底部的分割线
    let bottomSegView = UIView()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        //initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    func initView() -> Void
    {
        //左侧的视图
        self.addSubview(leftContainerView)
        leftContainerView.snp.makeConstraints{(make)->Void in
            make.left.top.equalTo(0)
            make.width.equalTo(100)
        }
        
        leftContainerView.addSubview(leftContentLabel)
        leftContentLabel.snp.makeConstraints{(make)->Void in
            make.left.top.equalTo(15)
        }
        
        //右侧的视图
        self.addSubview(rightContainerView)
        rightContainerView.snp.makeConstraints{(make)->Void in
            make.left.equalTo(leftContainerView.snp.right)
            make.right.equalTo(0)
            make.top.equalTo(0)
            
            //make.height.equalTo(10)
        }
        
        self.rightContentLabelList = []
        
        var lastItemView:UIView! = nil
        for i in 0..<rightItemCount
        {
            let labelItem = UILabel(text: "XXXXXXX\(i)", color: TBIThemePrimaryTextColor, size: 13)
            self.rightContentLabelList.append(labelItem)
            
            rightContainerView.addSubview(labelItem)
            labelItem.snp.makeConstraints{(make)->Void in
                make.left.right.equalTo(0)
                
                if i == 0
                {
                    make.top.equalTo(15)
                }
                else
                {
                    make.top.equalTo(lastItemView.snp.bottom).offset(10)
                }
                
                if i == (rightItemCount-1)
                {
                    make.bottom.equalTo(-15)
                }
            }
            lastItemView = labelItem
            
            if isGoBack    //往返程
            {
                if (i%2 == 1) && (i != rightItemCount-1)
                {
                    let segLineView = UIView()
                    segLineView.tag = 111   //标记它为分割线
                    segLineView.backgroundColor = TBIThemeGrayLineColor
                    rightContainerView.addSubview(segLineView)
                    segLineView.snp.makeConstraints{(make)->Void in
                        make.left.right.equalTo(0)
                        make.top.equalTo(labelItem.snp.bottom).offset(10)
                        
                        make.height.equalTo(1)
                    }
                    
                    lastItemView = segLineView
                }
            }
        }
        
        //底部的分割线
        bottomSegView.backgroundColor = TBIThemeGrayLineColor
        self.addSubview(bottomSegView)
        bottomSegView.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(rightContainerView.snp.bottom)
            
            make.height.equalTo(1)
            
            make.bottom.equalTo(0)
        }
    }
}
