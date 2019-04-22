//
//  AssuranceInfoViewController.swift
//  shop
//
//  Created by manman on 2017/4/26.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift



let assuranceInfoTableViewIdentify  = "assuranceInfoTableViewIdentify"


class AssuranceInfoViewController:  CompanyBaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    public var assuranceHotelOrderInfo:HotelOrderInfo = HotelOrderInfo()
    public var assuranceInfo:AssuranceAmountModel = AssuranceAmountModel()
    public var roomModel:RoomModel = RoomModel()
    
    public var requestOrder:SubmitOrderVO = SubmitOrderVO()
    
    public var roomSelected:HotelDetailResult.HotelRoomPlan = HotelDetailResult.HotelRoomPlan()
    
    public var searchSVCondition:HotelListRequest = HotelListRequest()
    
    
    //新老版 判断 字段 0 老版 1 新版  跳转 订单详情页面 使用此字段
    public var userVersion:NSInteger = 0
    
    private let footerViewHeight:Int = 107
    
    private var guaranteeAmount:String = ""
    //0 不需要 CVV 1 需要
    private var verifyCreditCVV:NSInteger = 0
    
    private  var expirationYear:     String = ""
    ///有效期月
    private var expirationMonth:    String = ""

    private let leftMargin:CGFloat = 10
    private var criditValude:Bool = false
    private var tableView = UITableView()
    private var okayButton = UIButton()
    private var firstNameTextField:UITextField = UITextField()
    private var lastNameTextField:UITextField = UITextField()
    private var spellFirstNameTextField:UITextField = UITextField()
    private var spellLastNameTextField:UITextField = UITextField()
    private var dateMonthView = TBIHotelDateView()
    private var dateYearView = TBIHotelDateView()
    private var tableViewDataSourcesArr = [[(title:String,content:String)]]()
    private let sectionTwoAuxiliary:[String] = ["请输入信用卡号码","","","","请输入办卡使用的证件号码","卡背后数字后三位",""]
    private var pickerView:TBIPickerView = TBIPickerView()
    
    private var pickerViewMonthDataSourcesArr:[String] = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    private var pickerViewYearDataSourcesArr:[String] = ["2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030","2031","2032","2033"]
    
    fileprivate let bag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        setBlackTitleAndNavigationColor(title: "担保信息")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        //assuranceInfo.roomTypeId = assuranceHotelOrderInfo.hotelProductParameters.roomTypeId!
        //assuranceInfo.roomTypeId = roomModel.roomTypeId!
        
        let sectionOne:[(title:String,content:String)] = [("担保金额","")]
        
        let sectionTwo:[(title:String,content:String)] = [("信用卡号",creditCard_Debug),("持卡人姓名",""),("姓名拼音",""),("过期日期",""),("证件号码",identityCard_Debug)]//,("CVV码","")
        tableViewDataSourcesArr = [sectionOne,sectionTwo]
        
        self.view.backgroundColor = TBIThemeBaseColor
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        //AssuranceInfoTableViewCell
        tableView.register(AssuranceInfoTableViewCell.classForCoder(), forCellReuseIdentifier: assuranceInfoTableViewIdentify)
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45 * 6 + 10 + footerViewHeight)
        }
        caculateAssuranceAmountSV()
//        //个人
//        if PersonalType == true {
//            caculateAssuranceAmount()
//        }else // 企业
//        {
//            companyCaculateAssuranceAmount()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func caculateAssuranceAmountSV() {
        let request = GuaranteeAmountRequest()
        request.guaranteeType = roomSelected.ratePlanInfo.guaranteeRuleInfo.guaranteeTypeStr
        request.nightCount = requestOrder.submitDetailVOList.first?.nightNum.description ?? "0"
        request.rate = roomSelected.ratePlanInfo.rate.OneOfTheEffectiveFraction()
        request.roomCount = requestOrder.roomNum.description
        weak var weakSelf = self
        showLoadingView()
        HotelService.sharedInstance
            .hotelGuaranteeAmount(request:request)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    printDebugLog(message: element)
                    weakSelf?.guaranteeAmount = element
                    weakSelf?.tableViewDataSourcesArr[0][0].content = element
                    weakSelf?.tableView.reloadData()
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
            }.disposed(by: bag)
        
    }
    
    
    
