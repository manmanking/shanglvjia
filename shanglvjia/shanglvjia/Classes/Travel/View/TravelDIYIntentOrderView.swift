//
//  TravelDIYIntentOrderView.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/7/6.
//  Copyright © 2017年 TBI. All rights reserved.
//

//定制旅游意向单View

import UIKit
import RxSwift

class TravelDIYIntentOrderView: UIView
{
//    let bag = DisposeBag()
//    //定制旅游意向单 提交实体
//    let travelOrderForm:TravelDIYIntentOrder = TravelDIYIntentOrder()
    
    let myScrollView = UIScrollView()
    let myScrollContentView:UIView = UIView()
    
    var mDiyDemandContentPlaceHolderLabel:UILabel! = nil
    
    //part1 ***
    //旅行目的地
    let travelArrivePlaceRightField = UITextField(placeholder: "输入您的旅行目的地，可填多个", fontSize: 13)
    //出发城市
    let startCityContainer = UIView()
    let startCityRightField = UITextField(placeholder: "选择您的出发城市", fontSize: 13)
    //出发日期
    let startDateContainer = UIView()
    let startDateRightField = UITextField(placeholder: "选择您的出发日期", fontSize: 13)
    //同行人数
    let ansyPeopleNumRightStepper = TBIStepper()
    //游玩天数
    let playDayNumRightStepper = TBIStepper()
    //人均预算
    let travelAveCostRightField = UITextField(placeholder: "输入您的人均预算，单位为元", fontSize: 13)
    //特殊需求说明的内容View
    let diyDemandContentTextView = UITextView()
    
    //part 2 ***
    //称呼
    let travelNameRightField = UITextField(placeholder: "输入您的称呼", fontSize: 13)
    //手机号码
    let travelPhoneRightField = UITextField(placeholder: "输入您的手机号码", fontSize: 13)
    //邮箱
    let travelEmailRightField = UITextField(placeholder: "输入您的邮箱", fontSize: 13)
    
