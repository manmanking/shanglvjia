//
//  FlightModifyPersonController.swift
//  shop
//
//  Created by TBI on 2017/5/25.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


enum FlightModifyPersonType:String {
    case ID = "证件号码"
    case PHONE = "手机号码"
    case ONWARD = "去程"
    case ONWARDFirst = "去程第一段"
    case ONWARDSecond  = "去程第二段"
    case BACKWARD = "返程"
    case BACKWARDFirst = "返程第一段"
    case BACKWARDSecond = "返程第二段"
    case UNKNOW = "know?"
}




class FlightModifyPersonController: CompanyBaseViewController {
    
    typealias FlightModifyPersonBlockResult = (LoginResponse.UserBaseCertInfo,String)->Void
    
    public var flightModifyPersonBlockResult:FlightModifyPersonBlockResult!
    
    public var travellerModel:Traveller?
    
    
    public var travellerSVModel:QueryPassagerResponse = QueryPassagerResponse()
    
    public var passenger:Any?// 选中的旅客
    
    
    private var passengerOld:CoOldFlightForm.Create.Passenger?
    private var passengerNew:CoNewFlightForm.Create.Passenger?
    
    
    
    private let manualStr = "手动输入"
    
    private let disposeBag = DisposeBag()
    
    fileprivate let flightModifyTravellerTableViewCellIdentify = "FlightModifyTravellerTableViewCellIdentify"
    
    
    private var finderView:TBIFinderView = TBIFinderView()
    
    fileprivate var tableView:UITableView = UITableView()
    
    fileprivate var okayButton:UIButton = UIButton()
    //去程 是否直接到达  0  不存在。1 直达 2 中转
    fileprivate var onwardDirect:NSInteger = 2
    //返程 是否直接到达 0  不存在。1 直达 2 中转
    fileprivate var backwardDirect:NSInteger = 2
    
    //是否 需要手动输入 1 自动的 0 手动的
    fileprivate var manual:NSInteger = 1
    
    //是否跳过 去程
    fileprivate var onwardJumpRow:NSInteger = 1
    //是否跳过 返程
    fileprivate var backwardJumpRow:NSInteger = 1
    //证件
    fileprivate var identificationDataSources:[String] = Array()
    // 默认值 100
    fileprivate var identificationSelectedIndex:NSInteger = 100
    
    
    //会员卡
    fileprivate var memberCardDataSources:[String] = Array()
    
    fileprivate var selectedeIndexPath:IndexPath = IndexPath()
    
    fileprivate var tableViewDataSource:[[(title:String,content:String)]] = Array()
    
    
    fileprivate var personalTitleInfo:[(title:String,content:String)] = Array()
    
    fileprivate var onwardTitleInfo:[(title:String,content:String)] = Array()
    
    fileprivate var backwardTitleInfo:[(title:String,content:String)] = Array()
    
//    fileprivate var personalDataSource:[(title:String,content:String)] = Array()
    
    fileprivate var certificate = Traveller.Certificate()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController ()
        
        //disablesAutomaticKeyboardDismissal = true
        
        //personalDataSource = [("赵飞飞",""),("身份证",""),("1388888888",""),("","")]
        
        initTableView()
        
       //测试数据
        //单程直达
//        onwardDirect = 1
//        backwardDirect = 0
//
        // 单程 中转
//        onwardDirect = 2
//        backwardDirect = 0
//
        //往返 直达
//        onwardDirect = 1
//        backwardDirect = 1
//
//        // 往返  直达 中转
//        onwardDirect = 1
//        backwardDirect = 2
//
//        // 往返 中转 直达
//        onwardDirect = 2
//        backwardDirect = 1
//        // 往返。中转
//        onwardDirect = 2
//        backwardDirect = 2

        //start of line  on 2018-04-19
        // 现在 新需求 常旅客卡 隐藏
//
//        //往返
//        if  searchModel.type == 2
//        {
//            print("往返 ...")
//            if takeOffCompanyModel?.direct ?? false
//            {
//                onwardDirect = 1
//                onwardJumpRow = 0
//            }
//            if arriveCompanyModel?.direct ?? false
//            {
//                backwardDirect = 1
//                backwardJumpRow = 0
//            }
//        }else // 单程
//        {
//            print("单程 ...")
//            if takeOffCompanyModel?.direct ?? false {
//                onwardDirect = 1
//                onwardJumpRow = 0
//                backwardDirect = 0
//            }
//            else //单程中转
//            {
//                onwardDirect = 2
//                backwardDirect = 0
//
//            }
//        }
        // end of line

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // 添加常旅客卡 信息
        
        var idcontent:String = ""
        var phonecontent:String = ""
        
