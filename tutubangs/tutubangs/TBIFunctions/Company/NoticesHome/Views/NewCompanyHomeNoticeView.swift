//
//  NewCompanyHomeNoticeView.swift
//  shanglvjia
//
//  Created by manman on 2018/3/20.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class NewCompanyHomeNoticeView: UIView,SDCycleScrollViewDelegate{
    
    typealias CompanyHomeNoticeViewSelectedResult = (NSNumber,Array<NoticeInfoResponse.TbiNotice>)->Void
    public  var companyHomeNoticeViewSelectedResult:CompanyHomeNoticeViewSelectedResult!
    
    fileprivate var noticeDataSources:[NoticeInfoResponse.TbiNotice] = Array()
    
    fileprivate var backgroundView = UIView()
    fileprivate var subBackgroundView = UIView()
    fileprivate var cycleScrollView:SDCycleScrollView = SDCycleScrollView()
    
    fileprivate let   iconImage = UIImageView(imageName: "ic_notice")
    
    fileprivate let   line = UILabel(color: TBIThemeGrayLineColor)
    
    fileprivate let   moreLabel: UILabel = UILabel(text: "更多", color: UIColor(r: 252, g: 173, b: 12), size: 12)
    
    fileprivate let   rightImage = UIImageView(imageName: "ic_right_orange")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.addSubview(backgroundView)
        backgroundView.backgroundColor = UIColor.white
        backgroundView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        self.backgroundColor = UIColor.white
        
        backgroundView.addSubview(iconImage)
        iconImage.snp.makeConstraints { (make) in
            make.width.equalTo(32)
            make.height.equalTo(15)
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
        }
        backgroundView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.width.equalTo(0.5)
            make.height.equalTo(25)
            make.left.equalTo(iconImage.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }
        backgroundView.addSubview(rightImage)
        rightImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
            make.width.equalTo(4)
            make.height.equalTo(8)
        }
        backgroundView.addSubview(moreLabel)
        moreLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(rightImage.snp.left).offset(-3)
        }
        subBackgroundView.backgroundColor = UIColor.clear
        backgroundView.addSubview(subBackgroundView)
        subBackgroundView.snp.makeConstraints { (make) in
            make.left.equalTo(line.snp.right).offset(8)
            make.right.equalTo(moreLabel.snp.left).offset(-5)
            make.centerY.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        setUIViewAutolayout()
        moreLabel.addOnClickListener(target: self, action: #selector(moreClick(tap:)))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUIViewAutolayout() {
        cycleScrollView.scrollDirection = UICollectionViewScrollDirection.vertical
        cycleScrollView.backgroundColor = UIColor.white
        cycleScrollView.onlyDisplayText = true
        cycleScrollView.titleLabelTextFont = UIFont.systemFont( ofSize: 12)
        cycleScrollView.delegate = self
        cycleScrollView.titleLabelTextColor = TBIThemePrimaryTextColor
        cycleScrollView.titleLabelBackgroundColor = UIColor.clear
        subBackgroundView.addSubview(cycleScrollView)
        cycleScrollView.snp.makeConstraints { (make) in
            make.left.top.bottom.right.equalToSuperview()
        }
    }
    
    public func reloadDataSources(dataSources:[CoNoticeItem])
    {
        var tmpArr:[String] = Array()
        for element in dataSources {
            
            tmpArr.append(element.title)
        }
        //noticeDataSources = dataSources
        cycleScrollView.titlesGroup = tmpArr
    }
    
    func reloadSVDataSources(dataSources:[NoticeInfoResponse.TbiNotice]) {
        
        var tmpArr:[String] = Array()
        for element in dataSources {
            
            tmpArr.append(element.noticeName)
        }
        noticeDataSources = dataSources
        cycleScrollView.titlesGroup = tmpArr
        
    }
    
    
    func moreClick(tap:UITapGestureRecognizer){
        guard cycleScrollView.titlesGroup.count > 0 else {
            return
        }
        companyHomeNoticeViewSelectedResult(NSNumber.init(value: 0),noticeDataSources)
    }
    /** 点击图片回调 */
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        print("selcted index",index)
        guard cycleScrollView.titlesGroup.count > 0 else {
            return
        }
        companyHomeNoticeViewSelectedResult(NSNumber.init(value: index),noticeDataSources)
    }
}
