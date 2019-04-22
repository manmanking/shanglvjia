//
//  ApprovalDetailPassengerTableViewCell.swift
//  shanglvjia
//
//  Created by manman on 2018/5/21.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class ApprovalDetailPassengerTableViewCell: UITableViewCell {

    typealias ApprovalDetailPassengerTableViewCellBlock = (NSInteger) ->Void
    
    public var approvalDetailPassengerTableViewCellBlock:ApprovalDetailPassengerTableViewCellBlock!
    
    private let baseBackgroundView:UIView = UIView()
    
    private let titleLabel:UILabel = UILabel()
    
    private let titleFlagLabel:UILabel = UILabel()
    
    private let firstLineLabel:UILabel = UILabel()
    
    private let titleContentLabel:UILabel = UILabel()
    
    private let subTitleLabel:UILabel = UILabel()
    
    private let subTitleContentLabel:UILabel = UILabel()
    
    private var baseInfoArr:[UIView] = Array()
    
    private let flightTitleDefaultTip:String =  "乘机人"
    private let trainTitleDefaultTip:String =  "乘车人"
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = TBIThemeBaseColor
        baseBackgroundView.backgroundColor = TBIThemeWhite
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)
        }
        setUIAutolayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUIAutolayout() {
        
        titleFlagLabel.backgroundColor = TBIThemeDarkBlueColor
        baseBackgroundView.addSubview(titleFlagLabel)
        titleFlagLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.left.equalToSuperview()
            make.width.equalTo(3)
            make.height.equalTo(33)
        }
        titleLabel.textColor = TBIThemePrimaryTextColor
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = NSTextAlignment.left
        baseBackgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleFlagLabel)
            make.height.equalTo(33)
            make.right.equalToSuperview()
            make.left.equalToSuperview().inset(15)
        }
        
        firstLineLabel.backgroundColor = TBIThemeGrayLineColor
        baseBackgroundView.addSubview(firstLineLabel)
        firstLineLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.height.equalTo(1)
        }
    }
    
    func fillDataSources(title:String,passengers:[ApproveDetailResponseVO.PassengerResponse]) {
        guard passengers.count > 0 else {
            return
        }
        _ = baseInfoArr.map{$0.removeFromSuperview()}
        
        var titleInfo:String = title
        if passengers.count > 0 {
            titleInfo = title + "   " + "(共" + passengers.count.description + "人)"
        }
        titleLabel.text = titleInfo
        
        var type:PassengerInfoCellType = PassengerInfoCellType.Trains
        var intoNext:Bool = false
        var cellHight:NSInteger = 70
        if title == flightTitleDefaultTip {
            type = PassengerInfoCellType.Flight
            cellHight = 55
            intoNext = true
            
        }
        
        
        let topMargin:NSInteger = 44
        var viewY:NSInteger = 0
        
        for (index,element) in passengers.enumerated() {
            viewY = index * cellHight + topMargin
            let tmpCell:PassengerInfoCell = PassengerInfoCell()
            baseBackgroundView.addSubview(tmpCell)
            tmpCell.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().inset(viewY)
                make.height.equalTo(cellHight)
            }
            if element.surances.count > 0 && element.surances[0].first == true
            {
                intoNext = true
            }else{
                intoNext = false
            }
            tmpCell.fillDataSources(passenger:element, index: index, intoNext: intoNext, type:type)
            weak var weakSelf = self
            
            tmpCell.passengerInfoCellIntoDetailBlock = { index in
                weakSelf?.selectedPassengerIntoNextDetail(index: index)
            }
            baseInfoArr.append(tmpCell)
        }
        
        
        
    }
    
    func selectedPassengerIntoNextDetail(index:NSInteger) {
        if approvalDetailPassengerTableViewCellBlock  != nil {
            approvalDetailPassengerTableViewCellBlock(index)
        }
    }
    
    
    
    class PassengerInfoCell: UIView {
        
        typealias PassengerInfoCellIntoDetailBlock = (NSInteger)->Void
        
        public var passengerInfoCellIntoDetailBlock:PassengerInfoCellIntoDetailBlock!
        
        private let baseBackgroundView:UIView = UIView()
        
        private let titleLabel:UILabel = UILabel()
        
        private let titleContentLabel:UILabel = UILabel()
        
        private let trainSitInfoContentLabel:UILabel = UILabel()
        
        private let firstLineLabel:UILabel = UILabel()
        
        private let intoNextButton:UIButton = UIButton()
        
        private var cellIndex:NSInteger = 0
        
        
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
           
            titleLabel.textColor = TBIThemePrimaryTextColor
            titleLabel.font = UIFont.systemFont(ofSize: 15)
            baseBackgroundView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().inset(8)
                make.left.equalToSuperview().inset(15)
                make.height.equalTo(16)
                make.right.equalToSuperview().inset(50)
            }
            
            titleContentLabel.textColor = UIColor.gray
            titleContentLabel.font = UIFont.systemFont(ofSize: 13)
            baseBackgroundView.addSubview(titleContentLabel)
            titleContentLabel.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
                make.height.equalTo(16)
                make.left.equalToSuperview().inset(15)
                make.right.equalToSuperview().inset(50)
            }
            
            trainSitInfoContentLabel.textColor = UIColor.gray
            trainSitInfoContentLabel.font = UIFont.systemFont(ofSize: 13)
            baseBackgroundView.addSubview(trainSitInfoContentLabel)
            trainSitInfoContentLabel.snp.makeConstraints { (make) in
                make.top.equalTo(titleContentLabel.snp.bottom).offset(3)
                make.height.equalTo(16)
                make.left.equalToSuperview().inset(15)
                make.right.equalToSuperview().inset(50)
            }
            
            intoNextButton.addTarget(self, action: #selector(intoNextButton(sender:)), for: UIControlEvents.touchUpInside)
            intoNextButton.setImage(UIImage.init(named: "Common_Forward_Arrow_Gray"), for: UIControlState.normal)
            intoNextButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            baseBackgroundView.addSubview(intoNextButton)
            intoNextButton.contentHorizontalAlignment=UIControlContentHorizontalAlignment.right
            intoNextButton.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.width.equalTo(60)
                make.height.equalToSuperview()
                make.right.equalToSuperview().inset(15)
            }
  
        }
        
        
        
        func intoNextButton(sender:UIButton) {
            if passengerInfoCellIntoDetailBlock != nil {
                passengerInfoCellIntoDetailBlock(cellIndex)
            }
            
        }
        
        
        func fillDataSources(passenger:ApproveDetailResponseVO.PassengerResponse,index:NSInteger,intoNext:Bool,type:PassengerInfoCellType) {
            
            titleLabel.text = passenger.psgName
            var typeStr:String = "身份证"
            
            if passenger.certType == "2" || passenger.certType == "护照" {
                typeStr = "护照"
            }
            titleContentLabel.text = typeStr + "  " + passenger.certNo
            intoNextButton.isHidden = !intoNext
            cellIndex = index
            if type == PassengerInfoCellType.Flight {
                trainSitInfoContentLabel.isHidden = true
            }else {
                trainSitInfoContentLabel.isHidden = false
                trainSitInfoContentLabel.text = passenger.siteCodeCH + " " + passenger.siteInfo
            }
            
            
        }
    }
    
    enum PassengerInfoCellType:NSInteger {
        case Flight = 1
        case Trains = 2
    }
    
    
    
}