        if travellerSVModel.certInfos.first?.certType == "1" && travellerSVModel.certInfos.first?.certNo.isEmpty == false {
            idcontent = "身份证" + "(" + (travellerSVModel.certInfos.first?.certNo)! + ")"
        }
        if travellerSVModel.certInfos.first?.certType == "2" && travellerSVModel.certInfos.first?.certNo.isEmpty == false {
            idcontent = "护照" + "(" + (travellerSVModel.certInfos.first?.certNo)! + ")"
        }
        if travellerSVModel.mobiles.count > 0 {
            phonecontent = travellerSVModel.mobiles.first ?? ""
        }
        
        
        
        
//        let userInfo = UserService.sharedInstance.userDetail()
//        if userInfo?.companyUser?.newVersion == true {
//            passengerNew = passenger as? CoNewFlightForm.Create.Passenger
//
//            if passengerNew?.certType == 1
//            {
//                if (passengerNew?.certNo.characters.count)! > 0 {
//                    idcontent = "身份证" + "(" + (passengerNew?.certNo)! + ")"
//                }
//            }
//
//            if passengerNew?.certType == 2
//            {
//                if (passengerNew?.certNo.characters.count)! > 0 {
//                    idcontent = "护照" + "(" + (passengerNew?.certNo)! + ")"
//                }
//
//            }
//            if passengerNew?.mobile != nil
//            {
//                phonecontent = (passengerNew?.mobile)!
//            }else
//            {
//                phonecontent = ""
//            }
//
//
//        }else
//        {
//            passengerOld = passenger as? CoOldFlightForm.Create.Passenger
//            if passengerOld?.certType == 1
//            {
//                if (passengerOld?.certNo.characters.count)! > 0 {
//                    idcontent = "身份证" + "(" + (passengerOld?.certNo)! + ")"
//                }
//
//            }
//
//            if passengerOld?.certType == 2
//            {
//                if (passengerOld?.certNo.characters.count)! > 0 {
//                    idcontent = "护照" + "(" + (passengerOld?.certNo)! + ")"
//                }
//            }
//
//            if passengerOld?.mobile != nil
//            {
//                phonecontent = (passengerOld?.mobile)!
//            }else
//            {
//                phonecontent = ""
//            }
//
//
//
//        }
        
        
        identificationDataSources.removeAll()
        // 证件信息
        for element in (travellerSVModel.certInfos)
        {
            if element.certType == "1" || element.certType == "2"
            {
                let name = element.certType == "1" ? "身份证" : "护照"
                let number = element.certNo
                identificationDataSources.append((name + "(" + number + ")"))
            }
            
        }
        //identificationDataSources.append(manualStr)
//        //会员卡信息
//        for element in (travellerSVModel?.travelCards)!
//        {
//            let supplierCode = element.supplierCode
//            let number = element.number
//            memberCardDataSources.append((supplierCode + number))
//        }
        
        var phone = ""
        if (travellerSVModel.mobiles.count > 0 && travellerSVModel.mobiles.first!.isEmpty == false) {
            phone = (travellerSVModel.mobiles.first)!
        }
        // 设置默认数据
        //personalTitleInfo = [("旅客姓名",travellerSVModel.name),("证件号码",idcontent),("手动输入",""),("手机号码",phonecontent)]
        personalTitleInfo = [("旅客姓名",travellerSVModel.name),("证件号码",idcontent),("手机号码",phonecontent)]
        
//        onwardTitleInfo = [("去程常旅客卡",""),("去程",""),("第一段",""),("第二段","")]
//        backwardTitleInfo = [("返程常旅客卡",""),("返程",""),("第一段",""),("第二段","")]
       
//        // modify by manman on 2018-04-19 start of line
//
//        var onwardTravelCardArr:[String] = Array()
//        var backwardTravelCardArr:[String] = Array()
//
//        // 调整默认数据
//        if userInfo?.companyUser?.newVersion == true
//        {
//            passengerNew = passenger as? CoNewFlightForm.Create.Passenger
//
//            //去程
//            if passengerNew?.depTravelCards != nil && (passengerNew?.depTravelCards.count)! >= 1
//            {
//                for (_, element) in (passengerNew?.depTravelCards.enumerated())!
//                {
//                    onwardTravelCardArr.append(element.number ?? "")
//                }
//            }
//
//            //返程
//            if passengerNew?.rtnTravelCards != nil && (passengerNew?.rtnTravelCards?.count)! >= 2
//            {
//                for (_, element) in (passengerNew?.depTravelCards.enumerated())!
//                {
//                    backwardTravelCardArr.append(element.number ?? "")
//                }
//            }
//        }else
//        {
//            passengerOld = passenger as? CoOldFlightForm.Create.Passenger
//
//            //去程
//            if passengerOld?.depTravelCards != nil && (passengerOld?.depTravelCards.count)! >= 1
//            {
//                for (_, element) in (passengerOld?.depTravelCards.enumerated())!
//                {
//                    onwardTravelCardArr.append(element.number)
//                }
//            }
//
//            //返程
//            if passengerOld?.rtnTravelCards != nil && (passengerOld?.rtnTravelCards?.count)! >= 2
//            {
//                for (_, element) in (passengerOld?.depTravelCards.enumerated())!
//                {
//                    backwardTravelCardArr.append(element.number)
//                }
//            }
//        }
//
//        //去程 中转
//        if onwardTravelCardArr.count >= 2
//        {
//            onwardTitleInfo[2].content = onwardTravelCardArr.first!
//            onwardTitleInfo[3].content = onwardTravelCardArr[1]
//
//        }else if onwardTravelCardArr.count == 1
//        {
//            onwardTitleInfo[1].content = onwardTravelCardArr.first!
//
//        }
//
//        //返程 中转
//        if backwardTravelCardArr.count >= 2
//        {
//            backwardTitleInfo[2].content = backwardTravelCardArr.first!
//            backwardTitleInfo[3].content = backwardTravelCardArr[1]
//
//        }else if backwardTravelCardArr.count == 1
//        {
//            backwardTitleInfo[1].content = backwardTravelCardArr.first!
//
//        }
        
        
        
        
        
