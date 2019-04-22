//
//  PSepcialHotelDetailHeaderCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/31.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PSepcialHotelDetailHeaderCell: UITableViewCell {

    typealias PSepcialHotelDetailHeaderMapNaviBlock = ()->Void
    
    public var sepcialHotelDetailHeaderMapNaviBlock:PSepcialHotelDetailHeaderMapNaviBlock!
    
    
    typealias PSepcialHotelDetailHeaderSelectedDateBlock = (String)->Void
    
    public var sepcialHotelDetailHeaderSelectedDateBlock:PSepcialHotelDetailHeaderSelectedDateBlock!
    
    typealias HotelDetailBlock = ()->Void
    
    public var hotelDetailBlock:HotelDetailBlock!
    
    private var bgView:UIView = UIView()
    private var cycleScrollView: SDCycleScrollView = SDCycleScrollView()
    private var nameLabel = UILabel.init(text: "", color: PersonalThemeMajorTextColor, size: 16)
    private var descLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 12)
    private var blackLabel = UILabel.init(text: "", color: TBIThemeWhite, size: 11)
    
    
    private var mapImageView = UIImageView()
    private var addressBackgroundView:UIView = UIView()
    private var lookMapButton:UIButton = UIButton()
    private var addressLabel = UILabel.init(text: "", color: PersonalThemeMajorTextColor, size: 12)
    
    private var bookDateBackgroundView:UIView = UIView()
    var startDateTitleLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 10)
    var startDateLabel = UILabel.init(text: "", color: PersonalThemeDarkColor, size: 15)
    var endDateTitleLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 10)
    var endDateLabel = UILabel.init(text: "", color: PersonalThemeDarkColor, size: 15)
    var duringLabel = UILabel.init(text: "", color: TBIThemeWhite, size: 12)
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = TBIThemeWhite
        self.selectionStyle = .none
        creatCellView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatCellView() {
        self.contentView.addSubview(cycleScrollView)
        self.contentView.addSubview(bgView)
        
        
        
        cycleScrollView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(276)
        }
        cycleScrollView.addSubview(blackLabel)
        blackLabel.layer.cornerRadius = 11
        blackLabel.clipsToBounds = true
        blackLabel.backgroundColor = TBIThemeBackgroundViewColor
        blackLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(22)
            make.bottom.equalToSuperview().inset(20)
        }
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
        bgView.backgroundColor = TBIThemeWhite
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(cycleScrollView.snp.bottom).offset(-10)
            make.height.equalTo(100)
        }
        bgView.isUserInteractionEnabled = true
        bgView.addOnClickListener(target: self, action: #selector(goToHotelDetail))
       
        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().offset(15)
        }
        bgView.addSubview(descLabel)
        descLabel.numberOfLines = 2
        descLabel.lineBreakMode = .byTruncatingTail
        descLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.bottom.equalToSuperview().inset(15)
        }
        
        let firstGrayLineLabel:UILabel = UILabel()
        firstGrayLineLabel.backgroundColor = TBIThemeBaseColor
        self.contentView.addSubview(firstGrayLineLabel)
        firstGrayLineLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(10)
        }
        
        mapImageView.image = UIImage(named:"p_hotel_map")
        mapImageView.isUserInteractionEnabled = true
        self.contentView.addSubview(mapImageView)
        mapImageView.snp.makeConstraints { (make) in
            make.top.equalTo(firstGrayLineLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(70)
        }
        addressBackgroundView.backgroundColor = TBIThemeWhite
        mapImageView.addSubview(addressBackgroundView)
        addressBackgroundView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(15)
        }
        addressBackgroundView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(100)
        }
        lookMapButton.setTitle("查看地图", for: UIControlState.normal)
        lookMapButton.setTitleColor(PersonalThemeNormalColor, for: UIControlState.normal)
        lookMapButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        lookMapButton.addTarget(self, action: #selector(lookMapAction(sender:)), for: UIControlEvents.touchUpInside)
        addressBackgroundView.addSubview(lookMapButton)
        lookMapButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.height.equalTo(44)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            
        }
        
        let secondGrayLineLabel:UILabel = UILabel()
        secondGrayLineLabel.backgroundColor = TBIThemeBaseColor
        self.contentView.addSubview(secondGrayLineLabel)
        secondGrayLineLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mapImageView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(10)
        }
        bookDateBackgroundView.backgroundColor = TBIThemeWhite
        self.contentView.addSubview(bookDateBackgroundView)
        bookDateBackgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(secondGrayLineLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(70 - 15)
        }
        setBookDateView()
        
        let thirdGrayLineLabel:UILabel = UILabel()
        thirdGrayLineLabel.backgroundColor = TBIThemeBaseColor
        self.contentView.addSubview(thirdGrayLineLabel)
        thirdGrayLineLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(10)
        }

    }
    
    func setBookDateView() {
        
        bookDateBackgroundView.addSubview(startDateTitleLabel)
        bookDateBackgroundView.addSubview(endDateTitleLabel)
        bookDateBackgroundView.addSubview(startDateLabel)
        bookDateBackgroundView.addSubview(endDateLabel)
        bookDateBackgroundView.addSubview(duringLabel)
        
     
        startDateLabel.text = "08-04"
        startDateLabel.font = UIFont.boldSystemFont(ofSize: 15)
        startDateLabel.textAlignment = .center
        startDateLabel.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.height.equalTo(45)
            make.width.equalToSuperview().dividedBy(2)
        }
        startDateLabel.addOnClickListener(target: self, action: #selector(selectedDateClick(tap:)))
        startDateTitleLabel.text = "入住"
        startDateTitleLabel.textAlignment = NSTextAlignment.center
        startDateTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalTo(startDateLabel.snp.centerX)
            make.width.equalTo(60)
        }
        
        
        endDateLabel.text = "08-20"
        endDateLabel.font = UIFont.boldSystemFont(ofSize: 15)
        endDateLabel.textAlignment = .center
        endDateLabel.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.height.equalTo(startDateLabel)
            make.width.equalToSuperview().dividedBy(2)
        }
        endDateLabel.addOnClickListener(target: self, action: #selector(selectedDateClick(tap:)))
        endDateTitleLabel.text = "退房"
        endDateTitleLabel.textAlignment = NSTextAlignment.center
        endDateTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalTo(endDateLabel.snp.centerX)
            make.width.equalTo(60)
        }
        
        duringLabel.text = ""
        duringLabel.backgroundColor = PersonalThemeNormalColor
        duringLabel.layer.cornerRadius = 10
        duringLabel.clipsToBounds = true
        duringLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
    }
    
    
    
    /// 定投酒店
    public  func fillPersonalSpecialHotelDataSources(item:SpecialHotelListResponse.SpecialHotelInfo,checkInDate:Date,checkOutDate:Date){
        
        cycleScrollView.placeholderImage = UIImage(named:"bg_default_travel")
        cycleScrollView.imageURLStringsGroup = [item.cover]
        nameLabel.text = item.hotelName
        
        //var htmlText = "空は<font color=\"blue\">青い</font>。<br>An apple is <font color=\"red\">red</font>."
        do{
            let attrStr = try NSAttributedString(data: item.hotelDesc.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            
            descLabel.attributedText = attrStr
        }catch let error as NSError {
            print(error.localizedDescription)
        }
        
        //descLabel.text = item.hotelDesc
        blackLabel.text = "    " + "集中修养供应商特别定制" + "    "
        addressLabel.text = "地址:" + item.address
        
        let dateFormatterString = DateFormatter()
        dateFormatterString.dateFormat = "MM月dd日"
        startDateLabel.text = dateFormatterString.string(from: checkInDate)
        endDateLabel.text = dateFormatterString.string(from: checkOutDate)
        duringLabel.text = "  " + caculateIntervalDay(fromDate: checkInDate, toDate: checkOutDate).description + "晚  "
    }
    
    public  func fillPersonalNormalHotelDataSources(item:HotelListNewItem,checkInDate:Date,checkOutDate:Date){
        cycleScrollView.imageURLStringsGroup = [item.cover]
        nameLabel.text = item.hotelName
        do{
            let attrStr = try NSAttributedString(data: item.hotelDesc.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            
            descLabel.attributedText = attrStr
        }catch let error as NSError {
            print(error.localizedDescription)
        }
        
        //descLabel.text = item.hotelDesc
        blackLabel.text = "    " + "集中修养供应商特别定制" + "    "
        addressLabel.text = "地址:" + item.hotelAddress
        printDebugLog(message: "hotelAddress in here")
        printDebugLog(message: item.hotelAddress)
        
        let dateFormatterString = DateFormatter()
        dateFormatterString.dateFormat = "MM月dd日"
        startDateLabel.text = dateFormatterString.string(from: checkInDate)
        endDateLabel.text = dateFormatterString.string(from: checkOutDate)
        duringLabel.text = "  " + caculateIntervalDay(fromDate: checkInDate, toDate: checkOutDate).description + "晚  "
    }
    
    private func caculateIntervalDay(fromDate:Date,toDate:Date) -> NSInteger {
        
        let calendar = NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)
        let result = calendar?.components(NSCalendar.Unit.day, from: fromDate, to: toDate, options: NSCalendar.Options.matchFirst)
        
        return (result?.day)!
    }
    
    //MARK:------Action-----
    @objc private func lookMapAction(sender:UIButton) {
        if sepcialHotelDetailHeaderMapNaviBlock != nil {
            sepcialHotelDetailHeaderMapNaviBlock()
        }
    }
    
    @objc private func selectedDateClick(tap:UITapGestureRecognizer){
        
        if sepcialHotelDetailHeaderSelectedDateBlock != nil {
            sepcialHotelDetailHeaderSelectedDateBlock("")
        }
        
        
    }
    
    func goToHotelDetail(){
        if hotelDetailBlock != nil{
            hotelDetailBlock()
        }
    }
    
    
}
