//
//  TripPeopleListViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/23.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift


class TripPeopleListViewController: PersonalBaseViewController {
    
    typealias TripPeopleListViewSelectedBlock = ([PersonalTravellerInfoRequest])->Void
    
    public var tripPeopleListViewSelectedBlock:TripPeopleListViewSelectedBlock!
    
    
    public var peopleListViewType:AppModelCatoryENUM = AppModelCatoryENUM.Default
    

    /// 酒店 不区分 国际 国内 这个 字段 其他业务 还需要
    public var modelInternationalType:AppModelInternationalType = AppModelInternationalType.Default

    // 签证出发日期 "YYYY-MM-dd"
    public var visaDate:String = ""
    
    
    
    /// 共几人
    public var needPassengerSum:NSInteger = 1
    public var childPassengerSum:NSInteger = 0
    public var isIndepend = false

    
    /// 删除人的index
    public var deletePassengerIndex:NSInteger = -1
    
    public var selectedPassengerArr:[PersonalTravellerInfoRequest] = Array()
    
    fileprivate var detailTable = UITableView()
    private let bag = DisposeBag()
    
    
    fileprivate var onlyOnePeopleArr:[String] = Array()
    
    fileprivate var passengerArr:[PersonalTravellerInfoRequest] = Array()
    
