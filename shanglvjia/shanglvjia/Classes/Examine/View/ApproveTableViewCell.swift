//
//  ApproveTableViewCell.swift
//  shanglvjia
//
//  Created by manman on 2018/5/16.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class ApproveTableViewCell: UITableViewCell {
    
    typealias ApproveTableViewCellSelectedBlock = (Bool,NSInteger)->Void
    
    public var approveTableViewCellSelectedBlock:ApproveTableViewCellSelectedBlock!
    
    private var cellIndex:NSInteger = 0
    
    private let orderCellHeight:NSInteger = 175
    
    private var selectedButton:UIButton = UIButton()
    
    private var baseBackgroundView:UIView = UIView()
    
    private var subBaseBackgroundView:UIView = UIView()
    
    //订单号 审批 单号
    private var orderNumLabel = UILabel(text: "订单号10008999", color: TBIThemePrimaryTextColor, size: 15)
    
    //状态 (1:计划中，2：审批中，3：待订妥，4：已订妥，5：已取消)
    private var orderStateLabel:UILabel = UILabel(text: "计划中", color: TBIThemeDarkBlueColor, size: 15)
    
    //线
    private var firstLineLabel = UILabel()
    
    
    private var orderArr:[UIView] = Array()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        setUIViewAutolayout()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUIViewAutolayout() {
        
        
        //        selectedButton.setImage(UIImage.init(named: "round_check_fill"), for: UIControlState.normal)
        //        selectedButton.setImage(UIImage.init(named: "round_check_fill_selected"), for: UIControlState.selected)
        //        selectedButton.addTarget(self, action: #selector(selectedButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        //        baseBackgroundView.addSubview(selectedButton)
        //        selectedButton.snp.makeConstraints { (make) in
        //            make.left.equalToSuperview().inset(10)
        //            make.top.equalToSuperview().inset(10)
        //            make.height.width.equalTo(10)
        //        }
        
        baseBackgroundView.addSubview(subBaseBackgroundView)
        subBaseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        orderNumLabel.text = "审批单号 88888888888888"
        subBaseBackgroundView.addSubview(orderNumLabel)
        orderNumLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.equalToSuperview()
            make.height.equalTo(44)
            make.right.equalToSuperview().inset(60)
        }
        
        baseBackgroundView.addSubview(orderStateLabel)
        orderStateLabel.font=UIFont.boldSystemFont(ofSize: 15)
        orderStateLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(orderNumLabel)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(44)
        }
        firstLineLabel.backgroundColor = TBIThemeGrayLineColor
        subBaseBackgroundView.addSubview(firstLineLabel)
        firstLineLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(43)
            make.height.equalTo(0.5)
        }
    }
    
    
    func fillDataSources(dataSources:ApproveListResponseVO.ApproveListInfo,index:NSInteger,isEdit:Bool) {
        
        cellIndex = index
        orderNumLabel.text = "审批单号" + dataSources.approveNo
        //0：待审批，1：已通过，2：已拒绝
        if dataSources.status == "0" {orderStateLabel.text = "待审批" }
        if dataSources.status == "1" {orderStateLabel.text = "已通过" }
        if dataSources.status == "2" {orderStateLabel.text = "已拒绝" }
        
        let topMargin = 44
        let cellHeight = orderCellHeight
        var viewY:NSInteger = topMargin
        _ = orderArr.map{$0.removeFromSuperview() }
        var isLast:Bool = true
        let capacity:NSInteger = dataSources.approveListOrderInfos.count
        for (index,element) in dataSources.approveListOrderInfos.enumerated() {
            
            if capacity == index + 1 { isLast = false }
            
            viewY = cellHeight * index + topMargin
            
            //1：机票，2：酒店，3：火车票，4：专车
            switch element.orderType {
                
            case "1":
                createApprovalFlightCell(baseView: subBaseBackgroundView, viewY:viewY, last:isLast , flightDataSources: element)
            case "2":
                createApprovalHotelCell(baseView: subBaseBackgroundView, viewY:viewY, last: isLast, hotelDataSources: element)
            case "3":
                createApprovalTrainCell(baseView: subBaseBackgroundView, viewY:viewY, last: isLast, trainDataSources: element)
            case "4":
                createApprovalCarCell(baseView: subBaseBackgroundView, viewY:viewY, last: isLast, flightDataSources: element)
            default:
                break
            }
        }
        
        if isEdit {
            // subBaseBackgroundView
        }
        
        
        
    }
    
    
    
    
    
    /// 机票
    func createApprovalFlightCell(baseView:UIView,viewY:NSInteger,last:Bool,flightDataSources:ApproveListResponseVO.ApproveListOrderInfo) {
        let flightCell:ApproveTableViewFlightCell = ApproveTableViewFlightCell()
        baseView.addSubview(flightCell)
        flightCell.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(viewY)
            make.height.equalTo(orderCellHeight)
        }
        orderArr.append(flightCell)
        flightCell.fillDataSources(flightDataSources:flightDataSources, showLine: last)
        
    }
    /// 酒店
    func createApprovalHotelCell(baseView:UIView,viewY:NSInteger,last:Bool,hotelDataSources:ApproveListResponseVO.ApproveListOrderInfo) {
        
        let hotelCell:ApproveTableViewHotelCell = ApproveTableViewHotelCell()
        baseView.addSubview(hotelCell)
        hotelCell.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(viewY)
            make.height.equalTo(orderCellHeight)
        }
        orderArr.append(hotelCell)
        hotelCell.fillDataSources(hotelDataSources:hotelDataSources, showLine: last)
        
    }
    /// 火车票
    func createApprovalTrainCell(baseView:UIView,viewY:NSInteger,last:Bool,trainDataSources:ApproveListResponseVO.ApproveListOrderInfo) {
        let trainCell:ApproveTableViewTrainCell = ApproveTableViewTrainCell()
        baseView.addSubview(trainCell)
        trainCell.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(viewY)
            make.height.equalTo(orderCellHeight)
        }
        orderArr.append(trainCell)
        trainCell.fillDataSources(trainDataSources:trainDataSources, showLine: last)
        
    }
    /// 专车
    func createApprovalCarCell(baseView:UIView,viewY:NSInteger,last:Bool,flightDataSources:ApproveListResponseVO.ApproveListOrderInfo) {
        let carCell:ApproveTableViewCarCell = ApproveTableViewCarCell()
        baseView.addSubview(carCell)
        carCell.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(viewY)
            make.height.equalTo(orderCellHeight)
        }
        orderArr.append(carCell)
        carCell.fillDataSources(carDataSources:flightDataSources, showLine: last)
        
    }
    
    
    class func drawDashLine(lineView : UIView,lineLength : Int ,lineSpacing : Int,lineColor : UIColor){
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = lineView.bounds
        //        只要是CALayer这种类型,他的anchorPoint默认都是(0.5,0.5)
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        //        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = lineColor.cgColor
        
        shapeLayer.lineWidth = lineView.frame.size.height
        shapeLayer.lineJoin = kCALineJoinRound
        
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength),NSNumber(value: lineSpacing)]
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: lineView.frame.size.width, y: 0))
        
        shapeLayer.path = path
        lineView.layer.addSublayer(shapeLayer)
    }
    
    
    
    enum ApproveTableViewSubOrderType:NSInteger {
        case SuborderTypeFlight = 1
        case SuborderTypeHotel = 2
        case SuborderTypeTrain = 3
        case SuborderTypeCar = 4
    }
    
    
    
    
    
    
    /// 机票信息
    class ApproveTableViewFlightCell: UIView {
        
        private let marginInterval:NSInteger = 10
        private var baseBackgroundView:UIView = UIView()
        private var orderTypeFlageImageView:UIImageView = UIImageView()
        private var orderTitleLabel:UILabel = UILabel()
        private var orderNoLabel:UILabel = UILabel()
        private var orderDateLabel:UILabel = UILabel()
        private var orderUserLabel:UILabel = UILabel()
        private var orderCreateDateLabel:UILabel = UILabel()
        private var orderTotalPriceLabel:UILabel = UILabel()
        //线
        private var firstLineLabel = UILabel()
        
        private var firstLineWidthLabel = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.addSubview(baseBackgroundView)
            baseBackgroundView.snp.makeConstraints { (make) in
                make.top.left.bottom.right.equalToSuperview()
            }
            setUIViewAutolayout()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setUIViewAutolayout() {
            
            orderTypeFlageImageView.image = UIImage.init(named: "ic_order_air")
            baseBackgroundView.addSubview(orderTypeFlageImageView)
            orderTypeFlageImageView.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(15)
                make.top.equalToSuperview().inset(15)
                make.width.height.equalTo(20)
                
            }
            orderTitleLabel.textColor = TBIThemePrimaryTextColor
            orderTitleLabel.font = UIFont.systemFont(ofSize: 15)
            orderTitleLabel.textAlignment = NSTextAlignment.left
            baseBackgroundView.addSubview(orderTitleLabel)
            orderTitleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(orderTypeFlageImageView.snp.right).offset(15)
                make.centerY.equalTo(orderTypeFlageImageView)
                make.height.equalTo(15)
                make.right.equalToSuperview()
            }
            orderNoLabel.textColor = TBIThemePlaceholderTextColor
            orderNoLabel.font = UIFont.systemFont(ofSize: 14)
            orderNoLabel.textAlignment = NSTextAlignment.left
            baseBackgroundView.addSubview(orderNoLabel)
            orderNoLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(orderTypeFlageImageView.snp.bottom).offset(15)
                make.height.equalTo(15)
                make.right.equalToSuperview()
            }
            orderDateLabel.textColor = TBIThemePlaceholderTextColor
            orderDateLabel.font = UIFont.systemFont(ofSize: 14)
            orderDateLabel.textAlignment = NSTextAlignment.left
            baseBackgroundView.addSubview(orderDateLabel)
            orderDateLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(orderNoLabel.snp.bottom).offset(marginInterval)
                make.height.equalTo(15)
                make.right.equalToSuperview()
            }
            orderUserLabel.textColor = TBIThemePlaceholderTextColor
            orderUserLabel.font = UIFont.systemFont(ofSize: 14)
            orderUserLabel.textAlignment = NSTextAlignment.left
            baseBackgroundView.addSubview(orderUserLabel)
            orderUserLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(orderDateLabel.snp.bottom).offset(marginInterval)
                make.height.equalTo(15)
                make.right.equalToSuperview()
            }
            orderCreateDateLabel.textColor = TBIThemePlaceholderTextColor
            orderCreateDateLabel.font = UIFont.systemFont(ofSize: 13)
            orderCreateDateLabel.backgroundColor = TBIThemeButtonBGGrayColor
            orderCreateDateLabel.layer.cornerRadius = 15
            orderCreateDateLabel.clipsToBounds = true
            orderCreateDateLabel.textAlignment = NSTextAlignment.center
            baseBackgroundView.addSubview(orderCreateDateLabel)
            orderCreateDateLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(25)
                make.top.equalTo(orderUserLabel.snp.bottom).offset(marginInterval)
                make.height.equalTo(30)
                make.width.equalTo(150)
            }
            orderTotalPriceLabel.textColor = TBIThemeOrangeColor
            orderTotalPriceLabel.backgroundColor = TBIThemeMinorOrangeColor
            orderTotalPriceLabel.layer.cornerRadius = 15
            orderTotalPriceLabel.clipsToBounds = true
            orderTotalPriceLabel.font = UIFont.systemFont(ofSize: 13)
            orderTotalPriceLabel.textAlignment = NSTextAlignment.center
            baseBackgroundView.addSubview(orderTotalPriceLabel)
            orderTotalPriceLabel.snp.makeConstraints { (make) in
                make.right.equalToSuperview().inset(15)
                make.centerY.equalTo(orderCreateDateLabel)
                make.width.equalTo(80)
                make.height.equalTo(30)
            }
            
            firstLineLabel.frame = CGRect.init(x: 15, y: 170, width: ScreenWindowWidth - 15, height:1)
            baseBackgroundView.addSubview(firstLineLabel)
            ApproveTableViewCell.drawDashLine(lineView: firstLineLabel, lineLength:5 , lineSpacing: 5, lineColor: TBIThemePlaceholderTextColor)
            
            firstLineWidthLabel.isHidden = true
            firstLineWidthLabel.backgroundColor = TBIThemeBaseColor
            baseBackgroundView.addSubview(firstLineWidthLabel)
            firstLineWidthLabel.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(10)
                make.bottom.equalToSuperview()
            }
            
            
        }
        
        
        func fillDataSources(flightDataSources:ApproveListResponseVO.ApproveListOrderInfo,showLine:Bool) {
            
            var title:String = "机票"
            if flightDataSources.orderTitle.isEmpty == false {
                title = flightDataSources.orderTitle
            }
            orderTitleLabel.text = title
            orderNoLabel.text = "订单号" + flightDataSources.orderNo
            orderDateLabel.text = flightDataSources.orderDetail
            orderUserLabel.text = flightDataSources.psgName
            let approvalCreateTimeDate:[String] = flightDataSources.approvalCreateTime.components(separatedBy: " ")
            if approvalCreateTimeDate.count > 0 {
                orderCreateDateLabel.text = "创建时间" + approvalCreateTimeDate.first!
            }else{
                orderCreateDateLabel.text = ""
            }
            
            orderTotalPriceLabel.text = "¥" + flightDataSources.amount
            firstLineLabel.isHidden = !showLine
            firstLineWidthLabel.isHidden = showLine
            
        }
        
        
        
        
    }
    
    /// 酒店信息
    class ApproveTableViewHotelCell: UIView  {
        
        private let marginInterval:NSInteger = 10
        private var baseBackgroundView:UIView = UIView()
        private var orderTypeFlageImageView:UIImageView = UIImageView()
        private var orderTitleLabel:UILabel = UILabel()
        private var orderNoLabel:UILabel = UILabel()
        private var orderDateLabel:UILabel = UILabel()
        private var orderUserLabel:UILabel = UILabel()
        private var orderCreateDateLabel:UILabel = UILabel()
        private var orderTotalPriceLabel:UILabel = UILabel()
        //线
        private var firstLineLabel = UILabel()
        
        private var firstLineWidthLabel = UILabel()
        
        private var dottedlineImageView:UIImageView = UIImageView()
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.addSubview(baseBackgroundView)
            baseBackgroundView.snp.makeConstraints { (make) in
                make.top.left.bottom.right.equalToSuperview()
            }
            setUIViewAutolayout()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setUIViewAutolayout() {
            
            orderTitleLabel.textColor = TBIThemePrimaryTextColor
            orderTitleLabel.font = UIFont.systemFont(ofSize: 15)
            orderTitleLabel.textAlignment = NSTextAlignment.left
            baseBackgroundView.addSubview(orderTitleLabel)
            orderTitleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(15)
                make.top.equalToSuperview().inset(15)
                make.height.equalTo(15)
                make.right.equalToSuperview()
            }
            orderNoLabel.textColor = TBIThemePlaceholderTextColor
            orderNoLabel.font = UIFont.systemFont(ofSize: 14)
            orderNoLabel.textAlignment = NSTextAlignment.left
            baseBackgroundView.addSubview(orderNoLabel)
            orderNoLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(orderTitleLabel.snp.bottom).offset(15)
                make.height.equalTo(15)
                make.right.equalToSuperview()
            }
            orderDateLabel.textColor = TBIThemePlaceholderTextColor
            orderDateLabel.font = UIFont.systemFont(ofSize: 14)
            orderDateLabel.textAlignment = NSTextAlignment.left
            baseBackgroundView.addSubview(orderDateLabel)
            orderDateLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(orderNoLabel.snp.bottom).offset(marginInterval)
                make.height.equalTo(15)
                make.right.equalToSuperview()
            }
            orderUserLabel.textColor = TBIThemePlaceholderTextColor
            orderUserLabel.font = UIFont.systemFont(ofSize: 14)
            orderUserLabel.textAlignment = NSTextAlignment.left
            baseBackgroundView.addSubview(orderUserLabel)
            orderUserLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(orderDateLabel.snp.bottom).offset(marginInterval)
                make.height.equalTo(15)
                make.right.equalToSuperview()
            }
            orderCreateDateLabel.textColor = TBIThemePlaceholderTextColor
            orderCreateDateLabel.font = UIFont.systemFont(ofSize: 13)
            orderCreateDateLabel.backgroundColor = TBIThemeBaseColor
            orderCreateDateLabel.layer.cornerRadius = 15
            orderCreateDateLabel.clipsToBounds = true
            orderCreateDateLabel.textAlignment = NSTextAlignment.center
            baseBackgroundView.addSubview(orderCreateDateLabel)
            orderCreateDateLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(25)
                make.top.equalTo(orderUserLabel.snp.bottom).offset(marginInterval)
                make.height.equalTo(30)
                make.width.equalTo(150)
            }
            orderTotalPriceLabel.textColor = TBIThemeOrangeColor
            orderTotalPriceLabel.backgroundColor = TBIThemeMinorOrangeColor
            orderTotalPriceLabel.layer.cornerRadius = 15
            orderTotalPriceLabel.clipsToBounds = true
            orderTotalPriceLabel.font = UIFont.systemFont(ofSize: 13)
            orderTotalPriceLabel.textAlignment = NSTextAlignment.center
            baseBackgroundView.addSubview(orderTotalPriceLabel)
            orderTotalPriceLabel.snp.makeConstraints { (make) in
                make.right.equalToSuperview().inset(15)
                make.centerY.equalTo(orderCreateDateLabel)
                make.width.equalTo(80)
                make.height.equalTo(30)
            }
            
            //firstLineLabel.backgroundColor = TBIThemePlaceholderTextColor
            firstLineLabel.frame = CGRect.init(x: 15, y: 170, width: ScreenWindowWidth - 15, height:1)
            baseBackgroundView.addSubview(firstLineLabel)
            ApproveTableViewCell.drawDashLine(lineView: firstLineLabel, lineLength:5 , lineSpacing: 5, lineColor: TBIThemePlaceholderTextColor)
            
            firstLineWidthLabel.isHidden = true
            firstLineWidthLabel.backgroundColor = TBIThemeBaseColor
            baseBackgroundView.addSubview(firstLineWidthLabel)
            firstLineWidthLabel.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(10)
                make.bottom.equalToSuperview()
            }
            
        }
        
        
        
        func fillDataSources(hotelDataSources:ApproveListResponseVO.ApproveListOrderInfo,showLine:Bool) {
            var title:String = "酒店"
            if hotelDataSources.orderTitle.isEmpty == false {
                title = hotelDataSources.orderTitle
            }
            //orderTitleLabel.text = title
            orderNoLabel.text = "订单号" + hotelDataSources.orderNo
            orderDateLabel.text = hotelDataSources.orderDetail
            orderUserLabel.text = hotelDataSources.psgName
            let approvalCreateTimeDate:[String] = hotelDataSources.approvalCreateTime.components(separatedBy: " ")
            if approvalCreateTimeDate.count > 0 {
                orderCreateDateLabel.text = "创建时间" + approvalCreateTimeDate.first!
            }else{
                orderCreateDateLabel.text = ""
            }
            orderTotalPriceLabel.text = "¥" + hotelDataSources.amount
            
            //定义富文本即有格式的字符串
            let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
            let dashuaige : NSAttributedString = NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName : UIColor.lightGray, NSFontAttributeName : UIFont.systemFont(ofSize: 15)])
            //笑脸图片
            let smileImage : UIImage = UIImage(named: "ic_order_hotel")!
            let textAttachment : NSTextAttachment = NSTextAttachment()
            textAttachment.image = smileImage
            textAttachment.bounds = CGRect(x: 0, y:-4, width: 20, height: 20)
            attributedStrM.append(NSAttributedString(attachment: textAttachment))
            attributedStrM.append(dashuaige)
            
            
            orderTitleLabel.attributedText = attributedStrM
            
            firstLineLabel.isHidden = !showLine
            firstLineWidthLabel.isHidden = showLine
            
        }
    }
    
    
    /// 火车票信息
    class ApproveTableViewTrainCell: UIView  {
        private let marginInterval:NSInteger = 10
        private var baseBackgroundView:UIView = UIView()
        private var orderTypeFlageImageView:UIImageView = UIImageView()
        private var orderTitleLabel:UILabel = UILabel()
        private var orderNoLabel:UILabel = UILabel()
        private var orderDateLabel:UILabel = UILabel()
        private var orderUserLabel:UILabel = UILabel()
        private var orderCreateDateLabel:UILabel = UILabel()
        private var orderTotalPriceLabel:UILabel = UILabel()
        //线
        private var firstLineLabel = UILabel()
        private var firstLineWidthLabel = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.addSubview(baseBackgroundView)
            baseBackgroundView.snp.makeConstraints { (make) in
                make.top.left.bottom.right.equalToSuperview()
            }
            setUIViewAutolayout()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setUIViewAutolayout() {
            
            orderTypeFlageImageView.image = UIImage.init(named: "ic_order_train")
            baseBackgroundView.addSubview(orderTypeFlageImageView)
            orderTypeFlageImageView.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(15)
                make.top.equalToSuperview().inset(15)
                make.width.height.equalTo(20)
                
            }
            orderTitleLabel.textColor = TBIThemePrimaryTextColor
            orderTitleLabel.font = UIFont.systemFont(ofSize: 15)
            orderTitleLabel.textAlignment = NSTextAlignment.left
            baseBackgroundView.addSubview(orderTitleLabel)
            orderTitleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(orderTypeFlageImageView.snp.right).offset(15)
                make.centerY.equalTo(orderTypeFlageImageView)
                make.height.equalTo(15)
                make.right.equalToSuperview()
            }
            orderNoLabel.textColor = TBIThemePlaceholderTextColor
            orderNoLabel.font = UIFont.systemFont(ofSize: 14)
            orderNoLabel.textAlignment = NSTextAlignment.left
            baseBackgroundView.addSubview(orderNoLabel)
            orderNoLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(orderTypeFlageImageView.snp.bottom).offset(15)
                make.height.equalTo(15)
                make.right.equalToSuperview()
            }
            orderDateLabel.textColor = TBIThemePlaceholderTextColor
            orderDateLabel.font = UIFont.systemFont(ofSize: 14)
            orderDateLabel.textAlignment = NSTextAlignment.left
            baseBackgroundView.addSubview(orderDateLabel)
            orderDateLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(orderNoLabel.snp.bottom).offset(marginInterval)
                make.height.equalTo(15)
                make.right.equalToSuperview()
            }
            orderUserLabel.textColor = TBIThemePlaceholderTextColor
            orderUserLabel.font = UIFont.systemFont(ofSize: 14)
            orderUserLabel.textAlignment = NSTextAlignment.left
            baseBackgroundView.addSubview(orderUserLabel)
            orderUserLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(orderDateLabel.snp.bottom).offset(marginInterval)
                make.height.equalTo(15)
                make.right.equalToSuperview()
            }
            orderCreateDateLabel.textColor = TBIThemePlaceholderTextColor
            orderCreateDateLabel.font = UIFont.systemFont(ofSize: 13)
            orderCreateDateLabel.backgroundColor = TBIThemeBaseColor
            orderCreateDateLabel.layer.cornerRadius = 15
            orderCreateDateLabel.clipsToBounds = true
            orderCreateDateLabel.textAlignment = NSTextAlignment.center
            baseBackgroundView.addSubview(orderCreateDateLabel)
            orderCreateDateLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(25)
                make.top.equalTo(orderUserLabel.snp.bottom).offset(marginInterval)
                make.height.equalTo(30)
                make.width.equalTo(150)
            }
            orderTotalPriceLabel.textColor = TBIThemeOrangeColor
            orderTotalPriceLabel.backgroundColor = TBIThemeMinorOrangeColor
            orderTotalPriceLabel.layer.cornerRadius = 15
            orderTotalPriceLabel.clipsToBounds = true
            orderTotalPriceLabel.font = UIFont.systemFont(ofSize: 13)
            orderTotalPriceLabel.textAlignment = NSTextAlignment.center
            baseBackgroundView.addSubview(orderTotalPriceLabel)
            orderTotalPriceLabel.snp.makeConstraints { (make) in
                make.right.equalToSuperview().inset(15)
                make.centerY.equalTo(orderCreateDateLabel)
                make.height.equalTo(30)
                make.width.equalTo(80)
            }
            
            firstLineLabel.frame = CGRect.init(x: 15, y: 170, width: ScreenWindowWidth - 15, height:1)
            baseBackgroundView.addSubview(firstLineLabel)
            ApproveTableViewCell.drawDashLine(lineView: firstLineLabel, lineLength:5 , lineSpacing: 5, lineColor: TBIThemePlaceholderTextColor)
            
            firstLineWidthLabel.isHidden = true
            firstLineWidthLabel.backgroundColor = TBIThemeBaseColor
            baseBackgroundView.addSubview(firstLineWidthLabel)
            firstLineWidthLabel.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(10)
                make.bottom.equalToSuperview()
            }
            
        }
        
        
        func fillDataSources(trainDataSources:ApproveListResponseVO.ApproveListOrderInfo,showLine:Bool) {
            var title:String = "火车票"
            if trainDataSources.orderTitle.isEmpty == false {
                title = trainDataSources.orderTitle
            }
            orderTitleLabel.text = title
            orderNoLabel.text = "订单号" + trainDataSources.orderNo
            orderDateLabel.text = trainDataSources.orderDetail
            orderUserLabel.text = trainDataSources.psgName
            let approvalCreateTimeDate:[String] = trainDataSources.approvalCreateTime.components(separatedBy: " ")
            if approvalCreateTimeDate.count > 0 {
                orderCreateDateLabel.text = "创建时间" + approvalCreateTimeDate.first!
            }else{
                orderCreateDateLabel.text = ""
            }
            orderTotalPriceLabel.text = "¥" + trainDataSources.amount
            firstLineLabel.isHidden = !showLine
            firstLineWidthLabel.isHidden = showLine
            
        }
    }
    
    
    /// 专车信息
    class ApproveTableViewCarCell: UIView  {
        private let marginInterval:NSInteger = 10
        private var baseBackgroundView:UIView = UIView()
        private var orderTypeFlageImageView:UIImageView = UIImageView()
        private var orderTitleLabel:UILabel = UILabel()
        private var orderNoLabel:UILabel = UILabel()
        private var orderDateLabel:UILabel = UILabel()
        private var orderUserLabel:UILabel = UILabel()
        private var orderCreateDateLabel:UILabel = UILabel()
        private var orderTotalPriceLabel:UILabel = UILabel()
        //线
        private var firstLineLabel = UILabel()
        private var firstLineWidthLabel = UILabel()
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.addSubview(baseBackgroundView)
            baseBackgroundView.snp.makeConstraints { (make) in
                make.top.left.bottom.right.equalToSuperview()
            }
            setUIViewAutolayout()
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setUIViewAutolayout() {
            orderTypeFlageImageView.image = UIImage.init(named: "ic_order_car")
            baseBackgroundView.addSubview(orderTypeFlageImageView)
            orderTypeFlageImageView.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(15)
                make.top.equalToSuperview().inset(15)
                make.width.height.equalTo(20)
                
            }
            orderTitleLabel.textColor = TBIThemePrimaryTextColor
            orderTitleLabel.font = UIFont.systemFont(ofSize: 15)
            orderTitleLabel.textAlignment = NSTextAlignment.left
            baseBackgroundView.addSubview(orderTitleLabel)
            orderTitleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(orderTypeFlageImageView.snp.right).offset(15)
                make.centerY.equalTo(orderTypeFlageImageView)
                make.height.equalTo(15)
                make.right.equalToSuperview()
            }
            orderNoLabel.textColor = TBIThemePlaceholderTextColor
            orderNoLabel.font = UIFont.systemFont(ofSize: 14)
            orderNoLabel.textAlignment = NSTextAlignment.left
            baseBackgroundView.addSubview(orderNoLabel)
            orderNoLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(orderTitleLabel.snp.bottom).offset(15)
                make.height.equalTo(15)
                make.right.equalToSuperview()
            }
            orderDateLabel.textColor = TBIThemePlaceholderTextColor
            orderDateLabel.font = UIFont.systemFont(ofSize: 14)
            orderDateLabel.textAlignment = NSTextAlignment.left
            baseBackgroundView.addSubview(orderDateLabel)
            orderDateLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(orderNoLabel.snp.bottom).offset(marginInterval)
                make.height.equalTo(15)
                make.right.equalToSuperview()
            }
            orderUserLabel.textColor = TBIThemePlaceholderTextColor
            orderUserLabel.font = UIFont.systemFont(ofSize: 14)
            orderUserLabel.textAlignment = NSTextAlignment.left
            baseBackgroundView.addSubview(orderUserLabel)
            orderUserLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(orderDateLabel.snp.bottom).offset(marginInterval)
                make.height.equalTo(15)
                make.right.equalToSuperview()
            }
            orderCreateDateLabel.textColor = TBIThemePlaceholderTextColor
            orderCreateDateLabel.font = UIFont.systemFont(ofSize: 13)
            orderCreateDateLabel.backgroundColor = TBIThemeBaseColor
            orderCreateDateLabel.layer.cornerRadius = 15
            orderCreateDateLabel.clipsToBounds = true
            orderCreateDateLabel.textAlignment = NSTextAlignment.center
            baseBackgroundView.addSubview(orderCreateDateLabel)
            orderCreateDateLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(25)
                make.top.equalTo(orderUserLabel.snp.bottom).offset(marginInterval)
                make.height.equalTo(30)
                make.width.equalTo(150)
            }
            orderTotalPriceLabel.textColor = TBIThemeOrangeColor
            orderTotalPriceLabel.backgroundColor = TBIThemeMinorOrangeColor
            orderTotalPriceLabel.layer.cornerRadius = 15
            orderTotalPriceLabel.clipsToBounds = true
            orderTotalPriceLabel.font = UIFont.systemFont(ofSize: 13)
            orderTotalPriceLabel.textAlignment = NSTextAlignment.center
            baseBackgroundView.addSubview(orderTotalPriceLabel)
            orderTotalPriceLabel.snp.makeConstraints { (make) in
                make.right.equalToSuperview().inset(15)
                make.centerY.equalTo(orderCreateDateLabel)
                make.width.equalTo(80)
                make.height.equalTo(30)
            }
            firstLineLabel.frame = CGRect.init(x: 15, y: 170, width: ScreenWindowWidth - 15, height:1)
            baseBackgroundView.addSubview(firstLineLabel)
            ApproveTableViewCell.drawDashLine(lineView: firstLineLabel, lineLength:5 , lineSpacing: 5, lineColor: TBIThemePlaceholderTextColor)
            
            firstLineWidthLabel.isHidden = true
            firstLineWidthLabel.backgroundColor = TBIThemeBaseColor
            baseBackgroundView.addSubview(firstLineWidthLabel)
            firstLineWidthLabel.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(10)
                make.bottom.equalToSuperview()
            }
            
        }
        
        
        func fillDataSources(carDataSources:ApproveListResponseVO.ApproveListOrderInfo,showLine:Bool) {
            var title:String = "   专车"
            if carDataSources.orderTitle.isEmpty == false {
                title = carDataSources.orderTitle
            }
            orderTitleLabel.text = title
            orderNoLabel.text = "订单号" + carDataSources.orderNo
            orderDateLabel.text = carDataSources.orderDetail
            orderUserLabel.text = carDataSources.psgName
            let approvalCreateTimeDate:[String] = carDataSources.approvalCreateTime.components(separatedBy: " ")
            if approvalCreateTimeDate.count > 0 {
                orderCreateDateLabel.text = "创建时间" + approvalCreateTimeDate.first!
            }else{
                orderCreateDateLabel.text = ""
            }
            orderTotalPriceLabel.text = "¥" + carDataSources.amount
            firstLineLabel.isHidden = !showLine
            firstLineWidthLabel.isHidden = showLine
            
        }
    }
    
    //MARK:------Action-------
    func selectedButtonAction(sender:UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        
        if approveTableViewCellSelectedBlock != nil {
            approveTableViewCellSelectedBlock(sender.isSelected,cellIndex)
        }
        
        
    }
    
    
}

