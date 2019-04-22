//
//  CoNoticeDetailsView.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/20.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CoNoticeDetailsView: UIView
{

    let myContentView = UIView()
    
    //头部的大标题
    var topBigTitle:UILabel! = nil
    //发布时间
    var publicTimeLabel:UILabel! = nil
    //文字视图
    var contentLabel:UILabel! = nil
    
    //上一篇
    var preItemPage:CoNoticeItemCell! = nil
    //下一篇
    var nextItemPage:CoNoticeItemCell! = nil
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func initView() -> Void
    {
        self.addSubview(myContentView)
        myContentView.snp.makeConstraints{(make)->Void in
            make.left.top.right.bottom.equalTo(0)
        }
        
        //头部的大标题
        topBigTitle = UILabel(text: "大标题XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", color: TBIThemePrimaryTextColor, size: 20)
        self.myContentView.addSubview(topBigTitle)
        topBigTitle.snp.makeConstraints{(make)->Void in
            make.left.equalTo(20)
            make.top.equalTo(30)
            make.right.equalTo(-20)
        }
        
        //发布时间
        publicTimeLabel = UILabel(text: "发布时间:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", color: TBIThemeTipTextColor, size: 13)
        self.myContentView.addSubview(publicTimeLabel)
        publicTimeLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(20)
            make.top.equalTo(topBigTitle.snp.bottom).offset(15)
            make.right.equalTo(-20)
        }
        
        //底部上一篇下一片的容器视图
        let bottomContainerView = UIView()
        self.myContentView.addSubview(bottomContainerView)
        bottomContainerView.snp.makeConstraints{(make)->Void in
            make.left.right.bottom.equalTo(0)
        }
        
        //底部容器的头部的分割线
        let bottomContainerTopSegLine = UIView()
        bottomContainerTopSegLine.backgroundColor = TBIThemeGrayLineColor
        bottomContainerView.addSubview(bottomContainerTopSegLine)
        bottomContainerTopSegLine.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalToSuperview()
            make.height.equalTo(1)
        }
        
        //上一篇
        preItemPage = CoNoticeItemCell(style: .default, reuseIdentifier: "a")
        bottomContainerView.addSubview(preItemPage)
        preItemPage.snp.makeConstraints{(make)->Void in
            make.left.right.top.equalTo(1)
            make.height.equalTo(100)
        }
        preItemPage.rightArrowView.isHidden = false
        preItemPage.topRightDateLabel.isHidden = true
        preItemPage.topLeftBigTitle.text = "上一篇"
        
        
        //下一篇
        nextItemPage = CoNoticeItemCell(style: .default, reuseIdentifier: "a")
        bottomContainerView.addSubview(nextItemPage)
        nextItemPage.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(preItemPage.snp.bottom)
            make.height.equalTo(100)
            
            make.bottom.equalTo(0)
        }
        nextItemPage.rightArrowView.isHidden = false
        nextItemPage.topRightDateLabel.isHidden = true
        nextItemPage.topLeftBigTitle.text = "下一篇"
        
        
        
        //中间的可以滚动的文字视图
        let contentScrollView = UIScrollView()
        self.myContentView.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints{(make)->Void in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(publicTimeLabel.snp.bottom).offset(30)
            //make.height.equalTo(120)
            make.bottom.equalTo(bottomContainerView.snp.top).offset(-30)
        }
        
        let contentText:String = "天津津旅商务信息技术股份有限公司（以下简称津旅商务）是天津市国资委下属天津市旅游(控股)集团有限公司全资二级子公司。旅游集团为打造新型现代化服务业，创新科技+服务商业模式，于2015年7月16日在天津市滨海高新区滨海科技园注册成立津旅商务，注册资本金3000万元。"
        contentLabel = UILabel(text: contentText, color: TBIThemePrimaryTextColor, size: 16)
        contentLabel.numberOfLines = -1
        contentScrollView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints{(make)->Void in
            make.left.right.top.bottom.equalTo(0)
            make.width.equalTo(ScreenWindowWidth-20-20)
        }
        
    }
    
}
