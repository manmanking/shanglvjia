//
//  PBaseInfoCell.swift
//  shanglvjia
//
//  Created by tbi on 23/08/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit

class PBaseInfoCell: UITableViewCell,UITextFieldDelegate {
    
    /// 选择 性别
    typealias BaseInfoSexSelectReturnBlock = (String)->Void
    public var baseInfoSexSelectReturnBlock:BaseInfoSexSelectReturnBlock!
    
    typealias BaseInfoBirthdaySelectReturnBlock = (String)->Void
    public var baseInfoBirthdaySelectReturnBlock:BaseInfoBirthdaySelectReturnBlock!
    
    typealias ClickCallBack = ()->Void
    public var clickCallBack:ClickCallBack!

    private let nameLabel = UILabel(text: "姓名", color: UIColor.gray, size: 15)
    
    public let nameField = UITextField(placeholder: "请输入您的姓名",fontSize: 15)
    
    private let engNameLabel = UILabel(text: "英文名", color: UIColor.gray, size: 15)
    
    public let engNameField = UITextField(placeholder: "请输入您的英文名",fontSize: 15)
    
    private let engFirstLabel = UILabel(text: "英文姓", color: UIColor.gray, size: 15)
    
    public let engFirstField = UITextField(placeholder: "请输入您的英文姓",fontSize: 15)
    
    private let sexLabel = UILabel(text: "性别", color: UIColor.gray, size: 15)
    
    public let sexField = UITextField(placeholder: "请选择",fontSize: 15)
    
    private let birthdayLabel = UILabel(text: "生日", color: UIColor.gray, size: 15)
    
    public let birthdayField = UITextField(placeholder: "生日",fontSize: 15)
    
    private let phoneLabel = UILabel(text: "联系电话", color: UIColor.gray, size: 15)
    
    public let phoneField = UITextField(placeholder: "请输入您的联系电话",fontSize: 15)
    
    private let emailLabel = UILabel(text: "邮箱", color: UIColor.gray, size: 15)
    
    public let emailField = UITextField(placeholder: "请输入您的邮箱",fontSize: 15)
    
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
    func initView(){
        self.addSubview(nameLabel)
        self.addSubview(nameField)
        self.addSubview(engNameLabel)
        self.addSubview(engNameField)
        self.addSubview(engFirstLabel)
        self.addSubview(engFirstField)
        self.addSubview(sexLabel)
        self.addSubview(sexField)
        self.addSubview(birthdayLabel)
        self.addSubview(birthdayField)
        self.addSubview(phoneLabel)
        self.addSubview(phoneField)
        self.addSubview(emailLabel)
        self.addSubview(emailField)
        
        phoneField.keyboardType = UIKeyboardType.numberPad
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(22)
        }
        nameField.delegate = self
        nameField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-23)
            make.centerY.equalTo(nameLabel)
        }
        engNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.centerY.equalTo(66)
        }
        engNameField.delegate = self
        engNameField.snp.makeConstraints { (make) in
            make.left.equalTo(nameField)
            make.right.equalTo(-23)
            make.centerY.equalTo(engNameLabel)
        }
        engFirstLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.centerY.equalTo(22+44*2)
        }
         engFirstField.delegate = self
        engFirstField.snp.makeConstraints { (make) in
            make.left.equalTo(nameField)
            make.right.equalTo(-23)
            make.centerY.equalTo(engFirstLabel)
        }
        sexLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.centerY.equalTo(22+44*3)
        }
        sexField.snp.makeConstraints { (make) in
            make.left.equalTo(nameField)
            make.right.equalTo(-23)
            make.centerY.equalTo(sexLabel)
        }
        let sexArrowImage = UIImageView()
        sexField.addSubview(sexArrowImage)
        sexArrowImage.image = UIImage(named:"ic_right_gray")
        sexArrowImage.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        sexField.addOnClickListener(target: self, action: #selector(selectSexClick(tap: )))
        
        birthdayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.centerY.equalTo(22+44*4)
        }
        birthdayField.snp.makeConstraints { (make) in
            make.left.equalTo(nameField)
            make.right.equalTo(-23)
            make.centerY.equalTo(birthdayLabel)
        }
        birthdayField.isEnabled = false
//        let birthArrowImage = UIImageView()
//        birthdayField.addSubview(birthArrowImage)
//        birthArrowImage.image = UIImage(named:"ic_right_gray")
//        birthArrowImage.snp.makeConstraints { (make) in
//            make.right.equalToSuperview()
//            make.centerY.equalToSuperview()
//        }
//        birthdayField.addOnClickListener(target: self, action: #selector(selectDate(tap: )))
        
        phoneLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.centerY.equalTo(22+44*5)
        }
        phoneField.snp.makeConstraints { (make) in
            make.left.equalTo(nameField)
            make.right.equalTo(-23)
            make.centerY.equalTo(phoneLabel)
        }
        emailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.centerY.equalTo(22+44*6)
        }
        emailField.snp.makeConstraints { (make) in
            make.left.equalTo(nameField)
            make.right.equalTo(-23)
            make.centerY.equalTo(emailLabel)
        }
        for i in 1...6{
            let lineLabel = UILabel.init()
            self.addSubview(lineLabel)
            lineLabel.backgroundColor = PersonalThemeBGGrayColor
            lineLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.right.equalToSuperview()
                make.height.equalTo(1)
                make.top.equalTo(44*i)
            })
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:--------修改性别---------
    func selectSexClick(tap:UITapGestureRecognizer){
        weak var weakSelf = self
        if clickCallBack != nil{
            clickCallBack()
        }
        let titleArr:[String] = ["男","女"]
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.rowHeight = 45
        roleView.fontSize = UIFont.systemFont(ofSize: 18)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            weakSelf?.sexField.text = titleArr[cellIndex]
            if weakSelf?.baseInfoSexSelectReturnBlock != nil{
                weakSelf?.baseInfoSexSelectReturnBlock( titleArr[cellIndex])
            }
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
    }
    
    //MARK:--------选择出生日期---------
    func selectDate(tap:UITapGestureRecognizer){
        if clickCallBack != nil{
            clickCallBack()
        }
        weak var weakSelf = self
        let datePicker = TBIDatePickerView(frame: ScreenWindowFrame)
        datePicker.date = birthdayField.text!
        ///出身日期应该是1949-1-1至系统的当前时间
        datePicker.datePicker.maximumDate =  Date()
        
        datePicker.datePickerResultBlock = { (date) in
            weakSelf?.birthdayField.text =  date
            if weakSelf?.baseInfoBirthdaySelectReturnBlock != nil{
                weakSelf?.baseInfoBirthdaySelectReturnBlock( date)
            }
            
        }
        KeyWindow?.addSubview(datePicker)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        ///中文姓名    字符    10
        ///英文姓    字符    20
        ///英文名    字符    20
        
        let text = textField.text!
        let len = text.count + string.count - range.length
        if textField == nameField{
            return len<=5
        }
        if textField == engNameField||textField == engFirstField{
            return len<=10
        }
        return len<=50
    }
}

