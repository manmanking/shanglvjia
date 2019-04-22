//
//  HomeHotLineView.swift
//  shop
//
//  Created by SLMF on 2017/4/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class HomeHotLineView: UIView {
    
    
    typealias HomeHotLineViewBlock = (String)->Void
    var homeHotLineViewBlock:HomeHotLineViewBlock!
    
    typealias HomeHotLineIdViewBlock = (Int)->Void
    var homeHotLineIdViewBlock:HomeHotLineIdViewBlock!
    
    let headerView = HomeHotLineHeaderView()
    let contentListView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    var idList: [String] = []
    var contentViewList: [HomeHotLineContentView] = []
    
    init(list: [String]) {
        self.idList = list
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.backgroundColor = .white
        self.addSubview(headerView)
        self.addSubview(contentListView)
        headerView.snp.makeConstraints{(make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(41.75)
        }
        contentListView.snp.makeConstraints{(make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalToSuperview()
//            make.height.equalTo(174.75)
            make.height.equalTo(194)
        }
        weak var weakSelf = self
        headerView.homeHotLineHeaderViewBlock = { (title) in
            weakSelf?.homeHotLineViewBlock(title)
            
        }

        
    }
    
    func setContentViews(model:[HomeInfoModel.SpecialMainListResponse]) {
        self.contentViewList.removeAll()
        for view in contentListView.subviews{
            view.removeFromSuperview()
        }
        for index in 0..<model.count {
            let content = HomeHotLineContentView.init(imageName: model[index].imgUrl, titleStr: model[index].productName,subTitleStr:model[index].productDescription,redTitleStr:model[index].label,priceStr:"¥\(Int(model[index].salePrice))")
            self.contentViewList.append(content)
            content.tag = 200 + index
            content.addOnClickListener(target: self, action: #selector(selectProductClick(sender:)))
            self.contentListView.addSubview(content)
        }
        for index in 0..<self.contentViewList.count {
            self.contentViewList[index].snp.makeConstraints{(make) in
                if index > 0 {
                    make.left.equalTo(contentViewList[index - 1].snp.right).offset(10)
                } else {
                    make.left.equalToSuperview().offset(15)
                }
                make.top.equalTo(headerView.snp.bottom).offset(21.75)
                make.height.equalToSuperview()
                make.width.equalTo(156)
            }
        }
    }
    
    /// 选中产品view
    ///
    /// - Parameter view:
    func selectProductClick(sender:UITapGestureRecognizer) -> Void {
        let view:HomeHotLineContentView = sender.view as! HomeHotLineContentView
        homeHotLineIdViewBlock(view.tag - 200)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HomeHotLineHeaderView: UIView {
    
    typealias HomeHotLineHeaderViewBlock = (String)->Void
    
    var homeHotLineHeaderViewBlock:HomeHotLineHeaderViewBlock!
    
    let titleLabel: UILabel
    let moreButton: UIButton
    
    init() {
        titleLabel = UILabel.init(text: NSLocalizedString("home.hotline.header.title", comment: "热门路线"), color: UIColor.init(r: 53, g: 53, b: 53), size: 16)
        moreButton = UIButton.init(title: NSLocalizedString("home.hotline.header.button", comment: "更多精彩"), titleColor: TBIThemeBlueColor, titleSize: 10)
        moreButton.layer.borderColor = TBIThemeBlueColor.cgColor
        moreButton.layer.borderWidth = 1
        moreButton.layer.cornerRadius = 5
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.addSubview(titleLabel)
        self.addSubview(moreButton)
        titleLabel.snp.makeConstraints{(make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(23.75)
        }
        moreButton.snp.makeConstraints{(make) in
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(21.75)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        moreButton.addTarget(self, action: #selector(moreButtonAction(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    func moreButtonAction(sender:UIButton) {
        
        print("into here  special product ...")
        
        homeHotLineHeaderViewBlock("morbutton")
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class HomeHotLineContentView: UIView {
    
    let imageView: UIImageView
    let title: UILabel
    let subTitle:UILabel
    let redTitle:UILabel
    let price:UILabel
    //let desc: UILabel
    
    init(imageName: String, titleStr: String,subTitleStr:String,redTitleStr:String,priceStr:String) {
        imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 3
        imageView.sd_setImage(with: URL.init(string: imageName), placeholderImage: UIImage.init(named: ""))
        
        title = UILabel.init(text: titleStr, color: .black, size: 16)
        title.numberOfLines = 1
        title.lineBreakMode = .byTruncatingTail
        
        subTitle = UILabel.init(text:subTitleStr,color:.darkGray,size:13)
        subTitle.numberOfLines = 1
        
        redTitle = UILabel.init(text:redTitleStr,color:.white,size:10)
        redTitle.textAlignment = .center
        redTitle.backgroundColor = TBIThemeOrangeColor
        redTitle.layer.masksToBounds = true
        redTitle.layer.cornerRadius = 8
        
        price = UILabel.init(text:priceStr,color:TBIThemeOrangeColor,size:17)
        price.numberOfLines = 1
        
        super.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        self.addSubview(imageView)
        self.addSubview(title)
        self.addSubview(subTitle)
        self.addSubview(redTitle)
        self.addSubview(price)
        imageView.snp.makeConstraints{(make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(80)
            make.width.equalTo(156)
        }
        title.snp.makeConstraints{(make) in
            make.left.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.width.equalTo(156)
        }
        subTitle.snp.makeConstraints{(make) in
            make.left.equalToSuperview()
            make.top.equalTo(title.snp.bottom).offset(5)
            make.width.equalTo(156)
        }
        redTitle.snp.makeConstraints{(make) in
            make.left.equalToSuperview()
            make.top.equalTo(subTitle.snp.bottom).offset(10)
            make.height.equalTo(16)
            make.width.equalTo(60)
        }
        price.snp.makeConstraints{(make) in
            make.right.equalToSuperview()
            make.centerY.equalTo(redTitle.snp.centerY)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