        // end of line
        
        
        
        tableViewDataSource = [personalTitleInfo]//,onwardTitleInfo,backwardTitleInfo
        
    }
    
    
    func clearLocationDataSources() {
        identificationSelectedIndex = 100 //默认值
        
    }
    
    
    
    func setNavigationController (){
        setBlackTitleAndNavigationColor(title: "修改旅客信息")
        self.view.backgroundColor = TBIThemeBaseColor
   
    }
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func okayButtonAction()  {
        self.view.endEditing(true)
        print(tableViewDataSource)
        printDebugLog(message: "okayButtonAction ...")
        let userInfo = UserService.sharedInstance.userDetail()
//        var onwardArrOld:[CoOldFlightForm.Create.Passenger.Card] = Array()
//        var backwardArrOld:[CoOldFlightForm.Create.Passenger.Card] = Array()
//        var onwardArrNew:[CoNewFlightForm.Create.Passenger.Card] = Array()
//        var backwardArrNew:[CoNewFlightForm.Create.Passenger.Card] = Array()
        
        // 证件类型
        var identification:LoginResponse.UserBaseCertInfo = LoginResponse.UserBaseCertInfo()
        if identificationSelectedIndex <= (travellerSVModel.certInfos.count) - 1
        {
            //let identify:String = travellerModel?.certificates[identificationSelectedIndex].name
            
            identification = (travellerSVModel.certInfos[identificationSelectedIndex])
        }
        else if identificationSelectedIndex != 100 //手动输入
        {
            identification.certType = "1"
            identification.certNo = (tableViewDataSource.first?[1].content)!
            
            
        }else if identificationSelectedIndex == 100
        {
            identification.certType = "1"//tableViewDataSource.first
            identification.certNo = (tableViewDataSource.first?[1].content.components(separatedBy: "(").last?.components(separatedBy: ")").first)!
        }
        print(tableViewDataSource.first?[2].content)
        flightModifyPersonBlockResult(identification,tableViewDataSource.first?[2].content ?? " ")
        
        
        
       //现在信息不全 暂时 将信息 不做处理
//        //获取会员卡信息
//        //去程直达
//        if onwardDirect == 1 {
//
//            let tmpCard = tableViewDataSource[1][1].content
//            for element in (travellerModel?.travelCards)!
//            {
//
//                if userInfo?.companyUser?.newVersion == true && tmpCard == element.number
//                {
//                        var selectedCard =  CoNewFlightForm.Create.Passenger.Card()
//                        selectedCard.number = element.number
//                        selectedCard.supplier = element.supplierCode
//                        onwardArrNew.append(selectedCard)
//                        break
//
//
//
//                }else if (tmpCard == element.number)
//                {
//                        var selectedCard =  CoOldFlightForm.Create.Passenger.Card()
//                        selectedCard.number = element.number
//                        selectedCard.supplier = element.supplierCode
//                        onwardArrOld.append(selectedCard)
//                        break
//                }
//
//
//            }
//        }else //去程中转 or 去程不存在
//        {
//            let tmpCarFirst = tableViewDataSource[1][2].content
//            let tmpCarSecond = tableViewDataSource[1][3].content
//            for element in (travellerModel?.travelCards)!
//            {
//                // 新老板 第一张卡
//                if userInfo?.companyUser?.newVersion == true && tmpCarFirst == element.number
//                {
//                        var selectedCard =  CoNewFlightForm.Create.Passenger.Card()
//                        selectedCard.number = element.number
//                        selectedCard.supplier = element.supplierCode
//                        onwardArrNew.append(selectedCard)
//                        break
//
//                }else if (tmpCarFirst == element.number)
//                {
//                        var selectedCard =  CoOldFlightForm.Create.Passenger.Card()
//                        selectedCard.number = element.number
//                        selectedCard.supplier = element.supplierCode
//                        onwardArrOld.append(selectedCard)
//                        break
//                }
//            }
//
//
//
//            // 新老板 第二张卡
//            for element in (travellerModel?.travelCards)!
//            {
//
//                if userInfo?.companyUser?.newVersion == true && tmpCarSecond == element.number
//                {
//                        var selectedCard =  CoNewFlightForm.Create.Passenger.Card()
//                        selectedCard.number = element.number
//                        selectedCard.supplier = element.supplierCode
//                        onwardArrNew.append(selectedCard)
//                        break
//                }else if (tmpCarSecond == element.number)
//                {
//                        var selectedCard =  CoOldFlightForm.Create.Passenger.Card()
//                        selectedCard.number = element.number
//                        selectedCard.supplier = element.supplierCode
//                        onwardArrOld.append(selectedCard)
//                        break
//                }
//            }
//        }
//
//        //返程 直达 获取 返程信息
//        if backwardDirect == 1 {
//            let tmpCard = tableViewDataSource[2][1].content
//            for element in (travellerModel?.travelCards)!
//            {
//
//                if userInfo?.companyUser?.newVersion == true && tmpCard == element.number
//                {
//                    var selectedCard =  CoNewFlightForm.Create.Passenger.Card()
//                    selectedCard.number = element.number
//                    selectedCard.supplier = element.supplierCode
//                    //onwardArrNew.append(selectedCard)
//                    backwardArrNew.append(selectedCard)
//                    break
//
//                }else if (tmpCard == element.number)
//                {
//                        var selectedCard =  CoOldFlightForm.Create.Passenger.Card()
//                        selectedCard.number = element.number
//                        selectedCard.supplier = element.supplierCode
//                        //onwardArrOld.append(selectedCard)
//                        backwardArrOld.append(selectedCard)
//                        break
//                }
//            }
//        }else if (backwardDirect == 2) // 返程常旅客卡 返程 中转
//        {
//            let tmpCarFirst = tableViewDataSource[2][2].content
//            let tmpCarSecond = tableViewDataSource[2][3].content
//            //返程  第一张卡
//            for element in (travellerModel?.travelCards)!
//            {
//                //返程 第一张卡 新版
//                if userInfo?.companyUser?.newVersion == true && tmpCarFirst == element.number
//                {
//                        var selectedCard =  CoNewFlightForm.Create.Passenger.Card()
//                        selectedCard.number = element.number
//                        selectedCard.supplier = element.supplierCode
//                        //onwardArrNew.append(selectedCard)
//                        backwardArrNew.append(selectedCard)
//                        break
//                }else if (tmpCarFirst == element.number)  //返程 第一张卡 老版
//                {
//                        var selectedCard =  CoOldFlightForm.Create.Passenger.Card()
//                        selectedCard.number = element.number
//                        selectedCard.supplier = element.supplierCode
//                        //onwardArrOld.append(selectedCard)
//                        backwardArrOld.append(selectedCard)
//                        break
//                }
//            }
//            //返程 第二张卡
//            for element in (travellerModel?.travelCards)!
//            {
//                //返程 第二张卡 新版
//                if userInfo?.companyUser?.newVersion == true && tmpCarSecond == element.number
//                {
//                        var selectedCard =  CoNewFlightForm.Create.Passenger.Card()
//                        selectedCard.number = element.number
//                        selectedCard.supplier = element.supplierCode
//                        //onwardArrNew.append(selectedCard)
//                        backwardArrNew.append(selectedCard)
//                        break
//                }
//                else  if (tmpCarSecond == element.number)  //返程 第二张卡 老版
//                {
//                        var selectedCard =  CoOldFlightForm.Create.Passenger.Card()
//                        selectedCard.number = element.number
//                        selectedCard.supplier = element.supplierCode
//                        //onwardArrOld.append(selectedCard)
//                        backwardArrOld.append(selectedCard)
//                        break
//                }
//            }
//        }
//
//        // 证件类型
//        var identification:Traveller.Certificate = Traveller.Certificate()
//        if travellerModel?.certificates != nil && identificationSelectedIndex <= (travellerModel?.certificates.count)! - 1
//        {
//            //let identify:String = travellerModel?.certificates[identificationSelectedIndex].name
//
//            identification = (travellerModel?.certificates[identificationSelectedIndex])!
//        }
//        else if identificationSelectedIndex != 100 //手动输入
//        {
//            identification.name = "身份证"
//            identification.type = 1
//            identification.number = (tableViewDataSource.first?[2].content)!
//
//
//        }else if identificationSelectedIndex == 100
//        {
//
//            identification.name = "身份证"
//            identification.type = 1
//            identification.number = (tableViewDataSource.first?[1].content.components(separatedBy: "(").last?.components(separatedBy: ")").first)!
//        }

//        // 往返
//        if searchModel.type == 2 {
//            // 往返 新版
//            if userInfo?.companyUser?.newVersion == true {
//                let passenger = CoNewFlightForm.Create.Passenger.init(uid:(travellerModel?.uid)! , mobile:(tableViewDataSource.first?[3].content)! , birthday: (travellerModel?.birthday)!, gender:CoNewFlightForm.Create.Passenger.Gender(rawValue: "M")!, depInsurance: false, rtnInsurance: false, depTravelCards:onwardArrNew , certNo:identification.number , certType:CertType(rawValue:identification.type!)!,rtnTravelCards:backwardArrNew)
//
//                //
//                print("往返",passenger)
//                flightModifyPersonBlockResult(passenger)
//
//            }else // 往返 老版
//            {
//             let passenger = CoOldFlightForm.Create.Passenger.init(uid:(travellerModel?.uid)! , mobile:(tableViewDataSource.first?[3].content)! , birthday: (travellerModel?.birthday)!, gender:CoOldFlightForm.Create.Passenger.Gender(rawValue: "M")!, depInsurance: false, rtnInsurance: false, depTravelCards:onwardArrOld , certNo:identification.number , certType:CertType(rawValue:identification.type!)!,rtnTravelCards:backwardArrOld)
//            print("往返",passenger)
//            flightModifyPersonBlockResult(passenger)
//            }
//        }else
//        {
//            // 单程 新版
//            if userInfo?.companyUser?.newVersion == true
//            {
//                let passenger = CoNewFlightForm.Create.Passenger.init(uid:(travellerModel?.uid)! , mobile:(tableViewDataSource.first?[3].content)! , birthday: (travellerModel?.birthday)!, gender:CoNewFlightForm.Create.Passenger.Gender(rawValue: "M")!, depInsurance: false, rtnInsurance: false, depTravelCards:onwardArrNew , certNo:identification.number , certType:CertType(rawValue:identification.type!)!)
//
//                print("单程",passenger)
//                flightModifyPersonBlockResult(passenger)
//            }else // 单程 老版
//            {
//                let passenger = CoOldFlightForm.Create.Passenger.init(uid:(travellerModel?.uid)! , mobile:(tableViewDataSource.first?[3].content)! , birthday: (travellerModel?.birthday)!, gender:CoOldFlightForm.Create.Passenger.Gender(rawValue: "M")!, depInsurance: false, rtnInsurance: false, depTravelCards:onwardArrOld , certNo:identification.number , certType:CertType(rawValue:identification.type!)!)
//
//                print("单程",passenger)
//                flightModifyPersonBlockResult(passenger)
//            }
//        }
       self.navigationController?.popViewController(animated: true)
        
        
    }
    
    func choicesDataSources(cellIndex:IndexPath,title:String,content:String) {
        
        
        var fullTitle = title
        if cellIndex.section == 1  && title != "去程" {
                fullTitle = "去程"
        }
        if cellIndex.section == 2  && title != "返程" {
            fullTitle = "返程"
        }
        if title == "第一段" || title == "第二段" {
            fullTitle += title
        }
        
        let value = FlightModifyPersonType(rawValue: fullTitle) ?? .UNKNOW
        switch value {
        case FlightModifyPersonType.ID:
            showPickView(dataSources: identificationDataSources,tarFontSize:UIFont.systemFont(ofSize: 16))
        case FlightModifyPersonType.PHONE:
            print("手机号码",content)
        case FlightModifyPersonType.ONWARD,.ONWARDFirst,.ONWARDSecond,.BACKWARD,.BACKWARDFirst,.BACKWARDSecond:
            showPickView(dataSources: memberCardDataSources)
        default:
            break
        }
    }
    
    
    func showPickView(dataSources:[String],tarFontSize:UIFont = UIFont.systemFont(ofSize: 18)) {
        
        var dataSourcesCopy:[String] = Array()
        
        if dataSources.count == 0
        {
           dataSourcesCopy.append("无")
        }else
        {
            dataSourcesCopy = dataSources
        }
        
        weak var weakSelf = self
        let finderView = TBIFinderView.init(frame: ScreenWindowFrame)
        finderView.textAlignment = TBIFinderViewTextAlignment.left
//        finderView.textAlignment = fillDataSources
        finderView.fontSize = UIFont.systemFont(ofSize: 16)
        finderView.finderViewSelectedResultBlock = { (cellIndex) in
            
            var content:String = "无"
            if cellIndex < dataSources.count
            {
                content = dataSources[cellIndex]
                print(dataSources[cellIndex])
            }
           
            weakSelf?.getPickViewDataSource(selectedIndex:cellIndex,selectedContent:content)
        }
        KeyWindow?.addSubview(finderView)
        finderView.reloadDataSources(titledataSources: dataSourcesCopy, flageImage: nil)

    }
    
    func getPickViewDataSource(selectedIndex:NSInteger,selectedContent:String) {
        
        //section 0
        if selectedeIndexPath.section == 0
        {
            //手动
            if selectedContent == manualStr
            {
                manual = 0
            }else  // 自动
            {
                manual = 1
            }
                identificationSelectedIndex = selectedIndex
                self.tableViewDataSource[selectedeIndexPath.section][1].content = selectedContent
                self.tableView.reloadData()
        }
//        //去程
//        if selectedeIndexPath.section == 1 {
//
//            if onwardDirect == 1 && backwardDirect == 1 {
//                //去程
//                if selectedeIndexPath.row == 1 {
//                    self.tableViewDataSource[selectedeIndexPath.section][1].content = selectedContent
//                }else
//                {
//                    self.tableViewDataSource[selectedeIndexPath.section + backwardDirect][1].content = selectedContent
//                }
//
//
//            }else
//            {
//
//                if onwardDirect == 2 && backwardDirect == 2 {
//
//                    self.tableViewDataSource[selectedeIndexPath.section][selectedeIndexPath.row + 1].content = selectedContent
//
//                }else
//                {
//                    if onwardDirect == 1 {
//                        self.tableViewDataSource[selectedeIndexPath.section][1].content = selectedContent
//                    }else
//                    {
//                        self.tableViewDataSource[selectedeIndexPath.section][selectedeIndexPath.row + 1].content = selectedContent
//                    }
//                }
//
//
//
//            }
//
//        }
//        // 返程
//        if selectedeIndexPath.section == 2
//        {
//
//            if onwardDirect == 2 && backwardDirect == 2 {
//
//                self.tableViewDataSource[selectedeIndexPath.section][selectedeIndexPath.row + 1].content = selectedContent
//
//            }else
//            {
//                if backwardDirect == 1 {
//                    self.tableViewDataSource[selectedeIndexPath.section][1].content = selectedContent
//                }else
//                {
//                    self.tableViewDataSource[selectedeIndexPath.section][selectedeIndexPath.row + 1].content = selectedContent
//                }
//            }
//
//
//        }
        self.tableView.reloadData()
    }
    
    
    func getCellDataSources(selectedIndex:IndexPath,title:String,content:String) {
        
        self.tableViewDataSource[selectedIndex.section][selectedIndex.row].content = content
        self.tableView.reloadData()
    }
    
    
    
    

}
extension FlightModifyPersonController: UITableViewDelegate,UITableViewDataSource{
    
    
    func initTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.register(FlightModifyTravellerTableViewCell.classForCoder(), forCellReuseIdentifier:flightModifyTravellerTableViewCellIdentify)
        
        
        