//
//    func caculateAssuranceAmount()  {
//        weak var weakSelf = self
//        HotelService.sharedInstance.caculateGuaranteeAmount(parameter: assuranceInfo.mj_keyValues() as! Dictionary<String, Any>)
//            .subscribe{ event in
//                if case .next(let e) = event {
//                    print(e)
//                    weakSelf?.guaranteeAmount = e
//                    weakSelf?.tableViewDataSourcesArr[0][0].content = e
//                    weakSelf?.tableView.reloadData()
//                }
//                if case .error(let e) = event {
//                    print(e)
//                }
//            }.disposed(by: bag)
//
//
//    }
//
//
//
//    func companyCaculateAssuranceAmount()  {
//        print("companyCaculateAssuranceAmount",assuranceInfo.mj_keyValues())
//        weak var weakSelf = self
//        HotelCompanyService.sharedInstance.caculateGuaranteeAmount(parameter: assuranceInfo.mj_keyValues() as! Dictionary<String, Any>)
//            .subscribe{ event in
//                if case .next(let e) = event {
//                    print(e)
//                    weakSelf?.guaranteeAmount = e
//                    weakSelf?.tableViewDataSourcesArr[0][0].content = e
//                    weakSelf?.tableView.reloadData()
//                }
//                if case .error(let e) = event {
//                    print(e)
//                }
//            }.disposed(by: bag)
//
//
//    }
//
    
    
    
    
    
    
    
    
    //MARK:- UITableViewDataSource
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewDataSourcesArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tableViewDataSourcesArr[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        //The First Method
        let cell:AssuranceInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: assuranceInfoTableViewIdentify) as! AssuranceInfoTableViewCell
        weak var weakSelf = self
        configCell(cell: cell, cellIndex: indexPath)
        cell.assuranceInfoResultBlock = { (content,title,selectedIndex) in
           print("into here ",content,title,selectedIndex)
            if selectedIndex.row == 0 && selectedIndex.section == 1
            {
                //weakSelf?.verifyCredit(credit: content)
                weakSelf?.hotelVerifyCridetCard(creditCard: content)
            }
                weakSelf?.tableViewDataSourcesArr[selectedIndex.section][selectedIndex.row].content = content
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 {
            let firstView:UIView = UIView.init(frame:CGRect(x:0,y:0,width:ScreenWindowWidth,height:10))
            firstView.backgroundColor = TBIThemeBaseColor
            return firstView
            
        }
        
        let footerView:UIView = UIView.init(frame: CGRect(x:0,y:0,width:ScreenWindowWidth,height:72))
        footerView.backgroundColor = UIColor.white
        okayButton.setTitle("担保", for: UIControlState.normal)
        okayButton.layer.cornerRadius = 5
        okayButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        okayButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        okayButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        okayButton.clipsToBounds=true
        okayButton.addTarget(self, action: #selector(okayButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        footerView.addSubview(okayButton)
        okayButton.snp.makeConstraints({ (make) in
            
            make.top.equalToSuperview().inset(30)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(47)
            
            
        })
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return CGFloat(footerViewHeight)
    }
    
    func choiceDateMonth() {
        printDebugLog(message: "选择日期  月")
        self.view.endEditing(true)
        weak var weakSelf = self
        setPickerRoomNumView()
        pickerView.fillDataSources(dataSourcesArr:pickerViewMonthDataSourcesArr)
        pickerView.pickerViewSelectedRow = {(selectedIndex,content) in
            weakSelf?.dateMonthView.setDate(title:(weakSelf?.pickerViewMonthDataSourcesArr[selectedIndex])!)
            
        }
        
        
        
    }
    
    func choiceDateYear() {
        printDebugLog(message: "选择日期 年")
        self.view.endEditing(true)
        weak var weakSelf = self
        setPickerRoomNumView()
        pickerView.fillDataSources(dataSourcesArr:pickerViewYearDataSourcesArr)
        pickerView.pickerViewSelectedRow = {(selectedIndex,content) in
            weakSelf?.dateYearView.setDate(title: (weakSelf?.pickerViewYearDataSourcesArr[selectedIndex])!)
            
            
        }
    }
    
    func  configSeondTypeCell(cell:UITableViewCell,index:IndexPath) {
        
       cell.textLabel?.text = tableViewDataSourcesArr[index.section][index.row].title
    }
    
    func configCell(cell:AssuranceInfoTableViewCell,cellIndex:IndexPath){
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        switch cellIndex.row {
            
        case 1:
            cell.fillDatasources(title:(tableViewDataSourcesArr[cellIndex.section][cellIndex.row].title), contentEnable: false , content: tableViewDataSourcesArr[cellIndex.section][cellIndex.row].content, contentPlacrHolder: sectionTwoAuxiliary[cellIndex.row],showLine:true, cellIndexPath: cellIndex)
            lastNameTextField.placeholder = "姓"
            lastNameTextField.font = UIFont.systemFont(ofSize: 16)
            lastNameTextField.delegate = self
            lastNameTextField.layer.cornerRadius = 2
            textFieldLeftPadding(textField: lastNameTextField, leftMargin: leftMargin)
            lastNameTextField.layer.borderWidth = 0.5
            lastNameTextField.layer.borderColor = TBIThemeGrayLineColor.cgColor
            cell.contentView.addSubview(lastNameTextField)
            lastNameTextField.snp.makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().inset(123)
                make.height.equalTo(24)
                make.width.equalTo((ScreenWindowWidth - 123)/2 - 8 - 4)
                
            })
            
            firstNameTextField.placeholder = "名"
            firstNameTextField.font = UIFont.systemFont(ofSize: 16)
            firstNameTextField.delegate = self
            firstNameTextField.layer.cornerRadius = 2
            textFieldLeftPadding(textField: firstNameTextField, leftMargin: leftMargin)
            firstNameTextField.layer.borderWidth = 0.5
            firstNameTextField.layer.borderColor = TBIThemeGrayLineColor.cgColor
            cell.contentView.addSubview(firstNameTextField)
            firstNameTextField.snp.makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(lastNameTextField.snp.right).offset(8)
                make.height.equalTo(24)
                make.right.equalToSuperview().inset(15)
                
            })
            
        
        
        case 2:
            cell.fillDatasources(title:(tableViewDataSourcesArr[cellIndex.section][cellIndex.row].title), contentEnable: false , content: tableViewDataSourcesArr[cellIndex.section][cellIndex.row].content, contentPlacrHolder: sectionTwoAuxiliary[cellIndex.row],showLine:true, cellIndexPath: cellIndex)
            
            if lastNameTextField.text?.isEmpty == false
            {
                let lastName:String = lastNameTextField.text!
                spellLastNameTextField.text = lastName.chineseToUpperPinyin()
                
            }else
            {
                lastNameTextField.text = ""
            }
            
            
            
            
            spellLastNameTextField.placeholder = "XING"
            textFieldLeftPadding(textField: spellLastNameTextField, leftMargin: leftMargin)
            spellLastNameTextField.layer.borderWidth = 0.5
            spellLastNameTextField.font = UIFont.systemFont(ofSize: 16)
            spellLastNameTextField.layer.cornerRadius = 2
            spellLastNameTextField.delegate = self
            spellLastNameTextField.layer.borderColor = TBIThemeGrayLineColor.cgColor
            cell.contentView.addSubview(spellLastNameTextField)
            spellLastNameTextField.snp.makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().inset(123)
                make.height.equalTo(24)
