//
//  TripPeopleListCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/23.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class TripPeopleListCell: UITableViewCell {

    typealias TripPeopleListSelectedBlock = (NSInteger,String)->Void
    public var tripPeopleListSelectedBlock:TripPeopleListSelectedBlock!
    private let phoneLabel:UILabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 13)
    let nameLabel:UILabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 15)
    let relationLabel:UILabel = UILabel.init(text: "", color: PersonalThemeNormalColor, size: 11)
    
    let idLabel:UILabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 13)
    let bgView:UIView = UIView()
    let selectButton:UIButton = UIButton()
    private let idCardNoInternationalErrorInfoDefaultTip:String = "护照信息不完整"
    private let idCardNoMainlandErrorInfoDefaultTip:String = "信息不完整"
    private var cellIndex:NSInteger = 99
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
        self.backgroundColor = TBIThemeBaseColor
        self.selectionStyle = .none
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView(){
        self.addSubview(bgView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(relationLabel)
        bgView.addSubview(idLabel)
        bgView.addSubview(selectButton)
        
        bgView.backgroundColor = TBIThemeWhite
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.right.left.bottom.equalToSuperview()
            make.height.equalTo(75)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(25)
        }
        relationLabel.layer.borderWidth = 1.0
        relationLabel.layer.cornerRadius = 2
        relationLabel.clipsToBounds = true
        relationLabel.layer.borderColor = PersonalThemeNormalColor.cgColor
        relationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(12)
            make.centerY.equalTo(nameLabel)
        }
        bgView.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.left.equalTo(nameLabel.snp.left)
            make.height.equalTo(20)
        }
        
        idLabel.snp.makeConstraints { (make) in
            make.top.equalTo(phoneLabel.snp.bottom).offset(5)
            make.left.equalTo(nameLabel.snp.left)
            //make.centerY.equalTo(50)
            make.height.equalTo(20)
        }
        
        selectButton.contentHorizontalAlignment = .right
        selectButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
            make.width.height.equalTo(50)
        }
        selectButton.setImage(UIImage(named:"personal_noselect_kuang"), for: UIControlState.normal)
        selectButton.setImage(UIImage(named:"personal_select_kuang"), for: UIControlState.selected)
        selectButton.addTarget(self, action: #selector(selectTripPeople(sender:)), for: UIControlEvents.touchUpInside)
    }
    func setCellWithModel(model:PersonalTravellerInfoRequest,cellRow:NSInteger,isSelected:Bool,type:AppModelInternationalType)  {
       
        
        
        idCardShowConfig(model: model, type: type)
       
        relationLabel.text = " \(model.relationTypeLocal.getChineseRelation()) "
        cellIndex = cellRow
        selectButton.setEnlargeEdgeWithTop(10, left: 10, bottom: 10, right: 0)
        selectButton.isSelected = isSelected
        phoneLabel.text = "手机号:" + model.mobile
    }
    
    func idCardShowConfig(model:PersonalTravellerInfoRequest,type:AppModelInternationalType) {
        
        switch type {
    case .PersonalInternationalTravel,.PersonalOnsaleInternationalFlight,
         .PersonalSpecialInternationalFlight,.PersonalInternationalHotel,
         .PersonalInternationalFlight:
            passportPriority(model: model)
        case .PersonalVisa:
            passportCard(model: model)
        default:
            identityCardPriority(model: model)
            
        }
        
        
       
        
    }
    
    func passportCard(model:PersonalTravellerInfoRequest) {
        nameLabel.text = (model.chName.isEmpty ? "\(model.enNameFirst) \(model.enNameSecond)" : model.chName )
        idLabel.text = model.passportNo.isEmpty ?  idCardNoInternationalErrorInfoDefaultTip : "护照:\(model.passportNo)"
    }
    
    
    func passportPriority(model:PersonalTravellerInfoRequest) {
        nameLabel.text = (model.chName.isEmpty ? "\(model.enNameFirst) \(model.enNameSecond)" : model.chName )
        
        var idNum:String = ""
        if  model.certNo.isEmpty == true && model.passportNo.isEmpty == true {
            idNum = idCardNoInternationalErrorInfoDefaultTip
        }else {
            idNum = model.passportNo.isEmpty ? "身份证:\(model.certNo)" : "护照:\(model.passportNo)"
        }
        idLabel.text = idNum
        
        //model.passportNo.isEmpty ? idCardNoErrorInfoDefaultTip : "护照:\(model.passportNo)"
    }
    
    func identityCardPriority(model:PersonalTravellerInfoRequest) {
        nameLabel.text = (model.chName.isEmpty ? "\(model.enNameFirst) \(model.enNameSecond)" : model.chName )
        //idLabel.text = model.certNo.isEmpty ?  idCardNoErrorInfoDefaultTip : "身份证:\(model.certNo)"
        var idNum:String = ""
        if  model.certNo.isEmpty == true && model.passportNo.isEmpty == true {
            idNum = idCardNoMainlandErrorInfoDefaultTip
        }else {
            idNum = model.certNo.isEmpty ? "护照:\(model.passportNo)" : "身份证:\(model.certNo)"
        }
        idLabel.text = idNum
    }

    func selectTripPeople(sender:UIButton){
        
        var currentTitle:String = idLabel.text ?? ""
        if currentTitle == idCardNoMainlandErrorInfoDefaultTip || currentTitle == idCardNoInternationalErrorInfoDefaultTip {
            currentTitle = ""
        }
        
        if tripPeopleListSelectedBlock != nil {
            tripPeopleListSelectedBlock(cellIndex,currentTitle)
        }
      
    }
}
