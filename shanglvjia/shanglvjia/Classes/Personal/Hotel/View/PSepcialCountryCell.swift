//
//  PSepcialCountryCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/30.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PSepcialCountryCell: UITableViewCell {

    ///标题按钮的点击回调
    typealias TitleClickBlock = (String) ->Void
    public var tclickBlock:TitleClickBlock!
    /// 选择城市 回调
    typealias HotelCityCellSelectedBlock = (String,String)->Void
    public var hotelCityCellSelectedBlock:HotelCityCellSelectedBlock!
    /// 选择星级 回调
    typealias HotelStarsCellSelectedBlock = (String)->Void
    public var hotelStarsCellSelectedBlock:HotelStarsCellSelectedBlock!
    
    ///标题按钮的scrollview
    private let countryView:UIView = UIView()
    private let starView:UIView = UIView()
    private var selectedContinentButton:UIButton = UIButton()
    private let titleArr = ["国内","国际"]
    private let starArr:[(title:String,content:String)] = [("五星","5"),("四星","4"),("三星","3"),("三星以下","2,1")]
    private let lineLabel = UILabel()
    
    private let choicesMoreCityTipDefault:String = "更多"
    
    private var selectedCityButton:UIButton = UIButton()
    private var selectedStarButton:UIButton = UIButton()
    
    private var cityLocalArr:[HotelCityModel] = Array()
    
    private var headerView:UIImageView = UIImageView()
    
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
        self.backgroundColor=UIColor.clear
        self.selectionStyle=UITableViewCellSelectionStyle.none
        self.addSubview(initHeaderView())
        creatCellUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func creatCellUI(){
        self.addSubview(countryView)
        self.addSubview(lineLabel)
        self.addSubview(starView)
        
        let buttonWidth = CGFloat(ScreenWindowWidth/2)
        
        for i in 0...titleArr.count-1 {
            let titileButton:UIButton = UIButton.init(type: UIButtonType.custom)
            titileButton.frame = CGRect(x:0 + (buttonWidth*CGFloat(i)),y:CGFloat(140 + kNavigationHeight - 44),width:buttonWidth,height:45)
            titileButton.backgroundColor = TBIThemeBackgroundViewColor
            titileButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            titileButton.setTitleColor(TBIThemeWhite, for: .normal)
            titileButton.setTitle(titleArr[i], for: .normal)
            titileButton.tag = i
            titileButton.addTarget(self, action: #selector(titileButtonClick(sender:)), for: UIControlEvents.touchUpInside)
            self.addSubview(titileButton)
            if i == 0 { //默认 选中 国内
                selectedContinentButton = titileButton
                selectedContinentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
                selectedContinentButton.setBackgroundImage(UIImage(named:"ic_car_pickup"), for: .normal)
                selectedContinentButton.setTitleColor(PersonalThemeMajorTextColor, for: .normal)
                //selectedContinentButton.lineLable.isHidden = false
            }
        }
        
//        lineLabel.backgroundColor = TBIThemeGrayLineColor
//        lineLabel.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview()
//            make.top.equalTo(44)
//            make.height.equalTo(0.5)
//        }
        
        countryView.backgroundColor = TBIThemeWhite
        countryView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(140 + kNavigationHeight)
            make.bottom.equalToSuperview()
        }
        starView.backgroundColor = TBIThemeWhite
        starView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        
    }
    func setCellWithData(contientArr:[HotelCityModel],currentContinentIndex:String,currentCountryIndex:Int)
    {
        // 国内 1 国际 2 currentContinentIndex
        cityLocalArr = contientArr
        //creatCountryButtons(selectedCountry: 0)
        if currentContinentIndex == "1" {
            creatCountryButtons(selectedCountry: currentCountryIndex)
            creatStarButtons(selectedStar:9)
        }else{
            creatCountryButtons(selectedCountry: currentCountryIndex)
            creatStarButtons(selectedStar:9)
        }
    }
    ///点击标题
    func titileButtonClick(sender:UIButton)  {
        // 选择分类的时候 默认选中第一个国家
        // 国际 不可以设置 默认
        
        if  selectedContinentButton == sender{
            selectedContinentButton.setTitleColor(PersonalThemeMajorTextColor, for: .normal)
            selectedContinentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            //selectedContinentButton.lineLable.isHidden = false
        }else{
            selectedContinentButton.setTitleColor(TBIThemeWhite, for: .normal)
            selectedContinentButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            selectedContinentButton.setBackgroundImage(UIImage(named:""), for: .normal)
            //翻转图片的方向
             let selectImage = UIImage(named:"ic_car_pickup")
            let flipImageOrientation = ((selectImage?.imageOrientation.rawValue)! + 4) % 8
            let flipImage =  UIImage.init(cgImage: (selectImage?.cgImage)!, scale: (selectImage?.scale)!, orientation: UIImageOrientation(rawValue: flipImageOrientation)!)
            sender.setBackgroundImage((sender.tag == 1 ? flipImage : selectImage), for: .normal)
            
            sender.setTitleColor(PersonalThemeMajorTextColor, for: .normal)
            sender.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            //selectedContinentButton.lineLable.isHidden = true
            //sender.lineLable.isHidden = false
            selectedContinentButton = sender;
        }
        var selectedIndex:String = "1"
        
        if sender.currentTitle == titleArr.last {
            selectedIndex = "2"
        }
        tclickBlock(selectedIndex)
        
       
        
        
        
    }
    ///更新下面的国家
    func creatCountryButtons(selectedCountry:Int)  {
        
        //CommonTool.removeSubviews(onBgview: countryView)
        for element in countryView.subviews {
            element.removeFromSuperview()
        }
        let cityLabel = UILabel.init(text: "城市:", color: PersonalThemeMajorTextColor, size: 13)
        cityLabel.frame = CGRect(x:15,y:10,width:40,height:30)
        countryView.addSubview(cityLabel)
        
        selectedCityButton = UIButton()
        let buttonWidth = CGFloat((ScreenWindowWidth - 15 * 2 - 10 * 3 - 40)/4)
        for i in 0...cityLocalArr.count-1{
            let conButton : UIButton = UIButton.init(title: cityLocalArr[i].cnName, titleColor: TBIThemePrimaryTextColor, titleSize: 13)
            let button_x = 15 + (buttonWidth + 10)*CGFloat(i%4)
            let button_y = 10 * CGFloat((i/4)+1) + CGFloat(30 * (i/4))
            conButton.frame = CGRect(x:40 + button_x,y:button_y,width:buttonWidth,height:30)
            conButton.backgroundColor = TBIThemeBaseColor
            conButton.setBackgroundImage(UIImage(named:"yellow_btn_gradient"), for: UIControlState.selected)
            conButton.setTitleColor(TBIThemeWhite, for: UIControlState.selected)
            
            conButton.addTarget(self, action: #selector(selectedCitysButton(sender:)), for: UIControlEvents.touchUpInside)
            conButton.layer.cornerRadius = 2
            conButton.clipsToBounds = true
            countryView.addSubview(conButton)
            // 默认选中 第一个
            if i == selectedCountry  {
                conButton.isSelected = true
                selectedCityButton = conButton
                
            }
        }
    }
    func selectedCitysButton(sender:UIButton) {
        var cityCode:String = ""
        var cityName:String = ""
        var cityButtonStatus:Bool = sender.isSelected
        
        let isSameButton:Bool = sender.currentTitle == selectedCityButton.currentTitle ?? "" ? true : false
        
        //选中状态 变为 非选中
        if cityButtonStatus && isSameButton {
            selectedCityButton.isSelected = false
            cityCode = ""
            cityName = ""
        }else{
            if cityButtonStatus == false && sender.isSelected == false {
                for element in cityLocalArr{
                    if element.cnName == sender.currentTitle {
                        cityCode = element.elongId
                        cityName = sender.currentTitle!
                        break
                    }
                }
                selectedCityButton.isSelected = false
                sender.isSelected = true
                selectedCityButton = sender
            }
        }
        if sender.currentTitle == choicesMoreCityTipDefault {
            selectedCityButton.isSelected = false
            cityCode = ""
            cityName = choicesMoreCityTipDefault
        }
        
        if hotelCityCellSelectedBlock != nil {
            hotelCityCellSelectedBlock(cityName,cityCode)
        }
        
    }
    
    ///更新星级
    func creatStarButtons(selectedStar:Int)  {
        CommonTool.removeSubviews(onBgview: starView)
        let cityLabel = UILabel.init(text: "星级:", color: PersonalThemeMajorTextColor, size: 13)
        cityLabel.frame = CGRect(x:15,y:0,width:40,height:30)
        starView.addSubview(cityLabel)
        
        selectedStarButton = UIButton()
        let buttonWidth = CGFloat((ScreenWindowWidth - 15 * 2 - 10 * 3 - 40)/4)
        for i in 0...starArr.count-1{
            let conButton : UIButton = UIButton.init(title: starArr[i].title, titleColor: TBIThemePrimaryTextColor, titleSize: 13)
            let button_x = 15 + (buttonWidth + 10)*CGFloat(i%4)
            let button_y = 10 * CGFloat((i/4)) + CGFloat(30 * (i/4))
            conButton.frame = CGRect(x:40 + button_x,y:button_y,width:buttonWidth,height:30)
            conButton.backgroundColor = TBIThemeBaseColor
            conButton.setBackgroundImage(UIImage(named:"yellow_btn_gradient"), for: UIControlState.selected)
            conButton.setTitleColor(TBIThemeWhite, for: UIControlState.selected)
            
            conButton.addTarget(self, action: #selector(selectedStarsButton(sender:)), for: UIControlEvents.touchUpInside)
            conButton.layer.cornerRadius = 2
            conButton.clipsToBounds = true
            starView.addSubview(conButton)
//            // 默认选中 第一个
//            if i == selectedStar {
//                conButton.isSelected = true
//                selectedStarButton = conButton
//
//            }
        }
    }
    func selectedStarsButton(sender:UIButton) {
     
        var selectedContent:String = ""
        var starButtonStatus:Bool = sender.isSelected
        
        let isSameButton:Bool = sender.currentTitle == selectedStarButton.currentTitle ?? "" ? true : false
        
        if isSameButton && selectedStarButton.isSelected {
            selectedStarButton.isSelected = false
            selectedContent = ""
        }else{
            for element in starArr {
                if element.title == sender.currentTitle {
                    selectedContent = element.content
                }
            }
            selectedStarButton.isSelected = false
            sender.isSelected = true
            selectedStarButton = sender
        }
        
        if hotelStarsCellSelectedBlock != nil {
            hotelStarsCellSelectedBlock(selectedContent)
        }
        
        
//
//        selectedStarButton.isSelected = false
//        sender.isSelected = true
//        selectedStarButton = sender
//
//        if hotelStarsCellSelectedBlock != nil {
//
//            var selectedContent:String = ""
//            for element in starArr {
//                if element.title == sender.currentTitle {
//                    selectedContent = element.content
//                }
//            }
//            hotelStarsCellSelectedBlock(selectedContent)
//        }
        
    }
    /// 广告头
    func initHeaderView() -> UIView {
        headerView.frame = CGRect(x: 0, y: 0, width: Int(ScreenWindowWidth), height: 140 + kNavigationHeight)
        headerView.sd_setImage(with: URL.init(string:"\(Html_Base_Url)/static/banner/subpage/hotel/ios/banner_hotel@3x.png"))
        return headerView
    }
}
