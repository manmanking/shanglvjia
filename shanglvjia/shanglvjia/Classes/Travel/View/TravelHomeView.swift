//
//  TravelHomeView.swift
//  shop
//
//  Created by TBI on 2017/7/10.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

//搜索框下的header页面
class TravelHomeHeaderCellView: UIView {
    
    fileprivate let  titleLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    //let  line = UILabel(color: TBIThemeRedColor)
    
    fileprivate let  imgView = UIImageView()
    
    init(title:String , img:String) {
        let frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth/5, height: 87)
        super.init(frame: frame)
        imgView.image = UIImage(named: img)
        titleLabel.text = title
        addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.height.width.equalTo(24)
            make.centerX.equalToSuperview()
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20)
        }
 //       addSubview(line)
//        line.snp.makeConstraints { (make) in
//            make.width.equalTo(titleLabel.snp.width)
//            make.height.equalTo(2)
//            make.bottom.equalToSuperview()
//            make.centerX.equalToSuperview()
//        }
//        line.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// 轮播图页面
class TravelHomeSDCycleCellView: UIView {

    fileprivate let  imgView = UIImageView()
    
    //轮播图
    let sdCycleScrollView:SDCycleScrollView = SDCycleScrollView()
    
    let  moreLabel = UILabel(text: "更多", color: TBIThemeRedColor, size: 13)
    
    let  titleLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 15)
    
    fileprivate let  footerView = UIView()
    
    init() {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        super.init(frame: frame)
        addSubview(sdCycleScrollView)
        sdCycleScrollView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(180)
            make.top.equalTo(44)
        }
        addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(sdCycleScrollView.snp.bottom)
        }
        footerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.height.equalTo(24)
            make.width.equalTo(136)
        }
        moreLabel.textAlignment = .center
        moreLabel.layer.cornerRadius = 5
        moreLabel.layer.borderColor = TBIThemeRedColor.cgColor
        moreLabel.layer.borderWidth = 1
        addSubview(moreLabel)
        moreLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(10)
            make.height.equalTo(22)
            make.width.equalTo(44)
        }
    }
    
    func fillCell(model:TravelAdvListResponse?){
        let data = model?.firstTravelAdvResponse
        imgView.sd_setImage(with: URL.init(string: data?.imgUrl ?? ""))
        titleLabel.text = model?.travelAdvResponseList.first?.title
        if data?.more == nil || data?.more == ""{
            moreLabel.isHidden = true
        }else {
            moreLabel.isHidden = false
        }
        moreLabel.tag = Int(data?.more ?? "6") ?? 6
        moreLabel.textColor = UIColor.init(hexString: data?.color ?? "#FFFFFF")
        moreLabel.layer.borderColor = UIColor.init(hexString: data?.color ?? "#FFFFFF")?.cgColor
        ///设置轮播图数据
        let list = model?.travelAdvResponseList.map{$0.imgUrl ?? ""} ?? [""]
        sdCycleScrollView.imageURLStringsGroup = list
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//scroll headerView
class TravelHomeScrollHeaderView: UIView {
    
    fileprivate let  titleImgView = UIImageView(imageName: "")

    fileprivate let  rightImgView = UIImageView(imageName: "ic_right_blue")

    let  moreLabel = UILabel(text: "更多", color: TBIThemeBlueColor, size: 13)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleImgView)
        titleImgView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(96)
        }
        addSubview(moreLabel)
        moreLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-26)
        }
        addSubview(rightImgView)
        rightImgView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(6)
            make.height.equalTo(8)
        }
        
    }
    
    func fillCell(model:TravelAdvResponse?) {
        titleImgView.sd_setImage(with:  URL.init(string: model?.imgUrl ?? ""))
        if model?.more == nil || model?.more == ""{
            moreLabel.isHidden = true
        }else {
            moreLabel.isHidden = false
        }
        let tintImage =  UIImage.init(named: "ic_right_blue")
        let color =  (model?.color ?? "#FFFFFF").isEmpty ? "#FFFFFF":model?.color
        let newImage = tintImage?.imageWithTintColor(color: UIColor.init(hexString: color ?? "#FFFFFF")!)
        rightImgView.image = newImage
        moreLabel.textColor = UIColor.init(hexString: color ?? "#FFFFFF")
        moreLabel.tag = Int(model?.more ?? "6") ?? 6
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// scroll内容
class TravelHomeScrollContentView: UIView {
    
    fileprivate let  imgView = UIImageView(imageName: "")
    
    fileprivate let  titleLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    fileprivate let  messageLabel = UILabel(text: "", color: TBIThemeMinorTextColor, size: 12)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(85)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(imgView.snp.bottom).offset(8)
        }
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalTo(-9)
        }
        
    }
    
    func fillCell(model:TravelAdvResponse?) {
        imgView.sd_setImage(with:  URL.init(string: model?.imgUrl ?? ""))
        titleLabel.text = model?.title
        messageLabel.text = model?.subtitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// 轮播图页面
class TravelHomeScrollView: UIView {
    
    typealias TravelHomeScrollViewBlock = (Int)->Void
    
    var travelHomeScrollViewBlock:TravelHomeScrollViewBlock!
    
    let headerView:TravelHomeScrollHeaderView = TravelHomeScrollHeaderView()
    
    let scrollView = UIScrollView()
    
    var contentViewList: [TravelHomeScrollContentView] = []
    
    override init(frame: CGRect) {
        let frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 182)
        super.init(frame: frame)
        self.backgroundColor = TBIThemeWhite
        addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(44)
        }
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
    }
    
    func fillCell(model:TravelAdvListResponse?) {
        let list = model?.travelAdvResponseList
        scrollView.contentSize = CGSize.init(width: 135 * (list?.count ?? 1) + 20, height: 0)
        scrollView.showsHorizontalScrollIndicator = false
        self.contentViewList.removeAll()
        headerView.fillCell(model: model?.firstTravelAdvResponse)
        for view in scrollView.subviews{
            view.removeFromSuperview()
        }
        for index in 0..<(list?.count ?? 0) {
            let content = TravelHomeScrollContentView()
            content.fillCell(model: list?[index])
            self.contentViewList.append(content)
            self.scrollView.addSubview(content)
            content.tag = 100 + index
            content.addOnClickListener(target: self, action: #selector(click(tap:)))
        }
        for index in 0..<self.contentViewList.count {
            self.contentViewList[index].snp.makeConstraints{(make) in
                if index > 0 {
                    make.left.equalTo(contentViewList[index - 1].snp.right).offset(10)
                } else {
                    make.left.equalToSuperview().offset(15)
                }
                make.top.height.equalToSuperview()
                make.width.equalTo(125)
            }
        }
    }
    
    func click(tap:UITapGestureRecognizer){
        let vi = tap.view as! TravelHomeScrollContentView
        travelHomeScrollViewBlock(vi.tag - 100)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
