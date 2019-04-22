//
//  HomeLowerPriceView.swift
//  shop
//
//  Created by SLMF on 2017/4/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class HomeLowerPriceView: UIView {
    
    typealias HomeLowerPriceViewBlock = (String)->Void
    var homeLowerPriceViewBlock:HomeLowerPriceViewBlock!
    
    typealias HomeLowerPriceIdViewBlock = (Int)->Void
    var homeLowerPriceIdViewBlock:HomeLowerPriceIdViewBlock!
    
    typealias HomeLowerPriceAdViewBlock = (Void)->Void
    var homeLowerPriceAdViewBlock:HomeLowerPriceAdViewBlock!
    
    let headerView = HomeLowerPriceHeaderView()
    let lowerPriceBannerView: UIImageView = UIImageView()
    let contentListView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    var idList: [String] = []
    var contentViewList: [HomeLowerPriceContentView] = []
    
    init(list: [String]) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.backgroundColor = .white
        self.addSubview(headerView)
        self.addSubview(lowerPriceBannerView)
        self.addSubview(contentListView)
        headerView.snp.makeConstraints{(make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(41.75)
        }
        lowerPriceBannerView.layer.cornerRadius = 3
        lowerPriceBannerView.layer.masksToBounds = true
        let height = (UIScreen.main.bounds.width - 30) / 345 * 130
        lowerPriceBannerView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(23.75)
            make.left.equalTo(15)
            make.width.equalTo(UIScreen.main.bounds.width - 30)
            make.height.equalTo(height)
        }
        contentListView.snp.makeConstraints { (make) in
            make.top.equalTo(lowerPriceBannerView.snp.bottom).offset(15)
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(0)
        }
        let tapStepGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeLowerPriceView.enterStepDetail))
        lowerPriceBannerView.addGestureRecognizer(tapStepGestureRecognizer)
        lowerPriceBannerView.isUserInteractionEnabled = true
        
        weak var weakSelf = self
        self.headerView.homeLowerPriceHeaderViewBlock = { (title) in
            weakSelf?.homeLowerPriceViewBlock(title)
            
        }
    }
    
    ///图片点击事件
    func enterStepDetail(){
        homeLowerPriceAdViewBlock()
    }
    
    func setContentViews(model:[HomeInfoModel.SpecialMainListResponse],imageUrl:[String]) {
        let width = UIScreen.main.bounds.width - 30
        lowerPriceBannerView.sd_setImage(with: URL.init(string: imageUrl.first ?? ""))
        
        contentListView.snp.updateConstraints { (make) in
            make.height.equalTo(model.count * 95 - 15)
        }
        contentViewList.removeAll()
        for view in contentListView.subviews{
            view.removeFromSuperview()
        }
        
        for index in 0..<model.count {
            let content = HomeLowerPriceContentView.init(imageName: model[index].imgUrl, titleStr: model[index].productName,labelStr:"", descStr: model[index].confirm,price: model[index].salePrice,originalPrice: model[index].price,hot: model[index].hot)

            
            content.layer.borderColor = TBIThemeGrayLineColor.cgColor
            content.layer.borderWidth = 0.5
            content.layer.cornerRadius = 3
            content.layer.masksToBounds = true
            content.tag = 100 + index
            content.addOnClickListener(target: self, action: #selector(selectProductClick(sender:)))
            self.contentViewList.append(content)
            self.contentListView.addSubview(content)
        }
        for index in 0..<self.contentViewList.count {
            
            self.contentViewList[index].snp.makeConstraints{(make) in
                if index > 0 {
                    make.top.equalTo(contentViewList[index - 1].snp.bottom).offset(15)
                } else {
                    make.top.equalToSuperview()
                }
                make.left.equalToSuperview().offset(15)
                make.height.equalTo(80)
                make.width.equalTo(width)
            }
        }
    }
    
    /// 选中产品view
    ///
    /// - Parameter view:
    func selectProductClick(sender:UITapGestureRecognizer) -> Void {
        let view = sender.view as! HomeLowerPriceContentView
        homeLowerPriceIdViewBlock(view.tag - 100)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HomeLowerPriceHeaderView: UIView {
    typealias HomeLowerPriceHeaderViewBlock = (String)->Void
    
    var homeLowerPriceHeaderViewBlock:HomeLowerPriceHeaderViewBlock!
    
    let titleLabel: UILabel
    let moreButton: UIButton
    
    init() {
        titleLabel = UILabel.init(text: NSLocalizedString("home.lowerPrice.header.title", comment: "特价产品"), color: TBIThemePrimaryTextColor, size: 16)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func moreButtonAction(sender:UIButton) {
        
        print("into here  special product ...")
        
        //let specialProductView = SpecialProductViewController()
        
        homeLowerPriceHeaderViewBlock("morbutton")
        
        
    }
    
    
    
    
}

class HomeLowerPriceContentView: UIView {
    
    let imageView: UIImageView
    let title: UILabel
    let labelTitle:UILabel
    var priceLabel: UILabel = UILabel()
    // 原价
    var originalPriceLabel: UILabel = UILabel(text: "", color: TBIThemeMinorTextColor, size: 12)
    
    let width = UIScreen.main.bounds.width - 15 - 15 - 80 - 20 - 20
    
    let hotLabel = UILabel(text: "", color: TBIThemeWhite, size: 14)
    
    fileprivate lazy var hotView: UIView = {
        let vi = UIView()
        vi.layer.cornerRadius = 8.5
        vi.backgroundColor = TBIThemeOrangeColor
        let img = UIImageView.init(imageName: "hot")
        
        vi.addSubview(img)
        vi.addSubview(self.hotLabel)
        self.hotLabel.snp.makeConstraints{ (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(5)
            //make.left.equalTo(img.snp.right).offset(5)
        }
        img.snp.makeConstraints{ (make) in
            make.right.equalTo(self.hotLabel.snp.left).offset(-3)
            make.centerY.equalToSuperview()
            //make.width.height.equalTo(12)
        }
        
        return vi
    }()

    
    init(imageName: String, titleStr: String,labelStr:String, descStr: String,price: Float,originalPrice: Float,hot:Int) {
        imageView = UIImageView()
        imageView.sd_setImage(with: URL.init(string: imageName))
        //imageView.layer.cornerRadius = 3
        //imageView.layer.masksToBounds =  true
        title = UILabel.init(text: titleStr, color: .black, size: 13)
        title.numberOfLines = 2
        title.lineBreakMode = .byTruncatingTail
        
        labelTitle = UILabel.init(text:labelStr,color:UIColor.init(r: 187, g: 187, b: 187),size:12)
        labelTitle.lineBreakMode = .byTruncatingTail
        
        super.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        priceLabel = setPrice(price)
        self.addSubview(imageView)
        self.addSubview(title)
        self.addSubview(labelTitle)
        self.addSubview(priceLabel)
        imageView.snp.makeConstraints{(make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(80)
        }
        title.snp.makeConstraints{(make) in
            make.left.equalTo(imageView.snp.right).offset(20)
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(width)
        }
        labelTitle.snp.makeConstraints{(make) in
            make.left.equalTo(imageView.snp.right).offset(20)
            make.top.equalTo(title.snp.bottom).offset(6.5)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(-6)
        }
        let attrs =  NSAttributedString(string: "¥\(String(describing: Int(originalPrice) ))",attributes: [NSStrikethroughStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue])
        originalPriceLabel.attributedText = attrs
        self.addSubview(originalPriceLabel)
        
        originalPriceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(priceLabel.snp.centerY)
            make.right.equalTo(priceLabel.snp.left).offset(-5)
        }
        self.addSubview(hotView)
        hotView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10)
            make.height.equalTo(17)
            make.width.equalTo(54)
            make.left.equalTo(imageView.snp.right).offset(20)
        }
        hotLabel.text = String(hot)
    }

    
    func setPrice(_ price:Float) -> UILabel {
        //可能有点流氓吧
        let _price:Int =  Int(price)
        
        let label = UILabel()
        let attr = NSMutableAttributedString()
        let priceT = NSAttributedString.init(string: String("¥"), attributes: [NSForegroundColorAttributeName : UIColor.init(r: 255, g: 93, b: 7), NSFontAttributeName : UIFont.systemFont(ofSize: 16)])
        let priceStr = NSAttributedString.init(string: String(_price), attributes: [NSForegroundColorAttributeName : UIColor.init(r: 255, g: 93, b: 7), NSFontAttributeName : UIFont.systemFont(ofSize: 16)])
        let labelStr = NSAttributedString.init(string: "起", attributes: [NSForegroundColorAttributeName : UIColor.init(r: 187, g: 187, b: 187), NSFontAttributeName : UIFont.systemFont(ofSize: 12)])
        attr.append(priceT)
        attr.append(priceStr)
        attr.append(labelStr)
        label.attributedText = attr
        
        return label
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