    private let newButton:UIButton = UIButton.init(title: "完成", titleColor: TBIThemeWhite, backImageName: "yellow_btn_gradient")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        setBlackTitleAndNavigationColor(title: "添加出行人")
        setNavigationRightButton(title: "新增", titleColor: PersonalThemeMajorTextColor)
        
        
        initTableView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
            passengerListNET()
    }
    
    
    func initTableView() {
        self.view.addSubview(detailTable)
        detailTable.backgroundColor = TBIThemeBaseColor
        detailTable.separatorStyle=UITableViewCellSeparatorStyle.none
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        detailTable.estimatedRowHeight = 200
        detailTable.delegate = self
        detailTable.dataSource = self
        detailTable.bounces = false
        detailTable.rowHeight = UITableViewAutomaticDimension
        detailTable.register(TripPeopleListCell.self, forCellReuseIdentifier: "TripPeopleListCell")
        detailTable.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
        }
        
        self.view.addSubview(newButton)
        newButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        newButton.addTarget(self, action: #selector(newButtonClick(sender:)), for: UIControlEvents.touchUpInside)
    }

    
    func filterPassengerRelationType() {
        onlyOnePeopleArr = ["1","2","3","4","6"]
        for element in passengerArr {
            if element.relationTypeLocal == PersonalTravellerInfoRequest.UserRelationShip.Children ||
                element.relationTypeLocal == PersonalTravellerInfoRequest.UserRelationShip.Other ||
                element.relationTypeLocal == PersonalTravellerInfoRequest.UserRelationShip.Myself {
                continue
            }
            onlyOnePeopleArr = onlyOnePeopleArr.filter { (onlyOneElement) -> Bool in
                if onlyOneElement == element.relationType {
                    return false
                }
                return true
            }
        }
        
        //printDebugLog(message: onlyOnePeopleArr)
        
    }
    
    
    //MARK:-----NET-----
    
    func passengerListNET()  {
        let userId:String = DBManager.shareInstance.userDetailDraw()?.cusLoginInfo.userId ?? ""
        weak var weakSelf = self
        ///showLoadingView()
         PersonalPassengerServices.sharedInstance
            .passengerList(request:userId)
            .subscribe { (event) in
                ///weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    printDebugLog(message: element)
                    weakSelf?.passengerArr = element
                    //weakSelf?.filterPassengerRelationType()
                    weakSelf?.detailTable.reloadData()
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break

                }
            }.addDisposableTo(self.bag)
    }
    
    
    func deletePassengerNET(passengerId:String) {
        guard passengerId.isEmpty == false else {
            return
        }

        weak var weakSelf = self
        showLoadingView()
        PersonalPassengerServices.sharedInstance
            .passengerDelete(passengerId:passengerId)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    if element {
                        weakSelf?.showSystemAlertView(titleStr: "提示", message: "删除成功!")
                        if weakSelf?.deletePassengerIndex != -1 && weakSelf?.selectedPassengerArr.isEmpty == false {
                            ///从已选择的联系人数组中删除
                            for i in 0...(weakSelf?.selectedPassengerArr.count)!-1{
                                if weakSelf?.selectedPassengerArr[i].id == weakSelf?.passengerArr[(weakSelf?.deletePassengerIndex)!].id{
                                    weakSelf?.selectedPassengerArr.remove(at: i)
                                }
                            }
                        }
                        weakSelf?.passengerArr.remove(at: (weakSelf?.deletePassengerIndex)!)
                        let indexPath:IndexPath = IndexPath.init(row: (weakSelf?.deletePassengerIndex)!, section: 0)
                         weakSelf?.detailTable.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                    }else{
                        weakSelf?.deletePassengerIndex = -1
                        weakSelf?.showSystemAlertView(titleStr: "提示", message: "删除失败!")
                    }
                    
                case .error(let error):
                    weakSelf?.deletePassengerIndex = -1
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                    
                }
            }.addDisposableTo(self.bag)
    }

    
    
    //MARK: -------- Action ------
    override func backButtonAction(sender: UIButton) {
        ///如果删除了
        if deletePassengerIndex != -1{
            tripPeopleListViewSelectedBlock(selectedPassengerArr)
        }        
        self.navigationController?.popViewController(animated: true)
    }
    override func rightButtonAction(sender: UIButton) {
        
        let tripVC:TripPeopleDetailViewController = TripPeopleDetailViewController()
        printDebugLog(message: onlyOnePeopleArr)
        filterPassengerRelationType()
        tripVC.onlyOnePeopleArr = onlyOnePeopleArr
        self.navigationController?.pushViewController(tripVC, animated: true)
        
       
    }
    
    
    
    /// 个人机票 选择出行人 特殊要求
    ///
    /// 符合要求 为 true 不符合 要求 false
    func personalFlightCustomConfig()->(isSuccess:Bool,error:String) {
        if selectedPassengerArr.isEmpty == true {
            return (false,"请选择出行人")
        }
        let isPassportNoCorrect:Bool = selectedPassengerArr.contains { (element) -> Bool in
            if element.passportNo.isEmpty == true {
                return false
            }
            return true
        }
        let isMainlandIdCorrect:Bool = selectedPassengerArr.contains { (element) -> Bool in
            if element.certNo.isEmpty == true {
                return false
            }
            return true
        }
        
        if isPassportNoCorrect == false && modelInternationalType.isInternational() == true {
            //showSystemAlertView(titleStr: "提示", message: )
            return (false,"护照信息不完整")
        }
        
        if isMainlandIdCorrect == false && modelInternationalType.isInternational() == false {
            //showSystemAlertView(titleStr: "提示", message: "身份证信息不完整")
            return (false,"身份证信息不完整")
        }
        
        var isOnlyChild:Bool = false
        for element in selectedPassengerArr {
            if element.isChild == false {
                isOnlyChild = true
                break
            }
        }
        return (isOnlyChild,"儿童不可单独出行!")
       //return (true,"")
    }
    
    
    /// 个人 旅游 选择出行人 特殊要求
    ///
    /// 符合要求 为 true 不符合 要求 false
    func personalTravelCustomConfig() -> (isSuccess:Bool,error:String){
        
        
        let isPassportNoCorrect:Bool = selectedPassengerArr.contains { (element) -> Bool in
            if element.passportNo.isEmpty == true {
                return false
            }
            return true
        }
        let isMainlandIdCorrect:Bool = selectedPassengerArr.contains { (element) -> Bool in
            if element.certNo.isEmpty == true {
                return false
            }
            return true
        }
        
        if isPassportNoCorrect == false && modelInternationalType.isInternational() == true {
            showSystemAlertView(titleStr: "提示", message: "护照信息不完整")
            return (false,"护照信息不完整")
        }
        
        if isMainlandIdCorrect == false && modelInternationalType.isInternational() == false {
            showSystemAlertView(titleStr: "提示", message: "身份证信息不完整")
            return (false,"身份证信息不完整")
        }
        
        
        
        var isSuccess:Bool = false
        var childNum:Int = 0
        
        
        for i in 0...selectedPassengerArr.count-1{
            let model:PersonalTravellerInfoRequest = selectedPassengerArr[i]
            ///如果是国际，选护照
            if modelInternationalType == .PersonalInternationalTravel{
                if model.passportNo.isEmpty {
                    //showSystemAlertView(titleStr: "提示", message: )
                    return (false,"护照信息不完整")
                }
            }
        }
        
        
        ///如果是自由行
        if isIndepend == true
        {
            for model in selectedPassengerArr {
                if model.isChild{
                    childNum = childNum + 1
                }
            }
        }
        ///如果是自由行
        if isIndepend == true
        {
            if childNum != childPassengerSum{
                //showSystemAlertView(titleStr: "提示", message: )
                return (false,(childPassengerSum == 0 ? "出行人不能选择儿童" :"请选择\(childPassengerSum)个儿童"))
            }
        }
        
        
        return (true,"")
    }
    
    
    /// 个人 签证 选择出行人 特殊要求
    ///
    /// 符合要求 为 true 不符合 要求 false
    func personalVisaCustomConfig() -> (isSuccess:Bool,error:String) {
        
        let isPassportNoCorrect:Bool = selectedPassengerArr.contains { (element) -> Bool in
            if element.passportNo.isEmpty == true {
                return false
            }
            return true
        }
        let isMainlandIdCorrect:Bool = selectedPassengerArr.contains { (element) -> Bool in
            if element.certNo.isEmpty == true {
                return false
            }
            return true
        }
        
        if isPassportNoCorrect == false && modelInternationalType.isInternational() == true {
           // showSystemAlertView(titleStr: "提示", message: "护照信息不完整")
            return (false,"护照信息不完整")
        }
        
        if isMainlandIdCorrect == false && modelInternationalType.isInternational() == false {
            //showSystemAlertView(titleStr: "提示", message: )
            return (false,"身份证信息不完整")
        }
        return (true,"")
    }
    
    
    
    
    /// 个人酒店 选择出行人 的特殊要求
    /// 符合要求 为 true 不符合 要求 false
    func personalHotelCustomeConfig() ->(isSuccess:Bool,error:String){
        if selectedPassengerArr.isEmpty == true {
            return (false,"请选择出行人")
        }
//        let isPassportNoCorrect:Bool = selectedPassengerArr.contains { (element) -> Bool in
//            if element.passportNo.isEmpty == true {
//                return false
//            }
//            return true
//        }
//        let isMainlandIdCorrect:Bool = selectedPassengerArr.contains { (element) -> Bool in
//            if element.certNo.isEmpty == true {
//                return false
//            }
//            return true
//        }
//        
//        if isPassportNoCorrect == false && isMainlandIdCorrect == false {
//            return  (false,"证件信息不完整")
//        }
//        
        
        var isOnlyChild:Bool = false
        for element in selectedPassengerArr {
            if element.isChild == false {
                isOnlyChild = true
                break
            }
        }
        return (isOnlyChild,"儿童不可单独出行!")
    }
    
    
    
    
    
    func selectedAndCancelPassenger(selectedIndex:NSInteger,currentTitle:String) {
        guard currentTitle.isEmpty == false else {
            showSystemAlertView(titleStr: "提示", message: "信息不全,请补充")
            return
        }
        guard passengerArr.count > selectedIndex else {
            return
        }
        let selectedPassenger:PersonalTravellerInfoRequest = passengerArr[selectedIndex]
        
        let isContain = selectedPassengerArr.contains { (element) -> Bool in
            return element.id == selectedPassenger.id
        }
        
        if isContain == true {
         selectedPassengerArr = selectedPassengerArr.flatMap { (element) -> PersonalTravellerInfoRequest? in
                if element.id != selectedPassenger.id {
                    return element
                }
            return nil
            }
        }else{
            switch peopleListViewType{
                
            case .PersonalFlight,.PersonalHotel:
                selectedPassengerArr.append(selectedPassenger)
            case .Default:
                if selectedPassengerArr.count >= needPassengerSum && isContain == false {
                    return
                }
                if selectedPassengerArr.count < needPassengerSum {
                    selectedPassengerArr.append(selectedPassenger)
                }
            default:break
            }
        }
        detailTable.reloadData()
    }
    
    
    

}
extension TripPeopleListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passengerArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  120
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        if indexPath.row == 0 {
            return false
        }
        return true
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            deletePassengerIndex = indexPath.row
            deletePassengerNET(passengerId: passengerArr[indexPath.row].id)
        }
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TripPeopleListCell = tableView.dequeueReusableCell(withIdentifier: "TripPeopleListCell") as! TripPeopleListCell
//        model.vpName = "王楠楠"
//        model.vpPassportno = "12334444555666"
        if passengerArr.count > indexPath.row {
            weak var weakSelf = self
            let isSelectedIndex:Bool = selectedPassengerArr.contains(where: { (element) -> Bool in
                if passengerArr[indexPath.row].id == element.id {
                    return true
                }
                return false
            })
            
            for (index,element) in selectedPassengerArr.enumerated() {
                if passengerArr[indexPath.row].id == element.id {
                    selectedPassengerArr[index] = passengerArr[indexPath.row]
                    break
                }
            }
            
           
            cell.setCellWithModel(model: passengerArr[indexPath.row],cellRow:indexPath.row, isSelected: isSelectedIndex,type:modelInternationalType)
            cell.tripPeopleListSelectedBlock = { selectedIndex,currentTitle in
                weakSelf?.selectedAndCancelPassenger(selectedIndex: selectedIndex, currentTitle: currentTitle)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard passengerArr.count > indexPath.row else {
            return
        }
        filterPassengerRelationType()
        let tripVC:TripPeopleDetailViewController = TripPeopleDetailViewController()
        tripVC.passenger = passengerArr[indexPath.row]
        tripVC.onlyOnePeopleArr = onlyOnePeopleArr
        self.navigationController?.pushViewController(tripVC, animated: true)
    }
    func newButtonClick(sender:UIButton){
        weak var weakSelf = self
        guard selectedPassengerArr.count > 0 else {
            showSystemAlertView(titleStr: "提示", message: "请选择出行人")
            return
        }
//        let isPassportNoCorrect:Bool = selectedPassengerArr.contains { (element) -> Bool in
//            if element.passportNo.isEmpty == true {
//                return false
//            }
//            return true
//        }
//        let isMainlandIdCorrect:Bool = selectedPassengerArr.contains { (element) -> Bool in
//            if element.certNo.isEmpty == true {
//                return false
//            }
//            return true
//        }
//
//        if isPassportNoCorrect == false && modelInternationalType.isInternational() == true {
//            showSystemAlertView(titleStr: "提示", message: "护照信息不完整")
//            return
//        }
//
//        if isMainlandIdCorrect == false && modelInternationalType.isInternational() == false {
//            showSystemAlertView(titleStr: "提示", message: "身份证信息不完整")
//            return
//        }
        var isExpiredPassenger:Bool = selectedPassengerArr.count == needPassengerSum ? true : false
        var isSuccess:(isSuccess:Bool,error:String)  = (true,"")
        switch peopleListViewType {
        case .PersonalFlight,.PersonalOnsaleFlight,.PersonalSpecialFlight:
            isExpiredPassenger = true
            isSuccess = personalFlightCustomConfig()
        case .PersonalHotel,.PersonalSpecialHotel:
            isSuccess = personalHotelCustomeConfig()
        case .PersonalVisa:
            isSuccess = personalVisaCustomConfig()
        case .PersonalTravel:
            isSuccess = personalTravelCustomConfig()
            
        default:break
            
        }
        if !isSuccess.isSuccess {
            showSystemAlertView(titleStr: "提示", message: isSuccess.error)
            return
        }
        
        if isExpiredPassenger  == false {
            showSystemAlertView(titleStr: "提示", message: "用户出行人数选择不符")
            return
        }
        
        
        if isExpiredPassenger  && tripPeopleListViewSelectedBlock != nil {
            tripPeopleListViewSelectedBlock(selectedPassengerArr)
            weakSelf?.navigationController?.popViewController(animated: true)
        }
    }
}
