//
//  TravelCarOnOffNumCell.swift
//  shanglvjia
//
//  Created by tbi on 24/08/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit

class TravelCarOnOffNumCell: UITableViewCell,UITextFieldDelegate {

    typealias SwithStatusBlock = (Bool,Int) ->Void
    public var swithStatusBlock:SwithStatusBlock!
    
    typealias UseCarTimeReturnBlock = (String)->Void
    public var useCarTimeReturnBlock:UseCarTimeReturnBlock!
    
    var leftLabel = UILabel(text: "发票", color: PersonalThemeMajorTextColor, size: 15)
    let  gtSwitch = UISwitch()
    let titleLabel:UILabel = UILabel.init(text: "xx", color: PersonalThemeMinorTextColor, size: 15)
    let numView:ChangeNumButton = ChangeNumButton()
    private let lineLabel:UILabel = UILabel()
    private let timeLabel = UILabel(text: "上车时间", color: UIColor.gray, size: 15)
    
    //public let timeField = UITextField(placeholder: "请选择",fontSize: 15)
    public let timeField = UIButton.init(title: "请选择", titleColor: PersonalThemeMajorTextColor, titleSize: 15)
    
    private let addressLabel = UILabel(text: "上车地点", color: UIColor.gray, size: 15)
    
    public let addressField = UITextField(placeholder: "请输入您的上车地点",fontSize: 15)
    
    private let secondLine = UILabel()
    private let thirdLine = UILabel()
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
        self.backgroundColor=TBIThemeWhite
        self.selectionStyle=UITableViewCellSelectionStyle.none
        creatCellUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func creatCellUI(){
        self.addSubview(leftLabel)
        self.addSubview(gtSwitch)
        self.addSubview(titleLabel)
        self.addSubview(numView)
        self.addSubview(lineLabel)
        
        self.addSubview(timeLabel)
        self.addSubview(timeField)
        self.addSubview(addressLabel)
        self.addSubview(addressField)
        
        self.addSubview(secondLine)
        self.addSubview(thirdLine)
        
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(0)
            make.height.equalTo(45)
            make.width.equalTo(270)
        }
        
        gtSwitch.onTintColor = PersonalThemeNormalColor
        gtSwitch.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(leftLabel)
        }
        gtSwitch.addTarget(self, action: #selector(switchChange(sender:)), for: UIControlEvents.valueChanged)
        
        
        lineLabel.backgroundColor = TBIThemeBaseColor
        lineLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(leftLabel.snp.bottom)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(leftLabel.snp.bottom)
            make.height.equalTo(45)
            make.width.equalTo(270)
        }
        numView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(titleLabel)
            make.width.equalTo(90)
            make.height.equalTo(titleLabel)
        }
        ///选择上车时间和地点
        secondLine.backgroundColor = TBIThemeBaseColor
        secondLine.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(45)
        }
        timeField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.top.equalTo(timeLabel)
            make.height.equalTo(45)
            make.right.equalTo(-15)
        }
        let timeArrowImage = UIImageView()
        timeField.addSubview(timeArrowImage)
        timeArrowImage.image = UIImage(named:"ic_right_gray")
        timeArrowImage.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        let startDate:Date = Date.init(timeIntervalSinceNow: 2*60*60)
        //timeField.text = startDate.string(custom: "YYYY-MM-dd HH:mm")
        timeField.setTitle(startDate.string(custom: "YYYY-MM-dd HH:mm"), for: .normal)
        timeField.addTarget(self, action: #selector(selectCarTimeClick(sender:)), for: .touchUpInside)
        timeField.contentHorizontalAlignment = .left
        //timeField.addOnClickListener(target: self, action: #selector(selectCarTimeClick(tap: )))
        
        thirdLine.backgroundColor = TBIThemeBaseColor
        thirdLine.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(timeLabel.snp.bottom)
        }
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(timeLabel.snp.bottom)
            make.height.equalTo(45)
            make.bottom.equalToSuperview()
        }
        addressField.clearButtonMode = .whileEditing
        addressField.delegate = self
        addressField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.top.equalTo(addressLabel)
            make.height.equalTo(45)
            make.right.equalTo(-15)
        }
    }
    
    func fillCell(isBill:Bool,title:String,description:String,section:Int){
        gtSwitch.isOn = isBill
        leftLabel.text = title
        titleLabel.text = description
        
        gtSwitch.tag = section
        
        if isBill == false{
            titleLabel.isHidden = true
            numView.isHidden = true
            timeLabel.isHidden = true
            timeField.isHidden = true
            addressLabel.isHidden = true
            addressField.isHidden = true
        }else{
            titleLabel.isHidden = false
            numView.isHidden = false
            timeLabel.isHidden = false
            timeField.isHidden = false
            addressLabel.isHidden = false
            addressField.isHidden = false
        }
        if useCarTimeReturnBlock != nil{
            useCarTimeReturnBlock( (timeField.titleLabel?.text)!)
        }
    }
    func switchChange(sender:UISwitch){
        if swithStatusBlock != nil{
            swithStatusBlock(sender.isOn,sender.tag)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text!
        let len = text.count + string.count - range.length
        return len<=50
        
    }
    
    func selectCarTimeClick(sender:UIButton){
        weak var weakSelf = self
        self.endEditing(true)
        let datePicker = TBIDatePickerView(frame: ScreenWindowFrame)
        ///出身日期应该是1949-1-1至系统的当前时间
        datePicker.datePicker.datePickerMode = .dateAndTime
        datePicker.datePicker.maximumDate =  Date.init(timeIntervalSinceNow: 2*365*24*60*60)
        ///最早是当前时间两小时后
        datePicker.datePicker.minimumDate =   Date.init(timeIntervalSinceNow: 2*60*60)
        datePicker.datePickerResultBlock = { (date) in
           
            weakSelf?.timeField.setTitle(date, for: .normal)
            if weakSelf?.useCarTimeReturnBlock != nil{
                weakSelf?.useCarTimeReturnBlock( date)
            }
        }
        KeyWindow?.addSubview(datePicker)
    }
}
