//
//  NewCompanyHomeView.swift
//  shop
//
//  Created by TBI on 2018/1/31.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit


class NewCompanyHomeBgSearchView: UIView {
    
    var  delegate:CoBusinessTypeListener!
    
    let flightView = NewCompanyCommonSearchView(image:"ic_flights",title:"机票",message:"FLIGHTS")
    
    let trainView =  NewCompanyCommonSearchView(image:"ic_trains",title:"火车票",message:"TRAINS")
    
    let hotelView =  NewCompanyCommonSearchView(image:"ic_hotels",title:"酒店",message:"HOTELS")
    
    let carView =    NewCompanyCommonSearchView(image:"ic_cars",title:"用车",message:"CARS")
    
    var  dataList:[(title:String,image:String,type:CoCompanyBusinessType,isClick:Bool)] = []
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: ScreenWindowWidth, height: 193*adaptationRatio)))
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView () {
        self.addCorner(byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], radii: 10)
        self.backgroundColor = TBIThemeWhite
        let leftMargin = 50 * adaptationRatioWidth //(ScreenWindowWidth-230)/3 < 50 ? (ScreenWindowWidth-230)/3:50
        addSubview(flightView)
        flightView.snp.makeConstraints { (make) in
            make.top.equalTo(33*adaptationRatio)
            make.left.equalToSuperview().inset(leftMargin)
            make.width.equalTo(113*adaptationRatioWidth)
            make.height.equalTo(50*adaptationRatio)
        }
        trainView.newImage.isHidden = false
        addSubview(trainView)
        trainView.snp.makeConstraints { (make) in
            make.top.equalTo(33*adaptationRatio)
            make.right.equalToSuperview().inset(leftMargin)
            make.width.equalTo(113*adaptationRatioWidth)
            make.height.equalTo(50*adaptationRatio)
        }
        addSubview(hotelView)
        hotelView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-33*adaptationRatio)
            make.left.equalToSuperview().inset(leftMargin)
            make.width.equalTo(113*adaptationRatioWidth)
            make.height.equalTo(50*adaptationRatio)
        }
        addSubview(carView)
        carView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-33*adaptationRatio)
            make.right.equalToSuperview().inset(leftMargin)
            make.width.equalTo(113*adaptationRatioWidth)
            make.height.equalTo(50*adaptationRatio)
        }
        flightView.addOnClickListener(target: self, action: #selector(flightClick(tap:)))
        trainView.addOnClickListener(target: self, action: #selector(trainClick(tap:)))
        hotelView.addOnClickListener(target: self, action: #selector(hotelClick(tap:)))
        carView.addOnClickListener(target: self, action: #selector(carClick(tap:)))
    }
    
    func flightClick (tap:UITapGestureRecognizer) {
        if dataList[0].isClick {
            delegate.onClickListener(type: dataList[0].type)
        }
    }
    
    func trainClick (tap:UITapGestureRecognizer) {
        if dataList[1].isClick {
            delegate.onClickListener(type: dataList[1].type)
        }
    }
    
    func hotelClick (tap:UITapGestureRecognizer) {
        if dataList[2].isClick {
            delegate.onClickListener(type: dataList[2].type)
        }
    }
    
    func carClick (tap:UITapGestureRecognizer) {
        if dataList[3].isClick {
            delegate.onClickListener(type: dataList[3].type)
        }
    }
    
    
    func fullCell (data:[(title:String,image:String,type:CoCompanyBusinessType,isClick:Bool)]) {
        self.dataList = data
        flightView.fullCell(data: data[0])
        trainView.fullCell(data: data[1])
        hotelView.fullCell(data: data[2])
        carView.fullCell(data: data[3])
    }
    
    
    class NewCompanyCommonSearchView: UIView {
        
        fileprivate let   iconImage = UIImageView(imageName: "ic_flights")
        
        fileprivate let   titleLabel:UILabel = UILabel(text: "机票", color: TBIThemePrimaryTextColor, size: 16)
        
        fileprivate let   messageLabel:UILabel = UILabel(text: "FLIGHTS", color: TBIThemeMinorTextColor, size: 10)
        
        let   newImage = UIImageView(imageName: "ic_new")
        
        init(image:String,title:String,message:String) {
            super.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 113, height: 50)))
            iconImage.image = UIImage(named: image)
            self.addSubview(iconImage)
            iconImage.snp.makeConstraints { (make) in
                make.left.top.equalToSuperview()
                //make.width.height.equalTo(80)
            }
            titleLabel.text = title
            self.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(11)
                make.left.equalTo(66)
            }
            messageLabel.text = message
            self.addSubview(messageLabel)
            messageLabel.snp.makeConstraints { (make) in
                make.left.equalTo(66)
                make.top.equalTo(titleLabel.snp.bottom).offset(1.5)
            }
            newImage.isHidden = true
            self.addSubview(newImage)
            newImage.snp.makeConstraints { (make) in
                make.width.equalTo(22)
                make.height.equalTo(12)
                make.left.equalTo(iconImage.snp.right).offset(-18)
                make.top.equalToSuperview()
            }
        }
        
        func fullCell (data:(title:String,image:String,type:CoCompanyBusinessType,isClick:Bool)) {
            iconImage.image = UIImage.init(named: data.image)
            if data.isClick {
                newImage.image = UIImage.init(named: "ic_new")
                titleLabel.textColor =  TBIThemePrimaryTextColor
            }else {
                titleLabel.textColor =  TBIThemePlaceholderLabelColor
                 newImage.image = UIImage.init(named: "ic_new_grey")
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}


class NewCompanyHomeBgOrderView: UIView {
    
    let planView     = NewCompanyCommonOrderView(number:0,title:"计划中")

    let approvalView =  NewCompanyCommonOrderView(number:0,title:"审批中")

    let willView    =  NewCompanyCommonOrderView(number:0,title:"待订妥")

    let ompletedView =    NewCompanyCommonOrderView(number:0,title:"已订妥")
    
    
    fileprivate let   titleImage = UIImageView(imageName: "ic_my order")
    
    fileprivate let   leftLineImage = UIImageView(imageName: "ic_line_blue_left")
    
    fileprivate let   rightLineImage = UIImageView(imageName: "ic_line_blue_right")
    
    var delegate:CoCompanyOrderStatusListener!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fullCell (data:CompanyJourneyCountResult?) {
        planView.fullCell(number: "\(data?.planning ?? 0)")
        approvalView.fullCell(number: "\(data?.waitForapprove ?? 0)")
        willView.fullCell(number: "\(data?.waitForTicket ?? 0)")
        ompletedView.fullCell(number: "\(data?.ticketed ?? 0)")
    }
    
    
    
    
    
    func initView () {
        self.backgroundColor = TBIThemeWhite
        addSubview(titleImage)
        titleImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(15*adaptationRatio)
//            make.width.equalTo(59*adaptationRatio)
//            make.height.equalTo(14*adaptationRatio)
        }
        addSubview(leftLineImage)
        leftLineImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleImage.snp.centerY)
            make.right.equalTo(titleImage.snp.left).offset(-14)
//            make.height.equalTo(1)
//            make.width.equalTo(34)
        }
        addSubview(rightLineImage)
        rightLineImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleImage.snp.centerY)
            make.left.equalTo(titleImage.snp.right).offset(14)
