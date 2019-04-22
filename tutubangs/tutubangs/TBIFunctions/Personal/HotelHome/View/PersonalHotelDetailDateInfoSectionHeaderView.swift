//
//  PersonalHotelDetailDateInfoSectionHeaderView.swift
//  shanglvjia
//
//  Created by manman on 2018/9/18.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalHotelDetailDateInfoSectionHeaderView: UITableViewHeaderFooterView {

    typealias PSepcialHotelDetailHeaderSelectedDateBlock = (String)->Void
    
    public var sepcialHotelDetailHeaderSelectedDateBlock:PSepcialHotelDetailHeaderSelectedDateBlock!
    
    private var bookDateBackgroundView:UIView = UIView()
    private var startDateTitleLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 10)
    private var startDateLabel = UILabel.init(text: "", color: PersonalThemeDarkColor, size: 15)
    private var endDateTitleLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 10)
    private var endDateLabel = UILabel.init(text: "", color: PersonalThemeDarkColor, size: 15)
    private var duringLabel = UILabel.init(text: "", color: TBIThemeWhite, size: 12)
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = TBIThemeWhite
        setUIViewAutolayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUIViewAutolayout() {
        
        bookDateBackgroundView.backgroundColor = TBIThemeWhite
        self.contentView.addSubview(bookDateBackgroundView)
        bookDateBackgroundView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(70 - 15)
        }
        setBookDateView()
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
    
    
    
    @objc private func selectedDateClick(tap:UITapGestureRecognizer){
        
        if sepcialHotelDetailHeaderSelectedDateBlock != nil {
            sepcialHotelDetailHeaderSelectedDateBlock("")
        }
    }
    
    
    
}
