//
//  PBaseInfoCertCell.swift
//  shanglvjia
//
//  Created by tbi on 23/08/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit

class PBaseInfoCertCell: UITableViewCell ,UITextFieldDelegate{

    typealias NationalitySelectReturnBlock = (String)->Void
    public var nationalitySelectReturnBlock:NationalitySelectReturnBlock!
    
    typealias IdCardCompleteReturnBlock = (String)->Void
    public var idCardCompleteReturnBlock:IdCardCompleteReturnBlock!
    
    typealias PassportNationSelectReturnBlock = (String)->Void
    public var passportNationSelectReturnBlock:PassportNationSelectReturnBlock!
    
    typealias PassportTimeSelectReturnBlock = (String)->Void
    public var passportTimeSelectReturnBlock:PassportTimeSelectReturnBlock!
    
    private let nationLabel = UILabel(text: "国籍", color: UIColor.gray, size: 15)
    
    public let nationField = UITextField(placeholder: "请选择",fontSize: 15)
    
    private let certLabel = UILabel(text: "身份证号", color: UIColor.gray, size: 15)
    
    public let certField = UITextField(placeholder: "请输入您的身份证号",fontSize: 15)
    
    private let passportLabel = UILabel(text: "护照号", color: UIColor.gray, size: 15)
    
    public let passportField = UITextField(placeholder: "请输入您的护照号",fontSize: 15)
    
    private let passportNationLabel = UILabel(text: "护照签发国", color: UIColor.gray, size: 15)
    
    public let passportNationField = UITextField(placeholder: "请选择",fontSize: 15)
    
    private let passportTimeLabel = UILabel(text: "护照有效期", color: UIColor.gray, size: 15)
    
    public let passportTimeField = UITextField(placeholder: "请选择",fontSize: 15)
    
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
        self.selectionStyle = .none
        initView()
    }
    func initView(){
        self.addSubview(nationLabel)
        self.addSubview(nationField)
        self.addSubview(certLabel)
        self.addSubview(certField)
        self.addSubview(passportLabel)
        self.addSubview(passportField)
        self.addSubview(passportNationLabel)
        self.addSubview(passportNationField)
        self.addSubview(passportTimeLabel)
        self.addSubview(passportTimeField)
        
        nationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(22)
        }
        nationField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-23)
            make.centerY.equalTo(nationLabel)
        }
        let nationArrowImage = UIImageView()
        nationField.addSubview(nationArrowImage)
        nationArrowImage.image = UIImage(named:"ic_right_gray")
        nationArrowImage.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        nationField.addOnClickListener(target: self, action: #selector(selectNation(tap: )))
        
        certLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nationLabel)
            make.centerY.equalTo(22+44)
        }
        certField.delegate = self
        certField.snp.makeConstraints { (make) in
            make.left.equalTo(nationField)
            make.right.equalTo(-23)
            make.centerY.equalTo(certLabel)
        }
        passportLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nationLabel)
            make.centerY.equalTo(22+44*2)
        }
         passportField.delegate = self
        passportField.snp.makeConstraints { (make) in
            make.left.equalTo(nationField)
            make.right.equalTo(-23)
            make.centerY.equalTo(passportLabel)
        }
        passportNationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nationLabel)
            make.centerY.equalTo(22+44*3)
        }
        passportNationField.snp.makeConstraints { (make) in
            make.left.equalTo(nationField)
            make.right.equalTo(-23)
            make.centerY.equalTo(passportNationLabel)
        }
        let passnationArrowImage = UIImageView()
        passportNationField.addSubview(passnationArrowImage)
        passnationArrowImage.image = UIImage(named:"ic_right_gray")
        passnationArrowImage.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        passportNationField.addOnClickListener(target: self, action: #selector(selectNationPassport(tap: )))
        
        passportTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nationLabel)
            make.centerY.equalTo(22+44*4)
        }
        passportTimeField.snp.makeConstraints { (make) in
            make.left.equalTo(nationField)
            make.right.equalTo(-23)
            make.centerY.equalTo(passportTimeLabel)
        }
        let passtimeArrowImage = UIImageView()
        passportTimeField.addSubview(passtimeArrowImage)
        passtimeArrowImage.image = UIImage(named:"ic_right_gray")
        passtimeArrowImage.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        passportTimeField.addOnClickListener(target: self, action: #selector(selectTimePassport(tap: )))
        
        for i in 1...4{
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
    
    func selectNation(tap:UIGestureRecognizer){
        weak var weakSelf = self
        self.endEditing(true)
        let titleArr:[String] = ["中国","日本"]
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.rowHeight = 44
        roleView.fontSize = UIFont.systemFont(ofSize: 18)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            weakSelf?.nationField.text = titleArr[cellIndex]
            if weakSelf?.nationalitySelectReturnBlock != nil{
                weakSelf?.nationalitySelectReturnBlock(titleArr[cellIndex])
            }
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
    }
    func selectNationPassport(tap:UIGestureRecognizer){
        weak var weakSelf = self
        self.endEditing(true)
        let titleArr:[String] = ["中国","日本"]
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.rowHeight = 44
        roleView.fontSize = UIFont.systemFont(ofSize: 18)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            weakSelf?.passportNationField.text = titleArr[cellIndex]
            if weakSelf?.passportNationSelectReturnBlock != nil{
                weakSelf?.passportNationSelectReturnBlock(titleArr[cellIndex])
            }
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
    }
    func selectTimePassport(tap:UIGestureRecognizer){
        weak var weakSelf = self
        let datePicker = TBIDatePickerView(frame: ScreenWindowFrame)
        datePicker.datePicker.minimumDate =  Date()
        datePicker.datePicker.maximumDate =  Date.init(timeIntervalSinceNow: 10*365*24*60*60)
        datePicker.datePickerResultBlock = { (date) in
            weakSelf?.passportTimeField.text =  date
            if weakSelf?.passportTimeSelectReturnBlock != nil{
                weakSelf?.passportTimeSelectReturnBlock(date)
            }
            
        }
        KeyWindow?.addSubview(datePicker)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text!
        let len = text.count + string.count - range.length
        return len<=19
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == certField{
            if idCardCompleteReturnBlock != nil{
                idCardCompleteReturnBlock(textField.text!)
            }
        }
        
    }
    
}