//                make.width.equalTo(114)
                 make.width.equalTo((ScreenWindowWidth - 123)/2 - 8 - 4)
            })
            
            if firstNameTextField.text?.isEmpty == false
            {
                let lastName:String = firstNameTextField.text!
                spellFirstNameTextField.text = lastName.chineseToUpperPinyin()
                
            }else
            {
                lastNameTextField.text = ""
            }
            
            spellFirstNameTextField.placeholder = "MING"
            textFieldLeftPadding(textField: spellFirstNameTextField, leftMargin: leftMargin)
            spellFirstNameTextField.layer.borderWidth = 0.5
            spellFirstNameTextField.layer.cornerRadius = 2
            spellFirstNameTextField.delegate = self
            spellFirstNameTextField.font = UIFont.systemFont(ofSize: 16)
            spellFirstNameTextField.layer.borderColor = TBIThemeGrayLineColor.cgColor
            cell.contentView.addSubview(spellFirstNameTextField)
            spellFirstNameTextField.snp.makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(spellLastNameTextField.snp.right).offset(8)
                make.height.equalTo(24)
                make.right.equalToSuperview().inset(15)
                
            })
            
            let lastName = Variable("")
            lastNameTextField.rx.text.orEmpty.bind(to: lastName).addDisposableTo(bag)
            lastName.asObservable().map{
                    $0.chineseToUpperPinyin()
                }.bind(to: spellLastNameTextField.rx.text).addDisposableTo(bag)
            
            let firstName = Variable("")
            firstNameTextField.rx.text.orEmpty.bind(to: firstName).addDisposableTo(bag)
            firstName.asObservable().map{
                $0.chineseToUpperPinyin()
                }.bind(to: spellFirstNameTextField.rx.text).addDisposableTo(bag)
            
        case 3:
            
            
            cell.fillDatasources(title:(tableViewDataSourcesArr[cellIndex.section][cellIndex.row].title), contentEnable: false , content: tableViewDataSourcesArr[cellIndex.section][cellIndex.row].content, contentPlacrHolder: sectionTwoAuxiliary[cellIndex.row],showLine:true, cellIndexPath: cellIndex)
            
            weak var weakSelf = self
            dateMonthView.customTextAlignment = NSTextAlignment.left
            dateMonthView.choiceDateBlock = {(paramater) in
                weakSelf?.view.endEditing(true)
                weakSelf?.choiceDateMonth()
                
            }
            dateMonthView.setDate(title: "")
            cell.contentView.addSubview(dateMonthView)
            dateMonthView.snp.makeConstraints({ (make) in
                
                make.left.equalToSuperview().inset(123)
                make.top.bottom.equalToSuperview().inset(10)
//                make.width.equalTo(114)
                 make.width.equalTo((ScreenWindowWidth - 123)/2 - 8 - 4)
            })
            
            
            
            dateYearView.customTextAlignment = NSTextAlignment.left
            dateYearView.setDate(title: "")
            cell.contentView.addSubview(dateYearView)
            dateYearView.snp.makeConstraints({ (make) in
                make.left.equalTo(dateMonthView.snp.right).offset(8)
                make.top.bottom.equalToSuperview().inset(10)
                make.right.equalToSuperview().inset(15)
            })
            dateYearView.choiceDateBlock = {(paramater) in
                self.view.endEditing(true)
                weakSelf?.choiceDateYear()
                
            }
            
        default:
            
            var contentPlacrHolder = self.sectionTwoAuxiliary[cellIndex.row]
            var content:String = tableViewDataSourcesArr[cellIndex.section][cellIndex.row].content
            var contentEnable = true
            
            var showLine = true
            
            if cellIndex.section == 0 {
                
                if content.isEmpty == false {
                    content = (Float(content)?.OneOfTheEffectiveFraction())!
                }
                contentPlacrHolder = ""
                contentEnable = false
                showLine = false
            }
            cell.fillDatasources(title:(tableViewDataSourcesArr[cellIndex.section][cellIndex.row].title), contentEnable: contentEnable, content:content, contentPlacrHolder: contentPlacrHolder,showLine:showLine, cellIndexPath: cellIndex)
        }
    }
    
    func hotelVerifyCridetCard(creditCard:String) {
        weak var weakSelf = self
        self.view.endEditing(true)
        self.showLoadingView()
        HotelService.sharedInstance
            .hotelCreditVerify(creditNo: creditCard)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    printDebugLog(message: element)
                    weakSelf?.criditValude = element.valid
                    
                    if  element.valid == true && element.cvv == true
                    {
                        weakSelf?.verifyCreditCVV = 1
                        if (weakSelf?.tableViewDataSourcesArr[1].count)! >= 6
                        {
                            return
                        }
                        weakSelf?.tableViewDataSourcesArr[1].append((title: "CVV码", content:""))
                        let indexPath = IndexPath.init(row:5, section: 1)
                        weakSelf?.tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.none)
                        weakSelf?.tableView.snp.remakeConstraints({ (make) in
                            make.top.left.right.equalToSuperview()
                            make.height.equalTo(45 * 7 + 10 + (weakSelf?.footerViewHeight)!)
                        })
                        
                    }else
                    {
                        weakSelf?.verifyCreditCVV = 0
                        weakSelf?.tableView.snp.remakeConstraints({ (make) in
                            make.top.left.right.equalToSuperview()
                            make.height.equalTo(45 * 6 + 10 + (weakSelf?.footerViewHeight)!)
                        })
                    }
                    printDebugLog(message: element)
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
                
            }.disposed(by: bag)
        
    }
    
    
    
    func verifyCredit(credit:String)  {
        
        weak var weakSelf = self
        self.view.endEditing(true)
        let tmp:Dictionary<String,Any> = ["cardId":credit]
        self.showLoadingView()
        HotelService.sharedInstance.verifyCredit(parameters:tmp)
        .subscribe{ event in
            weakSelf?.hideLoadingView()
            if case .next(let e) = event {
                print(e)
                weakSelf?.criditValude = e.valid
                
                if e.valid == true && e.cvv == true
                {
                    weakSelf?.verifyCreditCVV = 1
                    if (weakSelf?.tableViewDataSourcesArr[1].count)! >= 6
                    {
                        return
                    }
                    weakSelf?.tableViewDataSourcesArr[1].append((title: "CVV码", content:""))
                    let indexPath = IndexPath.init(row:5, section: 1)
                    weakSelf?.tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.none)
                    weakSelf?.tableView.snp.remakeConstraints({ (make) in
                        make.top.left.right.equalToSuperview()
                        make.height.equalTo(45 * 7 + 10 + (weakSelf?.footerViewHeight)!)
                    })
                    
                }else
                {
                     weakSelf?.verifyCreditCVV = 0
                    weakSelf?.tableView.snp.remakeConstraints({ (make) in
                        make.top.left.right.equalToSuperview()
                        make.height.equalTo(45 * 6 + 10 + (weakSelf?.footerViewHeight)!)
                    })
                }
               
            }
            if case .error(let e) = event {
                print(e)
            }
            }.disposed(by: bag)
        
        
    }
    
  
    
    private func setPickerRoomNumView() {
        
        KeyWindow?.addSubview(pickerView)
        pickerView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
            
        }
    }
    
    
   
    
   private  func isPurnInt(string: String) -> Bool {
        let scan: Scanner = Scanner(string: string)
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    
    
    
    private func isUppercase( type:String,content:String)->Bool
    {
        let uppercase = type
        let uppercasePre = NSPredicate.init(format: "SELF MATCHES %@",uppercase)
        return uppercasePre.evaluate(with:content)
        
        
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        spellLastNameTextField.resignFirstResponder()
        spellFirstNameTextField.resignFirstResponder()
        return true
    }
    
    
    func textFieldLeftPadding(textField:UITextField ,leftMargin:CGFloat) {
        var  frame = textField.frame
        frame.size.width = leftMargin
        let leftView:UIView = UIView.init(frame: frame)
        textField.leftViewMode = UITextFieldViewMode.always
        textField.leftView = leftView
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField == spellLastNameTextField || textField == spellFirstNameTextField {
            
            guard string.isEmpty == false else {
                return true
            }
            let fullName:String  = textField.text! + string.uppercased()
            textField.text = fullName
            return false
        }
        return true
    }
    
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        
//        if textField == lastNameTextField || textField == firstNameTextField
//        {
//            let updateRow:IndexPath = IndexPath.init(row: 2, section: 1)
//            self.tableView.reloadRows(at: [updateRow], with: UITableViewRowAnimation.none)
//        }
//        
//        
//        
//    }
    
    //MARK:---Action
    
    override func backButtonAction(sender: UIButton) {
         _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK:-- 下单
    func okayButtonAction(sender:UIButton) {
        printDebugLog(message: "  okayButtonAction ...  AssuranceInfoViewController")
        self.view.endEditing(true)
        
//^((?:4\d{3})|(?:5[1-5]\d{2})|(?:6011)|(?:3[68]\d{2})|(?:30[012345]\d))[ -]?(\d{4})[ -]?(\d{4})[ -]?(\d{4}|3[4,7]\d{13})$
        //^\\d{16}$
        //^5[1-5][0-9]{5,}|222[1-9][0-9]{3,}|22[3-9][0-9]{4,}|2[3-6][0-9]{5,}|27[01][0-9]{4,}|2720[0-9]{3,}$
        //^6(?:011|5[0-9]{2})[0-9]{3,}$
        _ = "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        //^\\d{16}$"
//        if isUppercase(type:cridetCardFormat , content: tableViewDataSourcesArr[1][0].content) == false
//        {
//            showSystemAlertView(titleStr: "提示", message: "信用卡信息有误")
//            return
//        }

        //去掉 验证 姓名
//        let holderName = tableViewDataSourcesArr[1][1].content
//        let success = isUppercase(type:"^[A-Z]+$" , content: holderName)
//        if success == false
//        {
//            showSystemAlertView(titleStr: "提示", message: "姓名信息有误")
//            return
//        }
        //(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)  ---- \\d{14}[[0-9],0-9xX]
//        let lastName:String = spellLastNameTextField.text!
//        let firstName:NSString = spellFirstNameTextField.text! as NSString
//       
//        let space:UInt8 = " "
//        
//        for element in firstName.utf8String
//        {
//            if element == space
//            {
//                return
//            }
//            if element < "A" && element > "Z"{
//                
//            }
//            
//        }
//        
//        
//        
//        for element in firstName.utf8String {
//            
//            print(element)
//            if element.isupper == 0
//            {
//                print("小写")
//                showSystemAlertView(titleStr: "提示", message: "姓名信息有误")
//                return
//            }
//            
//            
//            
//        }
        
        if spellLastNameTextField.text?.isEmpty == true || spellFirstNameTextField.text?.isEmpty == true
        {
            showSystemAlertView(titleStr: "提示", message: "姓名信息有误")
            return
        }

        
        
        if dateMonthView.getDate().isEmpty == true || dateYearView.getDate().isEmpty == true {
            showSystemAlertView(titleStr: "提示", message: "请选择日期")
            return
        }
        
        if tableViewDataSourcesArr[1][4].content.isEmpty == true || tableViewDataSourcesArr[1][4].content.validate(ValidateType.card) == false {
            showSystemAlertView(titleStr: "提示", message: "请输入正确证件号码")
            return
        }
        
        if tableViewDataSourcesArr[1].count >= 6 && tableViewDataSourcesArr[1][5].content.isEmpty == true && tableViewDataSourcesArr[1][5].content.characters.count != 3
        {
            showSystemAlertView(titleStr: "提示", message: "请输入正确的CVV码")
            return
        }
        if criditValude == false {
            showSystemAlertView(titleStr: "提示", message: "请输入正确的信用卡号")
            return
        }
        
        requestOrder.submitElongData.submitCreditCardData.expirationMonth = dateMonthView.getDate()
        requestOrder.submitElongData.submitCreditCardData.expirationYear = dateYearView.getDate()
        requestOrder.submitElongData.submitCreditCardData.holderName = (lastNameTextField.text! + firstNameTextField.text!)
        //lastNameTextField.text ?? "" + (firstNameTextField.text ?? "")!
        requestOrder.submitElongData.submitCreditCardData.idNo = tableViewDataSourcesArr[1][4].content
        requestOrder.submitElongData.submitCreditCardData.idType = "IdentityCard"
        requestOrder.submitElongData.submitCreditCardData.number = tableViewDataSourcesArr[1][0].content
        if verifyCreditCVV == 1 {
            requestOrder.submitElongData.submitCreditCardData.cvv = tableViewDataSourcesArr[1][5].content
        }
        
        
        //showLoadingView()
        submitNewOrder(request:requestOrder)
//        // 个人担保 下单
//        if PersonalType == true {
//            submitOrder()
//        }else //企业下单
//        {
//            companySubmitOrder()
//        }
        
    }
    private func companySubmitOrder() {
        weak var weakSelf = self
        
        
        var creditCard:HotelOrderInfo.CreditCard = HotelOrderInfo.CreditCard()
        
        creditCard.number = tableViewDataSourcesArr[1][0].content
        
        let spellLastName =  spellLastNameTextField.text
        var spellLastNameResult = ""
        let spellFirstName = spellFirstNameTextField.text
        var spellFirstNameResult = ""
        
        
        if spellLastName?.range(of: " ") != nil
        {
            let spellLastNameArr = spellLastName?.components(separatedBy: " ")
            for element in spellLastNameArr!
            {
                spellLastNameResult += element
            }
            
        }else
        {
            spellLastNameResult = spellLastName!
        }
        
        
        if spellFirstName?.range(of: " ") != nil
        {
            let spellLastNameArr = spellLastName?.components(separatedBy: " ")
            for element in spellLastNameArr!
            {
                spellFirstNameResult += element
            }
            
        }else
        {
            spellFirstNameResult = spellFirstName!
        }
        
        
        
        
        creditCard.holderName = spellLastNameResult + " " + spellFirstNameResult //tableViewDataSourcesArr[1][1].content
        creditCard.idNo = tableViewDataSourcesArr[1][4].content
        if verifyCreditCVV == 1 && tableViewDataSourcesArr[1][5].content.isEmpty == false
        {
            creditCard.cvv = tableViewDataSourcesArr[1][5].content
        }
        
        creditCard.idType = "IdentityCard"
        creditCard.expirationMonth = dateMonthView.getDate()
        creditCard.expirationYear = dateYearView.getDate()
        assuranceHotelOrderInfo.creditCard = creditCard
        print("request parameter",assuranceHotelOrderInfo)
        
        HotelCompanyService.sharedInstance
            .commit(order: assuranceHotelOrderInfo)
            .subscribe{ event in
                
                weakSelf?.hideLoadingView()
                if case .next(let orderNo) = event {
                    print(orderNo)
                    //weakSelf?.showSystemAlertView(titleStr: "成功", message: "下单成功")
                    weakSelf?.intoNextOrderDetail(orderNo: orderNo)
                    
                    
                }
                if case .error(let result) = event {
                    print(result)
                    weakSelf?.showSystemAlertView(titleStr: "失败", message: "下单失败")
                }
                
            }.disposed(by: bag)
    }
    
    /// 提交订单 NEWobt
    func submitNewOrder(request:SubmitOrderVO) {
        
        weak var weakSelf = self
        storeOrderCity()
        showLoadingView()
        HotelService.sharedInstance
            .hotelSubmitOrder(request: request)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    printDebugLog(message: element)
                weakSelf?.verifyUserRightApproval(orderArr: element)
                    //weakSelf?.getApproval(orderNoArr: element)
                //weakSelf?.intoNextOrderDetail(orderNo:element)
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
                
        }
    }
    
    ///保存当前订单 的城市
    func storeOrderCity() {
        var localHistoryCityArr:[HotelCityModel] = Array()
        if DBManager.shareInstance.userHistoryCityRecordDraw() != nil {
            localHistoryCityArr.append(contentsOf: DBManager.shareInstance.userHistoryCityRecordDraw()!)
        }
        let currentOrderCity = HotelCityModel()
        currentOrderCity.elongId = HotelManager.shareInstance.searchConditionUserDraw().cityName
        currentOrderCity.cityCode = HotelManager.shareInstance.searchConditionUserDraw().cityId
        currentOrderCity.cnName = HotelManager.shareInstance.searchConditionUserDraw().cityName
        localHistoryCityArr.append(currentOrderCity)
        DBManager.shareInstance.userHistoryCityRecordStore(cityArr: localHistoryCityArr)
    }
    
    /// 验证 是否需要送审
    func verifyUserRightApproval(orderArr:[String]) {
        
        if DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.oaCorp == "1" {
            intoNextSubmitOrderFailureView(orderStatus: true)
        }else{
            getApproval(orderNoArr: orderArr)
            
        }
    }
    
    func intoNextSubmitOrderFailureView(orderStatus:Bool) {
        let submitOrderFailureView = SubmitOrderFailureViewController()
        submitOrderFailureView.submitOrderStatus = orderStatus ? .Success_Submit_Order : .Failure_Submit_Order
        self.navigationController?.pushViewController(submitOrderFailureView, animated: true)
    }
    
    func getApproval(orderNoArr:[String]) {
        weak var weakSelf = self
        let request:QueryApproveVO = QueryApproveVO()
        for element in orderNoArr {
            let orderInfo:QueryApproveVO.ApproveOrderInfo = QueryApproveVO.ApproveOrderInfo()
            orderInfo.orderId = element
            orderInfo.orderType = "2"
            request.approveOrderInfos.append(orderInfo)
        }
        
        showLoadingView()
        _ = HomeService.sharedInstance
            .getApproval(request:request )
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    printDebugLog(message: element.mj_keyValues())
                    if element.approveGroupInfos.count > 0 {
                        weakSelf?.intoNextNewExamineView(approvalGroup:(element.approveGroupInfos.first)!,orderNoArr: orderNoArr)
                    }else {
                        weakSelf?.navigationController?.popToRootViewController(animated: true)
                    }
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
                
        }
    }
    
    
    func intoNextNewExamineView(approvalGroup:QueryApproveResponseVO.ApproveGroupInfo,orderNoArr:[String]) {
        //不用改
        let examineView = CoNewExamineViewController()
        examineView.approveGroupInfos = approvalGroup
        examineView.orderNoArr = orderNoArr
        examineView.orderType = "2"
        self.navigationController?.pushViewController(examineView, animated: true)
    }
    
    
    
    
    
    
    //MARK:----订单详情页
    private func intoNextOrderDetail(orderNo:String) {
        
        //老版
        if userVersion == 0 {
            let orderDetail = CoOldOrderDetailsController()
            orderDetail.mBigOrderNOParams = orderNo
            orderDetail.topBackEvent = OrderDetailsBackEvent.homePage
            self.navigationController?.pushViewController(orderDetail, animated: true)
        }else
        { //新版
            let orderDetail = CoNewOrderDetailsController()
            orderDetail.mBigOrderNOParams = orderNo
            orderDetail.topBackEvent = OrderDetailsBackEvent.homePage
            self.navigationController?.pushViewController(orderDetail, animated: true)
            
        }
        
        
    }
    
    private func submitOrder() {
        weak var weakSelf = self
    
        var creditCard:HotelOrderInfo.CreditCard = HotelOrderInfo.CreditCard()
        
        
        creditCard.number = tableViewDataSourcesArr[1][0].content
        
        
        let spellLastName =  spellLastNameTextField.text
        var spellLastNameResult = ""
        let spellFirstName = spellFirstNameTextField.text
        var spellFirstNameResult = ""
        
        
        if spellLastName?.range(of: " ") != nil
        {
            let spellLastNameArr = spellLastName?.components(separatedBy: " ")
            for element in spellLastNameArr!
            {
                spellLastNameResult += element
            }
            
        }else
        {
            spellLastNameResult = spellLastName!
        }
        
        
        if spellFirstName?.range(of: " ") != nil
        {
            let spellFirstNameArr = spellFirstName?.components(separatedBy: " ")
            for element in spellFirstNameArr!
            {
                spellFirstNameResult += element
            }
            
        }else
        {
            spellFirstNameResult = spellFirstName!
        }
        
        creditCard.holderName = spellLastNameResult + " " + spellFirstNameResult //tableViewDataSourcesArr[1][1].content
        creditCard.idNo = tableViewDataSourcesArr[1][4].content
        if tableViewDataSourcesArr[1].count >= 6
        {
            creditCard.cvv = tableViewDataSourcesArr[1][5].content
        }
        
        creditCard.idType = "IdentityCard"
        creditCard.expirationMonth = dateMonthView.getDate()
        creditCard.expirationYear = dateYearView.getDate()
        assuranceHotelOrderInfo.creditCard = creditCard
        print("request parameter",assuranceHotelOrderInfo)
        HotelService.sharedInstance
            .commit(order: assuranceHotelOrderInfo)
            .subscribe{ event in
                
                weakSelf?.hideLoadingView()
                if case .next(let e) = event {
                    print(e)
                    //weakSelf?.showSystemAlertView(titleStr: "成功", message: "下单成功")
                    PassengerManager.shareInStance.passengerSVDeleteAll()
                    weakSelf?.nextViewShowOrderStatus(order: e)
                    
                }
                if case .error(let e) = event {
                    print(e)
                    weakSelf?.showSystemAlertView(titleStr: "失败", message: "下单失败")
                }
            }.disposed(by: bag)
    }
    
    func nextViewShowOrderStatus(order:String) {
        let orderStatusView = PShowOrderStatusController()
        self.navigationController?.pushViewController(orderStatusView, animated: true)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
