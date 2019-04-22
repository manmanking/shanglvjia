
//
//  ReserveRoomViewController.swift
//  shop
//
//  Created by manman on 2017/4/22.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift


class ReserveCompanyRoomViewController: CompanyBaseViewController,UITableViewDelegate,UITableViewDataSource{

    //订单跳转 本页面标志
    public var travelNo:String = ""
    // 企业差标
    public var accordTravel:Float = 0
//    public var hotelRoomDetail:HotelDetail.HotelRoom = HotelDetail.HotelRoom()
    
    
    public var hotelSVDetail:HotelDetailResult.HotelDetailInfo = HotelDetailResult.HotelDetailInfo()
    
    public var searchSVCondition:HotelListRequest = HotelListRequest()
    
    public var roomSelected:HotelDetailResult.HotelRoomPlan = HotelDetailResult.HotelRoomPlan()
    
    public var hotelDetailForm:HotelDetailForm = HotelDetailForm()
    public var searchCondition:HotelSearchForm = HotelSearchForm()
    public var roomModel:RoomModel = RoomModel()
    private let personRoomPlaceHolder:String = "新增入住人"
    private let reserveRoomTableViewHeaderViewIdentify = "reserveRoomTableViewHeaderViewIdentify"
    private let reserveRoomTableViewCellIdentify = "reserveRoomTableViewCellIdentify"
    private let reserveCompanyRoomTableViewCellIdentify = "ReserveCompanyRoomTableViewCellIdentify"
    private let reserveRoomTableViewCellViewIdentify = "ReserveRoomTableViewCellViewIdentify"
    //违背cell
    fileprivate let trainContraryOrderTableCellIdentify = "trainContraryOrderTableCellIdentify"
    
    //订单备注
    fileprivate let addRemarkCellIdentify = "AddRemarkCell"
    
    private let reserveRoomViewCategoryRoom:String = "房间数量"
    private let reserveRoomViewCategoryTime:String = "最晚到店时间"
    private let reserveRoomViewCategoryRequire:String = "特殊要求"
    private let reserveRoomViewCategoryDispolicyReason:String = "违背原因"
    private let reserveRoomViewCategoryCheckinDate:String = "起始时间"
    private let reserveRoomViewCategoryCheckoutDate:String = "返程时间"
    private let reserveRoomViewCategoryBusinseeTripPurpose:String = "出差目的"
    private let reserveRoomViewCategoryBusinseeCostCenter:String = "成本中心"
    private let reserveRoomViewCategoryBusinseeRemarks:String = "备注说明"
    private var reserveRoomViewCategoryBusinseeRemarkPlaceHolderTip:String = "请添加订单备注"
    private var reserveRoomViewCategoryRequireOfBedType = ""
    private var reserveRoomViewCategoryRequireOfSpecial = ""
    private var tableView = UITableView()
    private var tableViewDataSourcesArr:[[(title:String,content:String)]] = NSArray() as! [[(title:String,content:String)]]
    
    private var companyCustomConfig: HotelOrderInfo.CompanyCustomConfig?
    
    private var companyCustomSVConfig:LoginResponse.UserBaseTravelConfig?
    
    private var selectedCustomRequire:[UIButton] = Array()
    //底部 控件
    private var bottomBackgroundView = UIView()
    private var amountTitleLabel = UILabel()
    private var amountLabel = UILabel()
    private var amountTitleButton = UIButton()
    
    // 等待分配的员工
    private var remainderPersonArr:[Traveller] = Array()
    private var remainderPersonSVArr:[QueryPassagerResponse] = Array()
    
    private var remainderPersonView:ReserveRoomChoiceStaffView = ReserveRoomChoiceStaffView()
    
    //正在操作的 行 单元
    private var operationCellIndex:IndexPath = IndexPath()
    
    //是否存在担保 政策  0 无需担保。 1需要担保
    private var sectionGuaranteePolicyNum:NSInteger = 1
     //差旅政策 是否 违规  0 正常。1 违规
    private var sectionViolateTravellerPolicyNum:NSInteger = 1
    //新老版 判断 字段 0 老版 1 新版
    private var userVersion:NSInteger = 0
    
    //是否填写 出差单 0 需要显示出差单 1 不需要出差单
    private var showBuseinessSection:NSInteger = 1
    
    //是否填写 备注  0 不需要显示 备注说明 1 需要显示备注说明
    private var showRemarkSection:NSInteger = 0
    
    //订单备注
    fileprivate var remarkSection:Int = 0
     fileprivate var orderRemark = Variable("")
    ///手动输入违背原因
    fileprivate var disReason:String = ""
    
    //丰田特殊配置  出差信息中  出差地点 是否显示  0 需要显示   1 不需要显示
    private var showFTMSSpecialConfig:NSInteger = 0
    
    
    //丰田特殊配置  出差信息  是否显示  0 需要显示   1 不需要显示
    private var showFTMSSpecialConfigVerisonSecond:NSInteger = 0
    
    
    
    //headerView 现在要正常显示为一个cell 视图  0 显示为headerView   1 显示为 cellView
    //headerView 单独显示为一个 section 0
    private var showHeaderViewSpecialConfig:NSInteger = 0
    
    
    //担保政策描述
    private var guaranteeDescription:String?
    
    //房间数量
    private var selectedRoomSum:NSInteger = 1
    
    private var selectedRoomCapacity:NSInteger = 2
    
    
    private var selectedRoomNightNum:NSInteger = 1
    
    
    private var selectedRoomTotalPrice:Float = 0
    
    //最晚到店时间
    private var selectedEndTime:String = "18:00"
    
    ///联系人选择
    fileprivate var contactPeopleDataSources:[String] = Array()

    //private let sectionGuaranteePolicy:Array = ["担保政策"]
    //入住人 存储位置  var costCenterId:       String = ""
    /// 成本中心名称
    var costCenterName:     String = ""
    private var sectionfirstPersoner:[(title1:String,content1:String,uid1:String,apvRuleId1:String,travelPolicyId1:String,costCenterId1:String,costCenterName1:String,
        title2:String,content2:String,uid2:String,apvRuleId2:String,travelPolicyId2:String,costCenterId2:String,costCenterName2:String)] = [("新增入住人","","","","","","","新增入住人","","","","","","")]
    // 这个替换上面 入住人的信息 更换数据结构
    private var sectionfirstSVPersoner:[(personerOne:HotelRoomPersonerModel,personerTwo:HotelRoomPersonerModel)] = Array()
    //
    //计算多少个房间
    private var sectionfirst:[(title:String,content:String)] = [("房间数量",""),("新增入住人","")]
    private var sectionSecond:[(title:String,content:String)] = [("特殊要求",""),("最晚到店时间","")]
    private var sectionThird:[(title:String,content:String)] = [("联系人",""),("电话号码",""),("邮箱","")]
    private var sectionPolicy:[(title:String,content:String)] = [("违背政策",""),("违背原因","")]
    private var sectionForth:[(title:String,content:String)] = [("出差信息",""),("起始时间",""),("返程时间",""),("出差地点",""),("出差目的",""),("出差事由","")]
    private var sectionFifth:[(title:String,content:String)] = [("成本中心","")]
    private var sectionSixth:[(title:String,content:String)] = [("备注说明","")]
    
    private let pickViewRoomDataSourcesArr:[String] = ["1间","2间","3间","4间","5间","6间","7间","8间","9间","10间"]
    //"01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00",
    private let pickViewTimeDataSourcesArr:[String] = ["14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00","24:00"]
    private var travelPurposesDataSources:[String] = Array()
    
    private var dispolicyReasonDataSources:[String] = Array()
    
    private var pickerRoomNumView:TBIPickerView = TBIPickerView()
    private let bag = DisposeBag()
    
