//
//  CoOldOrderDetailsTableHeadView.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/5/23.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CoOldOrderDetailsTableHeadView: UIView {

    //var tableTopView = self
    
    var circleViewArray:[UIImageView] = []
    var lineViewArray:[UIView] = []
    var statusTextViewArray:[UILabel] = []
    
    //状态对应的的文字
    var statusTextArray:[String] = []
    var statusNum:Int = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib()->Void
    {
        super.awakeFromNib()
        
        print("^_^    CoOldOrderDetailsTableHeadView")
        initView()
    }
    
    func initView() -> Void {
        
        self.backgroundColor = TBIThemeBlueColor
        
        //layoutTableTopView();
    }
    
    //对TableTopView进行布局
    func layoutTableTopView() -> Void
    {
        statusNum = statusTextArray.count
        
        //var i:Int = 0
        
        let lineNum = statusNum-1
        let circleStatusViewRadious = 8
        let marginEdge = 21
        
        let lineDistanceX:Int = (Int(ScreenWindowWidth)-(marginEdge*2)-(circleStatusViewRadious*2))/lineNum
        //设置中间线条的line
        for i in 0..<lineNum
        {
            let lineView = UIView();
            self.addSubview(lineView)
            //将线添加进数组
            lineViewArray.append(lineView)
            
            
            
            lineView.tag = i
            //lineView.backgroundColor = UIColor.white
            
            if i==0 {
                lineView.snp.makeConstraints{ (make) ->Void in
                    make.height.equalTo(4)
                    make.width.equalTo(lineDistanceX-17)
                    make.top.equalTo(38)
                    
                    make.centerX.equalTo(marginEdge+circleStatusViewRadious+lineDistanceX/2+3)
                    //make.left.equalTo(marginEdge+circleStatusViewRadious)
                }
            }
            else
            {
                //lineView.backgroundColor = UIColor.init(r: 154, g: 198, b: 250)
                
                lineView.snp.makeConstraints{ (make) ->Void in
                    make.height.equalTo(4)
                    make.width.equalTo(lineDistanceX-17)
                    make.top.equalTo(38)
                    
                    make.centerX.equalTo(marginEdge+circleStatusViewRadious+lineDistanceX*i+lineDistanceX/2+3)
                    //make.left.equalTo(marginEdge+circleStatusViewRadious+lineDistanceX*i)
                }
            }
            
            
        }
        
        //设置订单状态的Image
        for i in 0..<statusNum
        {
            let orderStatusImage = UIImageView()
            orderStatusImage.backgroundColor = UIColor.clear
            //orderStatusImage.image = UIImage(named: "ic_c_complete")
            orderStatusImage.tag=i
            self.addSubview(orderStatusImage)
            //将圆形状态添加进数组
            circleViewArray.append(orderStatusImage)
            
            if i==0
            {
                orderStatusImage.snp.makeConstraints { (make) -> Void in
                    make.width.height.equalTo(21)
                    make.left.equalTo(marginEdge)
                    make.top.equalTo(30)
                }
            }
            else
            {
                //orderStatusImage.image = UIImage(named: "ic_c_current")
                
                orderStatusImage.snp.makeConstraints { (make) -> Void in
                    make.width.height.equalTo(21)
                    make.top.equalTo(30)
                    make.left.equalTo(marginEdge+lineDistanceX*i)
                }
            }
            
        }
        
        
        
        for i in 0..<statusNum
        {
            let statusLabel = UILabel(text: statusTextArray[i], color: UIColor.white, size: 13)
            statusLabel.backgroundColor = UIColor.clear
            self.addSubview(statusLabel)
            statusTextViewArray.append(statusLabel)
            
            
            statusLabel.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(13)
                make.top.equalTo(56)
                make.centerX.equalTo(circleViewArray[i].snp.centerX)
            }
        }
        
    }
    
    //TODO: 设置当前整体的订单状态的视图
    func setCurrentTotalOrderStatus(currentStatusNo:Int) -> Void
    {
        for i in 0..<statusNum
        {
            if i < currentStatusNo
            {
                //TODO:需要设置图片
                circleViewArray[i].image = UIImage(named: "ic_c_complete")
            }
            else if i == currentStatusNo
            {
                //circleViewArray[i].image = UIImage(named: "ic_c_current")
                circleViewArray[i].image = UIImage(named: "ic_c_complete")
            }
            else if i > currentStatusNo
            {
                //TODO:需要设置图片
                //circleViewArray[i].image = UIImage(named: "ic_c_complete")
                circleViewArray[i].layer.cornerRadius = 21.0/2
                circleViewArray[i].backgroundColor = UIColor.init(r: 154, g: 198, b: 250)
            }
            
            
            
            if i != statusNum-1
            {
                if i < currentStatusNo
                {
                    lineViewArray[i].backgroundColor = UIColor.white
                }
                else
                {
                    lineViewArray[i].backgroundColor = UIColor.init(r: 154, g: 198, b: 250)
                }
            }
        }
    }

}
