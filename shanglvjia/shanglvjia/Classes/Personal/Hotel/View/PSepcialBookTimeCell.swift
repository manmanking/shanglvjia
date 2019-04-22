//
//  PSepcialBookTimeCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/30.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PSepcialBookTimeCell: UITableViewCell {
    
    
    typealias PSepcialBookTimeSelectedDateBlock = (String)->Void
    
    public var sepcialBookTimeSelectedDateBlock:PSepcialBookTimeSelectedDateBlock!

    var hotelBookController:PHotelBookInfoViewController = PHotelBookInfoViewController()
    var hotelDetailController:PHotelDetailViewController = PHotelDetailViewController()
    
    var startDateLabel = UILabel.init(text: "", color: PersonalThemeDarkColor, size: 15)
    var endDateLabel = UILabel.init(text: "", color: PersonalThemeDarkColor, size: 15)
    var duringLabel = UILabel.init(text: "", color: TBIThemeWhite, size: 12)
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
        self.backgroundColor = TBIThemeWhite
        self.selectionStyle = .none
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView(){
        self.addSubview(startDateLabel)
        self.addSubview(endDateLabel)
        self.addSubview(duringLabel)
        
        startDateLabel.numberOfLines = 2
        startDateLabel.textAlignment = .center
        startDateLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalToSuperview().dividedBy(2)
        }
        
        endDateLabel.numberOfLines = 2
        endDateLabel.textAlignment = .center
        endDateLabel.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        
        duringLabel.backgroundColor = PersonalThemeNormalColor
        duringLabel.layer.cornerRadius = 10
        duringLabel.clipsToBounds = true
        duringLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    func fillDataSources(checkInDate:Date,checkOutDate:Date) {
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
    
    

    func startTimeLabelClick(tap:UITapGestureRecognizer){
        
        if sepcialBookTimeSelectedDateBlock != nil {
            sepcialBookTimeSelectedDateBlock("")
        }
        
       
//        hotelBookController.navigationController?.pushViewController(calendarView, animated: true)
//        hotelDetailController.navigationController?.pushViewController(calendarView, animated: true )
    }
    private func searchDate(parameters:Array<String>?,action:TBICalendarAction) {
        guard action == TBICalendarAction.Done else {
            return
        }
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let searchCondition:HotelListRequest = HotelManager.shareInstance.searchConditionUserDraw()
        searchCondition.arrivalDateFormat = (parameters?[0])!
        searchCondition.departureDateFormat = (parameters?[1])!
        searchCondition.arrivalDate = (NSInteger(formatter.date(from:(parameters?[0])!)?.timeIntervalSince1970 ?? 0) * 1000).description
        searchCondition.departureDate = (NSInteger(formatter.date(from:(parameters?[1])!)?.timeIntervalSince1970 ?? 0) * 1000).description
        
        HotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        
        let travelStartDate:Date = formatter.date(from:(parameters?[0])!) ?? Date()
        let travelEndDate:Date = formatter.date(from:(parameters?[1])!) ?? Date()
        let dateFormatterString = DateFormatter()
        dateFormatterString.dateFormat = "MM-dd"
        
//        startTimeLabel.attributedText = returnAttributeString(str:"入住\n" + dateFormatterString.string(from: travelStartDate))
//        endTimeLabel.attributedText =  returnAttributeString(str:"退房\n" + dateFormatterString.string(from: travelEndDate))
//        timeLabel.text = "   " + String(NSInteger((Double(searchCondition.departureDate)! - Double( searchCondition.arrivalDate)!)/1000/3600/24)) + "晚   "
    }
    func returnAttributeString(str:String) ->NSMutableAttributedString{
        let attrs = NSMutableAttributedString(string:str)
        attrs.addAttributes([NSForegroundColorAttributeName :PersonalThemeMinorTextColor, NSFontAttributeName : UIFont.systemFont( ofSize: 10.0)],range: NSMakeRange(0,2))
        return attrs
    }
}
