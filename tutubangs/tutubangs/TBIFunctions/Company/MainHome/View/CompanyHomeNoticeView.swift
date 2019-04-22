//
//  CompanyHomeNoticeView.swift
//  shop
//
//  Created by SLMF on 2017/4/20.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CompanyHomeNoticeView: UIView,SDCycleScrollViewDelegate{
    
    typealias CompanyHomeNoticeViewSelectedResult = (NSNumber,Array<NoticeInfoResponse.TbiNotice>)->Void
    public  var companyHomeNoticeViewSelectedResult:CompanyHomeNoticeViewSelectedResult!
    
    private var noticeDataSources:[CoNoticeItem] = Array()
    private var noticeTitleLabel: UILabel = UILabel()
    private var backgroundView = UIView()
    private var subBackgroundView = UIView()
    private var cycleScrollView:SDCycleScrollView = SDCycleScrollView()// = SDCycleScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.addSubview(backgroundView)
        backgroundView.backgroundColor = UIColor.white
        backgroundView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        self.backgroundColor = UIColor.white
        noticeTitleLabel.text = "公告"
        noticeTitleLabel.textColor = TBIThemeBlueColor
        noticeTitleLabel.font = UIFont.init(name: "TRENDS", size: 16)
        backgroundView.addSubview(noticeTitleLabel)
        noticeTitleLabel.snp.makeConstraints { (make) in
            
//            make.centerY.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(30)
        }
        subBackgroundView.backgroundColor = UIColor.clear
        backgroundView.addSubview(subBackgroundView)
        subBackgroundView.snp.makeConstraints { (make) in
            //make.top.equalToSuperview().inset(11.5)
            make.left.equalTo(noticeTitleLabel.snp.right).offset(22)
            make.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }
        setUIViewAutolayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUIViewAutolayout() {
        //cycleScrollView = SDCycleScrollView.init(frame: CGRect(x:0,y:0,width:ScreenWindowWidth - 80,height:16), delegate: self, placeholderImage: nil)
        cycleScrollView.scrollDirection = UICollectionViewScrollDirection.vertical
        cycleScrollView.backgroundColor = UIColor.white
        cycleScrollView.onlyDisplayText = true
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
        noticeDataSources = dataSources
        cycleScrollView.titlesGroup = tmpArr
    }
    
    /** 点击图片回调 */
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        print("selcted index",index)
       // companyHomeNoticeViewSelectedResult(NSNumber.init(value: index),noticeDataSources)
    }
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("into here ...")
//    }
    
    
    
}
