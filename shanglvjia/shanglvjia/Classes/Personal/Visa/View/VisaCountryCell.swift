//
//  VisaCountryCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/11.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class VisaCountryCell: UITableViewCell {

    /// 选择城市 回调
    typealias VisaCountryCellSelectedCountryBlock = (String)->Void
    
    public var visaCountryCellSelectedCountryBlock:VisaCountryCellSelectedCountryBlock!
    
    ///标题按钮的点击回调
    typealias titleClickBlock = (Int) ->Void
    public var tclickBlock:titleClickBlock?
    ///标题按钮的scrollview
    private let scrollView :UIScrollView = UIScrollView()
    private let countryView:UIView = UIView()
    private var selectedContinentButton:MyTitleButton = MyTitleButton()
    
    private var selectedCountryButton:UIButton = UIButton()
    
    private var countryLocalArr:[ContinentModel] = Array()
    
    private var selectedCountryIndex:Int = 0
    
    private var moreChoicesTipDefault:String = "更多"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor=TBIThemeBaseColor
        self.selectionStyle=UITableViewCellSelectionStyle.none
        creatCellUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func creatCellUI(){
        self.addSubview(scrollView)
        self.addSubview(countryView)
        
        scrollView.bounces = false
        scrollView.backgroundColor = TBIThemeWhite
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(45)
        }
        countryView.backgroundColor = TBIThemeWhite
        
    }
    func setCellWithData(contientArr:[ContinentModel],currentContinentIndex:Int,currentCountryIndex:Int)  {
        //titleArray:[String],countryArray:[[String]]
        selectedCountryIndex = currentCountryIndex
        countryLocalArr = contientArr
        CommonTool.removeSubviews(onBgview: scrollView)
        
        let buttonWidth = CGFloat((ScreenWindowWidth - 15 * 2)/4)
        
        if countryLocalArr.count > 4{
            scrollView.contentSize = CGSize(width:30 + buttonWidth*CGFloat(countryLocalArr.count),height:0)
        }
        
        for i in 0...countryLocalArr.count-1 {
            let titileButton:MyTitleButton = MyTitleButton.init(type: UIButtonType.custom)
            titileButton.frame = CGRect(x:15 + (buttonWidth*CGFloat(i)),y:0,width:buttonWidth,height:45)
            titileButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            titileButton.setTitleColor(TBIThemeMinorTextColor, for: .normal)
            titileButton.setTitle(countryLocalArr[i].ctName, for: .normal)
            titileButton.tag = i
            titileButton.addTarget(self, action: #selector(titileButtonClick(sender:)), for: UIControlEvents.touchUpInside)
            scrollView.addSubview(titileButton)
            if i == currentContinentIndex {
                selectedContinentButton = titileButton
                selectedContinentButton.setTitleColor(PersonalThemeMajorTextColor, for: .normal)
                selectedContinentButton.lineLable.isHidden = false
            }
        }
        
        countryView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(scrollView.snp.bottom).offset(1)
            make.bottom.equalToSuperview()
        }
        creatCountryButtons(countryArray:countryLocalArr[currentContinentIndex].data,selectedCountry: currentCountryIndex)
    }
    ///点击标题
    func titileButtonClick(sender:MyTitleButton)  {
        if  selectedContinentButton == sender{
            selectedContinentButton.setTitleColor(PersonalThemeMajorTextColor, for: .normal)
            selectedContinentButton.lineLable.isHidden = false
        }else{
            selectedContinentButton.setTitleColor(TBIThemeMinorTextColor, for: .normal)
            sender.setTitleColor(PersonalThemeMajorTextColor, for: .normal)
            selectedContinentButton.lineLable.isHidden = true
            sender.lineLable.isHidden = false
            selectedContinentButton = sender;
        }
        countryView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(scrollView.snp.bottom).offset(1)
            make.bottom.equalToSuperview()
        }
        tclickBlock?(sender.tag)
        // 选择分类的时候 默认选中第一个国家
        creatCountryButtons(countryArray:countryLocalArr[sender.tag].data,selectedCountry: 0)
        
    }
    
    
    
    
    ///更新下面的国家
    func creatCountryButtons(countryArray:[ContinentModel.CountryModel],selectedCountry:Int)  {
        CommonTool.removeSubviews(onBgview: countryView)
        selectedCountryButton = UIButton()
        let buttonWidth = CGFloat((ScreenWindowWidth - 15 * 2 - 10 * 3)/4)
        for i in 0...countryArray.count-1{
            
            var title:String =  countryArray[i].countryNameCn
            
            
            if i == 7 {
                title = moreChoicesTipDefault
            }
            
            let conButton : UIButton = UIButton.init(title:title, titleColor: TBIThemePrimaryTextColor, titleSize: 13)
            let button_x = 15 + (buttonWidth + 10)*CGFloat(i%4)
            let button_y = 10 * CGFloat((i/4)+1) + CGFloat(30 * (i/4))
            conButton.frame = CGRect(x:button_x,y:button_y,width:buttonWidth,height:30)
            conButton.backgroundColor = TBIThemeBaseColor
            conButton.setBackgroundImage(UIImage(named:"yellow_btn_gradient"), for: UIControlState.selected)
            conButton.setTitleColor(TBIThemeWhite, for: UIControlState.selected)
            
            conButton.addTarget(self, action: #selector(selectedCountryButton(sender:)), for: UIControlEvents.touchUpInside)
            conButton.layer.cornerRadius = 2
            conButton.clipsToBounds = true
            countryView.addSubview(conButton)
            // 默认选中 第一个
            if i == selectedCountry {
                conButton.isSelected = true
                selectedCountryButton = conButton
                
            }
            if i == 7 {
                break
            }
        }
    }
    
    func selectedCountryButton(sender:UIButton) {
        guard sender.isSelected == false else {
            return
        }
        if sender.currentTitle != moreChoicesTipDefault {
            selectedCountryButton.isSelected = false
            sender.isSelected = true
            selectedCountryButton = sender
        }
        if visaCountryCellSelectedCountryBlock != nil {
            visaCountryCellSelectedCountryBlock(sender.currentTitle!)
        }
        
    }
    
    
    
    
}
///标题的按钮
class MyTitleButton: UIButton {
    let lineLable:UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lineLable.backgroundColor = PersonalThemeDarkColor
        self.addSubview(lineLable)
        lineLable.isHidden = true
        lineLable.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(2)
            make.width.equalTo(60)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
