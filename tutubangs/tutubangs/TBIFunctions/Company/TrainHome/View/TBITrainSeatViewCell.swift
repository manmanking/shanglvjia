//
//  TBITrainSeatView.swift
//  shanglvjia
//
//  Created by manman on 2018/4/13.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class TBITrainSeatViewCell: UITableViewCell {
    
    typealias TBITrainSeatViewCellSelectedSeatBlock = ([(line:String,seatNo:String)],String)->Void
    
    public var trainSeatViewCellSelectedSeatBlock:TBITrainSeatViewCellSelectedSeatBlock!
    
    private let titleLabel:UILabel = UILabel()
    
    private let tripTypeLabel:UILabel = UILabel()

    private let choiceSeatTitleLabel:UILabel = UILabel()
    
    private var cellIndex:NSInteger = 0
    
    private var passengerSum:NSInteger = 1
    
    private var selectedSeatArr:[(line:String,seatNo:String)] = Array()
    
    //两个都新建出来
    private let firstTrainSeatTypeView:TrainSeatTypeView = TrainSeatTypeView()
    
    private let secondTrainSeatTypeView:TrainSeatTypeView = TrainSeatTypeView()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = TBIThemeWhite
        setUIViewAutolayout()
    }
 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUIViewAutolayout() {
        
        titleLabel.text = "座位信息"
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = TBIThemePrimaryTextColor
        titleLabel.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(16)
            make.height.equalTo(15)
        }
        
        tripTypeLabel.text = "去"// 去。返
        tripTypeLabel.textColor = TBIThemeWhite
        tripTypeLabel.clipsToBounds = true
        tripTypeLabel.textAlignment = NSTextAlignment.center
        tripTypeLabel.font = UIFont.systemFont(ofSize: 12)
        tripTypeLabel.backgroundColor = TBIThemeBlueColor
        tripTypeLabel.layer.cornerRadius = 2
        self.contentView.addSubview(tripTypeLabel)
        tripTypeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(33)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.height.equalTo(18)
        }
        
        choiceSeatTitleLabel.text = "已选座 2/2"
        choiceSeatTitleLabel.font = UIFont.systemFont(ofSize: 13)
        choiceSeatTitleLabel.textColor = TBIThemePrimaryTextColor
        choiceSeatTitleLabel.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(choiceSeatTitleLabel)
        choiceSeatTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(tripTypeLabel.snp.right).offset(10)
            make.centerY.equalTo(tripTypeLabel.snp.centerY)
        }
        setOneLineAutolayout()
    }

    func customUIViewAutolayout(passengersum:NSInteger,title:String,seatType:SeatTrain){
        self.passengerSum = passengersum
        //self.cellIndex = rowIndex
        
        if title == "去" {
            tripTypeLabel.text = "去"
            setTrainViewType(view: firstTrainSeatTypeView, seatType: seatType)
            if passengersum > 1 {
                setTwoLineAutolayout()
                setTrainViewType(view: secondTrainSeatTypeView, seatType: seatType)
            }else
            {
                setOneLineAutolayout()
            }
        }else
        {
            tripTypeLabel.text = "返"
            setTrainViewType(view: firstTrainSeatTypeView, seatType: seatType)
            if passengersum > 1 {
                setTwoLineAutolayout()
                setTrainViewType(view: secondTrainSeatTypeView, seatType: seatType)
            }else
            {
                setOneLineAutolayout()
            }
        }
       
        choiceSeatTitleLabel.text = "已选座 0/" + passengerSum.description
        selectedSeatArr.removeAll()
        let attributedString = NSMutableAttributedString(string:choiceSeatTitleLabel.text!)
        attributedString.addAttribute(NSForegroundColorAttributeName, value:TBIThemeOrangeColor,range: NSMakeRange(4,1))
        choiceSeatTitleLabel.attributedText = attributedString
        
       
    }
    
    func setTrainViewType(view:TrainSeatTypeView,seatType:SeatTrain) {
        switch seatType {
        case .swzSeat:
            view.setTrainSeatType(type: TBITrainSeatViewCell.TBITrainSeatType.TrainSeat_BusinessSeat)
        case .ydzSeat:
            view.setTrainSeatType(type: TBITrainSeatViewCell.TBITrainSeatType.TrainSeat_FirstClass)
        case .edzSeat:
            view.setTrainSeatType(type: TBITrainSeatViewCell.TBITrainSeatType.TrainSeat_SecondClass)
        default:
            break
        }
    }
    
    
    
    
    
   private func setOneLineAutolayout() {
        self.contentView.addSubview(firstTrainSeatTypeView)
        firstTrainSeatTypeView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(tripTypeLabel.snp.bottom).offset(25)
            make.height.equalTo(30)
        }
        weak var weakSelf = self
        firstTrainSeatTypeView.trainSeatTypeViewSelectedSeatBlock = { selectedSeat in
            weakSelf?.selectedSeatStore(selectedSeat: selectedSeat, line: "1")
        }
        if secondTrainSeatTypeView.isHidden == false {
            secondTrainSeatTypeView.isHidden = true
        }
    }
   private func setTwoLineAutolayout() {
        if secondTrainSeatTypeView.isHidden == true {
            secondTrainSeatTypeView.isHidden = false
        }
        self.contentView.addSubview(secondTrainSeatTypeView)
        secondTrainSeatTypeView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(firstTrainSeatTypeView.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        weak var weakSelf = self
        secondTrainSeatTypeView.trainSeatTypeViewSelectedSeatBlock = { selectedSeat in
            weakSelf?.selectedSeatStore(selectedSeat: selectedSeat, line: "2")
        }
    }
    
    /// 保存选中的坐席
    ///
    /// - Parameters:
    ///   - selectedSeat:
    ///   - line:
    private func selectedSeatStore(selectedSeat:String,line:String) {
        
       let isContain = selectedSeatArr.contains { (element) -> Bool in
            if element.line == line && selectedSeat == element.seatNo {
                return true
            }
            return false
        }
        
        if isContain  == false {
           selectedSeatArr.append((line: line, seatNo: selectedSeat))
        }else
        {
            if isContain == true {
                for (index,element) in selectedSeatArr.enumerated() {
                    if element.line == line && element.seatNo == selectedSeat
                    {
                        selectedSeatArr.remove(at: index)
                        break
                    }
                }
            }
        }
        if selectedSeatArr.count > passengerSum {
            if selectedSeatArr.first?.line == "1" {
                firstTrainSeatTypeView.deleteSelectedSeat(deletedSeat:(selectedSeatArr.first?.seatNo)!)
            }else{
                secondTrainSeatTypeView.deleteSelectedSeat(deletedSeat:(selectedSeatArr.first?.seatNo)!)
            }
            selectedSeatArr.removeFirst()
        }
        choiceSeatTitleLabel.text = "已选座 " + selectedSeatArr.count.description + "/" + passengerSum.description
        if trainSeatViewCellSelectedSeatBlock != nil {
            trainSeatViewCellSelectedSeatBlock(selectedSeatArr,tripTypeLabel.text ?? "去")
        }
    }
    
    
    
    
    
    
    
    
    
    enum TBITrainSeatType:NSInteger {
        case TrainSeat_BusinessSeat = 1
        case TrainSeat_FirstClass = 2
        case TrainSeat_SecondClass = 3
    }

    
    
    class TrainSeatTypeView: UIView {
        
        typealias TrainSeatTypeViewSelectedSeatBlock = (String)->Void
        
        public var trainSeatTypeViewSelectedSeatBlock:TrainSeatTypeViewSelectedSeatBlock!
        
        
        private var storeSelectedSeat:[String] = Array()
        
        private let leftWindowLabel:UILabel = UILabel()
        
        private let rightWindowLabel:UILabel = UILabel()
        
        private let middleHallwayLabel:UILabel = UILabel()
        
        private let firstSeatButton:UIButton = UIButton()
        private let secondSeatButton:UIButton = UIButton()
        private let thirdSeatButton:UIButton = UIButton()
        private let forthSeatButton:UIButton = UIButton()
        private let fifthSeatButton:UIButton = UIButton()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = TBIThemeWhite
            setUIViewAutolayout()
            
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        //动态创建 button。和 创建好之后 隐藏 显示 的内存 使用 更加友好
        // 默认试图为二等座 视图
        private func setUIViewAutolayout() {
            leftWindowLabel.text = "窗"
            leftWindowLabel.textColor = TBIThemePrimaryTextColor
            leftWindowLabel.font = UIFont.systemFont(ofSize: 12)
            leftWindowLabel.textAlignment = NSTextAlignment.center
            self.addSubview(leftWindowLabel)
            firstSeatButton.setImage(UIImage.init(named: "ic_seat_a"), for: UIControlState.normal)
            firstSeatButton.setImage(UIImage.init(named: "ic_seat_a_sel"), for: UIControlState.selected)
            firstSeatButton.addTarget(self, action: #selector(selectedSeatAction(sender:)), for: UIControlEvents.touchUpInside)
            self.addSubview(firstSeatButton)
            secondSeatButton.setImage(UIImage.init(named: "ic_seat_b"), for: UIControlState.normal)
            secondSeatButton.setImage(UIImage.init(named: "ic_seat_b_sel"), for: UIControlState.selected)
            secondSeatButton.addTarget(self, action: #selector(selectedSeatAction(sender:)), for: UIControlEvents.touchUpInside)
            self.addSubview(secondSeatButton)
            thirdSeatButton.setImage(UIImage.init(named: "ic_seat_c"), for: UIControlState.normal)
            thirdSeatButton.setImage(UIImage.init(named: "ic_seat_c_sel"), for: UIControlState.selected)
            thirdSeatButton.addTarget(self, action: #selector(selectedSeatAction(sender:)), for: UIControlEvents.touchUpInside)
            self.addSubview(thirdSeatButton)
            middleHallwayLabel.text = "过道"
            middleHallwayLabel.textColor = TBIThemePrimaryTextColor
            middleHallwayLabel.font = UIFont.systemFont(ofSize: 12)
            middleHallwayLabel.textAlignment = NSTextAlignment.center
            self.addSubview(middleHallwayLabel)
            rightWindowLabel.text = "窗"
            rightWindowLabel.textColor = TBIThemePrimaryTextColor
            rightWindowLabel.font = UIFont.systemFont(ofSize: 12)
            rightWindowLabel.textAlignment = NSTextAlignment.center
            self.addSubview(rightWindowLabel)
            forthSeatButton.setImage(UIImage.init(named: "ic_seat_d"), for: UIControlState.normal)
            forthSeatButton.setImage(UIImage.init(named: "ic_seat_d_sel"), for: UIControlState.selected)
            forthSeatButton.addTarget(self, action: #selector(selectedSeatAction(sender:)), for: UIControlEvents.touchUpInside)
            self.addSubview(forthSeatButton)
            fifthSeatButton.setImage(UIImage.init(named: "ic_seat_f"), for: UIControlState.normal)
            fifthSeatButton.setImage(UIImage.init(named: "ic_seat_f_sel"), for: UIControlState.selected)
            fifthSeatButton.addTarget(self, action: #selector(selectedSeatAction(sender:)), for: UIControlEvents.touchUpInside)
            self.addSubview(fifthSeatButton)
            setSecondClassSeatView()
        }
        
        
        func allDeleteSeat() {
            firstSeatButton.isHidden = true
            firstSeatButton.isSelected = false
            secondSeatButton.isHidden = true
            secondSeatButton.isSelected = false
            thirdSeatButton.isHidden = true
            thirdSeatButton.isSelected = false
            forthSeatButton.isHidden = true
            forthSeatButton.isSelected = false
            fifthSeatButton.isHidden = true
            fifthSeatButton.isSelected = false
        }
        
        /// 商务座
        private func setBusinessSeatView() {
            allDeleteSeat()
            
            middleHallwayLabel.snp.remakeConstraints { (make) in
//                make.left.equalTo(thirdSeatButton.snp.right)
//                make.right.equalTo(fifthSeatButton.snp.left)
                make.width.equalTo(40)
                make.center.equalToSuperview()
                make.height.equalToSuperview()
            }
            thirdSeatButton.isHidden = false
            thirdSeatButton.snp.remakeConstraints { (make) in
                make.right.equalTo(middleHallwayLabel.snp.left).offset(-16)
                make.width.equalTo(30)
                make.height.equalTo(30)
                make.centerY.equalToSuperview()
            }
            firstSeatButton.isHidden = false
            firstSeatButton.snp.remakeConstraints { (make) in
                make.right.equalTo(thirdSeatButton.snp.left).offset(-12)
                make.width.equalTo(30)
                make.height.equalTo(30)
                make.centerY.equalToSuperview()
            }
            
            leftWindowLabel.snp.remakeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.right.equalTo(firstSeatButton.snp.left).offset(-16)
                make.width.equalTo(14)
            }
            
            fifthSeatButton.isHidden = false
            fifthSeatButton.snp.remakeConstraints { (make) in
                make.left.equalTo(middleHallwayLabel.snp.right).offset(12)
                //make.right.equalTo(rightWindowLabel.snp.left).offset(-16)
                make.width.equalTo(30)
                make.height.equalTo(30)
                make.centerY.equalToSuperview()
            }
            
            rightWindowLabel.snp.remakeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(fifthSeatButton.snp.right).offset(16)
                make.width.equalTo(14)
            }
        }
        
        
        /// 设置一等座视图
        private func setFirstClassSeatView() {
            allDeleteSeat()
            
            middleHallwayLabel.snp.remakeConstraints { (make) in
                //make.left.equalTo(thirdSeatButton.snp.right).offset(16)
                make.width.equalTo(30)
                make.center.equalToSuperview()
                make.height.equalToSuperview()
            }
            thirdSeatButton.isHidden = false
            thirdSeatButton.snp.remakeConstraints { (make) in
                make.right.equalTo(middleHallwayLabel.snp.left).offset(-16)
                make.width.equalTo(30)
                make.height.equalTo(30)
                make.centerY.equalToSuperview()
            }
            firstSeatButton.isHidden = false
            firstSeatButton.snp.remakeConstraints { (make) in
                make.right.equalTo(thirdSeatButton.snp.left).offset(-12)
                make.width.equalTo(30)
                make.height.equalTo(30)
                make.centerY.equalToSuperview()
            }
            leftWindowLabel.snp.remakeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.right.equalTo(firstSeatButton.snp.left).offset(-16)
                make.width.equalTo(14)
            }
            forthSeatButton.isHidden = false
            forthSeatButton.snp.remakeConstraints { (make) in
                //make.left.equalTo(middleHallwayLabel.snp.right).offset(12)
                make.left.equalTo(middleHallwayLabel.snp.right).offset(16)
                make.width.equalTo(30)
                make.height.equalTo(30)
                make.centerY.equalToSuperview()
            }

            fifthSeatButton.isHidden = false
            fifthSeatButton.snp.remakeConstraints { (make) in
                make.left.equalTo(forthSeatButton.snp.right).offset(12)
                make.width.equalTo(30)
                make.height.equalTo(30)
                make.centerY.equalToSuperview()
            }
            rightWindowLabel.snp.remakeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(fifthSeatButton.snp.right).offset(16)
                make.width.equalTo(14)
            }
           
        }
        
        /// 设置二等座视图
        private func setSecondClassSeatView() {
            allDeleteSeat()
            leftWindowLabel.snp.remakeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalToSuperview().inset(40)
                make.width.equalTo(14)
            }
            firstSeatButton.isHidden = false
            firstSeatButton.snp.remakeConstraints { (make) in
                make.left.equalTo(leftWindowLabel.snp.right).offset(16)
                make.width.equalTo(30)
                make.height.equalTo(30)
                make.centerY.equalToSuperview()
            }
            
            secondSeatButton.isHidden = false
            secondSeatButton.snp.remakeConstraints { (make) in
                make.left.equalTo(firstSeatButton.snp.right).offset(12)
                make.width.equalTo(30)
                make.height.equalTo(30)
                make.centerY.equalToSuperview()
            }
            thirdSeatButton.isHidden = false
            thirdSeatButton.snp.remakeConstraints { (make) in
                make.left.equalTo(secondSeatButton.snp.right).offset(12)
                make.width.equalTo(30)
                make.height.equalTo(30)
                make.centerY.equalToSuperview()
            }
            rightWindowLabel.snp.remakeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.right.equalToSuperview().inset(40)
                make.width.equalTo(14)
            }
            fifthSeatButton.isHidden = false
            fifthSeatButton.snp.remakeConstraints { (make) in
                //make.left.equalTo(forthSeatButton.snp.right).offset(12)
                make.right.equalTo(rightWindowLabel.snp.left).offset(-16)
                make.width.equalTo(30)
                make.height.equalTo(30)
                make.centerY.equalToSuperview()
            }
            forthSeatButton.isHidden = false
            forthSeatButton.snp.remakeConstraints { (make) in
                make.right.equalTo(fifthSeatButton.snp.left).offset(-12)
                make.width.equalTo(30)
                make.height.equalTo(30)
                make.centerY.equalToSuperview()
            }
            middleHallwayLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(thirdSeatButton.snp.right)
                make.right.equalTo(forthSeatButton.snp.left)
                //make.width.equalTo(30)
                make.centerY.equalToSuperview()
                make.height.equalToSuperview()
            }
        }
        
       /// 设置试图样式
       public func setTrainSeatType(type:TBITrainSeatType) {
            switch type {
            case .TrainSeat_BusinessSeat:
                setBusinessSeatView()
            case .TrainSeat_FirstClass:
                setFirstClassSeatView()
            case .TrainSeat_SecondClass:
                setSecondClassSeatView()
            }
        }
        
      private  func resetSeatStstus() {
            firstSeatButton.isSelected = false
            secondSeatButton.isSelected = false
            thirdSeatButton.isSelected = false
            forthSeatButton.isSelected = false
            fifthSeatButton.isSelected = false
        }
        
        
      public  func setSelectedSeat(selectedSeat:[String]) {
            resetSeatStstus()
            for element in selectedSeat {
                switch element {
                case "A":
                    firstSeatButton.isSelected = true
                case "B":
                    secondSeatButton.isSelected = true
                case "C":
                    thirdSeatButton.isSelected = true
                case "D":
                    forthSeatButton.isSelected = true
                case "F":
                    fifthSeatButton.isSelected = true
                default:
                    break
                }
            }
        }
        
        /// 取消选中
        public func deleteSelectedSeat(deletedSeat:String){
                switch deletedSeat {
                case "A":
                    firstSeatButton.isSelected = false
                case "B":
                    secondSeatButton.isSelected = false
                case "C":
                    thirdSeatButton.isSelected = false
                case "D":
                    forthSeatButton.isSelected = false
                case "F":
                    fifthSeatButton.isSelected = false
                default:
                    break
            }
        }
        
        
        //MARK:-------Action------
        
        func selectedSeatAction(sender:UIButton) {
            if sender.isSelected == true { sender.isSelected = false }
            else {sender.isSelected = true }
            var selectedSeat:String = ""
            switch sender {
            case firstSeatButton:
                selectedSeat = "A"
            case secondSeatButton:
                selectedSeat = "B"
            case thirdSeatButton:
                selectedSeat = "C"
            case forthSeatButton:
                selectedSeat = "D"
            case fifthSeatButton:
                selectedSeat = "F"
            default:
                break
            }
            
            if trainSeatTypeViewSelectedSeatBlock != nil {
                trainSeatTypeViewSelectedSeatBlock(selectedSeat)
            }
        }
        
    }
  
    
    
    
    
}
