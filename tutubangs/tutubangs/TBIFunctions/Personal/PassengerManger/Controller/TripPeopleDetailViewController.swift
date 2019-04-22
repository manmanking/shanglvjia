//
//  TripPeopleDetailViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/23.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class TripPeopleDetailViewController: PersonalBaseViewController {
    
    fileprivate var detailTable = UITableView()
    var peopleModel = PersonalTravellerInfoRequest()
    let titleArr:[String] = ["姓名","英文名","英文姓","性别","手机号","证件类型","证件号","发证国","有效期","出生日期","亲属关系"]
    var boolArr:[Bool] = [false,false,false,false,true,false,false,false,false,true,true]
    public var passenger:PersonalTravellerInfoRequest = PersonalTravellerInfoRequest()
    
    public var  onlyOnePeopleArr:[String] = Array()
    let bag = DisposeBag()
    
    //fileprivate var passengerRelation:String = ""
    fileprivate var chName:Variable = Variable("")
    fileprivate var sexValue:Variable = Variable("")
    fileprivate var birthday:Variable = Variable("")
    fileprivate var enNameFirst:Variable = Variable("")
    fileprivate var enNameSecond:Variable = Variable("")
    
    fileprivate var userRelationShip:Variable = Variable("")
    fileprivate var mobile:Variable = Variable("")
    
    
    // 显示的证件信息
    fileprivate var showIdCardName:Variable = Variable("")
    fileprivate var showIdCardNo:Variable = Variable("")
    // 证件信息
    fileprivate var certNo:Variable = Variable("")
    fileprivate var gangaoNo:Variable = Variable("")
    fileprivate var militaryCard:Variable = Variable("")
    fileprivate var passportNo:Variable = Variable("")
    fileprivate var taiwanNo:Variable = Variable("")
    fileprivate var taiwanpassNo:Variable = Variable("")
    
    fileprivate var backHomeTownNo:Variable = Variable("")
    fileprivate var permanentResidenceBookletNo:Variable = Variable("")
    fileprivate var birthCertificateNo:Variable = Variable("")
    
    fileprivate var passportCountry:Variable = Variable("")
    fileprivate var passportCountryCode:Variable = Variable("")
    fileprivate var passportExpireDate:Variable = Variable("")
    
    
    fileprivate var relationShip:PersonalTravellerInfoRequest.UserRelationShip = PersonalTravellerInfoRequest.UserRelationShip.Other
    
    /// 是否为本人
    fileprivate var isMyself:Bool = false
    
    /// 是否可以修改证件号 身份证号
    fileprivate var isModifyIdCardNo:Bool = true
    /// 是否可以修改证件号 身份证号
    fileprivate var isModifyPassportNo:Bool = true
    
    
    fileprivate let modifyInfoErrorDefaultTip:String = "请完善证件信息"
    
    fileprivate let modifyInfoErrorIdTypeDefaultTip:String = "请选择证件类型"
    
    fileprivate let modifyInfoSuccessDefaultModifyTip:String = "信息修改成功"
    
    fileprivate let modifyInfoSuccessDefaultAddTip:String = "信息添加成功"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        setBlackTitleAndNavigationColor(title: "出行人详情")
        fillLocalDataSources()
        initTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillLocalDataSources() {
        
        onlyOnePeopleArr.append("5")
        onlyOnePeopleArr.append("0")//passengerRelation = passenger.relationType
        onlyOnePeopleArr.append(passenger.relationType)
        
        
        passenger.userId = DBManager.shareInstance.userDetailDraw()?.cusLoginInfo.userId ?? ""
        ///付值
        chName.value = passenger.chName
        enNameSecond.value = passenger.enNameSecond
        enNameFirst.value = passenger.enNameFirst
        mobile.value = passenger.mobile
        birthday.value = passenger.birthday
        userRelationShip.value = passenger.relationTypeLocal.getChineseRelation()
        showIdCardName.value = "请选择证件类型"
        
        passportCountry.value = PersonalPassengerCountry.init(codeType: passenger.passportCountry).getCountryChineseName()
        passportCountryCode.value = PersonalPassengerCountry.init(nameType: passportCountry.value).getCountryCode()
        passportExpireDate.value = passenger.passportExpireDate
        if passenger.gender.isEmpty == false {
            sexValue.value = passenger.gender == "1" ? "男":"女"
        }
        
        if passenger.certNo.count>14{
            birthday.value = "\(CommonTool.returnSubString(passenger.certNo, withStart: 6, withLenght: 4)! )-\(CommonTool.returnSubString(passenger.certNo, withStart: 10, withLenght: 2)! )-\(CommonTool.returnSubString(passenger.certNo, withStart: 12, withLenght: 2)! )"
        }
        
        
        if passenger.relationTypeLocal == PersonalTravellerInfoRequest.UserRelationShip.Myself {
            isMyself = true
            if passenger.certNo.isEmpty == false { isModifyIdCardNo = false }
            if passenger.passportNo.isEmpty == false { isModifyPassportNo = false }
            
            
        }
        
        if passenger.certNo.isEmpty == false {
            showIdCardNo.value = passenger.certNo
            showIdCardName.value = PersonalTravellerInfoRequest.IDCardType.init(type:"身份证").getChineseName()
        }
        
        //这期 先做 身份证 和护照
        //        fileprivate var backHomeTownNo:Variable = Variable("")
        //        fileprivate var permanentResidenceBookletNo:Variable = Variable("")
        //        fileprivate var birthCertificateNo:Variable = Variable("")
        //        if passenger.taiwanNo.isEmpty == false {
        //            showIdCardNo.value = passenger.passportNo
        //            showIdCardName.value = PersonalTravellerInfoRequest.IDCardType.init(type:"台胞证").getChineseName()
        //        }
        //        if passenger.taiwanpassNo.isEmpty == false {
        //            showIdCardNo.value = passenger.passportNo
        //            showIdCardName.value = PersonalTravellerInfoRequest.IDCardType.init(type:"台湾通行证").getChineseName()
        //        }
        //        if passenger.gangaoNo.isEmpty == false {
        //            showIdCardNo.value = passenger.passportNo
        //            showIdCardName.value = PersonalTravellerInfoRequest.IDCardType.init(type:"港澳通行证").getChineseName()
        //        }
        //        if passenger.militaryCard.isEmpty == false {
        //            showIdCardNo.value = passenger.passportNo
        //            showIdCardName.value = PersonalTravellerInfoRequest.IDCardType.init(type:"军官证").getChineseName()
        //        }
        //
        if passenger.passportNo.isEmpty == false {
            showIdCardNo.value = passenger.passportNo
            showIdCardName.value = PersonalTravellerInfoRequest.IDCardType.init(type:"护照").getChineseName()
        }
        
        //        if showIdCardName.value.isEmpty == true {
        //            showIdCardNo.value = passenger.passportNo
        //            showIdCardName.value = PersonalTravellerInfoRequest.IDCardType.init(type:"护照").getChineseName()
        //        }
        //        if passenger.certNo.isEmpty == true && passenger.passportNo.isEmpty == true {
        //
        //        }
        
    }
    
    
    func initTableView() {
        self.view.addSubview(detailTable)
        detailTable.backgroundColor = TBIThemeBaseColor
        detailTable.separatorStyle=UITableViewCellSeparatorStyle.none
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        detailTable.estimatedRowHeight = 45
        detailTable.delegate = self
        detailTable.dataSource = self
        detailTable.rowHeight = 45
        detailTable.bounces = false
        detailTable.register(TripPeopleDetailCell.self, forCellReuseIdentifier: "TripPeopleDetailCell")
        detailTable.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        detailTable.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(10)
        }
        
    }
    
    
    
    //MARK:------NET-------
    
    /// 添加乘客信息
    func passengerAdd(request:PersonalTravellerInfoRequest) {
        weak var weakSelf = self
        showLoadingView()
        PersonalPassengerServices.sharedInstance
            .passengerAdd(request:request)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    printDebugLog(message: element)
                    ///weakSelf?.showSystemAlertView(titleStr: "提示", message:(weakSelf?.modifyInfoSuccessDefaultAddTip)!)
                    weakSelf?.navigationController?.popViewController(animated: true)
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                    
                }
            }.addDisposableTo(self.bag)
    }
    
    
    /// 乘客修改信息
    func passengerModify(request:PersonalTravellerInfoRequest) {
        weak var weakSelf = self
        showLoadingView()
        PersonalPassengerServices.sharedInstance
            .passengerModify(request:request)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    printDebugLog(message: element)
                    ///weakSelf?.showSystemAlertView(titleStr: "提示", message:(weakSelf?.modifyInfoSuccessDefaultModifyTip)! )
                    weakSelf?.navigationController?.popViewController(animated: true)
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                    
                }
            }.addDisposableTo(self.bag)
    }
    
    override func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.message == modifyInfoSuccessDefaultModifyTip || alertView.message == modifyInfoSuccessDefaultAddTip {
            backButtonAction(sender: UIButton())
        }
        
    }
    
    
    
    
    
    
    
    //MARK: -------- Action ------
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension TripPeopleDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == titleArr.count{
            return 55
        }
        return  45
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == titleArr.count{
            ///确定按钮
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
            cell.selectionStyle = .none
            cell.backgroundColor = TBIThemeBaseColor
            let submitButton:UIButton = UIButton.init(title: "确定", titleColor: TBIThemeWhite, backImageName: "yellow_btn_gradient")
            submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.addSubview(submitButton)
            submitButton.layer.cornerRadius = 4
            submitButton.clipsToBounds = true
            submitButton.snp.makeConstraints({ (make) in
                make.top.left.right.equalToSuperview().inset(10)
                make.height.equalTo(45)
            })
            submitButton.addTarget(self, action: #selector(submitButtonClick(sender:)), for: UIControlEvents.touchUpInside)
            
            return cell
        }else{
            let cell:TripPeopleDetailCell = tableView.dequeueReusableCell(withIdentifier: "TripPeopleDetailCell") as! TripPeopleDetailCell
            if showIdCardName.value == "护照"{
                boolArr = [false,true,true,false,true,true,true,true,true,true,true]
            }else if showIdCardName.value == "请选择证件类型"{
                boolArr = [false,false,false,false,true,false,false,false,false,true,true]
            }else{
                boolArr = [true,false,false,false,true,true,true,false,false,true,true]
            }
            cell.setCellWithData(titleStr:titleArr[indexPath.row],passenger: passenger,isMust:boolArr[indexPath.row])
            cell.controller = self
            if indexPath.row < titleArr.count-1{
                cell.lineLabel.isHidden = false
            }else{
                cell.lineLabel.isHidden = true
            }
            if cell.titleLabel.text == "姓名"{
                cell.infoTextField.text = chName.value
                cell.infoTextField.placeholder = "请输入姓名"
                cell.infoTextField.rx.text.orEmpty.bind(to: chName).addDisposableTo(bag)
                chName.value = cell.infoTextField.text!
            }
            if cell.titleLabel.text == "英文名"{
                cell.infoTextField.text = enNameSecond.value
                cell.infoTextField.placeholder = "请输入英文名"
                cell.infoTextField.rx.text.orEmpty.bind(to: enNameSecond).addDisposableTo(bag)
                enNameSecond.value = cell.infoTextField.text!
            }
            if cell.titleLabel.text == "英文姓"{
                cell.infoTextField.text = enNameFirst.value
                cell.infoTextField.placeholder = "请输入英文姓"
                cell.infoTextField.rx.text.orEmpty.bind(to: enNameFirst).addDisposableTo(bag)
                enNameFirst.value = cell.infoTextField.text!
            }
            if cell.titleLabel.text == "手机号"{
                cell.infoTextField.text = mobile.value
                cell.infoTextField.placeholder = "请输入手机号码"
                cell.infoTextField.rx.text.orEmpty.bind(to: mobile).addDisposableTo(bag)
                mobile.value = cell.infoTextField.text!
            }
            if cell.titleLabel.text == "证件号"{
                cell.infoTextField.text = showIdCardNo.value
                cell.infoTextField.placeholder = "请输入证件号码"
                let idCardType = PersonalTravellerInfoRequest.IDCardType.init(type: showIdCardName.value)
                
                if (idCardType == PersonalTravellerInfoRequest.IDCardType.idCard && isMyself == true && isModifyIdCardNo == false) || (idCardType == PersonalTravellerInfoRequest.IDCardType.Passport && isMyself == true && isModifyPassportNo == false) {
                    cell.infoTextField.isEnabled = false
                }else { cell.infoTextField.isEnabled = true }
                //                if (idCardType == PersonalTravellerInfoRequest.IDCardType.idCard || idCardType ==  PersonalTravellerInfoRequest.IDCardType.Passport) && isMyself == true
                //                {
                //                    cell.infoTextField.isEnabled = false
                //                }else
                cell.infoTextField.rx.text.orEmpty.bind(to: showIdCardNo).addDisposableTo(bag)
            }
            weak var weakSelf = self
            
            if cell.titleLabel.text == "发证国"{
                cell.infoTextField.placeholder = "请选择发证国"
                cell.infoTextField.text = passportCountry.value
                cell.tripPeopleDetailCellSelectedCountryBlock = { (idCardName,idCardNo) in
                    weakSelf?.passportCountry.value = idCardName
                    //                    let indexPath:IndexPath = IndexPath.init(row: 6, section: 0)
                    //                    weakSelf?.detailTable.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                }
                cell.infoTextField.rx.text.orEmpty.bind(to: passportCountry).addDisposableTo(self.bag)
                
            }
            ///如果身份证号不为空 生日不可点击 自动显示生日
            if passenger.certNo.isNotEmpty{
                if cell.titleLabel.text == "出生日期"{
                    cell.infoTextField.isEnabled = false
                }else{
                    cell.infoTextField.isEnabled  = true
                }
            }else{
                if cell.titleLabel.text == "证件类型" && cell.infoTextField.text == "身份证"{
                    cell.infoTextField.isEnabled  = false
                }else{
                    cell.infoTextField.isEnabled  = true
                }
            }
            cell.idCardCompleteReturnBlock = { (string) in
                if weakSelf?.showIdCardName.value == "身份证"{
                    if CommonTool.isIdcardNum(with: string){
                        
                        weakSelf?.passenger.certNo = string
                        ///自动显示生日
                        weakSelf?.birthday.value = "\(CommonTool.returnSubString(string, withStart: 6, withLenght: 4)! )-\(CommonTool.returnSubString(string, withStart: 10, withLenght: 2)! )-\(CommonTool.returnSubString(string, withStart: 12, withLenght: 2)! )"
                        weakSelf?.detailTable.reloadData()
                        
                    }else{
                        weakSelf?.showSystemAlertView(titleStr: "提示", message: "身份证格式错误")
                    }
                }
            }
            
            
            
            
            
            if cell.titleLabel.text == "有效期"{
                cell.infoTextField.placeholder = "请选择证件有效期"
                cell.infoTextField.text = passportExpireDate.value
                cell.tripPeopleDetailCellSelectedIdCardExpiredDateBlock = { (expireDate) in
                    weakSelf?.passportExpireDate.value = expireDate
                }
                cell.infoTextField.rx.text.orEmpty.bind(to: passportExpireDate).addDisposableTo(self.bag)
                
            }
            if cell.titleLabel.text == "性别" {
                
                cell.infoTextField.text = sexValue.value
                cell.infoTextField.placeholder = "请选择性别"
                cell.tripPeopleDetailCellSelectedIdCardExpiredDateBlock = { (sexName) in
                    weakSelf?.sexValue.value = sexName
                    
                }
                cell.infoTextField.rx.text.orEmpty.bind(to: sexValue).addDisposableTo(bag)
            }
            
            if cell.titleLabel.text == "出生日期"{
                cell.infoTextField.text = birthday.value
                cell.infoTextField.placeholder = "请输入出生日期"
                cell.tripPeopleDetailCellSelectedBlock = { (typeStr,_) in
                    weakSelf?.birthday.value = typeStr
                }
                cell.infoTextField.rx.text.orEmpty.bind(to: birthday).addDisposableTo(self.bag)
            }
            
            if cell.titleLabel.text == "证件类型"{
                cell.infoTextField.text = showIdCardName.value
                cell.infoTextField.placeholder = "请选择证件类型"
                cell.tripPeopleDetailCellSelectedBlock = { (idCardName,idCardNo) in
                    //                    weakSelf?.showIdCardName.value = idCardName
                    //                    weakSelf?.showIdCardNo.value = idCardNo
                    //                    let indexPath:IndexPath = IndexPath.init(row: 5, section: 0)
                    //                    weakSelf?.detailTable.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                    weakSelf?.storePassengerIdCardInfo(idCardName: idCardName, idCardNo: idCardNo)
                    
                }
                cell.infoTextField.rx.text.orEmpty.bind(to: showIdCardName).addDisposableTo(self.bag)
                
            }
            if cell.titleLabel.text == "亲属关系"{
                cell.infoTextField.text = userRelationShip.value
                cell.infoTextField.placeholder = "请选择亲属关系"
                cell.tripPeopleDetailCellSelectedBlock = { (typeStr,_)in
                    weakSelf?.userRelationShip.value = typeStr
                }
                cell.infoTextField.rx.text.orEmpty.bind(to: userRelationShip).addDisposableTo(self.bag)
            }
            
            if cell.titleLabel.text == "姓名"{
                if isMyself {
                    if passenger.chName.isEmpty{
                        cell.infoTextField.isEnabled = true
                    }else{
                        cell.infoTextField.isEnabled = false
                    }
                }
            }
            if cell.titleLabel.text == "证件号"{
                ///如果是本人 证件类型为身份证 身份证号不为空 可输入
                if isMyself{
                    if showIdCardName.value == "身份证"{
                        if showIdCardNo.value.isEmpty{
                            cell.infoTextField.isEnabled = true
                        }else{
                            cell.infoTextField.isEnabled = false
                        }
                    }else{
                        cell.infoTextField.isEnabled = true
                    }
                }
            }
            
            
            return cell
        }
        
    }
    
    func storePassengerIdCardInfo(idCardName:String,idCardNo:String) {
        showIdCardName.value = idCardName
        showIdCardNo.value = idCardNo
        
        let idCardType:PersonalTravellerInfoRequest.IDCardType = PersonalTravellerInfoRequest.IDCardType.init(type: idCardName)
        switch idCardType {
        case .idCard:
            passenger.certNo = idCardNo
            
        case .Passport:
            passenger.passportNo = idCardNo
        case .HKANDMacaoPassport:
            passenger.gangaoNo = idCardNo
        case .TaiwanCompatriotsCard:
            passenger.taiwanNo = idCardNo
        case .TaiwanesePass:
            passenger.taiwanpassNo = idCardNo
        case .MilitaryCer:
            passenger.militaryCard = idCardNo
        default: break
            
        }
        
        detailTable.reloadData()
        
        
        
    }
    
    
    
    /// 保存 旅客信息
    func submitButtonClick(sender:UIButton){
        
        ///37561. 证件类型增加“请选择证件类型”选项，默认停在该选项
        
        ///2. 如果选择身份证，则身份证，中文姓名，证件号，手机号，生日，亲属关系均为必填
        
        ///3. 如果选择护照，则英文姓名，证件号，手机号，生日，护照发证国，有效期，亲属关系均为必填
        
        ///4. 如果未选择证件类型，则中文或者英文姓名，出生日期，亲属关系，手机号必填
        
        
        let showIdType:PersonalTravellerInfoRequest.IDCardType = PersonalTravellerInfoRequest.IDCardType.init(type: showIdCardName.value)
        
        if showIdType == PersonalTravellerInfoRequest.IDCardType.Unknown{
            if chName.value.isEmpty == true && enNameFirst.value.isEmpty == true && enNameSecond.value.isEmpty == true{
                showSystemAlertView(titleStr: "提示", message: "请输入中文名字或英文名")
                return
            }
        }else{
            if showIdCardNo.value.isEmpty == true  {
                showSystemAlertView(titleStr: "提示", message: "请输入证件号")
                return
            }
        }
        
        
        //身份证
        if showIdType == PersonalTravellerInfoRequest.IDCardType.idCard {
            if chName.value.isEmpty == true {
                showSystemAlertView(titleStr: "提示", message: "请输入中文名字")
                return
            }
            if !CommonTool.isIdcardNum(with: passenger.certNo){
                showSystemAlertView(titleStr: "提示", message: "身份证格式错误")
                return
            }
        }
        
        
        
        //  验证护照信息
        if showIdType == PersonalTravellerInfoRequest.IDCardType.Passport {
            if (enNameSecond.value.isEmpty == true || enNameFirst.value.isEmpty == true ) {
                showSystemAlertView(titleStr: "提示", message: "请输入英文名字")
                return
            }
            
            if passportCountry.value.isEmpty == true {
                showSystemAlertView(titleStr: "提示", message: "请选择发证国")
                return
            }
            if sexValue.value.isEmpty == true {
                showSystemAlertView(titleStr: "提示", message: "请选择性别")
                return
            }
            if passportExpireDate.value.isEmpty == true {
                showSystemAlertView(titleStr: "提示", message: "请选择证件有效期")
                return
            }
        }
        //
        //        if showIdType == PersonalTravellerInfoRequest.IDCardType.Passport && (enNameSecond.value.isEmpty == true || enNameFirst.value.isEmpty == true ){
        //            showSystemAlertView(titleStr: "提示", message: "请输入英文名字")
        //            return
        //        }else {
        //            if passportCountry.value.isEmpty == true && sexValue.value.isEmpty == false && passportExpireDate.value.isEmpty == true {
        //                showSystemAlertView(titleStr: "提示", message: modifyInfoErrorDefaultTip)
        //                return
        //            }
        //        }
        
        //        guard sexValue.value.isEmpty == false else {
        //            showSystemAlertView(titleStr: "提示", message: "填写性别信息")
        //            return
        //        }
        
        guard mobile.value.validate(ValidateType.phone) == true else {
            showSystemAlertView(titleStr: "提示", message: "填写正确的的手机号")
            return
        }
        
        
        guard birthday.value.isEmpty == false else {
            showSystemAlertView(titleStr: "提示", message: "填写正确的的出生日期")
            return
        }
        
        
        let relationShip:String = PersonalTravellerInfoRequest.UserRelationShip.init(type: userRelationShip.value).rawValue.description
        let isContain:Bool = onlyOnePeopleArr.contains { (element) -> Bool in
            if element == relationShip {
                return true
            }
            return false
        }
        
        if isContain == false {
            showSystemAlertView(titleStr: "提示", message: "请选择正确的亲属关系!")
            return
        }
        
        
        switch showIdType {
        case .idCard:
            passenger.certNo = showIdCardNo.value
        case .Passport:
            passenger.passportNo = showIdCardNo.value
        case .HKANDMacaoPassport:
            passenger.gangaoNo = showIdCardNo.value
        case .TaiwanCompatriotsCard:
            passenger.taiwanNo = showIdCardNo.value
        case .TaiwanesePass:
            passenger.taiwanpassNo = showIdCardNo.value
        case .MilitaryCer:
            passenger.militaryCard = showIdCardNo.value
        case .BackHomeTown:
            passenger.huixiangCert = showIdCardNo.value
        case .PermanentResidenceBooklet:
            passenger.hukouCert = showIdCardNo.value
        case .BirthCertificate:
            passenger.bornCert = showIdCardNo.value
            
        default:
            break
        }
        
        passenger.chName = chName.value
        passenger.enNameSecond = enNameSecond.value
        passenger.enNameFirst = enNameFirst.value
        passenger.mobile = mobile.value
        passenger.birthday = birthday.value
        passenger.gender = sexValue.value == "男" ? "1" : "2"
        passenger.passportExpireDate = passportExpireDate.value
        passenger.passportCountry = PersonalPassengerCountry.init(nameType: passportCountry.value).getCountryCode()
        passenger.relationType = PersonalTravellerInfoRequest.UserRelationShip.init(type: userRelationShip.value).rawValue.description
        if passenger.id.isEmpty == true {
            passengerAdd(request:passenger)
        }else{
            passengerModify(request: passenger)
        }
        
        
    }
}
