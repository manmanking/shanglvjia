//
//  PersonalBaseInfoViewController.swift
//  shanglvjia
//
//  Created by tbi on 23/08/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit
import RxSwift

class PersonalBaseInfoViewController: PersonalBaseViewController {

    fileprivate var detailTable = UITableView()
    ///个人 公司
    public var typeIndex: NSInteger = 0
    
    var baseInfoModel:PersonalBaseInfoModel = PersonalBaseInfoModel(jsonData: "")!
    
    let bag = DisposeBag()
    
    ///基本信息
    fileprivate var baseName:Variable = Variable("")
    fileprivate var baseEngName:Variable = Variable("")
    fileprivate var baseEngFirstName:Variable = Variable("")
    fileprivate var baseSex:Variable = Variable("")
    fileprivate var baseBirthday:Variable = Variable("")
    fileprivate var basePhoneNum:Variable = Variable("")
    fileprivate var baseEmail:Variable = Variable("")
    ///证件信息
    fileprivate var nationality:Variable = Variable("")
    fileprivate var idcardNum:Variable = Variable("")
    fileprivate var passportNum:Variable = Variable("")
    fileprivate var passportNation:Variable = Variable("")
    fileprivate var passportTime:Variable = Variable("")
    ///地址
    fileprivate var addressCity:Variable = Variable("")
    fileprivate var addressStreet:Variable = Variable("")
    fileprivate var addressPro:Variable = Variable("")
     fileprivate var addresCit:Variable = Variable("")
     fileprivate var addressArea:Variable = Variable("")
    ///发票信息
    fileprivate var personalName:Variable = Variable("")
    fileprivate var companyHeader:Variable = Variable("")
    fileprivate var companyTaxNum:Variable = Variable("")
    fileprivate var companyBankName:Variable = Variable("")
    fileprivate var companyBankNum:Variable = Variable("")
    fileprivate var companyAddress:Variable = Variable("")
    fileprivate var companyPhone:Variable = Variable("")
    
    override func viewWillAppear(_ animated: Bool) {
        setBlackTitleAndNavigationColor(title: "基本信息")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        self.automaticallyAdjustsScrollViewInsets = false
        
        initTableView()
        initFooterView()
        fillDataSource()
    }