        let footerView = UIView.init(frame: CGRect(x:0,y:0,width:ScreenWindowWidth,height:72))
        tableView.tableFooterView = footerView
        okayButton.setTitle("确定", for: UIControlState.normal)
        okayButton.backgroundColor = TBIThemeDarkBlueColor
        okayButton.layer.cornerRadius = 4
        okayButton.addTarget(self, action: #selector(okayButtonAction), for: UIControlEvents.touchUpInside)
        
        footerView.addSubview(okayButton)
        okayButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(30)
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            
        }
        
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    //MARK:- UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
    
        return 1
//        if ((onwardDirect == 1 && (backwardDirect == 0 || backwardDirect == 1))||(onwardDirect == 2 && backwardDirect == 0))
//        {
//            return 2
//        }
//
//
//        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4 - manual
        
//        if onwardDirect == 1 && (backwardDirect == 0 || backwardDirect == 1) && section == 1{
//            return 2 + backwardDirect
//        }
//        if onwardDirect == 1 && backwardDirect == 2{
//
//            if section == 1 {
//                return 2
//            }
//            return 3
//        }
//        if onwardDirect == 2 && backwardDirect == 1 {
//            if section == 1 {
//                return 3
//            }
//            return 2
//        }
//        if onwardDirect == 2 && backwardDirect == 2 {
//            if manual == 0 && section == 0
//            {
//                return 4
//            }
//            return 3
//        }
//        return tableViewDataSource[section].count - manual
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section !=  0 {
//            return   10
//        }
//        return   0
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        if  section != 0  {
//            let headerView = UIView.init(frame: CGRect(x:0,y:0,width:ScreenWindowWidth,height:10))
//            headerView.backgroundColor = TBIThemeBaseColor
//            return headerView
//        }
//        return nil
//    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FlightModifyTravellerTableViewCell = tableView.dequeueReusableCell(withIdentifier: flightModifyTravellerTableViewCellIdentify) as! FlightModifyTravellerTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        weak var weakself = self
        cell.flightModifyTravellerCellBlock = { (cellIndex,title,content) in
            
            //weakself?.choicesDataSources(cellIndex: cellIndex, title: title,content:content)
            print(" cell 回调 controller show time " + content)
            weakself?.getCellDataSources(selectedIndex: cellIndex, title: title, content: content)
            
        }
        
        
        if tableViewDataSource.count > indexPath.section && tableViewDataSource[indexPath.section].count > indexPath.row {
            cellConfig(cell: cell, indexPath: indexPath)
        }
        return   cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell:FlightModifyTravellerTableViewCell = tableView.cellForRow(at: indexPath) as! FlightModifyTravellerTableViewCell
        self.view.endEditing(true)
        selectedeIndexPath = indexPath
        
        if (indexPath.section == 1 && indexPath.row == 0 ) || (indexPath.section == 2 && indexPath.row == 0) {
            return
        }
        choicesDataSources(cellIndex: indexPath, title: cell.categoryTitleLabel.text!, content: "")
    }
    
    
    
    func cellConfig(cell:FlightModifyTravellerTableViewCell,indexPath:IndexPath) {
        
        if indexPath.section == 0 {
            var rowIndex = indexPath.row
            var intoNextBool = false
            var enable:Bool = false
            var showLine:Bool = true
            var content = ""
            var contenPlaceHolder = "选择证件"
//            if rowIndex == 2  || rowIndex == 3{
//                rowIndex += manual
//                enable = true
//                contenPlaceHolder = "请输入手机号码"
//            }
            
            //设置手机号       自动状态下
            if (rowIndex  == 2 && manual == 1)//|| (rowIndex == 3 && manual == 0)
            {
               // rowIndex += manual
                enable = true
                showLine = false
                contenPlaceHolder = "请输入手机号码"
                
            }
            //手动输入身份证号码    手动情况下
            if rowIndex == 2 && manual == 0
            {
                enable = true
            }

            if tableViewDataSource[indexPath.section][rowIndex].content.isEmpty == false {
                content = tableViewDataSource[indexPath.section][rowIndex].content
                contenPlaceHolder = ""
            }
            if indexPath.row == 1 {
                intoNextBool = true
            }
            
            cell.fillDataSource(title:tableViewDataSource[indexPath.section][rowIndex].title , contentPlaceHolder:contenPlaceHolder , content: content, contentEnable: enable, intoNextEnable: intoNextBool ,cellIndex: indexPath, showLine: showLine)
            return
        }
//        if onwardDirect == 1 && (backwardDirect == 1 || backwardDirect == 0) {
//
//            var intoNextBool = true
//            var title = ""
//            var content = ""
//            var showLine:Bool = true
//            var contenPlaceHolder:String = ""
//            if indexPath.row == 0 {
//                intoNextBool = false
//                title = "常旅客卡"
//            }
//
//            if indexPath.row == 0 {
//                contenPlaceHolder = ""
//            }
//
//            if backwardDirect != 1 && onwardDirect == 1 && indexPath.row == 1 {
//                showLine = false
//            }
//
//
//            if indexPath.row == 1 {
//                title = tableViewDataSource[indexPath.section][indexPath.row].title
//                content = tableViewDataSource[indexPath.section][indexPath.row].content
//                contenPlaceHolder = "请选择去程"
//
//            }
//            if indexPath.row == 2 {
//                title = tableViewDataSource[indexPath.section + backwardDirect ][indexPath.row - backwardDirect].title
//                content = tableViewDataSource[indexPath.section + backwardDirect][indexPath.row - backwardDirect].content
//                contenPlaceHolder = "请选择返程"
//                showLine = false
//            }
//
//
//            cell.fillDataSource(title:title, contentPlaceHolder:contenPlaceHolder , content: content, contentEnable: false, intoNextEnable: intoNextBool ,cellIndex: indexPath, showLine:showLine)
//            return
//        }
//        if onwardDirect == 2 && (backwardDirect == 1 || backwardDirect == 0) {
//
//            var rowIndex = indexPath.row
//            var intoNextBool = true
//            var showLine:Bool = true
//            var content = ""
//            var contenPlaceHolder = ""
//
//            if rowIndex != 0 && indexPath.section == 1 {
//                rowIndex += onwardJumpRow
//            }
//            if tableViewDataSource[indexPath.section][rowIndex].content.isEmpty == false {
//                content = tableViewDataSource[indexPath.section][rowIndex].content
//                contenPlaceHolder = ""
//            }
//            if indexPath.row == 0 {
//                intoNextBool = false
//                contenPlaceHolder = ""
//                content = ""
//            }
//            if indexPath.section == 1  && (indexPath.row == 1 || indexPath.row == 2) {
//                contenPlaceHolder = "请选择去程"
//            }
//
//            if indexPath.section == 2  && (indexPath.row == 1 || indexPath.row == 2) {
//                contenPlaceHolder = "请选择返程"
//            }
//
//
//
//            if  indexPath.row == 2  || (indexPath.section == 2 && indexPath.row == 1) {
//                showLine = false
//            }
//
//
//
//
//            cell.fillDataSource(title:tableViewDataSource[indexPath.section][rowIndex].title , contentPlaceHolder:contenPlaceHolder , content: content, contentEnable: false, intoNextEnable: intoNextBool ,cellIndex: indexPath, showLine: showLine)
//            return
//        }
//
        
//
//        if onwardDirect == 2 && backwardDirect == 2
//        {
//
//            var rowIndex = indexPath.row
//            var intoNextBool = true
//            let enable:Bool = false
//            var showLine:Bool = true
//            var content = ""
//            var contenPlaceHolder = "请选择"
//
//            if rowIndex != 0 {
//                rowIndex += onwardJumpRow
//            }
//            if tableViewDataSource[indexPath.section][rowIndex].content.isEmpty == false {
//                content = tableViewDataSource[indexPath.section][rowIndex].content
//                contenPlaceHolder = ""
//            }
//            if indexPath.row == 0 {
//                intoNextBool = false
//                contenPlaceHolder = ""
//                content = ""
//            }
//            if indexPath.row == 2 {
//                showLine = false
//            }
//
//
//            if indexPath.section == 1  && (indexPath.row == 1 || indexPath.row == 2) {
//                contenPlaceHolder = "请选择去程"
//            }
//
//            if indexPath.section == 2  && (indexPath.row == 1 || indexPath.row == 2) {
//                contenPlaceHolder = "请选择返程"
//            }
//
//
//            cell.fillDataSource(title:tableViewDataSource[indexPath.section][rowIndex].title , contentPlaceHolder:contenPlaceHolder , content: content, contentEnable: enable, intoNextEnable: intoNextBool ,cellIndex: indexPath, showLine: showLine)
//
//        }
//
//        if onwardDirect == 1 && backwardDirect == 2
//        {
//            var showLine:Bool = true
//            var contenPlaceHolder = ""
//
//            if indexPath.section == 1
//            {
//                if indexPath.row == 1 {
//                    showLine = false
//                    contenPlaceHolder = "请选择去程"
//                }
//
//
//                 cell.fillDataSource(title:tableViewDataSource[indexPath.section][indexPath.row].title , contentPlaceHolder:contenPlaceHolder , content: tableViewDataSource[indexPath.section][indexPath.row].content, contentEnable: false, intoNextEnable: true ,cellIndex: indexPath, showLine: showLine)
//            }
//            if indexPath.section == 2
//            {
//                if indexPath.row == 0
//                {
//                    cell.fillDataSource(title:tableViewDataSource[indexPath.section][indexPath.row].title , contentPlaceHolder:tableViewDataSource[indexPath.section][indexPath.row].content , content: "", contentEnable: false, intoNextEnable: false ,cellIndex: indexPath, showLine: true)
//                }else
//                {
//                    if indexPath.row == 2 {
//                        showLine = false
//                    }
//                    contenPlaceHolder = "请选择返程"
//                    cell.fillDataSource(title:tableViewDataSource[indexPath.section][indexPath.row + 1].title , contentPlaceHolder:contenPlaceHolder , content: tableViewDataSource[indexPath.section][indexPath.row + 1].content, contentEnable: false, intoNextEnable: true ,cellIndex: indexPath, showLine: showLine)
//                }
//            }
//        }
//        if onwardDirect == 2 && backwardDirect == 1
//        {
//            var showLine:Bool = true
//            var contenPlaceHolder = ""
//
//            if indexPath.section == 1
//            {
//                if indexPath.row == 0
//                {
//                    cell.fillDataSource(title:tableViewDataSource[indexPath.section][indexPath.row].title , contentPlaceHolder:tableViewDataSource[indexPath.section][indexPath.row].content , content: "", contentEnable: false, intoNextEnable: false ,cellIndex: indexPath, showLine: showLine)
//                }else
//                {
//                    if  indexPath.row == 2 {
//                        showLine = false
//                    }
//                    contenPlaceHolder = "请选择去程"
//                    cell.fillDataSource(title:tableViewDataSource[indexPath.section][indexPath.row + 1].title , contentPlaceHolder:contenPlaceHolder, content: tableViewDataSource[indexPath.section][indexPath.row + 1].content, contentEnable: false, intoNextEnable: true ,cellIndex: indexPath, showLine: showLine)
//                }
//            }
//            else
//            {
//                if indexPath.row == 1 {
//                    showLine = false
//                    contenPlaceHolder = "请选择返程"
//                }
//                 cell.fillDataSource(title:tableViewDataSource[indexPath.section][indexPath.row].title , contentPlaceHolder:contenPlaceHolder , content: tableViewDataSource[indexPath.section][indexPath.row].content, contentEnable: false, intoNextEnable: true ,cellIndex: indexPath, showLine: showLine)
//            }
//        }
    }
    
    
    


}
