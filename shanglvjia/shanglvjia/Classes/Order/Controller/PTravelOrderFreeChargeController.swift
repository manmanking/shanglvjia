//
//  PTravelOrderFreeChargeController.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/7/7.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

//个人版旅游订单 报销凭证 ViewController

class PTravelOrderFreeChargeController: CompanyBaseViewController
{
    var travelOrderDetails:PSpecialOrderDetails! = nil
    
    //固定6个字段
    var dataSource:[(String,String)] = []
    
    let contentYOffset:CGFloat = 20 + 44
    var myContentView:UIView! = nil

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        //设置头部的导航栏
        self.title = "报销凭证"  //"报销凭证"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 16),NSForegroundColorAttributeName:UIColor.white]
        setNavigationBackButton(backImage: "back")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIColor.creatImageWithColor(color: TBIThemeBlueColor), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        setDataSource()
        initView()
        
    }
    
    //重写  头部左侧的🔙Btn
    override func backButtonAction(sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage.init(named: "border")
    }
    
    func setDataSource() -> Void
    {
        //固定几个字段     6
        dataSource = []
        
        dataSource.append(("发票类型",travelOrderDetails.invoiceTypeEnum.description))
        dataSource.append(("发票抬头",travelOrderDetails.invoiceTitle ?? ""))
        //TODO:"配送方式"字段
        dataSource.append(("配送方式","快递¥10"))
        dataSource.append(("收件人",travelOrderDetails.logisticsName ?? ""))
        
        dataSource.append(("手机号码",travelOrderDetails.logisticsPhone ?? ""))
        //TODO:"所在地区"字段
        //dataSource.append(("所在地区","所在地区XXX"))
        dataSource.append(("详细地址",travelOrderDetails.logisticsAddress ?? ""))
    }
    
    
    
    func initView() -> Void
    {
        myContentView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight - contentYOffset))
        myContentView.backgroundColor = TBIThemeBaseColor
        self.view.addSubview(myContentView)
        
        
        var lastContentItemView:UIView! = nil
        for i in 0..<(dataSource.count-1)
        {
            let itemContentView = UIView()
            itemContentView.backgroundColor = .white
            myContentView.addSubview(itemContentView)
            itemContentView.snp.makeConstraints{(make)->Void in
                make.left.right.equalTo(0)
                
                if i == 1   //该View的高度比较更高
                {
                    make.height.equalTo(66)
                }
                else
                {
                    make.height.equalTo(44)
                }
                
                if i == 0
                {
                    make.top.equalTo(10)
                }
                else
                {
                    make.top.equalTo(lastContentItemView.snp.bottom)
                }
            }
            lastContentItemView = itemContentView
            
            let leftLabel = UILabel(text: dataSource[i].0, color: TBIThemePrimaryTextColor, size: 13)
            itemContentView.addSubview(leftLabel)
            leftLabel.snp.makeConstraints{(make)->Void in
                make.left.equalTo(15)
                make.width.equalTo(80)
                make.centerY.equalToSuperview()
            }
            
            let rightLabel = UILabel(text: dataSource[i].1, color: TBIThemePrimaryTextColor, size: 13)
            itemContentView.addSubview(rightLabel)
            rightLabel.snp.makeConstraints{(make)->Void in
                make.left.equalTo(100)
                make.right.equalTo(-15)
                make.centerY.equalToSuperview()
            }
            if i == 1   //该View的高度比较更高
            {
                let attributedString0 = NSMutableAttributedString(string: rightLabel.text!)
                let paragraphStyle0 = NSMutableParagraphStyle()
                paragraphStyle0.lineSpacing = 11
                attributedString0.addAttributes([NSParagraphStyleAttributeName:paragraphStyle0], range:NSMakeRange(0,(rightLabel.text!).characters.count))
                rightLabel.attributedText = attributedString0
            }
            
            //item底部的分割线
            let bottomSegLine = UIView()
            bottomSegLine.backgroundColor = TBIThemeGrayLineColor
            itemContentView.addSubview(bottomSegLine)
            bottomSegLine.snp.makeConstraints{(make)->Void in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.bottom.equalTo(0)
                
                make.height.equalTo(1)
            }
        }
        
        
        //******最后一个Item
        let bottomItemView = UIView()
        bottomItemView.backgroundColor = .white
        myContentView.addSubview(bottomItemView)
        bottomItemView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.height.equalTo(66)
            
            make.top.equalTo(lastContentItemView.snp.bottom)
        }
        
        let bottomLeftLabel = UILabel(text: dataSource[dataSource.count-1].0, color: TBIThemePrimaryTextColor, size: 13)
        bottomItemView.addSubview(bottomLeftLabel)
        bottomLeftLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.width.equalTo(80)
            make.centerY.equalToSuperview()
        }
        
        let bottomRightLabel = UILabel(text: dataSource[dataSource.count-1].1, color: TBIThemePrimaryTextColor, size: 13)
        bottomRightLabel.numberOfLines = 2
        bottomItemView.addSubview(bottomRightLabel)
        bottomRightLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(100)
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        let attributedString0 = NSMutableAttributedString(string: bottomRightLabel.text!)
        let paragraphStyle0 = NSMutableParagraphStyle()
        paragraphStyle0.lineSpacing = 11
        attributedString0.addAttributes([NSParagraphStyleAttributeName:paragraphStyle0], range:NSMakeRange(0,(bottomRightLabel.text!).characters.count))
        bottomRightLabel.attributedText = attributedString0
        
        
    }
    
    

}