    func initTableView() {
        self.view.addSubview(detailTable)
        detailTable.backgroundColor = TBIThemeBaseColor
        detailTable.separatorStyle=UITableViewCellSeparatorStyle.none
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        detailTable.bounces = false
        detailTable.estimatedRowHeight = 200
        detailTable.delegate = self
        detailTable.dataSource = self
        detailTable.rowHeight = UITableViewAutomaticDimension
        detailTable.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(1)
            make.bottom.equalToSuperview().inset(54)
        }
        detailTable.register(PBaseInfoCell.self, forCellReuseIdentifier: "PBaseInfoCell")
        detailTable.register(PBaseInfoCertCell.self, forCellReuseIdentifier: "PBaseInfoCertCell")
        detailTable.register(PBaseInfoBillCell.self, forCellReuseIdentifier: "PBaseInfoBillCell")

        
    }
    func initFooterView(){
        let saveBtn = UIButton.init(title: "保存", titleColor: TBIThemeWhite, titleSize: 18)
        saveBtn.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        self.view.addSubview(saveBtn)
        saveBtn.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(54)
        }
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: UIControlEvents.touchUpInside)
    }
    func fillDataSource(){
        weak var weakSelf = self
        PersonalMineService.sharedInstance.queryPersonalBaseInfo()
        .subscribe { (event) in
            switch event {
            case .next(let result):
                
                printDebugLog(message: result.mj_keyValues())
                weakSelf?.baseName.value = result.cnName
                weakSelf?.baseEngFirstName.value = result.engFirst
                weakSelf?.baseEngName.value = result.engSecond
                weakSelf?.baseSex.value = (result.gender == "1" ? "男":"女")
                weakSelf?.baseBirthday.value = result.birthday
                weakSelf?.basePhoneNum.value = result.contactPhone
                weakSelf?.baseEmail.value = result.email
                weakSelf?.nationality.value = result.country
                weakSelf?.idcardNum.value = result.certCardNo
                weakSelf?.passportNum.value = result.passportNo
                weakSelf?.passportNation.value = result.passportCountry
                weakSelf?.passportTime.value = result.passportDate
                weakSelf?.addressCity.value = result.province + result.city + result.distrct
                weakSelf?.addressPro.value = result.province
                weakSelf?.addresCit.value = result.city
                weakSelf?.addressArea.value = result.distrct
                
                weakSelf?.addressStreet.value = result.address
                weakSelf?.personalName.value = result.cnName
                weakSelf?.companyHeader.value = result.invoiceTitle
                weakSelf?.companyTaxNum.value = result.taxIdCode
                weakSelf?.companyBankName.value = result.bank
                weakSelf?.companyBankNum.value = result.bankAccount
                weakSelf?.companyAddress.value = result.companyAddress
                weakSelf?.companyPhone.value = result.bankFax
                weakSelf?.detailTable.reloadData()
                
            case .error(let error):
              
                try? weakSelf?.validateHttp(error)
            case .completed:
                break
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension PersonalBaseInfoViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 44*7
        }else if indexPath.section == 1{
            return 44*5
        }else{
            ///3722 我的---基本信息隐去发票信息和姓名 这两部分内容
            ///return 44*2
            return (typeIndex == 0 ? 180 : 405)
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       let view:UIView = UIView()
       view.backgroundColor = TBIThemeBaseColor
       return view
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        weak var weakSelf = self
        if indexPath.section == 0
        {
            let cell:PBaseInfoCell = tableView.dequeueReusableCell(withIdentifier: "PBaseInfoCell") as! PBaseInfoCell
            
            cell.clickCallBack = { _ in
                weakSelf?.view.endEditing(true)
            }
            
            if idcardNum.value.isNotEmpty{
                cell.nameField.isEnabled = false
            }
            cell.nameField.text = baseName.value
            cell.nameField.rx.text.orEmpty.bind(to: baseName).addDisposableTo(bag)
            
            cell.engNameField.text = baseEngName.value
            cell.engNameField.rx.text.orEmpty.bind(to: baseEngName).addDisposableTo(bag)
            
            cell.engFirstField.text = baseEngFirstName.value
            cell.engFirstField.rx.text.orEmpty.bind(to: baseEngFirstName).addDisposableTo(bag)
            
            cell.sexField.text = baseSex.value
            cell.sexField.rx.text.orEmpty.bind(to: baseSex).addDisposableTo(bag)
            
            if idcardNum.value.isNotEmpty{
                baseBirthday.value = "\(CommonTool.returnSubString(idcardNum.value, withStart: 6, withLenght: 4)! )-\(CommonTool.returnSubString(idcardNum.value, withStart: 10, withLenght: 2)! )-\(CommonTool.returnSubString(idcardNum.value, withStart: 12, withLenght: 2)! )"
            }
            
            cell.birthdayField.text = baseBirthday.value
            cell.birthdayField.rx.text.orEmpty.bind(to: baseBirthday).addDisposableTo(bag)
            
            cell.phoneField.text = basePhoneNum.value
            cell.phoneField.rx.text.orEmpty.bind(to: basePhoneNum).addDisposableTo(bag)
            
            cell.emailField.text = baseEmail.value
            cell.emailField.rx.text.orEmpty.bind(to: baseEmail).addDisposableTo(bag)
            
            cell.baseInfoSexSelectReturnBlock = {(string) in
                weakSelf?.baseSex.value = string
            }
            cell.baseInfoBirthdaySelectReturnBlock = {(string) in
                weakSelf?.baseBirthday.value = string
            }
            
            return cell
        }else if indexPath.section == 1{
            let cell:PBaseInfoCertCell = tableView.dequeueReusableCell(withIdentifier: "PBaseInfoCertCell") as! PBaseInfoCertCell
            cell.nationField.text = nationality.value
            cell.nationField.rx.text.orEmpty.bind(to: nationality).addDisposableTo(bag)
            
            if idcardNum.value.isNotEmpty{
                 cell.certField.isEnabled = false
            }
            cell.certField.text = idcardNum.value
            cell.certField.rx.text.orEmpty.bind(to: idcardNum).addDisposableTo(bag)
            
            cell.passportField.text = passportNum.value
            cell.passportField.rx.text.orEmpty.bind(to: passportNum).addDisposableTo(bag)
            
            cell.passportNationField.text = passportNation.value
            cell.passportNationField.rx.text.orEmpty.bind(to: passportNation).addDisposableTo(bag)
            
            cell.passportTimeField.text = passportTime.value
            cell.passportTimeField.rx.text.orEmpty.bind(to: passportTime).addDisposableTo(bag)
            
            cell.nationalitySelectReturnBlock = {(string) in
                weakSelf?.nationality.value = string
            }
            cell.passportNationSelectReturnBlock = {(string) in
                weakSelf?.passportNation.value = string
            }
            cell.passportTimeSelectReturnBlock = {(string) in
                weakSelf?.passportTime.value = string
            }
            cell.idCardCompleteReturnBlock = { (string) in
                if CommonTool.isIdcardNum(with: string){
                    ///自动显示生日
                     weakSelf?.baseBirthday.value = "\(CommonTool.returnSubString(string, withStart: 6, withLenght: 4)! )-\(CommonTool.returnSubString(string, withStart: 10, withLenght: 2)! )-\(CommonTool.returnSubString(string, withStart: 12, withLenght: 2)! )"
                    weakSelf?.detailTable.reloadData()
                }else{
                    weakSelf?.showSystemAlertView(titleStr: "提示", message: "身份证格式错误")
                }
            }
            
            return cell
        }else{
            let cell:PBaseInfoBillCell = tableView.dequeueReusableCell(withIdentifier: "PBaseInfoBillCell") as! PBaseInfoBillCell
            cell.fillCell(type:typeIndex)
            weak var weakSelf  = self
            cell.companyOrPersonalBlock = { btnTag in
                weakSelf?.typeIndex = btnTag
                weakSelf?.detailTable.reloadData()
            }
            cell.addressCity.text = addressCity.value
            cell.addressCity.rx.text.orEmpty.bind(to: addressCity).addDisposableTo(bag)
            
            cell.addressStreet.text = addressStreet.value
            cell.addressStreet.rx.text.orEmpty.bind(to: addressStreet).addDisposableTo(bag)
            
            cell.personalName.text = personalName.value
            cell.personalName.rx.text.orEmpty.bind(to: personalName).addDisposableTo(bag)
            
            cell.companyHeader.text = companyHeader.value
            cell.companyHeader.rx.text.orEmpty.bind(to: companyHeader).addDisposableTo(bag)
            
            cell.companyTaxNum.text = companyTaxNum.value
            cell.companyTaxNum.rx.text.orEmpty.bind(to: companyTaxNum).addDisposableTo(bag)
            
            cell.companyBankName.text = companyBankName.value
            cell.companyBankName.rx.text.orEmpty.bind(to: companyBankName).addDisposableTo(bag)
            
            cell.companyBankNum.text = companyBankNum.value
            cell.companyBankNum.rx.text.orEmpty.bind(to: companyBankNum).addDisposableTo(bag)
            
            cell.companyAddress.text = companyAddress.value
            cell.companyAddress.rx.text.orEmpty.bind(to: companyAddress).addDisposableTo(bag)
            
            cell.companyPhone.text = companyPhone.value
            cell.companyPhone.rx.text.orEmpty.bind(to: companyPhone).addDisposableTo(bag)
            
            cell.provincePickerResultBlock = {(province,city,area)in
                weakSelf?.addressCity.value = province + city + area
                weakSelf?.addressPro.value = province
                weakSelf?.addresCit.value = city
                weakSelf?.addressArea.value = area
                //weakSelf?.baseInfoModel.province = province
                //weakSelf?.baseInfoModel.city = city
                //weakSelf?.baseInfoModel.distrct = area
            }
            return cell
        }
        
    }
    
    func saveBtnClick(){
        self.view.endEditing(true)
        guard baseName.value.isEmpty == false else {
            showSystemAlertView(titleStr: "提示", message: "请填写姓名")
            return
        }
        guard basePhoneNum.value.isEmpty == false  else {
            showSystemAlertView(titleStr: "提示", message: "请填写联系人手机号")
            return
        }
        guard basePhoneNum.value.validate(ValidateType.phone) == true else{
            showSystemAlertView(titleStr: "提示", message: "手机号格式错误")
            return
        }
        guard baseEmail.value.isEmpty == false  else {
            showSystemAlertView(titleStr: "提示", message: "请填写联系人邮箱")
            return
        }
        guard baseEmail.value.validate(ValidateType.email) == true else{
            showSystemAlertView(titleStr: "提示", message: "邮箱格式错误")
            return
        }
        if !CommonTool.isIdcardNum(with: idcardNum.value){
            showSystemAlertView(titleStr: "提示", message: "身份证格式错误")
            return
        }
        /*
        if  typeIndex == 0 && personalName.value.isEmpty {
            showSystemAlertView(titleStr: "提示", message: "请填写个人发票姓名")
            return
        }
        if typeIndex == 1  {
            if companyHeader.value.isEmpty{
                showSystemAlertView(titleStr: "提示", message: "请填写发票抬头")
                return
            }
            if companyTaxNum.value.isEmpty{
                showSystemAlertView(titleStr: "提示", message: "请填写纳税人识别号")
                return
            }
            if companyBankName.value.isEmpty{
                showSystemAlertView(titleStr: "提示", message: "请填写开户银行")
                return
            }
            if companyBankNum.value.isEmpty{
                showSystemAlertView(titleStr: "提示", message: "请填写银行账户")
                return
            }
            if companyAddress.value.isEmpty{
                showSystemAlertView(titleStr: "提示", message: "请填写公司地址")
                return
            }
            if companyPhone.value.isEmpty{
                showSystemAlertView(titleStr: "提示", message: "请填写公司电话号码")
                return
            }
            
        }*/
        baseInfoModel.cnName = baseName.value
        baseInfoModel.engFirst = baseEngFirstName.value
        baseInfoModel.engSecond = baseEngName.value
        baseInfoModel.gender = (baseSex.value == "女" ? "2" : "1")
        baseInfoModel.birthday = baseBirthday.value
        baseInfoModel.contactPhone = basePhoneNum.value
        baseInfoModel.email = baseEmail.value
        
        baseInfoModel.country = nationality.value
        baseInfoModel.certCardNo = idcardNum.value
        baseInfoModel.passportNo = passportNum.value
        baseInfoModel.passportCountry = passportNation.value
        baseInfoModel.passportDate = passportTime.value
        
        baseInfoModel.address = addressStreet.value
        baseInfoModel.province = addressPro.value
        baseInfoModel.city = addresCit.value
        baseInfoModel.distrct = addressArea.value
        
        baseInfoModel.invoiceType = typeIndex.description
        baseInfoModel.invoiceTitle = companyHeader.value
        baseInfoModel.taxIdCode = companyTaxNum.value
        baseInfoModel.bank = companyBankName.value
        baseInfoModel.bankAccount = companyBankNum.value
        baseInfoModel.companyAddress = companyAddress.value
        baseInfoModel.bankFax = companyPhone.value
        
        updateBaseInfo()
       
    }
    func updateBaseInfo()  {
        weak var weakSelf  = self
        showLoadingView()
        PersonalMineService.sharedInstance.bindUserAppend(request: baseInfoModel)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
            switch event {
            case .next(let result):
                
                printDebugLog(message: result.mj_keyValues())
                weakSelf?.navigationController?.popViewController(animated: true)
                
            case .error(let error):
                
                try? weakSelf?.validateHttp(error)
            case .completed:
                break
            }
        }
    }
}