//            make.height.equalTo(1)
//            make.width.equalTo(34)
        }
        let leftMargin = (ScreenWindowWidth - 240) / 17
        addSubview(planView)
        planView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-7*adaptationRatio)
            make.width.equalTo(60)
            make.height.equalTo(50)
            make.left.equalTo(leftMargin * 4)
        }
        addSubview(approvalView)
        approvalView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-7*adaptationRatio)
            make.width.equalTo(60)
            make.height.equalTo(50)
            make.left.equalTo(planView.snp.right).offset(leftMargin * 3)
        }
        addSubview(willView)
        willView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-7*adaptationRatio)
            make.width.equalTo(60)
            make.height.equalTo(50)
            make.left.equalTo(approvalView.snp.right).offset(leftMargin * 3)
        }
        addSubview(ompletedView)
        ompletedView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-7*adaptationRatio)
            make.width.equalTo(60)
            make.height.equalTo(50)
            make.left.equalTo(willView.snp.right).offset(leftMargin * 3)
        }
        planView.addOnClickListener(target: self, action: #selector(planClick(tap:)))
        approvalView.addOnClickListener(target: self, action: #selector(approvalClick(tap:)))
        willView.addOnClickListener(target: self, action: #selector(willClick(tap:)))
        ompletedView.addOnClickListener(target: self, action: #selector(ompletedClick(tap:)))
    }
    
    func fillDataSources(data:PersonalOrderCountResponseVO) {
        planView.fullCell(number: "\(data.planning )")
        approvalView.fullCell(number: "\(data.waitForapprove)")
        willView.fullCell(number: "\(data.waitForTicket)")
        ompletedView.fullCell(number: "\(data.ticketed)")
    }
    
    
    
    
    
    
    func planClick (tap:UITapGestureRecognizer) {
         delegate.onClickListener(status: .Planning)
    }
    
    func approvalClick (tap:UITapGestureRecognizer) {
        delegate.onClickListener(status: .WaitForapprove)
    }
    
    func willClick (tap:UITapGestureRecognizer) {
        delegate.onClickListener(status: .WaitForTicket)
    }
    
    func ompletedClick (tap:UITapGestureRecognizer) {
        delegate.onClickListener(status: .Ticketed)
    }
    
    class NewCompanyCommonOrderView: UIView {
        
        fileprivate let   numberLabel:UILabel = UILabel(text: "", color: TBIThemeBlueColor, size: 15)
        
        fileprivate let   titleLabel:UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
        
        init(number:Int,title:String) {
            super.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 60, height: 50)))
            numberLabel.text = "\(number)"
            self.addSubview(numberLabel)
            numberLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(5)
            }
            titleLabel.text = title
            self.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(numberLabel.snp.bottom).offset(4)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func fullCell (number:String) {
           numberLabel.text = number
        }
        
    }
    
}