    //最底部的按钮🔘
    let bottomCommitBtn = UIButton(title: "提交", titleColor: .white, titleSize: 18)
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    func initView() -> Void
    {
        ansyPeopleNumRightStepper.minNum = 1
        playDayNumRightStepper.minNum  = 1
        ansyPeopleNumRightStepper.currentValue = 1
        playDayNumRightStepper.currentValue  = 1
        myScrollView.backgroundColor = TBIThemeBaseColor
        //myScrollContentView.backgroundColor = TBIThemeBaseColor
        
        //ScrollView
        self.addSubview(myScrollView)
        self.myScrollView.snp.makeConstraints{(make)->Void in
            make.left.right.top.bottom.equalTo(0)
        }
        //ScrollView的内容的容器View
        self.myScrollView.addSubview(self.myScrollContentView)
        self.myScrollContentView.snp.makeConstraints{(make)->Void in
            make.left.right.top.bottom.equalTo(0)
            
            make.width.equalTo(ScreenWindowWidth)
        }
        
        
        //内部的内容
        let topImageView = UIImageView(imageName: "bg_banner_customized_travel")
        self.myScrollContentView.addSubview(topImageView)
        topImageView.snp.makeConstraints{(make)->Void in
            make.left.right.top.equalTo(0)
            make.height.equalTo(170)
        }
        
        //******内容的第一部分 1
        let myContentViewPart1 = UIView()
        self.myScrollContentView.addSubview(myContentViewPart1)
        myContentViewPart1.backgroundColor = .white
        myContentViewPart1.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(topImageView.snp.bottom).offset(10)
        }
        //旅行目的地  part1
        let travelArrivePlaceContainer = UIView()
        myContentViewPart1.addSubview(travelArrivePlaceContainer)
        travelArrivePlaceContainer.snp.makeConstraints{(make)->Void in
            make.left.right.top.equalTo(0)
            make.height.equalTo(44)
        }
        let travelArrivePlaceLeftLabel = UILabel(text: "旅行目的地", color: TBIThemePrimaryTextColor, size: 13)
        travelArrivePlaceContainer.addSubview(travelArrivePlaceLeftLabel)
        travelArrivePlaceLeftLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
        }
        //let travelArrivePlaceRightField = UITextField(placeholder: "输入您的旅行目的地，可填多个", fontSize: 13)
        travelArrivePlaceContainer.addSubview(travelArrivePlaceRightField)
        travelArrivePlaceRightField.snp.makeConstraints{(make)->Void in
            make.left.equalTo(100)
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        let travelArrivePlaceBottomSegLine = UIView()
        travelArrivePlaceContainer.addSubview(travelArrivePlaceBottomSegLine)
        travelArrivePlaceBottomSegLine.backgroundColor = TBIThemeGrayLineColor
        travelArrivePlaceBottomSegLine.snp.makeConstraints{(make)->Void in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        //出发城市  part1
        //let startCityContainer = UIView()
        myContentViewPart1.addSubview(startCityContainer)
        startCityContainer.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(travelArrivePlaceContainer.snp.bottom)
            make.height.equalTo(44)
        }
        let startCityLeftLabel = UILabel(text: "出发城市", color: TBIThemePrimaryTextColor, size: 13)
        startCityContainer.addSubview(startCityLeftLabel)
        startCityLeftLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
        }
        //let startCityRightField = UITextField(placeholder: "选择您的出发城市", fontSize: 13)
        startCityRightField.isEnabled = false
        startCityContainer.addSubview(startCityRightField)
        startCityRightField.snp.makeConstraints{(make)->Void in
            make.left.equalTo(100)
            make.right.equalTo(-30)
            make.centerY.equalToSuperview()
        }
        let startCityRightArrow = UIImageView(imageName: "ic_right_grey")
        startCityContainer.addSubview(startCityRightArrow)
        startCityRightArrow.snp.makeConstraints{(make)->Void in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        let startCityBottomSegLine = UIView()
        startCityContainer.addSubview(startCityBottomSegLine)
        startCityBottomSegLine.backgroundColor = TBIThemeGrayLineColor
        startCityBottomSegLine.snp.makeConstraints{(make)->Void in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        //出发日期  part1
        //let startDateContainer = UIView()
        myContentViewPart1.addSubview(startDateContainer)
        startDateContainer.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(startCityContainer.snp.bottom)
            make.height.equalTo(44)
        }
        let startDateLeftLabel = UILabel(text: "出发日期", color: TBIThemePrimaryTextColor, size: 13)
        startDateContainer.addSubview(startDateLeftLabel)
        startDateLeftLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
        }
        //let startDateRightField = UITextField(placeholder: "选择您的出发日期", fontSize: 13)
        startDateRightField.isEnabled = false
        startDateContainer.addSubview(startDateRightField)
        startDateRightField.snp.makeConstraints{(make)->Void in
            make.left.equalTo(100)
            make.right.equalTo(-30)
            make.centerY.equalToSuperview()
        }
        let startDateRightArrow = UIImageView(imageName: "ic_right_grey")
        startDateContainer.addSubview(startDateRightArrow)
        startDateRightArrow.snp.makeConstraints{(make)->Void in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        let startDateBottomSegLine = UIView()
        startDateContainer.addSubview(startDateBottomSegLine)
        startDateBottomSegLine.backgroundColor = TBIThemeGrayLineColor
        startDateBottomSegLine.snp.makeConstraints{(make)->Void in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        //同行人数 part1
        let ansyPeopleNumContainer = UIView()
        myContentViewPart1.addSubview(ansyPeopleNumContainer)
        ansyPeopleNumContainer.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(startDateContainer.snp.bottom)
            make.height.equalTo(44)
        }
        let ansyPeopleNumLeftLabel = UILabel(text: "出行人数", color: TBIThemePrimaryTextColor, size: 13)
        ansyPeopleNumContainer.addSubview(ansyPeopleNumLeftLabel)
        ansyPeopleNumLeftLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
        }
        //let ansyPeopleNumRightStepper = TBIStepper()
        ansyPeopleNumContainer.addSubview(ansyPeopleNumRightStepper)
        ansyPeopleNumRightStepper.snp.makeConstraints{(make)->Void in
            make.width.equalTo(83)
            make.height.equalTo(25)
            
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        let ansyPeopleNumBottomSegLine = UIView()
        ansyPeopleNumContainer.addSubview(ansyPeopleNumBottomSegLine)
        ansyPeopleNumBottomSegLine.backgroundColor = TBIThemeGrayLineColor
        ansyPeopleNumBottomSegLine.snp.makeConstraints{(make)->Void in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        //游玩天数 part1
        let playDayNumContainer = UIView()
        myContentViewPart1.addSubview(playDayNumContainer)
        playDayNumContainer.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(ansyPeopleNumContainer.snp.bottom)
            make.height.equalTo(44)
        }
        let playDayNumLeftLabel = UILabel(text: "游玩天数", color: TBIThemePrimaryTextColor, size: 13)
        playDayNumContainer.addSubview(playDayNumLeftLabel)
        playDayNumLeftLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
        }
        //let playDayNumRightStepper = TBIStepper()
        playDayNumContainer.addSubview(playDayNumRightStepper)
        playDayNumRightStepper.snp.makeConstraints{(make)->Void in
            make.width.equalTo(80)
            make.height.equalTo(25)
            
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        let playDayNumBottomSegLine = UIView()
        playDayNumContainer.addSubview(playDayNumBottomSegLine)
        playDayNumBottomSegLine.backgroundColor = TBIThemeGrayLineColor
        playDayNumBottomSegLine.snp.makeConstraints{(make)->Void in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        //人均预算  part1
        let travelAveCostContainer = UIView()
        myContentViewPart1.addSubview(travelAveCostContainer)
        travelAveCostContainer.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(playDayNumContainer.snp.bottom)
            make.height.equalTo(44)
        }
        let travelAveCostLeftLabel = UILabel(text: "人均预算", color: TBIThemePrimaryTextColor, size: 13)
        travelAveCostContainer.addSubview(travelAveCostLeftLabel)
        travelAveCostLeftLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
        }
        //let travelAveCostRightField = UITextField(placeholder: "输入您的人均预算，单位为元", fontSize: 13)
        travelAveCostRightField.keyboardType = .decimalPad
        travelAveCostContainer.addSubview(travelAveCostRightField)
        travelAveCostRightField.snp.makeConstraints{(make)->Void in
            make.left.equalTo(100)
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        let travelAveCostBottomSegLine = UIView()
        travelAveCostContainer.addSubview(travelAveCostBottomSegLine)
        travelAveCostBottomSegLine.backgroundColor = TBIThemeGrayLineColor
        travelAveCostBottomSegLine.snp.makeConstraints{(make)->Void in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        //特殊需求说明
        // 特殊需求说明:上方的标题
        let diyDemandTitleContainer = UIView()
        myContentViewPart1.addSubview(diyDemandTitleContainer)
        diyDemandTitleContainer.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(travelAveCostContainer.snp.bottom)
            make.height.equalTo(37)
        }
        let diyDemandTitleLabel = UILabel(text: "特殊需求说明", color: TBIThemePrimaryTextColor, size: 13)
        diyDemandTitleContainer.addSubview(diyDemandTitleLabel)
        diyDemandTitleLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            //make.width.equalTo(80)
        }
        let diyDemandTitleBottomSegLine = UIView()
        diyDemandTitleContainer.addSubview(diyDemandTitleBottomSegLine)
        diyDemandTitleBottomSegLine.backgroundColor = TBIThemeGrayLineColor
        diyDemandTitleBottomSegLine.snp.makeConstraints{(make)->Void in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
        //特殊需求说明:下方的内容
        let diyDemandContentContainer = UIView()
        //diyDemandContentContainer.backgroundColor = .green
        myContentViewPart1.addSubview(diyDemandContentContainer)
        diyDemandContentContainer.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
            make.top.equalTo(diyDemandTitleContainer.snp.bottom)
            make.height.equalTo(115)
        }
        
        //let diyDemandContentTextView = UITextView()
        diyDemandContentContainer.addSubview(diyDemandContentTextView)
        diyDemandContentTextView.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(15)
            make.bottom.equalTo(-15)
        }
        diyDemandContentTextView.textColor = TBIThemePrimaryTextColor
        diyDemandContentTextView.font = UIFont.systemFont(ofSize: 13)
        diyDemandContentTextView.delegate = self
        //设置diyDemandContentTextView的placeHolderText
        let diyDemandContentPlaceHolderLabel = UILabel(text: "输入您的特殊需求", color: TBIThemeTipTextColor, size: 13)
        self.mDiyDemandContentPlaceHolderLabel = diyDemandContentPlaceHolderLabel
        diyDemandContentContainer.addSubview(diyDemandContentPlaceHolderLabel)
        diyDemandContentPlaceHolderLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(18)
            make.top.equalTo(21)
        }
        
        
        //******内容的第二部分 2
        let myContentViewPart2 = UIView()
        self.myScrollContentView.addSubview(myContentViewPart2)
        myContentViewPart2.backgroundColor = .white
        myContentViewPart2.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(myContentViewPart1.snp.bottom).offset(10)
        }
        //称呼  part2
        let travelNameContainer = UIView()
        myContentViewPart2.addSubview(travelNameContainer)
        travelNameContainer.snp.makeConstraints{(make)->Void in
            make.left.right.top.equalTo(0)
            make.height.equalTo(44)
        }
        let travelNameLeftLabel = UILabel(text: "称呼", color: TBIThemePrimaryTextColor, size: 13)
        travelNameContainer.addSubview(travelNameLeftLabel)
        travelNameLeftLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
        }
        //let travelNameRightField = UITextField(placeholder: "输入您的称呼", fontSize: 13)
        travelNameContainer.addSubview(travelNameRightField)
        travelNameRightField.snp.makeConstraints{(make)->Void in
            make.left.equalTo(100)
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        let travelNameBottomSegLine = UIView()
        travelNameContainer.addSubview(travelNameBottomSegLine)
        travelNameBottomSegLine.backgroundColor = TBIThemeGrayLineColor
        travelNameBottomSegLine.snp.makeConstraints{(make)->Void in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        //手机号码  part2
        let travelPhoneContainer = UIView()
        myContentViewPart2.addSubview(travelPhoneContainer)
        travelPhoneContainer.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(travelNameContainer.snp.bottom)
            make.height.equalTo(44)
        }
        let travelPhoneLeftLabel = UILabel(text: "手机号码", color: TBIThemePrimaryTextColor, size: 13)
        travelPhoneContainer.addSubview(travelPhoneLeftLabel)
        travelPhoneLeftLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
        }
        //let travelPhoneRightField = UITextField(placeholder: "输入您的手机号码", fontSize: 13)
        travelPhoneRightField.keyboardType = .phonePad
        travelPhoneContainer.addSubview(travelPhoneRightField)
        travelPhoneRightField.snp.makeConstraints{(make)->Void in
            make.left.equalTo(100)
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        let travelPhoneBottomSegLine = UIView()
        travelPhoneContainer.addSubview(travelPhoneBottomSegLine)
        travelPhoneBottomSegLine.backgroundColor = TBIThemeGrayLineColor
        travelPhoneBottomSegLine.snp.makeConstraints{(make)->Void in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        //邮箱📮  part2
        let travelEmailContainer = UIView()
        myContentViewPart2.addSubview(travelEmailContainer)
        travelEmailContainer.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
            make.top.equalTo(travelPhoneContainer.snp.bottom)
            make.height.equalTo(44)
        }
        let travelEmailLeftLabel = UILabel(text: "邮箱", color: TBIThemePrimaryTextColor, size: 13)
        travelEmailContainer.addSubview(travelEmailLeftLabel)
        travelEmailLeftLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
        }
        //let travelEmailRightField = UITextField(placeholder: "输入您的邮箱", fontSize: 13)
        travelEmailRightField.keyboardType = .emailAddress
        travelEmailContainer.addSubview(travelEmailRightField)
        travelEmailRightField.snp.makeConstraints{(make)->Void in
            make.left.equalTo(100)
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        
        //******内容的第三部分 3
        let myContentViewPart3 = UIView()
        self.myScrollContentView.addSubview(myContentViewPart3)
        myContentViewPart3.backgroundColor = .white
        myContentViewPart3.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(myContentViewPart2.snp.bottom).offset(10)
            make.height.equalTo(27)
        }
        let leftHintImageView = UIImageView(imageName: "ic_hotel_remark")
        myContentViewPart3.addSubview(leftHintImageView)
        leftHintImageView.snp.makeConstraints{(make)->Void in
            make.width.height.equalTo(14)
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        let rightTextLabel = UILabel(text: "您提交需求后，专属服务人员会与您联系，确认信息以及价格。", color: TBIThemeTipTextColor, size: 11)
        myContentViewPart3.addSubview(rightTextLabel)
        rightTextLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(leftHintImageView.snp.right).offset(5)
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        //最底部的按钮🔘
        //let bottomCommitBtn = UIButton(title: "提交", titleColor: .white, titleSize: 18)
        bottomCommitBtn.backgroundColor = TBIThemeOrangeColor
        bottomCommitBtn.layer.cornerRadius = 5
        self.myScrollContentView.addSubview(bottomCommitBtn)
        bottomCommitBtn.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(myContentViewPart3.snp.bottom).offset(15)
            make.height.equalTo(47)
            
            make.bottom.equalTo(-15)
        }
    }
    
}


extension TravelDIYIntentOrderView:UITextViewDelegate
{
    public func textViewDidChange(_ textView: UITextView)
    {
        //print("textViewDidChange   \(textView.text)")
        if (textView.text == nil) || (textView.text == "")
        {
            self.mDiyDemandContentPlaceHolderLabel.text = "输入您的特殊需求"
        }
        else
        {
            self.mDiyDemandContentPlaceHolderLabel.text = ""
        }
    }
}