    /// 用户信息
    fileprivate var userSVDetail:LoginResponse = LoginResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //setTitle(titleStr: )
        //setNavigationBackButton(backImage: self.title!)
        setBlackTitleAndNavigationColor(title:self.title! )
        self.view.backgroundColor = TBIThemeBaseColor
        showHeaderViewSpecialConfig = 1
        setUIViewAutolayout()
        setBottomView()
        singlePersonSingleRoom()
        //companyConfig()
        // 联系人 默认信息
        //newLocalData()
        fillLocalDataSources()
    }
    
    func fillLocalDataSources() {
        
        userSVDetail = DBManager.shareInstance.userDetailDraw()!
        
        //联系人 默认 设置 为 账号本人 信息
        if DBManager.shareInstance.userDetailDraw() != nil && DBManager.shareInstance.userDetailDraw()!.busLoginInfo.userName.isEmpty == false  {
            if DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.name.isEmpty == false {
                sectionThird[0].content = (DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.name)!
            }
            if DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.mobiles.first != nil {
                sectionThird[1].content = (DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.mobiles.first)!
            }
            if DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.emails.first != nil {
                sectionThird[2].content = (DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.emails.first)!
            }
        }
        
        
        //是否违背差旅政策
        if roomSelected.ratePlanInfo.rate <= accordTravel {
            sectionViolateTravellerPolicyNum = 0
        }
        
        // 公司个性化 配置
        companyCustomSVConfig = DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.travelConfig
        
        filterTravelPurposesDataSources()
        
        selectedRoomNightNum = caculateIntervalDay(fromDate: Date.init(timeIntervalSince1970: TimeInterval(searchSVCondition.arrivalDate)! / 1000 ) , toDate: Date.init(timeIntervalSince1970: TimeInterval(searchSVCondition.departureDate)! / 1000))
        //新老版 北京
        userVersion = 1
        //true 新版
        //是否显示 出差信息section
        if companyCustomSVConfig?.hasTravel == "1" {
            showBuseinessSection = 0
        }else {
            showBuseinessSection = 1
        }
        tableViewDataSourcesArr = [sectionfirst ,sectionSecond,sectionThird,sectionPolicy,sectionForth,sectionFifth,sectionSixth]
        tableViewDataSourcesArr[1][1].content = selectedEndTime
        
        tableViewDataSourcesArr[4][3].content = searchSVCondition.cityName
        
        
        // 丰田销售定制化 需求 version Second
        // 替代 version first
        // add by manman  start of line
        
        if DBManager.shareInstance.userDetailDraw() != nil &&
            DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.corpCode.uppercased() == Toyota
        {
            showFTMSSpecialConfigVerisonSecond = 1 // 不需要显示 出差单信息
        }
        
        // 现在 由这个变量 间接控制 是否显示出差单信息  以后扩展 继续使用这个变量
        // 出差单信息 是否显示 只要处理 showBuseinessSection 变量即可 唯一入口
        if showFTMSSpecialConfigVerisonSecond == 1 {
            showBuseinessSection = 1
        }
        
        //订单备注
        remarkSection = 1
        
        filterDispolicyReasonDataSources()
        
        //end of line
        
        selectedRoomCapacity = NSInteger(roomSelected.capacity) ?? 2
        
        
        
        
        
        // 丰田销售 不显示 出差地点 require
        // 这个需求有变更 暂时保存实现  versionFirst
        //start of line
        //
        //        if UserService.sharedInstance.userDetail() != nil &&
        //            UserService.sharedInstance.userDetail()?.companyUser?.companyCode == Toyota
        //        {
        //            showFTMSSpecialConfig = 1
        ////            sectionForth.remove(at: 3)// 删除 出差地点
        //            tableViewDataSourcesArr[4].remove(at: 3)
        //        }
        //end of line
        
        
        
        
        
        
        
        
        
        
        self.view.addSubview(bottomBackgroundView)
        adjustTotalMoney()
        if adjustGuaranteeView() {
            guaranteeDescription = roomSelected.ratePlanInfo.guaranteeRuleInfo.gDescription
            setAmountTitleButton(state: AmountTitleButtonState.next)
        }else
        {
            sectionGuaranteePolicyNum = 0
            setAmountTitleButton(state: AmountTitleButtonState.done)
        }
        tableView.reloadData()
    }
    
    
    
    func newLocalData() {
        
        //联系人 默认 设置 为 账号本人 信息
        if UserService.sharedInstance.userDetail() != nil && UserService.sharedInstance.userDetail()?.companyUser != nil  {
            if UserService.sharedInstance.userDetail()?.companyUser?.name?.isEmpty == false {
                sectionThird[0].content = (UserService.sharedInstance.userDetail()?.companyUser?.name)!
            }
            if UserService.sharedInstance.userDetail()?.companyUser?.mobile != nil {
                sectionThird[1].content = (UserService.sharedInstance.userDetail()?.companyUser?.mobile)!
            }
            if UserService.sharedInstance.userDetail()?.companyUser?.emails.first != nil {
                sectionThird[2].content = (UserService.sharedInstance.userDetail()?.companyUser?.emails.first)!
            }
        }
        

        //是否违背差旅政策
        if roomModel.averageRate! <= accordTravel {
            sectionViolateTravellerPolicyNum = 0
        }
        
        //新老版 北京
        
        //true 新版
        if (UserService.sharedInstance.userDetail() != nil && ((UserService.sharedInstance.userDetail()?.companyUser?.newVersion) != nil)) && UserService.sharedInstance.userDetail()?.companyUser?.newVersion == true
        {
            userVersion = 1
        }else
        {
            userVersion = 0
        }
        
        //是否显示 出差信息section
        if travelNo.isEmpty {
            // 显示出差信息
            showBuseinessSection = 0
        }else
        {
            // 不需要显示 出差信息
            showBuseinessSection = 1
        }
        
        tableViewDataSourcesArr = [sectionfirst ,sectionSecond,sectionThird,sectionPolicy,sectionForth,sectionFifth,sectionSixth]
        tableViewDataSourcesArr[1][1].content = selectedEndTime
        
        tableViewDataSourcesArr[4][3].content = searchCondition.cityName
        
        
        // 丰田销售定制化 需求 version Second
        // 替代 version first 
        // add by manman  start of line
        
        if UserService.sharedInstance.userDetail() != nil &&
            UserService.sharedInstance.userDetail()?.companyUser?.companyCode == Toyota
        {
            showFTMSSpecialConfigVerisonSecond = 1 // 不需要显示 出差单信息
        }
        
        // 现在 由这个变量 间接控制 是否显示出差单信息  以后扩展 继续使用这个变量
        // 出差单信息 是否显示 只要处理 showBuseinessSection 变量即可 唯一入口
        if showFTMSSpecialConfigVerisonSecond == 1 {
            showBuseinessSection = 1
        }
        
        
        
        
        //end of line
        
        
        
        
        
        
        
        // 丰田销售 不显示 出差地点 require
        // 这个需求有变更 暂时保存实现  versionFirst
        //start of line
//        
//        if UserService.sharedInstance.userDetail() != nil &&
//            UserService.sharedInstance.userDetail()?.companyUser?.companyCode == Toyota
//        {
//            showFTMSSpecialConfig = 1
////            sectionForth.remove(at: 3)// 删除 出差地点
//            tableViewDataSourcesArr[4].remove(at: 3)
//        }
        //end of line
        
        
        
        
        
        
        
        
        
        
        self.view.addSubview(bottomBackgroundView)
        adjustTotalMoney()
        if adjustGuaranteeView() {
            //guaranteeDescription = roomModel.guaranteeRuleDescription
            setAmountTitleButton(state: AmountTitleButtonState.next)
        }else
        {
            //sectionGuaranteePolicyNum = 0
            setAmountTitleButton(state: AmountTitleButtonState.done)
        }
    }
    
    
    
    // true 需要担保  false 不需要担保
    func adjustGuaranteeView()-> Bool {
        if verifyGuaranteeNewRule()
        {
            sectionGuaranteePolicyNum = 1
            guaranteeDescription = roomSelected.ratePlanInfo.guaranteeRuleInfo.gDescription
            return true
        }else
        {
            sectionGuaranteePolicyNum = 0
            return false
        }
    }
    
    
    
    // true 需要担保  false 不需要担保
    
    func verifyGuaranteeNewRule() -> Bool {
        guard roomSelected.ratePlanInfo.isGuarantee == "1" else {
            return false
        }
        
        
        if roomSelected.ratePlanInfo.guaranteeRuleInfo.amountGuarantee == false && roomSelected.ratePlanInfo.guaranteeRuleInfo.timeGuarantee == false
        {
            return true
        }
        //房量担保
        if roomSelected.ratePlanInfo.guaranteeRuleInfo.amountGuarantee == true && roomSelected.ratePlanInfo.guaranteeRuleInfo.timeGuarantee == false
        {
            
            if (roomSelected.ratePlanInfo.guaranteeRuleInfo.amount) <= selectedRoomSum + 1  {
                return true
            }
        }
        //到店时间担保
        if roomSelected.ratePlanInfo.guaranteeRuleInfo.amountGuarantee == false && roomSelected.ratePlanInfo.guaranteeRuleInfo.timeGuarantee == true
        {
            return verifyGuaranteeTime(startTime:(roomSelected.ratePlanInfo.guaranteeRuleInfo.startTime) , verifyTime: selectedEndTime)
        }
        
        //房量担保 或者 到店时间担保
        if roomSelected.ratePlanInfo.guaranteeRuleInfo.amountGuarantee == true && roomSelected.ratePlanInfo.guaranteeRuleInfo.timeGuarantee == true {
            
            let amount:Bool =  (roomSelected.ratePlanInfo.guaranteeRuleInfo.amount) <= selectedRoomSum ? true :false
            let time:Bool = verifyGuaranteeTime(startTime:roomSelected.ratePlanInfo.guaranteeRuleInfo.startTime , verifyTime: selectedEndTime)
            if amount || time {
                return true
            }
        }
        return false
        
    }
    
    
    func verifyGuaranteeRule() -> Bool {
        if roomModel.amountGuarantee == false && roomModel.timeGuarantee == false
        {
            return true
        }
        //房量担保
        if roomModel.amountGuarantee == true && roomModel.timeGuarantee == false
        {
            
            if (roomModel.amount)! <= selectedRoomSum + 1  {
                return true
            }
        }
        //到店时间担保
        if roomModel.amountGuarantee == false && roomModel.timeGuarantee == true
        {
            return verifyGuaranteeTime(startTime:(roomModel.startTime)! , verifyTime: selectedEndTime)
            
        }
        
        //房量担保 或者 到店时间担保
        if roomModel.amountGuarantee == true && roomModel.timeGuarantee == true {
            
            let amount:Bool =  (roomModel.amount)! <= selectedRoomSum ? true :false
            let time:Bool = verifyGuaranteeTime(startTime:roomModel.startTime! , verifyTime: selectedEndTime)
            if amount || time {
                return true
            }
        }
        return false
        
    }

    //验证担保时间 true 需要担保  false 不需要担保
    func verifyGuaranteeTime(startTime:String,verifyTime:String) -> Bool {
        
        let verifyTimeArr:[String] = verifyTime.components(separatedBy: ":")
        let startTimeArr:[String] = startTime.components(separatedBy: ":")
        
        if Int(startTimeArr.first! )! < Int(verifyTimeArr.first!)!{
            return true
        }
        if  Int(startTimeArr.first! )! ==  Int(verifyTimeArr.first!)! && Int(startTimeArr.last! )! <=  Int(verifyTimeArr.last!)! {
            return true
        }
        return false
    }
    
    // 初步推荐 房间分配 单人单间
    func singlePersonSingleRoom() {
        //PassengerManager.shareInStance.passengerDraw().count //personalDataSourcesArr.count
        //TODO zww 10.10修改先让程序不崩溃
        if PassengerManager.shareInStance.passengerSVDraw().count ==  0 {
            return
        }
        selectedRoomSum = PassengerManager.shareInStance.passengerSVDraw().count
        //先设置第一个人 信息 case
        let firstname:String  = PassengerManager.shareInStance.passengerSVDraw().first!.name
        let firstphone:String = PassengerManager.shareInStance.passengerSVDraw().first!.mobiles.first ?? ""
        let firstUid:String = PassengerManager.shareInStance.passengerSVDraw().first?.passagerId ?? ""
        let apvRuleId1:String = PassengerManager.shareInStance.passengerSVDraw().first?.approveId ?? ""
        let travelPolicyId1:String = PassengerManager.shareInStance.passengerSVDraw().first?.policyId ?? ""
        /// 成本中心ID
        let costCenterId1:       String = PassengerManager.shareInStance.passengerSVDraw().first?.costInfoId ?? ""
        /// 成本中心名称
        let costCenterName1:     String = PassengerManager.shareInStance.passengerSVDraw().first?.costInfoName ?? ""
        sectionfirstPersoner[0] = (firstname,firstphone,firstUid,apvRuleId1,travelPolicyId1,costCenterId1,costCenterName1,"新增入住人","","","","","","")
        // by manman  on 2018-06-29 start of line
        //更换数据结构
        if sectionfirstSVPersoner.count > 0 {
            sectionfirstSVPersoner.removeAll()
        }
        let roomFirstPersoner:HotelRoomPersonerModel = HotelRoomPersonerModel()
        roomFirstPersoner.name = firstname
        roomFirstPersoner.phone = firstphone
        roomFirstPersoner.uid = firstUid
        roomFirstPersoner.apvRuleId = apvRuleId1
        roomFirstPersoner.travelPolicyId = travelPolicyId1
        roomFirstPersoner.costCenterId = costCenterId1
        roomFirstPersoner.costCenterName = costCenterName1
        sectionfirstSVPersoner.append((roomFirstPersoner,HotelRoomPersonerModel()))
        
        
        
        // end of line
        
        
        if PassengerManager.shareInStance.passengerSVDraw().count == 1 {
            return
        }
        if PassengerManager.shareInStance.passengerSVDraw().count > 1 {
            for index in 1..<PassengerManager.shareInStance.passengerSVDraw().count
            {
                //
                let name:String  = (PassengerManager.shareInStance.passengerSVDraw()[index].name)
                let phone:String = (PassengerManager.shareInStance.passengerSVDraw()[index].mobiles.first ?? "")
                let firstUid:String = PassengerManager.shareInStance.passengerSVDraw()[index].passagerId
                let apvRuleId1:String = PassengerManager.shareInStance.passengerSVDraw().first?.approveId ?? ""
                let travelPolicyId1:String = PassengerManager.shareInStance.passengerSVDraw().first!.policyId
                /// 成本中心ID
                let costCenterId1:       String = PassengerManager.shareInStance.passengerSVDraw().first!.costInfoId
                /// 成本中心名称
                let costCenterName1:     String = PassengerManager.shareInStance.passengerSVDraw().first!.costInfoName
                sectionfirst.append(("新增入住人",""))//计算多少个房间
                sectionfirstPersoner.append((title1:name,content1:phone,uid1:firstUid,apvRuleId1:apvRuleId1,travelPolicyId1:travelPolicyId1,costCenterId1:costCenterId1,costCenterName1:costCenterName1,title2:"新增入住人",content2:"",uid2:"",apvRuleId2:"",travelPolicyId2:"",costCenterId2:"",costCenterName2:""))
                
                // by manman  on 2018-06-29 start of line
                //更换数据结构
                let roomFirstPersoner:HotelRoomPersonerModel = HotelRoomPersonerModel()
                roomFirstPersoner.name = name
                roomFirstPersoner.phone = phone
                roomFirstPersoner.uid = firstUid
                roomFirstPersoner.apvRuleId = apvRuleId1
                roomFirstPersoner.travelPolicyId = travelPolicyId1
                roomFirstPersoner.costCenterId = costCenterId1
                roomFirstPersoner.costCenterName = costCenterName1
                
                sectionfirstSVPersoner.append((roomFirstPersoner,HotelRoomPersonerModel()))
                
                // end of line
                
            }
        }
    }
    
    
    
    // 调整房间数量后 推荐房间分配
    func adjustPersonalRoom(roomSum:NSInteger,personerSum:[QueryPassagerResponse]) ->Bool {
        
        let remainder = personerSum.count%roomSum //取余
        let multiple = personerSum.count / roomSum //倍数
        
        //房间太少或者太多
        if multiple > 2  || multiple < 1 {
            return false
        }
        
        if sectionfirstPersoner.count > 0 {
            sectionfirstPersoner.removeAll()
        }
        
        //每个房间两个人
        if remainder == 0 && multiple == 2 {
        
            for index in 0..<roomSum
            {
                let first =  personerSum[index]
                let second =  personerSum[index + roomSum]
                sectionfirstPersoner.append((title1: first.name, content1: first.mobiles.first ?? "", uid1: first.passagerId,apvRuleId1:first.approveId,travelPolicyId1:first.policyId,costCenterId1:first.costInfoId,costCenterName1:first.costInfoName, title2: second.name, content2: second.mobiles.first ?? "", uid2: second.passagerId,apvRuleId2:second.approveId,travelPolicyId2:second.policyId,costCenterId2:second.costInfoId,costCenterName2:second.costInfoName))
                
            }
            return true
        }
        
        //每个房间一个人
        if remainder == 0 && multiple == 1 {
            for index in 0..<roomSum
            {
                let first =  personerSum[index]
                sectionfirstPersoner.append((title1: first.name, content1: first.mobiles.first ?? "", uid1: first.passagerId,apvRuleId1:first.approveId,travelPolicyId1:first.policyId,costCenterId1:first.costInfoId,costCenterName1:first.costInfoName,title2: "新增入住人", content2:"", uid2:"",apvRuleId2:"",travelPolicyId2:"",costCenterId2:"",costCenterName2:""))
                
            }
            return true
        }
        
        
        //房间 有两个人的 也有一个人的
        if multiple >= 1 && multiple < 2 && remainder > 0 {
        
            for index in 0..<roomSum
            {
                let first =  personerSum[index]
                var second:QueryPassagerResponse = QueryPassagerResponse()
                if remainder > index {
                 second = personerSum[roomSum + remainder - index - 1]
                    
                }
                
                if second.name.isEmpty {
                    sectionfirstPersoner.append((title1: first.name, content1: first.mobiles.first ?? "", uid1: first.passagerId,apvRuleId1:first.approveId,travelPolicyId1:first.policyId,costCenterId1:first.costInfoId,costCenterName1:first.costInfoName,title2: "新增入住人", content2:"", uid2:"",apvRuleId2:"",travelPolicyId2:"",costCenterId2:"",costCenterName2:""))
                    
                }
                else
                {
                    sectionfirstPersoner.append((title1: first.name, content1: first.mobiles.first ?? "", uid1: first.passagerId,apvRuleId1:first.approveId,travelPolicyId1:first.policyId,costCenterId1:first.costInfoId,costCenterName1:first.costInfoName, title2: second.name, content2: second.mobiles.first ?? "", uid2: second.passagerId,apvRuleId2:second.approveId,travelPolicyId2:second.policyId,costCenterId2:second.costInfoId,costCenterName2:second.costInfoName))
                    
                }
            }
            
            return true
            
        }
        
        return false
        
    }
    
    // 调整房间数量后 推荐房间分配
    func adjustSVPersonalRoom(roomSum:NSInteger) ->Bool {
        
        guard roomSum != sectionfirstSVPersoner.count else {
            return false
        }
        
        
        
        // 1、调整房间  房间数量大于 还是小于 已分配的房间数量
                //a、 先查看是否有为分配的人员
                    //a-1> 先将未分配的人员 放到房间中去(后分配的一人一个房间)
        // 有为分配的人员
        if remainderPersonSVArr.count > 0 {
            for element in remainderPersonSVArr{
                let roomFirstPersoner:HotelRoomPersonerModel = HotelRoomPersonerModel()
                roomFirstPersoner.name = element.name
                roomFirstPersoner.phone = element.mobiles.first ?? ""
                roomFirstPersoner.uid = element.uid
                roomFirstPersoner.apvRuleId = element.approveId
                roomFirstPersoner.travelPolicyId = element.policyId
                roomFirstPersoner.costCenterId = element.costInfoId
                roomFirstPersoner.costCenterName = element.costInfoName
                sectionfirstSVPersoner.append((roomFirstPersoner,HotelRoomPersonerModel()))
            }
        }
        
        sectionFirstRemovePlaceHolderRoom()
        
        // 2、 判断 将要分配的房间数量 和已经分配的房间数量 的大小
        //a 若将要分配的房间数量大于已经分配的房间数量
        // a -1> 检测 已经分配的房间中 是否有两个人住一间房的
        //a-1.1> 将以分配的房间中以倒叙的方式查找 找到在两个人一个房间的,将第二个人分配到新的房间中 ,until 以分配的房间数量 和 将要分配的房间数量 相等
        //b、若将要分配的房间数量小于已经分配的房间数量
        //b -1> 检测 已经分配的房间中是否存在一个人住一个房间的
        //b-1.1> 将已经分配的房间中 以倒叙的形式查找一人住一个房间的  找到后将这个房间去除然后将这个人放到 正序查找 一人一个房间中
        //房间数量 增加
        if roomSum > sectionfirstSVPersoner.count {
            
            while(roomSum > sectionfirstSVPersoner.count){
                for (index,element) in sectionfirstSVPersoner.reversed().enumerated(){
                    if (element.personerOne.name.isEmpty == false && element.personerOne.name != personRoomPlaceHolder) &&
                        (element.personerTwo.name.isEmpty == false && element.personerTwo.name != personRoomPlaceHolder) {
                        
                        let newRoomPersoner:HotelRoomPersonerModel = HotelRoomPersonerModel()
                        newRoomPersoner.name = element.personerTwo.name
                        newRoomPersoner.phone = element.personerTwo.phone
                        newRoomPersoner.uid = element.personerTwo.uid
                        newRoomPersoner.apvRuleId = element.personerTwo.apvRuleId
                        newRoomPersoner.travelPolicyId = element.personerTwo.travelPolicyId
                        newRoomPersoner.costCenterId = element.personerTwo.costCenterId
                        newRoomPersoner.costCenterName = element.personerTwo.costCenterName
                        sectionfirstSVPersoner[sectionfirstSVPersoner.count - 1 - index] = (element.personerOne,HotelRoomPersonerModel())
                        sectionfirstSVPersoner.append((newRoomPersoner,HotelRoomPersonerModel()))
                        break
                    }
                }
            }
        }else{// 房间数量减少
            
            while(roomSum < sectionfirstSVPersoner.count){
                var newRoomPersoner:HotelRoomPersonerModel = HotelRoomPersonerModel()
                for (index,element) in sectionfirstSVPersoner.reversed().enumerated(){
                    if (element.personerOne.name.isEmpty == true || element.personerOne.name == personRoomPlaceHolder) ||
                        (element.personerTwo.name.isEmpty == true || element.personerTwo.name == personRoomPlaceHolder) {
                        if element.personerOne.name.isEmpty == true || element.personerOne.name == personRoomPlaceHolder {
                            newRoomPersoner = element.personerTwo
                        }else{
                            newRoomPersoner = element.personerOne
                        }
                        
//                        newRoomPersoner.name = element.personerTwo.name
//                        newRoomPersoner.phone = element.personerTwo.phone
//                        newRoomPersoner.uid = element.personerTwo.uid
//                        newRoomPersoner.apvRuleId = element.personerTwo.apvRuleId
//                        newRoomPersoner.travelPolicyId = element.personerTwo.travelPolicyId
//                        newRoomPersoner.costCenterId = element.personerTwo.costCenterId
//                        newRoomPersoner.costCenterName = element.personerTwo.costCenterName
//                        sectionfirstSVPersoner[index] = (element.personerOne,HotelRoomPersonerModel())
//                        sectionfirstSVPersoner.append((newRoomPersoner,HotelRoomPersonerModel()))
                        sectionfirstSVPersoner.remove(at: sectionfirstSVPersoner.count - 1 - index)
                        break
                    }
                }
                
                for (index,element) in sectionfirstSVPersoner.enumerated() {
                    if (element.personerOne.name.isEmpty == true || element.personerOne.name == personRoomPlaceHolder) ||
                        (element.personerTwo.name.isEmpty == true || element.personerTwo.name == personRoomPlaceHolder) {
                        
                        var singlePersonerSingleRoom = sectionfirstSVPersoner[index]
                        if element.personerOne.name.isEmpty == true || element.personerOne.name == personRoomPlaceHolder {
                            singlePersonerSingleRoom.personerOne = newRoomPersoner
                        }else{
                            singlePersonerSingleRoom.personerTwo = newRoomPersoner
                        }
                        
                        sectionfirstSVPersoner[index] = singlePersonerSingleRoom
                        
                        
//
//                        if element.personerOne.name.isEmpty == true || element.personerOne.name == personRoomPlaceHolder {
//                            newRoomPersoner = element.personerTwo
//                        }else{
//                            newRoomPersoner = element.personerOne
//                        }
//
                        //                        newRoomPersoner.name = element.personerTwo.name
                        //                        newRoomPersoner.phone = element.personerTwo.phone
                        //                        newRoomPersoner.uid = element.personerTwo.uid
                        //                        newRoomPersoner.apvRuleId = element.personerTwo.apvRuleId
                        //                        newRoomPersoner.travelPolicyId = element.personerTwo.travelPolicyId
                        //                        newRoomPersoner.costCenterId = element.personerTwo.costCenterId
                        //                        newRoomPersoner.costCenterName = element.personerTwo.costCenterName
                        //                        sectionfirstSVPersoner[index] = (element.personerOne,HotelRoomPersonerModel())
                        //                        sectionfirstSVPersoner.append((newRoomPersoner,HotelRoomPersonerModel()))
                       // sectionfirstSVPersoner.remove(at: index)
                        break
                    }
                }
            }
            
        }
        
        return true
        
        
    }
    
    
    /// 在调整房间数量 时 去除空的 房间
    func sectionFirstRemovePlaceHolderRoom() {
        
        sectionfirstSVPersoner = sectionfirstSVPersoner.filter({ (element) -> Bool in
           if (element.personerOne.name.isEmpty == true || element.personerOne.name == personRoomPlaceHolder)
            && (element.personerTwo.name.isEmpty == true || element.personerTwo.name == personRoomPlaceHolder){
                return false
            }
            return true
            
        })
        
        
        
//        for (index,element) in sectionfirstSVPersoner.enumerated() {
//
//            if (element.personerOne.name.isEmpty == true || element.personerOne.name == personRoomPlaceHolder)
//                && (element.personerTwo.name.isEmpty == true || element.personerTwo.name == personRoomPlaceHolder){
//                sectionfirstSVPersoner.remove(at: index)
//            }
//        }
    }
    
    
    
    
    
    func setPickerRoomNumView() {
        
        KeyWindow?.addSubview(pickerRoomNumView)
        pickerRoomNumView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        weak var weakSelf = self
        pickerRoomNumView.pickerViewSelectedRow = {(selectedIndex,title) in
            weakSelf?.pickViewSelectedIndex(selectedRow: selectedIndex,title: title)
            
            
        }
    }
    
    
    func setAmountTitleButton(state:AmountTitleButtonState) {
        
        switch state {
        case .done:
            amountTitleButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
            amountTitleButton.setTitle("提交订单", for: UIControlState.normal)
            amountTitleButton.titleLabel?.font = UIFont.systemFont( ofSize: 18)
            amountTitleButton.addTarget(self, action: #selector(amountTitleButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            break
            
        case .next:
            amountTitleButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
            amountTitleButton.titleLabel?.font = UIFont.systemFont( ofSize: 18)
            amountTitleButton.setTitle("下一步", for: UIControlState.normal)
            amountTitleButton.addTarget(self, action: #selector(amountTitleButtonNextAction(sender:)), for: UIControlEvents.touchUpInside)
            break
        default:
            break
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- 定制视图
    
    func setUIViewAutolayout() {
        
//        tableView.frame = self.view.frame
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(ReserveRoomTableViewCell.classForCoder(), forCellReuseIdentifier: reserveRoomTableViewCellIdentify)
        tableView.register(FlightContraryOrderTableCell.classForCoder(), forCellReuseIdentifier: trainContraryOrderTableCellIdentify)
        tableView.register(AddRemarkCell.classForCoder(), forCellReuseIdentifier: addRemarkCellIdentify)
        tableView.register(ReserveCompanyRoomPersonerTableViewCell.classForCoder(), forCellReuseIdentifier: reserveCompanyRoomTableViewCellIdentify)
        if showHeaderViewSpecialConfig == 0 {
           tableView.register(ReserveRoomTableViewHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: reserveRoomTableViewHeaderViewIdentify)
          
        }else
        {
            let headerView:ReserveRoomTableViewHeaderView = ReserveRoomTableViewHeaderView.init(reuseIdentifier:reserveRoomTableViewHeaderViewIdentify)
            headerView.frame = CGRect.init(x: 0, y: 0, width: ScreenWindowWidth, height: 229 + 10 + 70 - 10)
            //headerView.fillDataSourcesNew(hotelRoomDetail: self.roomModel, checkinDateStr: self.hotelDetailForm.arrivalDate, checkoutDateStr: hotelDetailForm.departureDate, accordTravel: accordTravel)
            headerView.fillDataSources(hotelRoomDetail: roomSelected, checkinDateStr: searchSVCondition.arrivalDate, checkoutDateStr: searchSVCondition.departureDate, accordTravel: accordTravel)
            tableView.tableHeaderView = headerView
        }
        
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(44)
        }

        
    }
    
    func setBottomView()
    {
        
        bottomBackgroundView.backgroundColor = UIColor.white
        self.view.addSubview(bottomBackgroundView)
        bottomBackgroundView.snp.makeConstraints { (make) in
            
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(44)
            
        }
        
        let lineLable = UILabel()
        lineLable.backgroundColor = TBIThemeGrayLineColor
        bottomBackgroundView.addSubview(lineLable)
        lineLable.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        amountTitleLabel.text = "每间房总价:"
        amountTitleLabel.textColor = TBIThemePrimaryTextColor
        amountTitleLabel.adjustsFontSizeToFitWidth = true
        amountTitleLabel.font = UIFont.systemFont( ofSize: 13)
        bottomBackgroundView.addSubview(amountTitleLabel)
        amountTitleLabel.snp.makeConstraints { (make) in
            
            make.left.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            
        }
        amountLabel.textColor = TBIThemeOrangeColor
        amountLabel.font = UIFont.systemFont(ofSize: 16)
        amountLabel.text = "¥690"
        amountLabel.textAlignment = NSTextAlignment.left
        bottomBackgroundView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { (make) in
            
            make.centerY.equalToSuperview()
            make.left.equalTo(amountTitleLabel.snp.right).offset(5)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        
        
        amountTitleButton.setTitle("下一步", for: UIControlState.normal)
        amountTitleButton.titleLabel?.font = UIFont.systemFont( ofSize: 14)
        amountTitleButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        amountTitleButton.backgroundColor = TBIThemeDarkBlueColor
        amountTitleButton.addTarget(self, action: #selector(amountTitleButtonNextAction(sender:)), for: UIControlEvents.touchUpInside)
        bottomBackgroundView.addSubview(amountTitleButton)
        amountTitleButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            
            
        }
        
        
        
    }
    private func caculateIntervalDay(fromDate:Date,toDate:Date) -> NSInteger {
        
        let calendar = NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)
        let result = calendar?.components(NSCalendar.Unit.day, from: fromDate, to: toDate, options: NSCalendar.Options.matchFirst)
        
        return (result?.day)!
    }
    
    //MARK:- UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        //控制新老版视图 展示
        //老版
        if userVersion == 0 {
            
            return 3 + sectionGuaranteePolicyNum + sectionViolateTravellerPolicyNum
            
        }else
        {
         
            var showBuseinessSectionInteger:NSInteger = 0
            
            //存在订单号 需要 填写 出差单信息
            //  添加 需求  丰田销售 定制化   不需要显示出差单
            if showBuseinessSection == 0
            {
                showBuseinessSectionInteger = 1
                
            }else // 不需要显示出差单
            {
                showRemarkSection = 0
            }
            
            
            
            return 4 + showBuseinessSectionInteger  + sectionGuaranteePolicyNum + sectionViolateTravellerPolicyNum + showRemarkSection + remarkSection
           
        }
    }
    
    //new
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return caculateSVNumberRowInSection(selectedSection: section)//caculateNumberRowInSection(selectedSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ReserveRoomTableViewCell = tableView.dequeueReusableCell(withIdentifier: reserveRoomTableViewCellIdentify) as! ReserveRoomTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        weak var weakself = self
        cell.reserveRoomTableViewContentResultBlock = { (textField,cellIndexPath) in
            print("传值回控制器 ...")
            weakself?.modifyTableViewDataSources(content: textField.text!, selectedIndex: cellIndexPath)
        }
        //configCell(cell: cell, indexPath: indexPath)
        
        // 担保政策
        let selectedRoomStr:String = String(selectedRoomSum) + "间"
        if indexPath.section == 0 && sectionGuaranteePolicyNum == 1
        {
            cell.fillDataSource(title:"担保政策",contentPlaceHolder: "", contentCertain: false, content: guaranteeDescription ?? "", contentEnable: false, intoNextEnable: false,showLineEnable:false, cellIndex: indexPath)
            return cell
        }
        
        
        var sectionArr:[(title:String,content:String)] = tableViewDataSourcesArr[indexPath.section - sectionGuaranteePolicyNum]
        
        //房间数量
        if indexPath.section == 0 + sectionGuaranteePolicyNum {
            //房间数量
            if indexPath.row == 0 {
                var intoNextEnable:Bool = true
                var showLineEnable:Bool = false
                
                if PassengerManager.shareInStance.passengerSVDraw().count == 1 {
                    intoNextEnable = false
                    showLineEnable = true
                }
                cell.fillDataSource(title:sectionArr[indexPath.row].title , contentPlaceHolder: "", contentCertain: false, content:selectedRoomStr, contentEnable: false, intoNextEnable: intoNextEnable,showLineEnable:showLineEnable, cellIndex: indexPath)
                
                return cell
            }
            
            if indexPath.row > 0 {
                
                //一个人的 定制设置
                if PassengerManager.shareInStance.passengerSVDraw().count == 1 {
                    
//                    let contentStr = sectionfirstPersoner[0].title1 + "   " + sectionfirstPersoner[0].content1
                    let contentStr = (sectionfirstSVPersoner.first?.personerOne.name ?? "")! + "    " + (sectionfirstSVPersoner.first?.personerOne.phone ?? "")!
                    cell.fillDataSource(title:"入住人" , contentPlaceHolder: "", contentCertain: false, content:contentStr, contentEnable: false, intoNextEnable: false,showLineEnable:false, cellIndex: indexPath)
                    
                    return cell
                    
                    
                    
                }
                
                
                //房间信息
                let cell:ReserveCompanyRoomPersonerTableViewCell = tableView.dequeueReusableCell(withIdentifier: reserveCompanyRoomTableViewCellIdentify) as! ReserveCompanyRoomPersonerTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                
               // cell.fillDataSources(roomNum: String(indexPath.row), firstName: sectionfirstPersoner[indexPath.row - 1].title1, firstTel: sectionfirstPersoner[indexPath.row - 1].content1, secondName: sectionfirstPersoner[indexPath.row - 1].title2, secondTel:sectionfirstPersoner[indexPath.row - 1].content2, index: indexPath)
                cell.fillDataSources(roomNum: String(indexPath.row), firstName: sectionfirstSVPersoner[indexPath.row - 1].personerOne.name, firstTel:sectionfirstSVPersoner[indexPath.row - 1].personerOne.phone, secondName: sectionfirstSVPersoner[indexPath.row - 1].personerTwo.name, secondTel:sectionfirstSVPersoner[indexPath.row - 1].personerTwo.phone, index: indexPath)
                
                weak var weakSelf = self
                cell.reserveCompanyRoomPersonerDeleteBlock = { (parameter,cellIndexRow ) in
                    
                    print(parameter)
                    weakSelf?.operationCellIndex = parameter
                    
                    weakSelf?.deleteSelectedPersonAction(cellIndex: parameter, row: cellIndexRow)
                }
                cell.reserveCompanyRoomPersonerAddBlock = { (parameter) in
                    print(parameter)
                    if (weakSelf?.selectedRoomCapacity)! > 1 {
                        weakSelf?.operationCellIndex = parameter
                        weakSelf?.showSVRemainderPersonView()
                    }
                }
                return cell
            }
        }
        
        // 特殊要求 最晚到店时间
        if indexPath.section == 1 + sectionGuaranteePolicyNum{
            if indexPath.row == 0 {
                cell.fillDataSource(title: sectionArr[indexPath.row].title, contentPlaceHolder: "", contentCertain: false, content: sectionArr[indexPath.row].content, contentEnable: false, intoNextEnable: true, showLineEnable: true, cellIndex: indexPath)
            }
            if indexPath.row == 1 {
                sectionArr[indexPath.row].content = selectedEndTime
                cell.fillDataSource(title: sectionArr[indexPath.row].title, contentPlaceHolder: "", contentCertain: false, content: sectionArr[indexPath.row].content, contentEnable: false, intoNextEnable: true, showLineEnable: false, cellIndex: indexPath)
            }
            
            return cell
            
        }
        
        // 违背差旅政策
        
        if sectionViolateTravellerPolicyNum == 1 && indexPath.section == 2 + sectionGuaranteePolicyNum  {
            
            var sectionVioLateArr:[(title:String,content:String)] = tableViewDataSourcesArr[3]
            if indexPath.row == 0 {
                var content = "价格不符！"
                if  !sectionVioLateArr[indexPath.row].content.isEmpty {
                    content = sectionVioLateArr[indexPath.row].content
                }
                cell.fillDataSource(title: sectionVioLateArr[indexPath.row].title, contentPlaceHolder: "", contentCertain: false, content:content , contentEnable: false, intoNextEnable: false, showLineEnable: true, cellIndex: indexPath)
            }
            
            if indexPath.row > 0 {
                var contentCertain:Bool = true
                var contentPlaceHolder = "请输入(必填)" //"请输入(必填)"
                let userDetail = UserService.sharedInstance.userDetail()
                if userDetail?.companyUser?.companyCode == Toyota   {
                    contentPlaceHolder = "请输入违背原因"
                    contentCertain = false
                }
                if !sectionVioLateArr[indexPath.row].content.isEmpty {
                    contentPlaceHolder = ""
                    contentCertain = false
                }
                
                cell.fillDataSource(title: sectionVioLateArr[indexPath.row].title, contentPlaceHolder:contentPlaceHolder, contentCertain: contentCertain , content: sectionVioLateArr[indexPath.row].content, contentEnable: false, intoNextEnable: true, showLineEnable: false, cellIndex: indexPath)
            }
            
            
            return cell
        }
        
        //联系人信息
        if indexPath.section == 2 + sectionGuaranteePolicyNum  + sectionViolateTravellerPolicyNum{
            
            var personInfo = tableViewDataSourcesArr[2]
            var contentPlaceHolder = "请输入联系人名称"
            var showLine:Bool = true
            var intoNextEnable:Bool = false
            
            
            if !personInfo[indexPath.row].content.isEmpty {
                contentPlaceHolder = ""
            }
            if indexPath.row == 0 {
                intoNextEnable = true
            }
            
            //最后一个元素
            if personInfo.count == indexPath.row + 1 {
                showLine = false
            }
            
            cell.fillDataSource(title:personInfo[indexPath.row].title , contentPlaceHolder: contentPlaceHolder, contentCertain: false, content: personInfo[indexPath.row].content, contentEnable: (indexPath.row == 0 ? false : true), intoNextEnable: intoNextEnable, showLineEnable: showLine, cellIndex: indexPath)
        }
        
        
        
        
        // 出差信息
        if showBuseinessSection == 0 && indexPath.section == 3 + sectionGuaranteePolicyNum + sectionViolateTravellerPolicyNum
        {
            let businessInfo = tableViewDataSourcesArr[4]
            if indexPath.row == 0 {
                
                cell.fillDataSource(title: businessInfo[indexPath.row].title, contentPlaceHolder: "", contentCertain: false, content: "", contentEnable: false, intoNextEnable: false, showLineEnable: false, cellIndex: indexPath)
                
            }
            else
            {
                var contentCertain:Bool = false
                var contentEnable:Bool = true
                var intoNextEnable:Bool = true
                var showLine:Bool = true
                var contentPlaceHolder = "请选择(必填)" //"请输入(必填)"
                if businessInfo.count - 1 == indexPath.row {
                    showLine = false
                }
                
                
                //出差时间 必填 开始时间 和结束时间破
                if companyCustomSVConfig?.travelTimeRequire  == "1" && (indexPath.row == 1 || indexPath.row == 2 ){
                    
                    contentCertain = true
                    contentEnable = false
                }else if (companyCustomSVConfig?.travelTimeRequire == "0" && (indexPath.row == 1 || indexPath.row == 2))
                {
                    contentPlaceHolder = "请输入"
                    contentCertain = false
                    contentEnable = false
                    
                }
                
                
                //出差地点
                if companyCustomSVConfig?.travelDestRequire == "1" && indexPath.row == 3 && showFTMSSpecialConfig == 0 {
                    contentCertain = true
                    intoNextEnable = false
                }else if companyCustomSVConfig?.travelDestRequire == "0" && indexPath.row == 3 && showFTMSSpecialConfig == 0
                {
                    contentPlaceHolder = "请输入"
                    contentCertain = false
                    intoNextEnable = false
                    
                }
                //出差目的
                if companyCustomSVConfig?.travelPurposeRequire == "1" && indexPath.row == 4 - showFTMSSpecialConfig
                {
                    contentCertain = true
                    contentEnable = false
                }else if  companyCustomSVConfig?.travelPurposeRequire == "0" && indexPath.row == 4 - showFTMSSpecialConfig
                {
                    contentPlaceHolder = "请输入"
                    contentCertain = false
                    contentEnable = false
                    intoNextEnable = true
                    
                }
                //出差是由
                if companyCustomSVConfig?.travelReasonRequire == "1" && indexPath.row == 5 - showFTMSSpecialConfig {
                    contentCertain = true
                    intoNextEnable = false
                }else if companyCustomSVConfig?.travelReasonRequire == "0" && indexPath.row == 5 - showFTMSSpecialConfig
                {
                    contentPlaceHolder = "请输入出差事由"
                    contentCertain = false
                    intoNextEnable = false
                    
                }
                
                
                
                cell.fillDataSource(title:businessInfo[indexPath.row].title , contentPlaceHolder: contentPlaceHolder, contentCertain: contentCertain, content: businessInfo[indexPath.row].content, contentEnable: contentEnable, intoNextEnable: intoNextEnable, showLineEnable: showLine, cellIndex: indexPath)
            }
            
            
        }
        var showBusinessSectionNsinteger:NSInteger = 1
        if showBuseinessSection == 1 {
            showBusinessSectionNsinteger = 0
        }
        
        //成本中心
        if indexPath.section == 3 + showBusinessSectionNsinteger + sectionGuaranteePolicyNum + sectionViolateTravellerPolicyNum{
            
            let costCenterInfo = tableViewDataSourcesArr[5]
            if indexPath.row == 0 {
                cell.fillDataSource(title: costCenterInfo[indexPath.row].title,subTitle: "查看详情",contentPlaceHolder: "", contentCertain: true, content: costCenterInfo[indexPath.row].content, contentEnable: false, intoNextEnable: false, showLineEnable: false, cellIndex: indexPath)
                
            }
//            else
//            {
//                cell.fillDataSource(title:costCenterInfo[indexPath.row].title , contentPlaceHolder: "请选择(必填)", contentCertain: false, content: "", contentEnable: true, intoNextEnable: true, showLineEnable: true, cellIndex: indexPath)
//            }
        }
        
        ///  订单备注
        if indexPath.section ==  3 + showBusinessSectionNsinteger + sectionGuaranteePolicyNum + sectionViolateTravellerPolicyNum + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: addRemarkCellIdentify) as! AddRemarkCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.fillDataSourcesRemark(reason: orderRemark.value)
//            cell.messageLabel.snp.updateConstraints({ (make) in
//                make.left.equalTo(14)
//            })
            //cell.messageField.rx.text.orEmpty.bind(to: orderRemark).addDisposableTo(bag)
            cell.messageTextView.rx.text.orEmpty.bind(to: orderRemark).addDisposableTo(bag)
            return cell
        }
        // 自定义字段
        if  showBuseinessSection == 0 &&  indexPath.section == 4 + showBusinessSectionNsinteger + sectionGuaranteePolicyNum + sectionViolateTravellerPolicyNum{
            let costCenterInfo = tableViewDataSourcesArr[6]
            if indexPath.row == 0 {
                var contentPlaceHolder = "请选择" //"请输入(必填)"
                var ceontentCertain:Bool = false
                if companyCustomConfig?.customFields?.first?.require == true {
                    ceontentCertain = true
                    contentPlaceHolder = "请选择(必填)"
                    
                }
                cell.fillDataSource(title: costCenterInfo[indexPath.row].title, contentPlaceHolder: contentPlaceHolder, contentCertain: ceontentCertain, content: costCenterInfo[indexPath.row].content, contentEnable: false, intoNextEnable: true, showLineEnable: false, cellIndex: indexPath)
                
            }
        }
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && showHeaderViewSpecialConfig == 0  {
            return 229 + 10 + 70
        }else
        {
            return 10
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if section == 0 && showHeaderViewSpecialConfig == 0 {
            let headerView:ReserveRoomTableViewHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: reserveRoomTableViewHeaderViewIdentify) as! ReserveRoomTableViewHeaderView
            headerView.fillDataSourcesNew(hotelRoomDetail: self.roomModel, checkinDateStr: self.hotelDetailForm.arrivalDate, checkoutDateStr: hotelDetailForm.departureDate, accordTravel: accordTravel)
            
            return headerView
        }
        else
        {
            let headerView = UIView()
            headerView.backgroundColor = TBIThemeBaseColor
            return headerView
        }
        
    }
    
    
    
    //MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // 担保政策 
        if sectionGuaranteePolicyNum == 1 && indexPath.section == 0
        {
            
          return getTextHeigh(textStr: guaranteeDescription, font: UIFont.systemFont( ofSize: 13), width: ScreenWindowWidth - 30 ) + 44 + 15
            
        }
        if (indexPath.section == sectionGuaranteePolicyNum + 0)
        {
            if indexPath.row  > 0 {
                if PassengerManager.shareInStance.passengerSVDraw().count == 1 {
                    return 45
                }
                return 44 * 3
            }
            
        }
        
        //备注说明
        var showBusinessSectionNsinteger:NSInteger = 1
        if showBuseinessSection == 1 {
            showBusinessSectionNsinteger = 0
        }
        
        if indexPath.section ==  4 + showBusinessSectionNsinteger + sectionGuaranteePolicyNum + sectionViolateTravellerPolicyNum
        {
            return 70
        }
        
        
        
        
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        printDebugLog(message: "didSelectRow ")
        
        if indexPath.section == 0 + sectionGuaranteePolicyNum && indexPath.row > 0 {
            return
        }
        var showBusinessSectionNsinteger:NSInteger = 1
        if showBuseinessSection == 1 {
            showBusinessSectionNsinteger = 0
        }
        //订单备注
        if indexPath.section ==  3 + showBusinessSectionNsinteger + sectionGuaranteePolicyNum + sectionViolateTravellerPolicyNum + 1
        {
            return
        }
        let cell:ReserveRoomTableViewCell = tableView.cellForRow(at: indexPath) as! ReserveRoomTableViewCell
        
        let title:String = (cell.categoryTitleLabel.text?.description)!
       
        nextToSelectedRoomNumView(parameters: title)
    }
    
    func getTextHeigh(textStr:String?,font:UIFont,width:CGFloat) -> CGFloat {
        
        if textStr?.characters.count == 0 || textStr == nil {
            return 0.0
        }
        let normalText: NSString = textStr! as NSString
        let size = CGSize(width:width,height:1000)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        return stringSize.height
    }
    
    
    
    
   //MARK:------ 添加人员
    //展示没有房间的人员
    func showSVRemainderPersonView() {
        
        if remainderPersonSVArr.count == 0 {
            
            showSystemAlertView(titleStr: "提示", message: "无可选入住人")
            return
        }
        
        weak var weakSelf = self
        remainderPersonView.frame = ScreenWindowFrame
        //remainderPersonView.tableViewDataSourcesArr = remainderPersonArr
        remainderPersonView.reserveRoomChoiceStaffResultBlock = {(selectedIndex) in
            
            print(selectedIndex)
            weakSelf?.selectedRemainderPerson(cellIndex: selectedIndex)
            
            
        }
        remainderPersonView.reloadDataSources(passenger:remainderPersonSVArr)
        KeyWindow?.addSubview(remainderPersonView)
        
    }
    func showRemainderPersonView() {
        
        if remainderPersonArr.count == 0 {
            
            showSystemAlertView(titleStr: "提示", message: "无可选入住人")
            return
        }
        
        weak var weakSelf = self
        remainderPersonView.frame = ScreenWindowFrame
        remainderPersonView.tableViewDataSourcesArr = remainderPersonArr
        remainderPersonView.reserveRoomChoiceStaffResultBlock = {(selectedIndex) in
            
            print(selectedIndex)
            weakSelf?.selectedRemainderPerson(cellIndex: selectedIndex)
            
            
        }
        remainderPersonView.reloadDataSource()
        KeyWindow?.addSubview(remainderPersonView)
        
    }
    
    //MARK:------删除人员
    func deleteSelectedPersonAction(cellIndex:IndexPath,row:NSInteger) {
        print(cellIndex)
        
//        let personCount:NSNumber = NSNumber.init(value: PassengerManager.shareInStance.passengerSVDraw().count)
//        let roomMinSum:NSNumber = NSNumber.init(value:ceil(personCount.floatValue / 2))
//
//        if sectionfirstPersoner.count == 1
//        {
//            showSystemAlertView(titleStr: "提示", message: "只剩一间房了")
//            return
//        }
//
        //删除对象
        //let deleteItem = sectionfirstPersoner[cellIndex.row - 1]
        
//        if deleteItem.uid1.characters.count > 0  && deleteItem.uid2.characters.count > 0 {
//            deleteCellIndexRow(cellIndex: cellIndex, row: row)
//        }else
//        {
//            deleteCellIndex(cellIndex: cellIndex, row: row)
//        }
        
        let deleteItem = sectionfirstSVPersoner[cellIndex.row - 1]
        if deleteItem.personerOne.uid.characters.count > 0  && deleteItem.personerTwo.uid.characters.count > 0 {
            //deleteCellIndexRow(cellIndex: cellIndex, row: row)
            deleteCellIndexRowSV(cellIndex: cellIndex, row: row)
        }else
        {
            deleteCellIndex(cellIndex: cellIndex, row: row)
        }
        
        
    }
    
    //整体 删除
    func deleteCellIndex(cellIndex:IndexPath,row:NSInteger)  {
        //删除对象
        let deleteItem = sectionfirstSVPersoner[cellIndex.row - 1]
        //sectionfirstSVPersoner.remove(at: cellIndex.row - 1)//人员显示的调整
        sectionfirstSVPersoner[cellIndex.row - 1] = (HotelRoomPersonerModel(),HotelRoomPersonerModel())
//        let deleteItem = sectionfirstPersoner[cellIndex.row - 1]
//        sectionfirstPersoner.remove(at: cellIndex.row - 1)//人员显示的调整
        
        // add by manman start of lien
        // 添加新需求  更改人员 不修改 房间数量
        // 2018-06-29
        //sectionfirst.remove(at: cellIndex.row)//行的个数调整
        //tableViewDataSourcesArr[0] = sectionfirst
        // end of line
        
        
        let person =  PassengerManager.shareInStance.passengerSVDraw().first { (element) -> Bool in
            if( element.passagerId == deleteItem.personerOne.uid || element.passagerId == deleteItem.personerTwo.uid){
                return true
            }
            return false
        }
        if person != nil {
            remainderPersonSVArr.append(person!)
            //remainderPersonArr.append(person!)
        }
        // 更改房间数量
        // add by manman start of lien
        // 添加新需求  更改人员 不修改 房间数量
        // 2018-06-29
        //selectedRoomSum = selectedRoomSum - 1
        
        // end of line
        self.tableView.reloadData()
        
    }
    
    
    //   单个 删除
    func deleteCellIndexRow(cellIndex:IndexPath,row:NSInteger) {
        var deleteItemUid = ""
        //删除对象
        var deleteItem = sectionfirstPersoner[cellIndex.row - 1]
        //删除 第一个位置 信息
        if row == 1 && deleteItem.uid1.characters.count > 0 {
            deleteItemUid = deleteItem.uid1
            deleteItem.title1 = "新增入住人"
            deleteItem.content1 = ""
            deleteItem.uid1 = ""
        }else
        {
            deleteItemUid = deleteItem.uid2
            deleteItem.title2 = "新增入住人"
            deleteItem.content2 = ""
            deleteItem.uid2 = ""
        }
       sectionfirstPersoner[cellIndex.row - 1] = deleteItem//人员显示的调整
        // 显示的行数 不需要变化
        //        sectionfirst.remove(at: cellIndex.row)//行的个数调整
        //tableViewDataSourcesArr[0] = sectionfirst
        //获取 删除的人员信息
        let person =  PassengerManager.shareInStance.passengerSVDraw().first { (element) -> Bool in
            element.passagerId == deleteItemUid
        }
        if person != nil {
            remainderPersonSVArr.append(person!)
        }
        // 房间数量 未变化
        //selectedRoomSum = selectedRoomSum - 1
        self.tableView.reloadData()
    }
    
   
    //   单个 删除 替换上面的方法
    func deleteCellIndexRowSV(cellIndex:IndexPath,row:NSInteger) {
        var deleteItemUid = ""
        //删除对象
        var deleteItem = sectionfirstSVPersoner[cellIndex.row - 1]
        //删除 第一个位置 信息
        if row == 1 && deleteItem.personerOne.uid.characters.count > 0 {
            deleteItemUid = deleteItem.personerOne.uid
            deleteItem.personerOne = HotelRoomPersonerModel()
//            deleteItem.title1 = "新增入住人"
//            deleteItem.content1 = ""
//            deleteItem.uid1 = ""
        }else {
            deleteItemUid = deleteItem.personerTwo.uid
            deleteItem.personerTwo = HotelRoomPersonerModel()
//            deleteItem.title2 = "新增入住人"
//            deleteItem.content2 = ""
//            deleteItem.uid2 = ""
        }
        sectionfirstSVPersoner[cellIndex.row - 1] = deleteItem
        //sectionfirstPersoner[cellIndex.row - 1] = deleteItem//人员显示的调整
        // 显示的行数 不需要变化
        //        sectionfirst.remove(at: cellIndex.row)//行的个数调整
       // tableViewDataSourcesArr[0] = sectionfirst
        //获取 删除的人员信息
        let person =  PassengerManager.shareInStance.passengerSVDraw().first { (element) -> Bool in
            element.passagerId == deleteItemUid
        }
        if person != nil {
            remainderPersonSVArr.append(person!)
        }
        // 房间数量 未变化
        //selectedRoomSum = selectedRoomSum - 1
        self.tableView.reloadData()
    }
    
    
    
    
    
    func selectedRemainderPerson(cellIndex:NSInteger) {
        
        let selectedItem =  remainderPersonSVArr[cellIndex]
        print(operationCellIndex)//操作的cell
//        var operateItem = sectionfirstPersoner[operationCellIndex.row - 1]
        var operateItem = sectionfirstSVPersoner[operationCellIndex.row - 1]
        // 操作的是第一个位置
        if operateItem.personerOne.name.characters.count > 0 && operateItem.personerOne.name == "新增入住人" {
            operateItem.personerOne.name = selectedItem.name
            operateItem.personerOne.phone = selectedItem.mobiles.first ?? ""
            operateItem.personerOne.uid = selectedItem.passagerId
            
            
        }else
        {
            operateItem.personerTwo.name = selectedItem.name
            operateItem.personerTwo.phone = selectedItem.mobiles.first ?? ""
            operateItem.personerTwo.uid = selectedItem.passagerId
        }
        //sectionfirstPersoner[operationCellIndex.row - 1] = operateItem
        sectionfirstSVPersoner[operationCellIndex.row - 1] = operateItem
        remainderPersonSVArr.remove(at: cellIndex)
        //remainderPersonArr.remove(at: cellIndex)
        
        self.tableView.reloadData()
    }
    
    
    
    
    func caculateSVNumberRowInSection(selectedSection:Int)-> Int {
        
        guard tableViewDataSourcesArr.count > 0 else {
            return 0
        }
            // 担保政策 存在
            if sectionGuaranteePolicyNum == 1 {
                
                if selectedSection == 0 {
                    return 1
                }else
                {
                    //违背 差旅政策
                    if sectionViolateTravellerPolicyNum == 1 {
                        
                        //房间 特殊要求
                        if selectedSection < 3 {
                            
                            return self.tableViewDataSourcesArr[selectedSection - sectionGuaranteePolicyNum].count
                            
                        }else
                        {
                            //违背政策  政策 描述
                            if selectedSection == 3 {
                                return self.tableViewDataSourcesArr[selectedSection].count
                                
                            }
                            // 联系人
                            if selectedSection == 4 {
                                return self.tableViewDataSourcesArr[selectedSection - sectionViolateTravellerPolicyNum - sectionGuaranteePolicyNum].count
                            }
                            // 出差信息  成本中心 备注信息
                            return self.tableViewDataSourcesArr[selectedSection + showBuseinessSection - sectionViolateTravellerPolicyNum].count
                        }
                    }else //不违背 差旅政策
                    {
                        if selectedSection < 4 {
                            //房间数 + 特殊要求 + 联系人
                            return self.tableViewDataSourcesArr[selectedSection - sectionGuaranteePolicyNum].count
                        }
                        if selectedSection >= 4 {
                            //出差信息 //成本中心
                            return self.tableViewDataSourcesArr[selectedSection + showBuseinessSection].count
                        }
                    }
                }
                
            }else //不存在担保政策
            {
                //不违背 差旅政策
                if sectionViolateTravellerPolicyNum != 1
                {
                    //房间 特殊要求 联系人
                    if selectedSection < 3
                    {
                        return tableViewDataSourcesArr[selectedSection].count
                    }else  // 出差信息  //成本中心
                    {
                        
                        return tableViewDataSourcesArr[selectedSection + userVersion + showBuseinessSection].count
                        
                    }
                }else //违背差旅政策
                {
                    if selectedSection < 2 {
                        
                        return tableViewDataSourcesArr[selectedSection].count
                    }
                    //违背差旅政策 陈述原因
                    if selectedSection == 2 {
                        return tableViewDataSourcesArr[selectedSection + sectionViolateTravellerPolicyNum].count
                    }
                    //联系人 信息
                    if selectedSection == 3 {
                        return tableViewDataSourcesArr[selectedSection - sectionViolateTravellerPolicyNum].count
                    }
                    // 出差信息 成本中心
                    if selectedSection > 3 {
                        return tableViewDataSourcesArr[selectedSection + showBuseinessSection].count
                    }
                }
            }
        
        return 0
    }
    
    func caculateNumberRowInSection(selectedSection:Int)-> Int {
        
        guard tableViewDataSourcesArr.count > 0 else {
            return 0
        }
        
        //老版
        if userVersion == 0 {
            //存在担保政策
            if sectionGuaranteePolicyNum == 1 {
                if selectedSection == 0{
                    return 1
                }else
                {
                    //违背 差旅政策
                    if sectionViolateTravellerPolicyNum == 1 {
                        //房间 特殊要求
                        if selectedSection > 0 && selectedSection < 3 {
                            return self.tableViewDataSourcesArr[selectedSection - sectionGuaranteePolicyNum].count
                            
                        }else
                        {
                            //违背政策  政策 描述
                            if selectedSection == 3 {
                                return self.tableViewDataSourcesArr[selectedSection].count
                            }
                            // 联系人
                            return self.tableViewDataSourcesArr[selectedSection - sectionViolateTravellerPolicyNum - sectionGuaranteePolicyNum].count
                        }
                    }else //不违背 差旅政策
                    {
                        //房间数 + 特殊要求 + 联系人
                        return self.tableViewDataSourcesArr[selectedSection - sectionGuaranteePolicyNum].count
                    }
                }
            }else //不存在担保
            {
                //不违背 差旅政策
                if sectionViolateTravellerPolicyNum != 1
                {
                    return tableViewDataSourcesArr[selectedSection].count
                    
                }else
                {
                    if selectedSection < 2 {
                        
                        return tableViewDataSourcesArr[selectedSection].count
                    }
                    //违背差旅政策 陈述原因
                    if selectedSection == 2 {
                        return tableViewDataSourcesArr[selectedSection + sectionViolateTravellerPolicyNum].count
                    }
                    //联系人 信息
                    if selectedSection == 3 {
                        return tableViewDataSourcesArr[selectedSection - sectionViolateTravellerPolicyNum].count
                    }
                }
            }
            
        }else //新版
        {
            // 担保政策 存在
            if sectionGuaranteePolicyNum == 1 {
                
                if selectedSection == 0 {
                    return 1
                }else
                {
                    //违背 差旅政策
                    if sectionViolateTravellerPolicyNum == 1 {
                        
                        //房间 特殊要求
                        if selectedSection < 3 {
                            
                            return self.tableViewDataSourcesArr[selectedSection - sectionGuaranteePolicyNum].count
                            
                        }else
                        {
                            //违背政策  政策 描述
                            if selectedSection == 3 {
                                return self.tableViewDataSourcesArr[selectedSection].count
                                
                            }
                            // 联系人
                            if selectedSection == 4 {
                                return self.tableViewDataSourcesArr[selectedSection - sectionViolateTravellerPolicyNum - sectionGuaranteePolicyNum].count
                            }
                            // 出差信息  成本中心
                            return self.tableViewDataSourcesArr[selectedSection + showBuseinessSection].count
                        }
                    }else //不违背 差旅政策
                    {
                        if selectedSection < 4 {
                            //房间数 + 特殊要求 + 联系人
                            return self.tableViewDataSourcesArr[selectedSection - sectionGuaranteePolicyNum].count
                        }
                        if selectedSection >= 4 {
                            //出差信息 //成本中心
                            return self.tableViewDataSourcesArr[selectedSection + showBuseinessSection].count
                        }
                    }
                }
                
            }else //不存在担保政策
            {
                //不违背 差旅政策
                if sectionViolateTravellerPolicyNum != 1
                {
                    //房间 特殊要求 联系人
                    if selectedSection < 3
                    {
                        return tableViewDataSourcesArr[selectedSection].count
                    }else  // 出差信息  //成本中心
                    {
                        
                        return tableViewDataSourcesArr[selectedSection + userVersion + showBuseinessSection].count
                        
                    }
                }else //违背差旅政策
                {
                    if selectedSection < 2 {
                        
                        return tableViewDataSourcesArr[selectedSection].count
                    }
                    //违背差旅政策 陈述原因
                    if selectedSection == 2 {
                        return tableViewDataSourcesArr[selectedSection + sectionViolateTravellerPolicyNum].count
                    }
                    //联系人 信息
                    if selectedSection == 3 {
                        return tableViewDataSourcesArr[selectedSection - sectionViolateTravellerPolicyNum].count
                    }
                    // 出差信息 成本中心
                    if selectedSection > 3 {
                        return tableViewDataSourcesArr[selectedSection + showBuseinessSection].count
                    }
                }
            }
        }
        
        return 0
    }
    
    func configCell(cell:UITableViewCell,indexPath:IndexPath){
        
        
       
        
    }
    
    
    
    
    
    
    
    func modifyTableViewDataSources(content:String,selectedIndex:IndexPath) {
     
        weak var weakSelf = self
        var index:IndexPath = selectedIndex
        print(index)
        //有担保政策
        if sectionGuaranteePolicyNum  == 1{
            
            // 违背差旅政策
            if sectionViolateTravellerPolicyNum == 1 {
                
                //修改 违背差旅政策 陈述
                if index.section == 3 {
                    weakSelf?.tableViewDataSourcesArr[3][index.row].content = content
                }
                // 修改联系人 信息
                if index.section == 4 {
                 weakSelf?.tableViewDataSourcesArr[2][index.row].content = content
                }
                //修改 出差信息。成本中心
                if index.section > 4 {
                    
                    weakSelf?.tableViewDataSourcesArr[index.section - 1 + showBuseinessSection][index.row].content = content
                }
            }else //不违背 差旅政策
            {
                // 修改联系人 信息
                if index.section == 3 {
                    weakSelf?.tableViewDataSourcesArr[index.section - sectionGuaranteePolicyNum][index.row].content = content
                }
                else
                {
                    //修改 出差信息  成本中心
                 weakSelf?.tableViewDataSourcesArr[index.section + showBuseinessSection][index.row].content = content
                }
            }
        }else //非担保
        {
            
            // 违背差旅政策
            if sectionViolateTravellerPolicyNum == 1 {
                
                //修改 违背差旅政策 陈述
                if index.section == 2 {
                    weakSelf?.tableViewDataSourcesArr[index.section + sectionViolateTravellerPolicyNum][index.row].content = content
                }
                // 修改联系人 信息
                if index.section == 3 {
                    weakSelf?.tableViewDataSourcesArr[index.section - sectionViolateTravellerPolicyNum][index.row].content = content
                }
                //修改 出差信息。成本中心
                if index.section > 3 {
                    
                    weakSelf?.tableViewDataSourcesArr[index.section + showBuseinessSection][index.row].content = content
                }
   
            }else //不违背 差旅政策
            {
                // 修改联系人 信息
                if index.section == 2 {
                    weakSelf?.tableViewDataSourcesArr[index.section][index.row].content = content
                }
                else
                {
                    //修改 出差信息  成本中心
                    weakSelf?.tableViewDataSourcesArr[index.section + userVersion + showBuseinessSection][index.row].content = content
                }
            }
        }
        //有担保  违背差旅政策
        if weakSelf?.sectionGuaranteePolicyNum == 1 && weakSelf?.sectionViolateTravellerPolicyNum == 1 {
            // 差旅政策 违背 陈述
            if index.section == 3 {
                
                weakSelf?.tableViewDataSourcesArr[selectedIndex.section][selectedIndex.row].content = content
//                print(content,selectedIndex,weakSelf?.tableViewDataSourcesArr)
            }
            // 修改联系人 信息
            if  index.section == 4{
                weakSelf?.tableViewDataSourcesArr[2][selectedIndex.row].content = content
//                print(content,selectedIndex,weakSelf?.tableViewDataSourcesArr)
            }
            
        }
        
        
        
        
    }
    
    
    //MARK:---跳转
    func nextToSelectedRoomNumView (parameters:String) {
        
        weak var weakself = self
        self.view.endEditing(true)
        
        if parameters == reserveRoomViewCategoryRoom && PassengerManager.shareInStance.passengerSVDraw().count > 1
        {

            setPickerRoomNumView()
            
            //防止房间数量大于人数 一人一间 房间数量 大于 人数
            //防止房间数量小于 两人一间
            // 选择房间 最大只能按照一人一间
            // 若房间 不能一人一间  可以推荐入住房间
            let psgCount : Int = PassengerManager.shareInStance.passengerSVDraw().count
            pickerRoomNumView.fillDataSources(dataSourcesArr: Array(pickViewRoomDataSourcesArr[psgCount/2 + (psgCount%2 == 0 ? 0 : 1 )-1...psgCount-1]))
        }
        if parameters == reserveRoomViewCategoryTime
        {
            //pickerRoomNumView.pickerViewDatasources = pickViewTimeDataSourcesArr
            setPickerRoomNumView()
            pickerRoomNumView.fillDataSources(dataSourcesArr: pickViewTimeDataSourcesArr)
        }
        if parameters == reserveRoomViewCategoryRequire
        {
            
            let customRequireView = ReserveRoomCustomRequireViewController()
            customRequireView.selectedCustomRequire = selectedCustomRequire
            customRequireView.reserveRoomCustomRequireResultBlock = { (bedType,requiredStr,selectedRequire) in
                var customRequireStr:String  = ""
                if bedType.characters.count > 0 {
                    customRequireStr  = bedType + ","
                    weakself?.reserveRoomViewCategoryRequireOfBedType = bedType
                }
                if  requiredStr.characters.count > 0{
                    customRequireStr  = customRequireStr + requiredStr
                    weakself?.reserveRoomViewCategoryRequireOfSpecial = requiredStr
                }else if requiredStr.characters.count == 0 && customRequireStr.characters.count > 1
                {
                        customRequireStr.remove(at: customRequireStr.index(before: customRequireStr.endIndex))
                }
                if selectedRequire.count > 0
                {
                    weakself?.selectedCustomRequire.removeAll()
                    weakself?.selectedCustomRequire.append(contentsOf: selectedRequire)
                }
                
                weakself?.tableViewDataSourcesArr[1][0].content = customRequireStr
                weakself?.tableView.reloadData()
            }
            self.navigationController?.pushViewController(customRequireView, animated: true)
            
        }
        
        
        //选择 时间
        if (parameters == reserveRoomViewCategoryCheckinDate || parameters == reserveRoomViewCategoryCheckoutDate) {
            
            
            //nextViewSpecialCalendar()
            nextViewTBICalendar()

        }
        // 出差目的
        if parameters == reserveRoomViewCategoryBusinseeTripPurpose{
//            if (companyCustomConfig?.travelTargets?.count)! > 0 {
//                setPickerRoomNumView()
//                pickerRoomNumView.fillDataSources(dataSourcesArr:(companyCustomConfig?.travelTargets)!)
//            }
        
//            let optionsView = TBICommonOptionsView(frame: ScreenWindowFrame,count:(companyCustomSVConfig?.travelPurposes.count)!)
//            optionsView.optionsType = .single
            weak var weakSelf = self
//            optionsView.commonOptionsBlock = { (selecedData) in
//                guard selecedData.count > 0 else {
//                    return
//                }
//                if weakSelf?.showFTMSSpecialConfig == 1 {
//                    weakSelf?.tableViewDataSourcesArr[4][3].content = selecedData.first!
//                }else
//                {
//                    weakSelf?.tableViewDataSourcesArr[4][4].content = selecedData.first!
//                }
//
//                weakSelf?.tableView.reloadData()
//            }
//            optionsView.fillDataSources(data: travelPurposesDataSources)
//            //optionsView.selectedData = companyCustomConfig?.customFields?.first?.selectValue ?? []
//            KeyWindow?.addSubview(optionsView)
            
            let titleArr:[String] = travelPurposesDataSources
           
            let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
            roleView.finderViewSelectedResultBlock = { (cellIndex) in
               if weakSelf?.showFTMSSpecialConfig == 1 {
                 weakSelf?.tableViewDataSourcesArr[4][3].content = titleArr[cellIndex]
               }else{
                 weakSelf?.tableViewDataSourcesArr[4][4].content = titleArr[cellIndex]
               }
                 weakSelf?.tableView.reloadData()
            }
            KeyWindow?.addSubview(roleView)
            roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
        
        }
            
        
        if parameters == reserveRoomViewCategoryBusinseeCostCenter{
            var alertContentArray:[(key:String,value:String)] = []//设置数据 [(key:String,value:String)]   -key为用户名，value为用户对应的成本中心
            let costCenterList =  PassengerManager.shareInStance.passengerSVDraw().first?.costInfoName.components(separatedBy: "-") ?? []
            let costCenterStr:String? = costCenterList.joined(separator: " - ")
            for traveller in PassengerManager.shareInStance.passengerSVDraw(){
                alertContentArray.append((key:traveller.name,value:traveller.costInfoName))
            }
            let tbiALertView2 = TBIAlertView2.init(frame: ScreenWindowFrame)
            tbiALertView2.titleStr = "成本中心"
            tbiALertView2.dataSource = alertContentArray
            tbiALertView2.initView()
            KeyWindow?.addSubview(tbiALertView2)
        }
        if parameters == "联系人" || parameters == "电话号码" || parameters == "邮箱"{
            contactPeopleDataSources.removeAll()
            for element in PassengerManager.shareInStance.passengerSVDraw(){
                if element.passagerId != DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.uid{
                    contactPeopleDataSources.append(element.name)
                }
            }
            contactPeopleDataSources.append((DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.name)!)
            //如果是一个人不弹出
            if contactPeopleDataSources.count > 1
            {
                weak var weakSelf = self
                let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
                roleView.finderViewSelectedResultBlock = { (cellIndex) in
                    
                    weakSelf?.sectionThird[0].content = (weakSelf?.contactPeopleDataSources[cellIndex])!
                    if cellIndex < (PassengerManager.shareInStance.passengerSVDraw().count){
                      
                        weakSelf?.sectionThird[1].content = PassengerManager.shareInStance.passengerSVDraw()[cellIndex].mobiles.first != nil ? PassengerManager.shareInStance.passengerSVDraw()[cellIndex].mobiles.first ?? "" : ""
                       
                       weakSelf?.sectionThird[2].content = PassengerManager.shareInStance.passengerSVDraw()[cellIndex].emails.first != nil ? PassengerManager.shareInStance.passengerSVDraw()[cellIndex].emails.first ?? "" : ""
                     }else{
                        
                        weakSelf?.sectionThird[1].content =   DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.mobiles.first != nil ? (DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.mobiles.first)! : ""
                       weakSelf?.sectionThird[2].content =   DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.emails.first != nil ? (DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.emails.first)! : ""
                        
                    }
                    weakSelf?.tableViewDataSourcesArr[2] = (weakSelf?.sectionThird)!
                    weakSelf?.tableView.reloadData()
               }
   
                KeyWindow?.addSubview(roleView)
                roleView.reloadDataSources(titledataSources: contactPeopleDataSources, flageImage: nil)
            }
        }
        if parameters == reserveRoomViewCategoryBusinseeRemarks {
            
            let type = [1,2,3] // 1,2,3是选择类型
            if type.contains(companyCustomConfig?.customFields?.first?.type ?? 0) {
                let optionsView = TBICommonOptionsView(frame: ScreenWindowFrame,count: companyCustomConfig?.customFields?.first?.defaultValue?.count ?? 0)
                if companyCustomConfig?.customFields?.first?.type == 3 {//多选
                    optionsView.optionsType = .multiple
                }else {//单选
                    optionsView.optionsType = .single
                }
                weak var weakSelf = self
                optionsView.commonOptionsBlock = { (selecedData) in
                    weakSelf?.companyCustomConfig?.customFields?[0].selectValue = selecedData
                    let selectedRemarks = selecedData.toString()
                    weakSelf?.tableViewDataSourcesArr[6][0].content = selectedRemarks
                    
                    weakSelf?.tableView.reloadData()
                }
                optionsView.datasource = companyCustomConfig?.customFields?.first?.defaultValue ?? []
                optionsView.selectedData = companyCustomConfig?.customFields?.first?.selectValue ?? []
                KeyWindow?.addSubview(optionsView)
            }
        }
        
        if parameters == reserveRoomViewCategoryDispolicyReason {
            showDispolicyReasonView()
        }
        
    }
    
    
    /// 违背原因  展示
    func showDispolicyReasonView() {
        weak var weakSelf = self
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            
            weakSelf?.dispolicyReasonSelected(index: cellIndex)
            
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: dispolicyReasonDataSources, flageImage: nil)
    }
    
    func dispolicyReasonSelected(index:NSInteger) {
        guard dispolicyReasonDataSources.count >= index else {
            return
        }
        if  index == dispolicyReasonDataSources.count - 1 {
            // 进入手动输入 页面
            showManualDispolicyReasonView()
        }else{
            disReason = ""
        }
        tableViewDataSourcesArr[3][1].content = dispolicyReasonDataSources[index]
        let indexpath:IndexPath = IndexPath.init(row: 1, section:2 + sectionGuaranteePolicyNum )
        tableView.reloadRows(at:[indexpath] , with: UITableViewRowAnimation.automatic)
        
    }
    /// 展示 手动输入 违背原因
    func showManualDispolicyReasonView()  {
        weak var weakSelf = self
        let dispolicyReasonView = AddDispolicyReasonViewController()
        dispolicyReasonView.contentStr = disReason
        dispolicyReasonView.addDispolicyReasonViewResultBlock = { reason in
            weakSelf?.disReason = reason
            weakSelf?.tableViewDataSourcesArr[3][1].content = reason
            let indexpath:IndexPath = IndexPath.init(row: 1, section:2 + (weakSelf?.sectionGuaranteePolicyNum)! )
            weakSelf?.tableView.reloadRows(at:[indexpath] , with: UITableViewRowAnimation.automatic)
        }
        
        self.navigationController?.pushViewController(dispolicyReasonView, animated: true)
    }
    
    
   
    func filterTravelPurposesDataSources() {
        guard companyCustomSVConfig != nil && (companyCustomSVConfig?.travelPurposes.count)! > 0 else {
            return
        }
        
      
        let travelPurpose = companyCustomSVConfig?.travelPurposes.filter({ $0.type == "2" })
        travelPurposesDataSources = (travelPurpose?.flatMap({ (element) -> String in
            return element.chDesc
        })) ?? [""]
    }
    
    /// 过滤 违背原因
    func filterDispolicyReasonDataSources() {
        guard userSVDetail.busLoginInfo.userBaseInfo.disPolicy.count > 0 else {
            return
        }
        
        
        let dispolicyReason:[LoginResponse.TravelPurposes] = (userSVDetail.busLoginInfo.userBaseInfo.disPolicy.filter({ $0.type == "2" }))
        dispolicyReasonDataSources = dispolicyReason.flatMap({ (element) -> String? in
            return element.chDesc
        })
        dispolicyReasonDataSources.append("手动输入")
        
    }
    
    
    
    
    
    func nextViewTBICalendar() {
        let calendarView = TBICalendarViewController()
        //calendarView.selectedDates = [tmpCheckinDateStr,tmpCheckoutDateStr]
        calendarView.selectedDates = [searchSVCondition.arrivalDateFormat,
                                      searchSVCondition.departureDateFormat]
        calendarView.isMultipleTap = true
        calendarView.showDateTitle = ["入住","离店"]
        weak var weakSelf = self
        calendarView.hotelSelectedDateAcomplishBlock = { (parameters,action) in
            guard action == TBICalendarAction.Done else {
                return
            }
            weakSelf?.searchDate(parameters: parameters, action: action)
            weakSelf?.tableView.reloadData()
        }
         _ = self.navigationController?.pushViewController(calendarView, animated: true)
    }
    
    private func searchDate(parameters:Array<String>?,action:TBICalendarAction) {
        guard action == TBICalendarAction.Done else {
            return
        }
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let travelStartDate:Date = formatter.date(from:(parameters?[0])!) ?? Date()
        let travelEndDate:Date = formatter.date(from:(parameters?[1])!) ?? Date()
        let dateFormatterString = DateFormatter()
        dateFormatterString.dateFormat = "yyyy-MM-dd"
        tableViewDataSourcesArr[4][1].content = dateFormatterString.string(from: travelStartDate)
        tableViewDataSourcesArr[4][2].content = dateFormatterString.string(from: travelEndDate)
    }
    
    
    
    //MARK:- Action
    //MARK:----  选择 最晚到店时间。 选择 房间数量
    func pickViewSelectedIndex(selectedRow:NSInteger,title:String) {
        
        
        if title.range(of: "00") != nil {
            printDebugLog(message: "选择最晚到店时间")
            selectedEndTime = title
            tableViewDataSourcesArr[1][1].content = selectedEndTime
            //校验是否有最晚到店时间的担保信息
            
            if adjustGuaranteeView()
            {
                setAmountTitleButton(state: AmountTitleButtonState.next)
            }else
            {
                setAmountTitleButton(state: AmountTitleButtonState.done)
            }
            
            
        }else if (title.characters.last == "间")
        {
         
            
            //防止房间数量大于人数 一人一间 房间数量 大于 人数
            //防止房间数量小于 两人一间
            // 选择房间 最大只能按照一人一间
            // 若房间 不能一人一间  可以推荐入住房间
//            if PassengerManager.shareInStance.passengerSVDraw().count < selectedRow + 1 || PassengerManager.shareInStance.passengerSVDraw().count > (selectedRow + 1) * 2  {
//                showSystemAlertView(titleStr: "提示", message: "容我再想想")
//                return
//            }
            let passengerCount:NSNumber = NSNumber.init(value:PassengerManager.shareInStance.passengerSVDraw().count)
            let roomMinSum:NSNumber = NSNumber.init(value:ceil(passengerCount.floatValue / 2.0))
            let tmpSelectedRoomSum = roomMinSum.intValue + selectedRow
            
            let total = tmpSelectedRoomSum - selectedRoomSum
            if total > 0 {
                for _ in 0..<total
                {
                    sectionfirst.append(("新增入住人",""))
                }
            }else
            {
                for _ in 0..<abs(total)
                {
                    sectionfirst.remove(at: sectionfirst.count - 1)
                }
            }
            
            // 还有一种情况  有余数的情况 没有验证
            //let isSuccess = adjustPersonalRoom(roomSum: selectedRow + 1, personerSum: PassengerManager.shareInStance.passengerDraw())
//            let psgCount : Int = PassengerManager.shareInStance.passengerSVDraw().count
//            let roomStr : String = CommonTool.returnSubString(Array(pickViewRoomDataSourcesArr[psgCount/2 + (psgCount%2 == 0 ? 0 : 1 )-1...psgCount-1])[selectedRow], withStart: 0, withLenght: 1)
            //let isSuccess = adjustPersonalRoom(roomSum: tmpSelectedRoomSum, personerSum: PassengerManager.shareInStance.passengerSVDraw())
            let isSuccess = adjustSVPersonalRoom(roomSum:tmpSelectedRoomSum)
            
            if isSuccess {
                selectedRoomSum = tmpSelectedRoomSum
                self.tableViewDataSourcesArr[0] = sectionfirst
                adjustTotalMoney()
            }
            
            if adjustGuaranteeView()
            {
                setAmountTitleButton(state: AmountTitleButtonState.next)
            }else
            {
                setAmountTitleButton(state: AmountTitleButtonState.done)
            }
            
            if remainderPersonSVArr.count > 0 {
                remainderPersonSVArr.removeAll()
            }
            
        }else //出差目的
        {
            self.tableViewDataSourcesArr[4][4].content = title
        }
        self.tableView.reloadData()
        
    }

    func adjustTotalMoney() {
        //let amountContent = String.init(format: "¥%.0f",(roomModel.totalRate)!)
        selectedRoomTotalPrice = roomSelected.ratePlanInfo.rate * Float(selectedRoomNightNum)
        let amountContent = "¥" + selectedRoomTotalPrice.OneOfTheEffectiveFraction()
        //(roomModel.totalRate?.OneOfTheEffectiveFraction())!
        let mutableAttribute = NSMutableAttributedString.init(string: amountContent)
        mutableAttribute.addAttributes([NSFontAttributeName:UIFont.systemFont( ofSize: 10)], range: NSRange(location: 0,length: 1))
        amountLabel.attributedText = mutableAttribute
        // zww 酒店订单价格字体不对
       // amountLabel.text = amountContent
    }
    //MARK:----获取公司的个性化设置
    func companyConfig() {
        weak var weakSelf = self
        showLoadingView()
        HotelCompanyService.sharedInstance.companyConfig()
            .subscribe{ event in
                
                weakSelf?.hideLoadingView()
                if case .next(let e) = event {
                    print("个性化设置")
                    print(e)
                    weakSelf?.companyCustomConfig = e
                    if e.customFields?.first?.name.isEmpty == false
                    {
                        self.showRemarkSection = 1
                    }
                    //weakSelf?.showSystemAlertView(titleStr: "成功", message: "获得企业个性化配置")
                    weakSelf?.tableView.reloadData()
                }
                if case .error(let e) = event {
                    print(e)
                    try? weakSelf?.validateHttp(e)
                    //weakSelf?.showSystemAlertView(titleStr: "失败", message: "获得企业个性化失败")
                }
            }.disposed(by: bag)
    }
    

    //MARK:----提交订单 下单
    func amountTitleButtonAction(sender:UIButton)  {
        printDebugLog(message: "amountTitleButtonAction ...")
        if remainderPersonSVArr.count > 0 {
            showSystemAlertView(titleStr: "提示", message: "还有遗漏的小伙伴")
            return
        }
        //placeOrderNew()
        if submitOrder() != nil {
            conmitOrder(request:submitOrder()!)
        }
    }
    
    
    //MARK:---进入担保页面
    func amountTitleButtonNextAction(sender:UIButton)
    {
        if submitOrder() != nil {
            let request = submitOrder()
            intoNextAssuranceInfoView(request: request!)
        }
        
    }
    
    //MARK:----跳转担保页面
    private func intoNextAssuranceInfoView(orderInfo:HotelOrderInfo){
        
        let assuranceInfoView = AssuranceInfoViewController()
        assuranceInfoView.assuranceInfo.hotelId  = hotelDetailForm.hotelId
        let rateId:NSNumber =  roomModel.ratePlanId as NSNumber
        assuranceInfoView.assuranceInfo.ratePlanId = rateId.stringValue
        assuranceInfoView.userVersion = userVersion
        
        assuranceInfoView.assuranceInfo.roomNum =  selectedRoomSum.description
        assuranceInfoView.assuranceInfo.ArrivalDate = searchCondition.arrivalDate
        assuranceInfoView.assuranceInfo.DepartureDate = searchCondition.departureDate
        assuranceInfoView.assuranceHotelOrderInfo = orderInfo
        assuranceInfoView.roomModel = roomModel
        self.navigationController?.pushViewController(assuranceInfoView, animated: true)
    }
    
    
    private func intoNextAssuranceInfoView(request:SubmitOrderVO){
        
        let assuranceInfoView = AssuranceInfoViewController()
        assuranceInfoView.requestOrder = request
        assuranceInfoView.roomSelected = roomSelected
        assuranceInfoView.searchSVCondition = searchSVCondition
        self.navigationController?.pushViewController(assuranceInfoView, animated: true)
    }
    
    
    
    
    
    //MARK:----订单详情页
    private func intoNextOrderDetail(orderNo:String) {
        
        PassengerManager.shareInStance.passengerSVDeleteAll()
        
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
    
    
    
    
    
    
    //MARK:----- 下单
    func submitOrder()-> SubmitOrderVO?{
        let submitOrderRequest:SubmitOrderVO = SubmitOrderVO()
        submitOrderRequest.roomNum = selectedRoomSum
        submitOrderRequest.orderSource = 2
        
        
        for element in sectionfirstSVPersoner {
            
            let passenger:SubmitOrderVO.SubmitDetailVO = SubmitOrderVO.SubmitDetailVO()
            passenger.meal = roomSelected.ratePlanInfo.valueAdd
            passenger.mealCount = NSInteger(roomSelected.ratePlanInfo.mealCount) ?? 0
            //            passenger.passengerName = element.name
            //            passenger.passengerParid = element.passagerId
            passenger.payType = "2"
            passenger.perPrice = NSNumber.init(value:roomSelected.ratePlanInfo.rate)
            passenger.roomType = roomSelected.roomTypeName
            passenger.nightNum = selectedRoomNightNum
            passenger.special = tableViewDataSourcesArr[1][0].content
            passenger.priceDetail = roomSelected.ratePlanInfo.nightRateList
            
            if (element.personerOne.name.isEmpty == true || element.personerOne.name == personRoomPlaceHolder) &&
                (element.personerTwo.name.isEmpty == true || element.personerTwo.name == personRoomPlaceHolder) {
                showSystemAlertView(titleStr: "提示", message: "有房间尚未分配旅客")
                return nil
                
            }
            
            
            if element.personerOne.name.isEmpty == false && element.personerOne.name != personRoomPlaceHolder {
                passenger.passengerName = element.personerOne.name
                passenger.passengerParid = element.personerOne.uid
            }
            if element.personerTwo.name.isEmpty == false && element.personerTwo.name != personRoomPlaceHolder{
                passenger.passengerName += ","
                passenger.passengerParid += ","
                passenger.passengerName += element.personerTwo.name
                passenger.passengerParid += element.personerTwo.uid
            }
            if element.personerOne.name.isEmpty == false && element.personerOne.name != personRoomPlaceHolder ||
                element.personerTwo.name.isEmpty == false && element.personerTwo.name != personRoomPlaceHolder {
                submitOrderRequest.submitDetailVOList.append(passenger)
            }
            
            
            
        }
        

        submitOrderRequest.submitElongData.totalPrice = NSNumber.init(value:selectedRoomTotalPrice)
        submitOrderRequest.submitOwnData.accordPolicy = sectionViolateTravellerPolicyNum == 1 ? "0" : "1"
        submitOrderRequest.submitOwnData.agreementHotel = sectionGuaranteePolicyNum == 0 ? 2: 1
        submitOrderRequest.submitOwnData.hotelName = roomSelected.hotelName
        if orderRemark.value != reserveRoomViewCategoryBusinseeRemarkPlaceHolderTip {
            submitOrderRequest.submitOwnData.remark = orderRemark.value
        }
        
        //联系人信息
        let  contactPersonerInfo:[(title:String,content:String)] = self.tableViewDataSourcesArr[2]
        if contactPersonerInfo[2].content.isEmpty == false {
        submitOrderRequest.submitOwnData.contactEmail = contactPersonerInfo[2].content
        }
        submitOrderRequest.submitOwnData.contactName = contactPersonerInfo.first?.content ?? ""
        submitOrderRequest.submitOwnData.contactPhone = contactPersonerInfo[1].content
        if self.sectionViolateTravellerPolicyNum == 1 {
            
            let userDetail = DBManager.shareInstance.userDetailDraw()
            if userDetail?.busLoginInfo.userBaseInfo.corpCode.uppercased() != Toyota && tableViewDataSourcesArr[3][1].content.isEmpty == true
            {
                showSystemAlertView(titleStr: "提示", message: "填写违背原因")
                return nil
            }
            
            
            submitOrderRequest.submitOwnData.disPolicyReason = (tableViewDataSourcesArr[3][1].content)
        }
        
        let earliestArrivalDate:Date = Date.init(timeIntervalSince1970: TimeInterval(searchSVCondition.arrivalDate)! / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        //let earliestArrivalDay:String =  dateFormatter.string(from:earliestArrivalDate)
        
        let earliestArrivalTimeInterval:TimeInterval = (dateFormatter.date(from: earliestArrivalDate.string(custom: "YYYY-MM-dd") + " 13:00" )?.timeIntervalSince1970)!
        var hourStr:String = ""
        if tableViewDataSourcesArr[1][1].content == "24:00" {
            hourStr = "23:59"
        }else{
            hourStr = tableViewDataSourcesArr[1][1].content
        }
        let latestArrivalTimeInterval:TimeInterval = (dateFormatter.date(from: earliestArrivalDate.string(custom: "YYYY-MM-dd") + " " + hourStr )?.timeIntervalSince1970)!
        
        submitOrderRequest.submitOwnData.earliestArrivalTime = NSNumber.init(value:earliestArrivalTimeInterval * 1000).intValue.description
        submitOrderRequest.submitOwnData.latestArrivalTime = NSNumber.init(value:latestArrivalTimeInterval * 1000).intValue.description
        submitOrderRequest.submitOwnData.hasTravelApply = "1"
        submitOrderRequest.submitOwnData.hotelElongId = roomSelected.hotelElongId
        submitOrderRequest.submitOwnData.hotelFax =  hotelSVDetail.hotelPhone
        submitOrderRequest.submitOwnData.hotelAddress = hotelSVDetail.hotelAddress
        submitOrderRequest.submitOwnData.hotelCity = HotelManager.shareInstance.searchConditionUserDraw().cityId
        submitOrderRequest.submitOwnData.roomTypeId = roomSelected.ratePlanInfo.roomTypeId
        submitOrderRequest.submitOwnData.hotelOwnId = roomSelected.hotelOwnId
        submitOrderRequest.submitOwnData.numberOfCustorm = PassengerManager.shareInStance.passengerSVDraw().capacity
        submitOrderRequest.submitOwnData.orderSource = 3
        submitOrderRequest.submitOwnData.hotelLat = hotelSVDetail.latitude
        submitOrderRequest.submitOwnData.hotelLong = hotelSVDetail.longitude
        submitOrderRequest.submitOwnData.ratePlanId = roomSelected.roomElongId
        submitOrderRequest.submitOwnData.roomTypeId = roomSelected.ratePlanInfo.roomTypeId
        submitOrderRequest.submitOwnData.tripEnd = searchSVCondition.departureDate
        submitOrderRequest.submitOwnData.tripStart = searchSVCondition.arrivalDate
        
        
        if showBuseinessSection == 0 {
            //var travellerInfo = HotelOrderInfo.OrderHotelTravelInfo()
            let departureDateStr:String = tableViewDataSourcesArr[4][1].content
            let returnDateStr:String = tableViewDataSourcesArr[4][2].content
            var  destinations: String = ""
            var  purpose: String = ""
            var  reason: String = ""
            
            if showFTMSSpecialConfig == 0 {
                destinations = tableViewDataSourcesArr[4][3].content
            }else
            {
                destinations = ""
            }
            
            purpose = tableViewDataSourcesArr[4][4 - showFTMSSpecialConfig].content
            reason = tableViewDataSourcesArr[4][5 - showFTMSSpecialConfig].content
            if companyCustomSVConfig?.travelTimeRequire == "1" &&  (departureDateStr.isEmpty == true || returnDateStr.isEmpty == true ) {
                showSystemAlertView(titleStr: "必填项", message: "请选择出差时间")
                return nil
            }
            // 出差地点
            if companyCustomSVConfig?.travelDestRequire == "1" && destinations.isEmpty == true {
                showSystemAlertView(titleStr: "必填项", message: "出差地点填写错误")
                return nil
            }
            //出差目的
            if companyCustomSVConfig?.travelPurposeRequire == "1" && purpose.isEmpty == true {
                showSystemAlertView(titleStr: "必填项", message: "出差目的填写错误")
                return nil
            }
            //出差是由
            if companyCustomSVConfig?.travelReasonRequire == "1"  && reason.isEmpty == true{
                showSystemAlertView(titleStr: "必填项", message: "出差事由填写错误")
                return nil
            }
            //修改时间单位   修改为以秒为单位
            //修改时间单位   修改为以毫秒为单位 doing
            submitOrderRequest.submitOwnData.travelDest = destinations
            submitOrderRequest.submitOwnData.travelPurpose = purpose
            submitOrderRequest.submitOwnData.travelReason = reason
            if  companyCustomSVConfig?.hasTravelTime == "1" {
                // 现在后台需要转化为 yyyy-MM-dd
//                let dateFormatterSecond = DateFormatter()
//                dateFormatterSecond.timeZone = NSTimeZone.system
//                dateFormatterSecond.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                let tmpCheckinDate = dateFormatterSecond.date(from: (departureDateStr + " 00:00:00"))
//                let tmpCheckoutDate = dateFormatterSecond.date(from: (returnDateStr + " 00:00:00"))
//                let intervalCheckinDate = (tmpCheckinDate?.timeIntervalSince1970)! * 1000
//                let intervalCheckoutDate = (tmpCheckoutDate?.timeIntervalSince1970)! * 1000
                submitOrderRequest.submitOwnData.travelTime = departureDateStr//NSNumber.init(value: intervalCheckinDate).stringValue
                submitOrderRequest.submitOwnData.travelRetTime = returnDateStr//NSNumber.init(value: intervalCheckoutDate).stringValue
            }
            
           
            
        }
        
        return submitOrderRequest
    }
    
    
    func conmitOrder(request:SubmitOrderVO) {
        
        weak var weakSelf = self
        storeOrderCity()
        showLoadingView()
       _ = HotelService.sharedInstance
            .hotelSubmitOrder(request: request)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    printDebugLog(message: element)
                    weakSelf?.verifyUserRightApproval(orderArr: element)
                    
                
                //weakSelf?.intoNextOrderDetail(orderNo:element)
                case .error( _ ):
                    weakSelf?.intoNextSubmitOrderFailureView(orderStatus: false)
                //try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
                
        }
    }
    
    ///保存当前订单 的城市
    func storeOrderCity() {
        let currentOrderCity = HotelCityModel()
        currentOrderCity.elongId = HotelManager.shareInstance.searchConditionUserDraw().cityId
        currentOrderCity.cityCode = HotelManager.shareInstance.searchConditionUserDraw().cityId
        currentOrderCity.cnName = HotelManager.shareInstance.searchConditionUserDraw().cityName
        DBManager.shareInstance.userHistoryCityRecordAdd(city: currentOrderCity)
    }
    
    
    /// 验证 是否需要送审
    func verifyUserRightApproval(orderArr:[String]) {
        
        if DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.oaCorp == "1" {
            intoNextSubmitOrderFailureView(orderStatus: true)
        }else{
           getApproval(orderNoArr: orderArr)
            
        }
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
                        weakSelf?.intoNextSubmitOrderFailureView(orderStatus: true)
                    }
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
                
        }
    }
    
    
    func intoNextNewExamineView(approvalGroup:QueryApproveResponseVO.ApproveGroupInfo,orderNoArr:[String]) {
        let examineView = CoNewExamineViewController()
        examineView.approveGroupInfos = approvalGroup
        examineView.orderNoArr = orderNoArr
        examineView.orderType = "2"
        self.navigationController?.pushViewController(examineView, animated: true)
    }
    
    func intoNextSubmitOrderFailureView(orderStatus:Bool) {
        let submitOrderFailureView = SubmitOrderFailureViewController()
        submitOrderFailureView.submitOrderStatus = orderStatus ? .Success_Submit_Order : .Failure_Submit_Order
        self.navigationController?.pushViewController(submitOrderFailureView, animated: true)
    }
    
    
    override func backButtonAction(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
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