/// 审批按钮
class NewCompanyHomeApprovalView: UIView {
    
    fileprivate let   iconImage = UIImageView(imageName: "ic_approval")
    
    fileprivate let   titleImage = UIImageView(imageName: "ic_quick_approval")
    
    fileprivate let   numberLabel: UILabel = UILabel(text: "0", color: TBIThemeWhite, size: 10)
    
    fileprivate var   data:(title:String,image:String,type:CoCompanyBusinessType,isClick:Bool)?
    
    var  delegate:CoBusinessTypeListener!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        self.addOnClickListener(target: self, action:  #selector(approvalClick(tap:)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView () {
        self.backgroundColor = TBIThemeWhite
        //        addSubview(titleImage)
        numberLabel.textAlignment = .center
        //        titleImage.snp.makeConstraints { (make) in
        //            make.centerX.equalToSuperview()
        //            make.bottom.equalTo(-30)
        ////            make.width.equalTo(59)
        ////            make.height.equalTo(15)
        //        }
        addSubview(iconImage)
        iconImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            //            make.width.equalTo(21)
            //            make.height.equalTo(22)
        }
        numberLabel.textAlignment = .center
        numberLabel.layer.cornerRadius = 7
        numberLabel.clipsToBounds = true
        numberLabel.backgroundColor = UIColor.red
        numberLabel.adjustsFontSizeToFitWidth = true
        addSubview(numberLabel)
        numberLabel.snp.makeConstraints { (make) in
            make.height.equalTo(12)
            make.left.equalTo(iconImage.snp.centerX).offset(10)
            make.top.equalTo(iconImage.snp.top).offset(-4)
        }
    }
    
    
    func approvalClick (tap:UITapGestureRecognizer) {
        if data?.isClick ?? false{
            delegate.onClickListener(type: data?.type ?? .Approval)
        }
    }
    
    func fullCellCount (data:CompanyJourneyCountResult?) {
        if data?.approving == 0 {
            numberLabel.text = String(describing: data?.approving ?? 0)
            numberLabel.isHidden = true
        }else {
            numberLabel.text = String(describing: data?.approving ?? 0)
            numberLabel.isHidden = false
        }
        
    }
    
    
    func fillDataSources(data:PersonalOrderCountResponseVO) {
        if data.approving == 0 {
            numberLabel.text = String(describing: data.approving)
            numberLabel.isHidden = true
        }else {
            numberLabel.text = String(describing: data.approving)
            numberLabel.isHidden = false
            if numberLabel.text?.count == 1 {
                numberLabel.snp.remakeConstraints { (make) in
                    make.height.equalTo(14)
                    make.left.equalTo(iconImage.snp.centerX).offset(3)
                    make.top.equalTo(iconImage.snp.top).offset(-4)
                    make.width.equalTo(14)
                }
            }else
            {
                numberLabel.snp.remakeConstraints { (make) in
                    make.height.equalTo(14)
                    make.left.equalTo(iconImage.snp.centerX).offset(3)
                    make.top.equalTo(iconImage.snp.top).offset(-4)
                    make.width.equalTo(18)
                }
            }
            
            if (data.approving) > 99 {
                numberLabel.text  = "99+"
                numberLabel.snp.remakeConstraints { (make) in
                    make.height.equalTo(14)
                    make.left.equalTo(iconImage.snp.centerX).offset(3)
                    make.top.equalTo(iconImage.snp.top).offset(-4)
                    make.width.equalTo(22)
                }
            }
        }
        
    }
    
    
    
    
    func fullCell (data:(title:String,image:String,type:CoCompanyBusinessType,isClick:Bool)) {
        self.data = data
        iconImage.image = UIImage.init(named: data.image)
        titleImage.image = UIImage.init(named: data.title)
        if data.isClick {
            numberLabel.backgroundColor = UIColor.red
        }else {
            numberLabel.backgroundColor = TBIThemeTipTextColor
        }
    }
    
   
}


