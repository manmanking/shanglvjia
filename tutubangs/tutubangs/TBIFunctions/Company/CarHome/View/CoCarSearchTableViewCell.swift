//
//  CoCarSearchTableViewCell.swift
//  shop
//
//  Created by TBI on 2018/1/16.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftDate

class CoCarSearchTableViewHeaderCell: UITableViewCell {

    var coCarClickListener:CoCarClickListener!
    
    let  bgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWindowWidth - 10, height: 40))
    
    let pickMachine:UILabel = UILabel(text: "接机", color: TBIThemeWhite, size: 16)
    
    let sendMachine:UILabel = UILabel(text: "送机", color: TBIThemeWhite, size: 16)
    
    let appointment:UILabel = UILabel(text: "预约用车", color: TBIThemeWhite, size: 16)
    
    
    let pickMachineImg:UIImageView = UIImageView.init(imageName: "ic_car_pickup")
     let sendMachineImg:UIImageView = UIImageView.init(imageName: "ic_car_pickup")
     let appointMachineImg:UIImageView = UIImageView.init(imageName: "ic_car_pickup")
    
    let selectPickMachine:UILabel = UILabel(text: "接机", color: TBIThemePrimaryTextColor, size: 16)
    
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView () {
        self.backgroundColor = UIColor.clear
        //bgView.layer.cornerRadius = 3
       
        bgView.addCorner(byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], radii: 3)
        bgView.backgroundColor = TBIThemeBackgroundViewColor
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(5)
        }
        
        pickMachineImg.isHidden = false
        self.contentView.addSubview(pickMachineImg)
        pickMachineImg.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo((ScreenWindowWidth - 10)/3)
        }
        sendMachineImg.isHidden = true
        self.contentView.addSubview(sendMachineImg)
        sendMachineImg.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo((ScreenWindowWidth - 10)/3)
            make.left.equalTo(pickMachineImg.snp.right)
        }
        //翻转图片的方向
        let selectImage = UIImage(named:"ic_car_pickup")
        let flipImageOrientation = ((selectImage?.imageOrientation.rawValue)! + 4) % 8
        let flipImage =  UIImage.init(cgImage: (selectImage?.cgImage)!, scale: (selectImage?.scale)!, orientation: UIImageOrientation(rawValue: flipImageOrientation)!)
        appointMachineImg.image = flipImage
        appointMachineImg.isHidden = true
        self.contentView.addSubview(appointMachineImg)
        appointMachineImg.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo((ScreenWindowWidth - 10)/3)
            make.left.equalTo(sendMachineImg.snp.right)
        }
        
        pickMachine.textColor = TBIThemePrimaryTextColor
        pickMachine.textAlignment = .center
        self.contentView.addSubview(pickMachine)
        pickMachine.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.width.equalTo((ScreenWindowWidth - 10)/3)
            make.top.equalTo(5)
        }
        sendMachine.textAlignment = .center
        self.contentView.addSubview(sendMachine)
        sendMachine.snp.makeConstraints { (make) in
            make.left.equalTo(pickMachine.snp.right)
            make.bottom.equalToSuperview()
            make.width.equalTo((ScreenWindowWidth - 10)/3)
             make.top.equalTo(5)
        }
        appointment.textAlignment = .center
        self.contentView.addSubview(appointment)
        appointment.snp.makeConstraints { (make) in
            make.left.equalTo(sendMachine.snp.right)
            make.bottom.right.equalToSuperview()
            make.top.equalTo(5)
        }
       
        pickMachineImg.addSubview(selectPickMachine)
        selectPickMachine.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        selectPickMachine.isHidden = true
        
        pickMachine.addOnClickListener(target: self, action:  #selector(pickMachineClick(tap:)))
        sendMachine.addOnClickListener(target: self, action:  #selector(sendMachineClick(tap:)))
        appointment.addOnClickListener(target: self, action:  #selector(appointmentClick(tap:)))
    }

    func pickMachineClick(tap:UITapGestureRecognizer){
        sendMachineImg.isHidden = true
        appointMachineImg.isHidden = true
        pickMachineImg.isHidden = false
//        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.pickMachineImg.frame.origin.x = self.pickMachine.frame.origin.x
//        }, completion: { (finished) -> Void in
            self.pickMachine.textColor = TBIThemePrimaryTextColor
            self.sendMachine.textColor = TBIThemeWhite
            self.appointment.textColor = TBIThemeWhite
//        })
        coCarClickListener.onOrderTypeClickListener(orderType: .pick)
    }
    
    func sendMachineClick(tap:UITapGestureRecognizer){
        sendMachineImg.isHidden = false
        appointMachineImg.isHidden = true
        pickMachineImg.isHidden = true
//        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.pickMachineImg.frame.origin.x = self.sendMachine.frame.origin.x
//        }, completion: { (finished) -> Void in
            self.sendMachine.textColor = TBIThemePrimaryTextColor
            self.pickMachine.textColor = TBIThemeWhite
            self.appointment.textColor = TBIThemeWhite
//        })
        coCarClickListener.onOrderTypeClickListener(orderType: .send)
    }
    
    func appointmentClick(tap:UITapGestureRecognizer){
        sendMachineImg.isHidden = true
        appointMachineImg.isHidden = false
        pickMachineImg.isHidden = true
//        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
//            self.pickMachineImg.frame.origin.x = self.appointment.frame.origin.x
//        }, completion: { (finished) -> Void in
             self.appointment.textColor = TBIThemePrimaryTextColor
             self.pickMachine.textColor = TBIThemeWhite
             self.sendMachine.textColor = TBIThemeWhite
//        })
        coCarClickListener.onOrderTypeClickListener(orderType: .about)
    }
   
}


class CoCarSearchTableViewScrollViewCell: UITableViewCell {

    var coCarClickListener:CoCarClickListener!
    
    let scrollView :UIScrollView = UIScrollView()
    
    var listView:[CoCarCellView] = []
    
    var selectIndex:Int = 0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView () {
        //是否显示水平滚动条
        scrollView.showsHorizontalScrollIndicator = false
        self.contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(45)
        }
    }
    
    func fullCell (data:[CompanyJourneyResult],orderType:OrderCarTypeEnum,flightIndex:Int) {
       
        //是否显示水平滚动条
        scrollView.showsHorizontalScrollIndicator = false
        listView.removeAll()
        scrollView.subviews.forEach{$0.removeFromSuperview()}
        self.selectIndex = flightIndex
        for index in 0..<data.count {
            let view = CoCarCellView()
            scrollView.addSubview(view)
            view.initData(data: data[index], orderType: orderType)
            view.tag = index
            if flightIndex == index && flightIndex != -1{
                view.selectd()
            }
            listView.append(view)
            view.addOnClickListener(target: self, action: #selector(click(tap:)))
        }
        
        for index in 0..<listView.count {
          
            listView[index].snp.makeConstraints({ (make) in
                make.bottom.top.equalToSuperview()
                make.height.equalTo(45)
                make.width.equalTo((ScreenWindowWidth - 55)/2)
                if index > 0 {
                    make.left.equalTo(listView[index - 1].snp.right).offset(15)
                }else {
                    make.left.equalTo(15)
                }
                if index == listView.count - 1 {
                    make.right.equalTo(-15)
                }
            })
        }
    }
    
    func fillDataSources( flightList:[PersonalFlightListResponse.PersonalFlightInfo] ,orderType:OrderCarTypeEnum,flightIndex:Int) {
        
        listView.removeAll()
        scrollView.subviews.forEach{$0.removeFromSuperview()}
        self.selectIndex = flightIndex
        for index in 0..<flightList.count {
            let view = CoCarCellView()
            scrollView.addSubview(view)
            //view.initData(data: flightList[flightIndex], orderType: orderType)
            view.fillDataSources(element: flightList[index], orderType: orderType)
            view.tag = index
            if flightIndex == index && flightIndex != -1{
                view.selectd()
            }
            listView.append(view)
            view.addOnClickListener(target: self, action: #selector(click(tap:)))
        }
        
        for index in 0..<listView.count {
            
            listView[index].snp.makeConstraints({ (make) in
                make.bottom.top.equalToSuperview()
                make.height.equalTo(45)
                make.width.equalTo((ScreenWindowWidth - 55)/2)
                if index > 0 {
                    make.left.equalTo(listView[index - 1].snp.right).offset(15)
                }else {
                    make.left.equalTo(15)
                }
                if index == listView.count - 1 {
                    make.right.equalTo(-15)
                }
            })
        }
        
        
        
        
    }
    
    

    func click(tap:UITapGestureRecognizer){
        let vi = tap.view as? CoCarCellView
        for index in 0..<listView.count {
            if vi?.tag == index && selectIndex != index{
                listView[index].selectd()
            }else {
                listView[index].normal()
            }
        }
        if vi?.tag == selectIndex  {
            coCarClickListener.onAirportClickListener(row: -1)
        }else {
            coCarClickListener.onAirportClickListener(row: vi?.tag ?? 0)
        }
        
    }
    
}

class CoCarCellView: UIView {
    
    let title:UILabel = UILabel(text: "长沙 - 天津", color: TBIThemePrimaryTextColor, size: 11)
    
    let text:UILabel = UILabel(text: "02/19 天津滨海国际机场", color: TBIThemeMinorTextColor, size: 10)
    
    let selectImage = UIImageView.init(imageName: "ic_car_sel")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    func initView () {
        self.layer.cornerRadius = 6
        self.backgroundColor = TBIThemeNormalBaseColor
//        self.layer.borderWidth = 1
//        self.layer.borderColor = TBIThemePlaceholderTextColor.cgColor
        self.addSubview(selectImage)
        selectImage.isHidden = true
        selectImage.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
        }
        self.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(7)
            make.centerX.equalToSuperview()
        }
        self.addSubview(text)
        text.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }
    func initData (data:CompanyJourneyResult,orderType:OrderCarTypeEnum) {
        title.text = data.flight.departureCity + " - " + data.flight.arriveCity
        if orderType == .pick {
            text.text = data.flight.flightNo + " " + data.flight.arriveDate.string(custom: "MM/dd HH:mm") + "到达"
        }else if orderType == .send{
            text.text = data.flight.flightNo + " " + data.flight.departureDate.string(custom: "MM/dd HH:mm") + "出发"
        }
    }
    
    func fillDataSources(element:PersonalFlightListResponse.PersonalFlightInfo,orderType:OrderCarTypeEnum) {
        title.text = element.depCity + " - " + element.arrCity
            //element.flight.departureCity + " - " + data.flight.arriveCity
        printDebugLog(message: element.mj_keyValues())
        if orderType == .pick {
            text.text = element.flightNo + " " + element.arrTime + "到达"
            //element.flight.flightNo + " " + data.flight.arriveDate.string(custom: "MM/dd HH:mm") + "到达"
        }else if orderType == .send{
            text.text = element.flightNo + " " + element.depDate + "出发"
            // data.flight.flightNo + " " + data.flight.departureDate.string(custom: "MM/dd HH:mm") + "出发"
        }
        
        
    }
    
    func selectd () {
        self.backgroundColor = TBIThemeSelectBaseColor
        selectImage.isHidden = false
    }
    
    func normal () {
        self.backgroundColor = TBIThemeNormalBaseColor
        selectImage.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class CoCarSearchTableViewAddressViewCell: UITableViewCell {
    
    fileprivate  let  flagImageView = UIImageView.init(imageName: "ic_car_airport")
    
    fileprivate  let  line = UILabel(color: TBIThemeGrayLineColor)
    
    fileprivate  let  nameText = UITextField(placeholder: "请选择上车地点",fontSize: 16)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView () {
        nameText.isUserInteractionEnabled = false
        self.contentView.addSubview(flagImageView)
        flagImageView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
        self.contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        self.contentView.addSubview(nameText)
        nameText.snp.makeConstraints { (make) in
            make.centerY.equalTo(flagImageView.snp.centerY)
            make.left.equalTo(flagImageView.snp.right).offset(15)
            make.height.equalTo(44)
            make.right.equalTo(-15)
        }
    }
    
    func fullCell (data:(image:String,placeholder:String,value:String,model:CoPointAddressModel?)) {
        flagImageView.image = UIImage.init(named: data.image)
        nameText.placeholder = data.placeholder
        nameText.text = data.value
    }
    
}


class CoCarSearchTableViewTimeViewCell: UITableViewCell {
    
    fileprivate  let  flagImageView = UIImageView.init(imageName: "ic_car_time")
    
    
    fileprivate  let  buttomLine = UILabel(color: TBIThemeGrayLineColor)
    
    fileprivate  let  nameText = UITextField(placeholder: "请选择上车时间",fontSize: 16)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView () {
        nameText.isUserInteractionEnabled  = false
        self.contentView.addSubview(flagImageView)
        flagImageView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
        self.contentView.addSubview(buttomLine)
        buttomLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        self.contentView.addSubview(nameText)
        nameText.snp.makeConstraints { (make) in
            make.centerY.equalTo(flagImageView.snp.centerY)
            make.left.equalTo(flagImageView.snp.right).offset(15)
            make.height.equalTo(44)
            make.right.equalTo(-15)
        }
    }
    
    func fullCell (data:(image:String,placeholder:String,value:String,model:CoPointAddressModel?)) {
        flagImageView.image = UIImage.init(named: data.image)
        nameText.placeholder = data.placeholder
        if data.value.isNotEmpty {
            let date = DateInRegion(string: data.value, format: .custom("YYYY-MM-dd HH:mm"), fromRegion: regionRome)!
            let str = date.string(custom: "MM月dd日  EEE    HH:mm")
            //nameText.text = str
            
            let attrs = NSMutableAttributedString(string:str)
            attrs.addAttributes([NSForegroundColorAttributeName :TBIThemePrimaryTextColor, NSFontAttributeName : UIFont.systemFont( ofSize: 16.0)],range: NSMakeRange(0,attrs.length))
            attrs.addAttributes([NSForegroundColorAttributeName :TBIThemeMinorTextColor, NSFontAttributeName : UIFont.systemFont( ofSize: 10.0)],range: NSMakeRange(8,2))
//            attrs.addAttributes([NSForegroundColorAttributeName :TBIThemePrimaryTextColor, NSFontAttributeName : UIFont.systemFont( ofSize: 16.0)],range: NSMakeRange(8, 5))
            nameText.attributedText = attrs
        }else {
            nameText.text = ""
        }
        
    }
    
}

class CoCarSearchSubmitViewCell: UITableViewCell {
    
    let submitButton:UIButton = UIButton(title: "查询",titleColor: TBIThemeWhite,titleSize: 20)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView () {
        submitButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        submitButton.clipsToBounds=true
        submitButton.layer.cornerRadius  = 5
        self.contentView.addSubview(submitButton)
        submitButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(15)
            make.top.equalTo(30)
        }
    }
    
    func fullCell () {
        
    }
    
}
