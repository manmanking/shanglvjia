//
//  TripPeopleDetailCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/23.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftDate

class TripPeopleDetailCell: UITableViewCell,UITextFieldDelegate {

    // 选择护照 block
    typealias TripPeopleDetailCellSelectedBlock = (String,String)->Void
    public var tripPeopleDetailCellSelectedBlock:TripPeopleDetailCellSelectedBlock!
    // 选择 发证国
    typealias TripPeopleDetailCellSelectedCountryBlock = (String,String)->Void
    public var tripPeopleDetailCellSelectedCountryBlock:TripPeopleDetailCellSelectedCountryBlock!
    
    /// 选择 证件 有效期
    typealias TripPeopleDetailCellSelectedIdCardExpiredDateBlock = (String)->Void
    public var tripPeopleDetailCellSelectedIdCardExpiredDateBlock:TripPeopleDetailCellSelectedIdCardExpiredDateBlock!
    
    ///身份证号
    typealias IdCardCompleteReturnBlock = (String)->Void
    public var idCardCompleteReturnBlock:IdCardCompleteReturnBlock!
    
    private var idCardArr:[(idCardName:String,idCardNo:String)] = [("身份证",""),("护照",""),("港澳通行证",""),("台胞证",""),("台湾通行证",""),("军官证",""),("回乡证",""),("户口簿",""),("出生证明",""),("请选择证件类型","")]
    private var nationalityArr:[(Name:String,id:String)] = [("中国","CN"),("日本","JP")]
    let titleLabel:UILabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 15)
    let infoTextField = UITextField(fontSize:16)
    let lineLabel:UILabel = UILabel()
    let arrowImage = UIImageView()
    var controller = TripPeopleDetailViewController()
    let mustImage = UIImageView()
    
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        self.addSubview(titleLabel)
        self.addSubview(infoTextField)
        self.addSubview(lineLabel)
        self.addSubview(arrowImage)
        titleLabel.addSubview(mustImage)
        
        mustImage.image = UIImage(named:"red_must")
        arrowImage.image = UIImage(named:"ic_right_gray")
        lineLabel.backgroundColor = TBIThemeGrayLineColor
        
        titleLabel.textAlignment = .left
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(85)
            make.top.bottom.equalToSuperview()
        }
        
        infoTextField.delegate = self
        infoTextField.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right)
            make.centerY.equalTo(titleLabel)
            make.right.top.bottom.equalToSuperview()
        }
        arrowImage.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        lineLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    func setCellWithData(titleStr:String,passenger:PersonalTravellerInfoRequest,isMust:Bool) {
        titleLabel.text = titleStr
        
        if (titleStr == "证件类型" || titleStr == "亲属关系" || titleStr == "出生日期"){
           arrowImage.isHidden = false
            if titleStr == "证件类型" { infoTextField.text = passenger.showIdCardName}
        }else{
            arrowImage.isHidden = true
           
        }
        
        if titleStr == "发证国" ||  titleStr == "有效期"||titleStr == "性别" {
            arrowImage.isHidden = false
        }
        
        
        if isMust{
           mustImage.isHidden = false
            let titleWidth = titleStr.getTextWidth(font: UIFont.systemFont(ofSize: 15), height: 45) + 4
            mustImage.snp.makeConstraints { (make) in
                make.centerY.equalTo(titleLabel)
                make.width.height.equalTo(6)
                make.left.equalTo(titleWidth)
            }
        }else{
            mustImage.isHidden = true
        }
        
        fillIdCardNo(passenger: passenger)
    }
    
    private func fillIdCardNo(passenger:PersonalTravellerInfoRequest) {
        //身份证
        if passenger.certNo.isEmpty == false {
            idCardArr[0].idCardNo = passenger.certNo
        }
        
        //护照
        if passenger.passportNo.isEmpty == false {
            idCardArr[1].idCardNo = passenger.passportNo
        }
        //港澳通行证
        if passenger.gangaoNo.isEmpty == false {
            idCardArr[2].idCardNo = passenger.gangaoNo
        }
        //台胞证
        if passenger.taiwanNo.isEmpty == false {
            idCardArr[3].idCardNo = passenger.taiwanNo
        }
        //"台湾通行证
        if passenger.taiwanpassNo.isEmpty == false {
            idCardArr[4].idCardNo = passenger.taiwanpassNo
        }
        //"军人证"
        if passenger.militaryCard.isEmpty == false {
            idCardArr[5].idCardNo = passenger.militaryCard
        }
        //回乡证
        if passenger.huixiangCert.isEmpty == false {
            idCardArr[6].idCardNo = passenger.huixiangCert
        }
        //户口簿
        if passenger.hukouCert.isEmpty == false {
            idCardArr[7].idCardNo = passenger.hukouCert
        }
        //出生证明
        if passenger.bornCert.isEmpty == false {
            idCardArr[8].idCardNo = passenger.bornCert
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if titleLabel.text == "证件类型"{
            textField.resignFirstResponder()
            infoTextField.addOnClickListener(target: self, action: #selector(selectIDTypeClick(tap: )))
            return false
        }
        if titleLabel.text == "亲属关系"{
            textField.resignFirstResponder()
            if infoTextField.text != "本人"{
                infoTextField.addOnClickListener(target: self, action: #selector(selectRelationClick(tap: )))
            }            
            return false
        }
        if titleLabel.text == "性别"{
            textField.resignFirstResponder()
            infoTextField.addOnClickListener(target: self, action: #selector(selectSexClick(tap: )))
            return false
        }
        
        if titleLabel.text == "出生日期" {
            textField.resignFirstResponder()
            infoTextField.addOnClickListener(target: self, action: #selector(selectDate(tap: )))
            return false
        }
        if titleLabel.text == "发证国" {
            textField.resignFirstResponder()
            infoTextField.addOnClickListener(target: self, action: #selector(selectNationalityClick(tap: )))
            return false
        }
        
        if titleLabel.text == "有效期" {
            textField.resignFirstResponder()
            infoTextField.addOnClickListener(target: self, action: #selector(selectIdCardExpiredDate(tap: )))
            return false
        }
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        printDebugLog(message: titleLabel.text)
        printDebugLog(message: "endEdit")
        if titleLabel.text == "证件号"{
            
                    if idCardCompleteReturnBlock != nil{
                        idCardCompleteReturnBlock(textField.text!)
                   
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        printDebugLog(message: "return")
        return true
    }
    
    
    
    func selectIDTypeClick(tap:UITapGestureRecognizer){
        weak var weakSelf = self
        self.endEditing(true)
        
        var idCardArrCopy:[String] = Array()
        for element in idCardArr {
            let tmp = element.idCardName + "  " + element.idCardNo
            idCardArrCopy.append(tmp)
        }
        
        
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.rowHeight = 44
        roleView.fontSize = UIFont.systemFont(ofSize: 18)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            weakSelf?.infoTextField.text =  weakSelf?.idCardArr[cellIndex].idCardName
            if weakSelf?.tripPeopleDetailCellSelectedBlock != nil{
                weakSelf?.tripPeopleDetailCellSelectedBlock(weakSelf?.idCardArr[cellIndex].idCardName ?? "",weakSelf?.idCardArr[cellIndex].idCardNo ?? "")
            }
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: idCardArrCopy, flageImage: nil)
    }
    func selectRelationClick(tap:UITapGestureRecognizer){
        weak var weakSelf = self
        self.endEditing(true)
        let titleArr:[String] = ["配偶","子女","父亲","母亲","配偶父亲","配偶母亲","其他"]
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.rowHeight = 44
        roleView.fontSize = UIFont.systemFont(ofSize: 18)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            weakSelf?.infoTextField.text = titleArr[cellIndex]
            if weakSelf?.tripPeopleDetailCellSelectedBlock != nil{
                weakSelf?.tripPeopleDetailCellSelectedBlock(titleArr[cellIndex],"")
            }
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
    }
    ///选择出生日期
    func selectDate(tap:UITapGestureRecognizer){
        
        weak var weakSelf = self
        let datePicker = TBIDatePickerView(frame: ScreenWindowFrame)
        datePicker.date = infoTextField.text!
        ///出身日期应该是1949-1-1至系统的当前时间
        let startDate:Date = ("1949-01-01").stringToDate(dateFormat: "yyyy-MM-dd")
        datePicker.datePicker.maximumDate =  Date()
        datePicker.datePicker.datePickerMode = .date
        datePicker.datePicker.minimumDate = startDate
        datePicker.datePickerResultBlock = { (date) in
             weakSelf?.infoTextField.text =  date
            if weakSelf?.tripPeopleDetailCellSelectedBlock != nil{
                 weakSelf?.tripPeopleDetailCellSelectedBlock( date,"")
            }
            
        }
        KeyWindow?.addSubview(datePicker)
    }
    
    func selectNationalityClick(tap:UITapGestureRecognizer){
        weak var weakSelf = self
        self.endEditing(true)
        let titleArr:[String] = ["中国","日本"]
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.rowHeight = 44
        roleView.fontSize = UIFont.systemFont(ofSize: 18)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            weakSelf?.infoTextField.text = titleArr[cellIndex]
            if weakSelf?.tripPeopleDetailCellSelectedCountryBlock != nil{
                weakSelf?.tripPeopleDetailCellSelectedCountryBlock(weakSelf?.nationalityArr[cellIndex].Name ?? "",weakSelf?.nationalityArr[cellIndex].id ?? "")
            }
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
    }
    ///选择有效期
    func selectIdCardExpiredDate(tap:UITapGestureRecognizer){
        
        weak var weakSelf = self
        let datePicker = TBIDatePickerView(frame: ScreenWindowFrame)
        datePicker.datePicker.datePickerMode = .date
        datePicker.datePicker.maximumDate = (Date() + 10.year)
        datePicker.date = infoTextField.text!
        datePicker.datePicker.minimumDate =  Date()
        datePicker.datePickerResultBlock = { (date) in
            weakSelf?.infoTextField.text =  date
            if weakSelf?.tripPeopleDetailCellSelectedIdCardExpiredDateBlock != nil{
                weakSelf?.tripPeopleDetailCellSelectedIdCardExpiredDateBlock(date)
            }
            
        }
        KeyWindow?.addSubview(datePicker)
    }
    
    func selectSexClick(tap:UITapGestureRecognizer){
        weak var weakSelf = self
        self.endEditing(true)
        let titleArr:[String] = ["男","女"]
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.rowHeight = 44
        roleView.fontSize = UIFont.systemFont(ofSize: 18)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            weakSelf?.infoTextField.text = titleArr[cellIndex]
            if weakSelf?.tripPeopleDetailCellSelectedIdCardExpiredDateBlock != nil{
                weakSelf?.tripPeopleDetailCellSelectedIdCardExpiredDateBlock(titleArr[cellIndex])
            }
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
    }
    
    
}