/// VIP
class NewCompanyHomeVipView: UIView {
    
    fileprivate let   iconImage = UIImageView(imageName: "ic_vip")
    
    fileprivate let   titleImage = UIImageView(imageName: "ic_vip_service")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView () {
        self.backgroundColor = TBIThemeWhite
        
        addSubview(iconImage)
        iconImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
//            make.width.equalTo(21)
//            make.height.equalTo(17)
        }
        
//        addSubview(titleImage)
//        titleImage.snp.makeConstraints { (make) in
//            make.left.equalTo(iconImage.snp.right).offset(12)
//            make.centerY.equalToSuperview()
////            make.width.equalTo(50)
////            make.height.equalTo(13)
//        }
        
       
    }
}


///   新建出差单
class NewCompanyHomeNewTripView: UIView {
    
    fileprivate let   iconImage = UIImageView(imageName: "ic_book")
    
    fileprivate let   titleImage = UIImageView(imageName: "ic_bulid")
    
    fileprivate var   data:(title:String,image:String,type:CoCompanyBusinessType,isClick:Bool)?
    
    var  delegate:CoBusinessTypeListener!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        self.addOnClickListener(target: self, action:  #selector(newTripClick(tap:)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func newTripClick (tap:UITapGestureRecognizer) {
        if data?.isClick ?? false{
            delegate.onClickListener(type: data?.type ?? .NewTrip)
        }
    }
    
    func fullCell (data:(title:String,image:String,type:CoCompanyBusinessType,isClick:Bool)) {
        self.data = data
        iconImage.image = UIImage.init(named: data.image)
        titleImage.image = UIImage.init(named: data.title)
    }
    
    func initView () {
        self.backgroundColor = TBIThemeWhite
        addSubview(iconImage)
        iconImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(-45)
            make.centerY.equalToSuperview()
            make.width.equalTo(16)
            make.height.equalTo(20)
        }
        
        addSubview(titleImage)
        titleImage.snp.makeConstraints { (make) in
            make.left.equalTo(iconImage.snp.right).offset(12)
            make.centerY.equalToSuperview()
//            make.width.equalTo(69)
//            make.height.equalTo(14)
        }
       
    }
}




