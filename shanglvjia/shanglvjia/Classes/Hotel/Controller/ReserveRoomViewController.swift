//
//  ReserveRoomViewController.swift
//  shop
//
//  Created by manman on 2017/4/22.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift

enum AmountTitleButtonState {
    case next
    case done
    
}

class ReserveRoomViewController: CompanyBaseViewController,UITableViewDelegate,UITableViewDataSource{
    
    //public var hotelRoomDetail:HotelDetail.HotelRoom = HotelDetail.HotelRoom()
    public var hotelSVDetail:HotelDetailResult.HotelRoomPlan = HotelDetailResult.HotelRoomPlan()
    
    public var searchSVCondition:HotelListRequest = HotelListRequest()
    
    public var hotelDetailForm:HotelDetailForm = HotelDetailForm()
    public var searchCondition:HotelSearchForm = HotelSearchForm()
    public var roomModel:RoomModel = RoomModel()
    
    private let reserveRoomTableViewHeaderViewIdentify = "reserveRoomTableViewHeaderViewIdentify"
    
    private let reserveRoomTableViewCellIdentify = "reserveRoomTableViewCellIdentify"
    
    private let reserveRoomTableViewCellViewIdentify = "reserveRoomTableViewCellViewIdentify"
    
    //nestTableView
    private let reserveRoomNestTableViewCellIdentify = "reserveRoomNestTableViewCellIdentify"
    private let reserveRoomSystemTableViewCellIdentify = "reserveRoomSystemTableViewCellIdentify"
    
    private let personRoomPlaceHolder:String = "新增入住人"
    private let reserveRoomViewCategoryRoom = "房间数"
    private let reserveRoomViewCategoryTime = "最晚到店时间"
    private let reserveRoomViewCategoryRequire = "特殊要求"
    private var reserveRoomViewCategoryRequireOfBedType = ""
    private var reserveRoomViewCategoryRequireOfSpecial = ""
    
    
    private var placeOrderModel:HotelOrderInfo?
    private var tableView:UITableView = UITableView()
    private var nestTableView:UITableView = UITableView()
    private var tableViewDataSourcesArr:[[(title:String,content:String)]] = NSArray() as! [[(title: String, content: String)]]
    private var selectTextField:UITextField?//释放
    private var selectedCustomRequire:[UIButton] = Array()
    //底部 控件
    private var bottomBackgroundView = UIView()
    private var amountTitleLabel = UILabel()
    private var amountLabel = UILabel()
    // 下一步 或者 提交
    private var amountTitleButton = UIButton()
    //担保政策描述。
    private var guaranteeDescription:String?
    
    //是否存在担保 1 需要担保 0不需要担保
    private var assuranceSection:NSInteger = 1
    //房间数量
    private var selectedRoomSum:NSInteger = 1
    //最晚到店时间
    private var selectedEndTime:String = "18:00"
    
    //headerView 现在要正常显示为一个cell 视图  0 显示为headerView   1 显示为 cellView
    //headerView 单独显示为一个 section 0
    private var showHeaderViewSpecialConfig:NSInteger = 0
    
    private var sectionfirst:[(title:String,content:String)] = [("房间数",""),("入住人","")]
    private let pickViewRoomDataSourcesArr:[String] = ["1间","2间","3间","4间","5间","6间","7间","8间","9间","10间"]
    private let pickViewTimeDataSourcesArr:[String] = ["14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00","24:00"]
    private var pickerRoomNumView:TBIPickerView = TBIPickerView()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setBlackTitleAndNavigationColor(title: self.title!)
        self.view.backgroundColor = TBIThemeBaseColor
        showHeaderViewSpecialConfig = 1
        setUIViewAutolayout()
        localDataNew()
        
    }
    
    func localDataNew() {
        
        
        let sectionSecond:[(title:String,content:String)] = [("特殊要求","无"),("最晚到店时间","")]
        var sectionThird:[(title:String,content:String)] = [("联系人",""),("电话号码","")]
        let sectionForth:[(title:String,content:String)] = [("支付方式","")]
        
        
        
        let userInfo = UserService.sharedInstance.userDetail()
        if userInfo?.name != nil {
            sectionThird[0].content = (userInfo?.name)!
        }
        if userInfo?.userName != nil {
            sectionThird[1].content = (userInfo?.userName)!
        }
        tableViewDataSourcesArr = [sectionfirst ,sectionSecond ,sectionThird ,sectionForth ]
        setBottomView()
        self.view.addSubview(bottomBackgroundView)
        
        // 没有担保政策 更改为提交
        tableViewDataSourcesArr[1][1].content = selectedEndTime
        adjustTotalMoney()
        if adjustGuaranteeView() {
            setAmountTitleButton(state: AmountTitleButtonState.next)
            //guaranteeDescription = roomModel.guaranteeRuleDescription
        }else
        {
            //assuranceSection = 0
            setAmountTitleButton(state: AmountTitleButtonState.done)
        }
        
        
    }
    

    
    // true 需要担保  false 不需要担保
    func adjustGuaranteeView()-> Bool {
        if verifyGuaranteeRuleNew()
        {
            assuranceSection = 1
            guaranteeDescription = roomModel.guaranteeRuleDescription
            return true
        }else
        {
            assuranceSection = 0
            return false
        }
    }
    
    
    // true 需要担保  false 不需要担保
    func verifyGuaranteeRuleNew() -> Bool {
        if roomModel.amountGuarantee == false && roomModel.timeGuarantee == false
        {
            return true
        }
        //房量担保
        if roomModel.amountGuarantee == true && roomModel.timeGuarantee == false {
            
            if (roomModel.amount)! <= selectedRoomSum  {
                return true
            }
        }
        //到店时间担保
        if roomModel.amountGuarantee == false && roomModel.timeGuarantee == true {
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
       
        if Int(startTimeArr.first! )! <= Int(verifyTimeArr.first!)!{
            return true
        }
        return false
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- 定制视图
    
    func setUIViewAutolayout() {
        
//        tableView.frame = self.view.frame
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(ReserveRoomTableViewCell.classForCoder(), forCellReuseIdentifier: reserveRoomTableViewCellIdentify)
        if showHeaderViewSpecialConfig == 0 {
          tableView.register(ReserveRoomTableViewHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: reserveRoomTableViewHeaderViewIdentify)
        }else
        {
            //替换全局的headerView
            let headerView:ReserveRoomTableViewHeaderView = ReserveRoomTableViewHeaderView.init(reuseIdentifier:reserveRoomTableViewHeaderViewIdentify)
            headerView.frame = CGRect.init(x: 0, y: 0, width: ScreenWindowWidth, height: 229 + 10 + 70 - 10)
            headerView.fillDataSourcesNew(hotelRoomDetail: roomModel, checkinDateStr: self.hotelDetailForm.arrivalDate, checkoutDateStr: hotelDetailForm.departureDate, accordTravel:0)
            tableView.tableHeaderView = headerView
            //在iOS9 上 多注意 10 对这个优化过了
        }
        
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(44)
        }
        
        
        nestTableView.delegate = self
        nestTableView.dataSource = self
        nestTableView.bounces = false
        nestTableView.isScrollEnabled = false
        nestTableView.showsVerticalScrollIndicator = false
        nestTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        nestTableView.register(SingleContentTableViewCell.classForCoder(), forCellReuseIdentifier:reserveRoomNestTableViewCellIdentify)
        
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
        
        amountTitleLabel.text = "总价:"
        amountTitleLabel.font = UIFont.systemFont(ofSize: 13)
        bottomBackgroundView.addSubview(amountTitleLabel)
        amountTitleLabel.snp.makeConstraints { (make) in
            
            make.left.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(60)
            
        }
        amountLabel.textColor = TBIThemeOrangeColor
        amountLabel.font = UIFont.systemFont(ofSize: 16)
        amountLabel.text = ""
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
        amountTitleButton.backgroundColor = TBIThemeOrangeColor
        amountTitleButton.addTarget(self, action: #selector(amountTitleButtonNextAction(sender:)), for: UIControlEvents.touchUpInside)
        bottomBackgroundView.addSubview(amountTitleButton)
        amountTitleButton.snp.makeConstraints { (make) in
            
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            
            
        }
        
        
        
    }
    
    func setAmountTitleButton(state:AmountTitleButtonState) {
        
        switch state {
        case .next:
            amountTitleButton.removeTarget(self, action: nil, for: UIControlEvents.touchUpInside)
            amountTitleButton.setTitle("下一步", for: UIControlState.normal)
            amountTitleButton.addTarget(self, action: #selector(amountTitleButtonNextAction(sender:)), for: UIControlEvents.touchUpInside)
            tableViewDataSourcesArr[3][0].content = "个人支付-信用卡担保"
            tableView.reloadData()
            
            
        case .done:
            amountTitleButton.removeTarget(self, action: nil, for: UIControlEvents.touchUpInside)
            amountTitleButton.setTitle("提交", for: UIControlState.normal)
            amountTitleButton.addTarget(self, action: #selector(amountTitleButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            tableViewDataSourcesArr[3][0].content = "个人支付-前台现付"
            tableView.reloadData()
        }
    }
    
    
    
    
    //MARK:- UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == nestTableView {
            return 1
        }
        return tableViewDataSourcesArr.count + assuranceSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //房间数量  入住人
        if tableView == nestTableView  {
            return selectedRoomSum
        }
        
        
        
        var sectionArr:[(title:String,content:String)] = Array()
        
       
        if assuranceSection == 1 && section == 0  {
            
            return 1
        }
        
        // add by manman on start of line  2017-07-29
        // 房间数量 特殊处理 无担保政策
        if assuranceSection == 0 && section == 0  || assuranceSection == 1 && section == 1 {
            return 2
        }
        //end of line
        
        
        
        // The first Method 
        // 房间数量   特殊要求／最晚到点时间 联系人 支付方式
        if tableViewDataSourcesArr.count > 1 {
            if assuranceSection == 1
            {
                sectionArr = tableViewDataSourcesArr[section - 1]
                
            }else
            {
                sectionArr = tableViewDataSourcesArr[section]
            }
        }
       
        return sectionArr.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      
        
        // add by manman  beacause nestTableView  start of line 
        if tableView == nestTableView {
            
            
            // 房间数量  入住人
            weak var weakself = self
            let cell:SingleContentTableViewCell = tableView.dequeueReusableCell(withIdentifier: reserveRoomNestTableViewCellIdentify) as! SingleContentTableViewCell
            
            cell.singleContentTableViewCellComplateBlock = { (content,cellIndex) in
                
                print(content,cellIndex)
                weakself?.tableViewDataSourcesArr[0][cellIndex.row + 1].content = content
            }
            
            
            
            var contentPlaceHolder = "请输入入住人姓名"
            var content = ""
            var showBottomLine:Bool = true
            
            if tableViewDataSourcesArr[0][indexPath.row + 1].content.characters.count > 0 {
                content = tableViewDataSourcesArr[0][indexPath.row + 1].content
                contentPlaceHolder = ""
            }
            if indexPath.row == selectedRoomSum - 1 {
                showBottomLine = false
            }
            
            
            cell.fillDataSources(content: content, placeHolder: contentPlaceHolder, contentEnable: true, showLine: showBottomLine, indexPath: indexPath)
            return cell
            
        }
        
        
        
        
        // end of line
        
        
        
        
        // tableViewHeaderView 更改为cellView section first
        //add by manman   start of line
//        if showHeaderViewSpecialConfig == 1 && indexPath.section == 0 {
//            
//            let cellView:ReserveRoomTableViewHeaderView = tableView.dequeueReusableCell(withIdentifier: reserveRoomTableViewCellViewIdentify) as! ReserveRoomTableViewHeaderView
//            cellView.fillDataSourcesNew(hotelRoomDetail: roomModel, checkinDateStr: self.hotelDetailForm.arrivalDate, checkoutDateStr: hotelDetailForm.departureDate, accordTravel:0)
//            
//            return cellView
//        }
        // end of line
        let cell:ReserveRoomTableViewCell = tableView.dequeueReusableCell(withIdentifier: reserveRoomTableViewCellIdentify) as! ReserveRoomTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let selectedRoomStr:String = String(selectedRoomSum) + "间"
        weak var weakself = self
        
        cell.reserveRoomTableViewContentResultBlock = { (textField,cellIndexPath) in
            print("传值回控制器 ...")
            
            weakself?.selectTextField = textField
            var index:Int = cellIndexPath.section
            
            print(index)
            if weakself?.assuranceSection == 1 {
                index = cellIndexPath.section - 1
            }
            
            weakself?.tableViewDataSourcesArr[index][indexPath.row].content = textField.text!
            //print(textField,cellIndexPath,weakself?.tableViewDataSourcesArr)
            weakself?.selectTextField?.resignFirstResponder()
        }
        
        
        if assuranceSection == 1 {
            
            if indexPath.section  == 0
            {
                
                
                if guaranteeDescription == nil {
                    guaranteeDescription = ""
                }
                cell.fillDataSource(title:"担保政策", contentPlaceHolder: "", contentCertain: false, content: guaranteeDescription!, contentEnable: false, intoNextEnable: false,showLineEnable:false, cellIndex: indexPath)
                return cell
            }
        }
        
        
        // 房间数量  入住人
        var sectionArr:[(title:String,content:String)] = Array()
        if assuranceSection == 1 {
            sectionArr = tableViewDataSourcesArr[indexPath.section - assuranceSection]
        }else
        {
            sectionArr = tableViewDataSourcesArr[indexPath.section]
        }
        
        if indexPath.section == 0 + assuranceSection {
            
            
            if indexPath.row == 0 {
                
                sectionArr[indexPath.row].content = selectedRoomStr
                cell.fillDataSource(title: sectionArr[indexPath.row].title, contentPlaceHolder: "", contentCertain: false, content:selectedRoomStr, contentEnable: false, intoNextEnable: true,showLineEnable:true, cellIndex: indexPath)
                
                return cell
            }
            
            if selectedRoomSum == 1 {
                var contentPlaceHolder = "请输入入住人姓名"
                var content = ""
                if sectionArr[indexPath.row].content.characters.count > 0 {
                    content = sectionArr[indexPath.row].content
                    contentPlaceHolder = ""
                }
                cell.fillDataSource(title: sectionArr[indexPath.row].title, contentPlaceHolder: contentPlaceHolder, contentCertain: false, content: content, contentEnable: true, intoNextEnable: false, showLineEnable: false, cellIndex: indexPath)
                
            }else
            {
                
                
              cell.fillDataSource(title: sectionArr[indexPath.row].title, contentPlaceHolder: "", contentCertain: false, content: "", contentEnable: false, intoNextEnable: false, showLineEnable: false, cellIndex: indexPath)
                cell.contentView.addSubview(nestTableView)
                nestTableView.snp.makeConstraints({ (make) in
                    make.top.bottom.equalToSuperview()
                    make.left.equalTo(120)
                    make.right.equalToSuperview().inset(15)
                    
                })
            }
            
            
        }
        //特殊要求 最晚到店时间
        if indexPath.section == 1 + assuranceSection{
            
            if indexPath.row == 0 {
                cell.fillDataSource(title: sectionArr[indexPath.row].title, contentPlaceHolder: "", contentCertain: false, content:sectionArr[indexPath.row].content, contentEnable: false, intoNextEnable: true, showLineEnable: true, cellIndex: indexPath)
            }
            if indexPath.row == 1 {
                sectionArr[indexPath.row].content = selectedEndTime
                cell.fillDataSource(title: sectionArr[indexPath.row].title, contentPlaceHolder: "", contentCertain: false, content: sectionArr[indexPath.row].content, contentEnable: false, intoNextEnable: true, showLineEnable: false, cellIndex: indexPath)
            }
            
        }
        
        //联系人信息
        if indexPath.section == 2 + assuranceSection {
            
            var contentFirstPlaceHolder = "请输入联系人姓名"
            var contentSecondPlaceHolder = "请输入联系人电话号码"
            var content = ""
             if sectionArr[indexPath.row].content.characters.count > 1
             {
                content = sectionArr[indexPath.row].content
            }
            
            
            
            if indexPath.row == 0 {
                if content.characters.count > 1 {
                    contentFirstPlaceHolder = ""
                }
                
                cell.fillDataSource(title: sectionArr[indexPath.row].title, contentPlaceHolder: contentFirstPlaceHolder, contentCertain: false, content: content, contentEnable: true, intoNextEnable: false,showLineEnable:true, cellIndex: indexPath)
            }
            
            
            
            if indexPath.row == 1 {
                if content.characters.count > 1 {
                    contentSecondPlaceHolder = ""
                }
                
                cell.fillDataSource(title: sectionArr[indexPath.row].title, contentPlaceHolder: contentSecondPlaceHolder, contentCertain: false, content: content, contentEnable: true, intoNextEnable: false, showLineEnable: false, cellIndex: indexPath)
            }
            
        }
        if indexPath.section == 3 + assuranceSection{
            
             if indexPath.row == 0 {

                    cell.fillDataSource(title: sectionArr[indexPath.row].title, contentPlaceHolder: "", contentCertain: false, content: sectionArr[indexPath.row].content, contentEnable: false, intoNextEnable: false, showLineEnable: false, cellIndex: indexPath)
                
            }
        }
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        guard tableView != nestTableView else {
            return 0
        }
        if showHeaderViewSpecialConfig == 0 {
            if section == 0{
                return 229 + 10 + 70 - 10
            }else
            {
                return 10
            }
            
        }else
        {
            return 10
           
        }
       
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        guard tableView != nestTableView else {
            return nil
        }
        
        
       
        if section == 0 && showHeaderViewSpecialConfig == 0  {
            let headerView:ReserveRoomTableViewHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: reserveRoomTableViewHeaderViewIdentify) as! ReserveRoomTableViewHeaderView
            headerView.fillDataSourcesNew(hotelRoomDetail: roomModel, checkinDateStr: self.hotelDetailForm.arrivalDate, checkoutDateStr: hotelDetailForm.departureDate, accordTravel:0)
            
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
        
        if tableView == nestTableView {
            return 45
        }
        
        if assuranceSection == 1 && indexPath.section == 0
        {
            
          return getTextHeigh(textStr: guaranteeDescription, font: UIFont.systemFont( ofSize: 13), width: ScreenWindowWidth - 30 ) + 44 + 15
            
        }
        
        //  add by manman  2017-07-29 start of line 
        if assuranceSection == 1 && indexPath.section == 1 && indexPath.row == 1 ||
            assuranceSection == 0 && indexPath.section == 0 && indexPath.row == 1 {
            return CGFloat(45 * selectedRoomSum)
        }
        // end of line
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        printDebugLog(message: "didSelectRow ")
        
      
        let cell:ReserveRoomTableViewCell = tableView.cellForRow(at: indexPath) as! ReserveRoomTableViewCell
        
        let title:String = (cell.categoryTitleLabel.text?.description)!
       
        nextToSelectedRoomNumView(parameters: title)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectTextField?.resignFirstResponder()
    }
    
    func getTextHeigh(textStr:String?,font:UIFont,width:CGFloat) -> CGFloat {
        
        if textStr?.characters.count == 0 || textStr == nil {
            return 0.0
        }
        let normalText: NSString = textStr as! NSString
        let size = CGSize(width:width,height:1000)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        return stringSize.height
    }
    func placeOrder() {
        
        //HotelService.sharedInstance.placeOrder(order: )
        
    }
    
    
    
    
    
    //MARK:---跳转
    func nextToSelectedRoomNumView (parameters:String) {
        
        if parameters == reserveRoomViewCategoryRoom
        {
            //pickerRoomNumView.pickerViewDatasources = pickViewRoomDataSourcesArr
            setPickerRoomNumView()
            pickerRoomNumView.fillDataSources(dataSourcesArr:pickViewRoomDataSourcesArr )
        }
        if parameters == reserveRoomViewCategoryTime
        {
            //pickerRoomNumView.pickerViewDatasources = pickViewTimeDataSourcesArr
            setPickerRoomNumView()
            pickerRoomNumView.fillDataSources(dataSourcesArr:pickViewTimeDataSourcesArr)
        }
        if parameters == reserveRoomViewCategoryRequire
        {
            weak var weakself = self
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
                }
                else if requiredStr.characters.count == 0 && customRequireStr.characters.count > 1
                {
                    customRequireStr.remove(at: customRequireStr.index(before: customRequireStr.endIndex))
                }
                if selectedRequire.count > 0 {
                    weakself?.selectedCustomRequire.removeAll()
                    weakself?.selectedCustomRequire.append(contentsOf: selectedRequire)
                }
                
                
                weakself?.tableViewDataSourcesArr[1][0].content = customRequireStr
                weakself?.tableView.reloadData()
            }
            self.navigationController?.pushViewController(customRequireView, animated: true)
            
        }
        
    }

    
    
    
    
    
    
    //MARK:- Action
    //MARK:--  选择最晚到点时间  房间数量
    func pickViewSelectedIndex(selectedRow:NSInteger,title:String) {
        
        if title.range(of: "00") != nil {
            printDebugLog(message: "选择最晚到店时间")
            selectedEndTime = title
            tableViewDataSourcesArr[1][1].content = selectedEndTime
            
            if adjustGuaranteeView(){
               setAmountTitleButton(state: AmountTitleButtonState.next)
            }else
            {
                setAmountTitleButton(state: AmountTitleButtonState.done)
            }
            
        }
        else
        {
            let total = selectedRow - selectedRoomSum + 1
            if total > 0 {
                for _ in 0..<total
                {
                    sectionfirst.append(("入住人",""))
                }
            }else
            {
                for _ in 0..<abs(total)
                {
                    sectionfirst.remove(at: sectionfirst.count - 1)
                }
            }
            selectedRoomSum = selectedRow + 1
            self.tableViewDataSourcesArr[0] = sectionfirst
            adjustTotalMoney()
            //添加对 房间数量的校验
            if  adjustGuaranteeView() {
                setAmountTitleButton(state: AmountTitleButtonState.next)
            }
            else
            {
                setAmountTitleButton(state: AmountTitleButtonState.done)
            }
        }
        if selectedRoomSum > 1 {
            self.nestTableView.reloadData()
        }
        self.tableView.reloadData()
        
    }
    
    func adjustTotalMoney() {
        let number = selectedRoomSum as NSNumber
//        let amountContent = String.init(format: "¥%.0f",(roomModel.totalRate)! * number.floatValue)
        let amountContent:String = "¥" + ((roomModel.totalRate)! * number.floatValue).OneOfTheEffectiveFraction()
        let mutableAttribute = NSMutableAttributedString.init(string: amountContent)
        mutableAttribute.addAttributes([NSFontAttributeName:UIFont.systemFont( ofSize: 10)], range: NSRange(location: 0,length: 1))
        amountLabel.attributedText = mutableAttribute
    
    }
    
    
    
    //MARK:---提交订单
    func amountTitleButtonAction(sender:UIButton)  {
        printDebugLog(message: "amountTitleButtonAction ...")
        selectTextField?.resignFirstResponder()
        
        if verifyCorrect(format:"^1[3|4|5|7|8][0-9]\\d{8}$" , content:self.tableViewDataSourcesArr[2][1].content ) == false{
            showSystemAlertView(titleStr: "提示", message: "电话号码不正确")
            return
        }
        
        submitOrder()
        
    }
    
    
    func verifyCorrect(format:String,content:String)->Bool
    {
        
        let uppercase = format
        let uppercasePre = NSPredicate.init(format: "SELF MATCHES %@",uppercase)
        return uppercasePre.evaluate(with:content)
        
        
        
    }
    
    
    
    //MARK:--- 进入担保页面
    func amountTitleButtonNextAction(sender:UIButton) {
        print("进入担保页面 ... ")
        
        if verifyCorrect(format:"^1[3|4|5|7|8][0-9]\\d{8}$" , content:self.tableViewDataSourcesArr[2][1].content ) == false{
            showSystemAlertView(titleStr: "提示", message: "电话号码不正确")
            return
        }
        
        //入住人 校验 是否为空
        for index in 1..<tableViewDataSourcesArr[0].count
        {
            if tableViewDataSourcesArr[0][index].content.isEmpty
            {
                showSystemAlertView(titleStr: "提示", message: "填写入住人信息")
                return
            }
            
        }
        
        //联系人 校验 是否为空
        for index in 0..<tableViewDataSourcesArr[2].count
        {
            if tableViewDataSourcesArr[2][index].content.isEmpty
            {
                showSystemAlertView(titleStr: "提示", message: "填写联系人信息")
                return
            }
            
        }
        

        
        
        
        var hotelOrder:HotelOrderInfo = HotelOrderInfo()
        hotelOrder.customerType = "CUSTOMER_TYPE_PERSONAL"
        //产品信息
        var hp:HotelOrderInfo.HotelProductParameters  = HotelOrderInfo.HotelProductParameters()
        hp.country = ""
        hp.cityId = searchCondition.cityId
        hp.hotelId = hotelDetailForm.hotelId
        
        let ratePlanIdNumber = roomModel.ratePlanId as! NSNumber
        hp.ratePlanId = ratePlanIdNumber.stringValue
        hp.roomTypeId = roomModel.roomTypeId
        
        
        hp.arrivalDate = searchCondition.arrivalDate
        hp.departureDate = searchCondition.departureDate
        hotelOrder.hotelProductParameters = hp
        //房间客人信息
        var room:HotelOrderInfo.OrderHotelRoom = HotelOrderInfo.OrderHotelRoom()
        room.earliestArrivalTime = "13:00"//这个变量 没有交互性
        room.latestArrivalTime = tableViewDataSourcesArr[1][1].content
        room.noteToHotelBed  = reserveRoomViewCategoryRequireOfBedType
        room.noteToHotels = reserveRoomViewCategoryRequireOfSpecial
        room.orderHotelRoomCustomersList = Array()
        hotelOrder.orderHotelRoomList =  Array()
        
        //联系人信息
        for index in 1..<tableViewDataSourcesArr[0].count
        {
            
            var customer:HotelOrderInfo.OrderHotelRoomCustomer = HotelOrderInfo.OrderHotelRoomCustomer()
            customer.name = tableViewDataSourcesArr[0][index].content
            customer.phone = ""
            room.orderHotelRoomCustomersList?.append(customer)
        }
        
        hotelOrder.orderHotelRoomList?.append(room)
        
        
        
        //联系人信息
        var contactPersoner:HotelOrderInfo.OrderHotelContact = HotelOrderInfo.OrderHotelContact()
        
        let  contactPersonerInfo:[(title:String,content:String)] = self.tableViewDataSourcesArr[2]
        contactPersoner.contactName = contactPersonerInfo.first?.content
        contactPersoner.contactPhone = contactPersonerInfo[1].content
        hotelOrder.orderHotelContact = contactPersoner
        
        
        
        intoNextAssuranceInfoView(orderInfo:hotelOrder)
        
    }
    
    func intoNextAssuranceInfoView(orderInfo:HotelOrderInfo){
        
        let assuranceInfoView = AssuranceInfoViewController()
        assuranceInfoView.assuranceInfo.hotelId  = hotelDetailForm.hotelId
        let rateId:NSNumber = roomModel.ratePlanId as NSNumber
        assuranceInfoView.assuranceInfo.ratePlanId = rateId.stringValue
        assuranceInfoView.roomModel = self.roomModel
        assuranceInfoView.assuranceInfo.roomNum =  selectedRoomSum.description
        assuranceInfoView.assuranceInfo.ArrivalDate = searchCondition.arrivalDate
        assuranceInfoView.assuranceInfo.DepartureDate = searchCondition.departureDate
        assuranceInfoView.assuranceHotelOrderInfo = orderInfo
        self.navigationController?.pushViewController(assuranceInfoView, animated: true)
        
    }
    
    
    
    func submitOrder() {
        var hotelOrder:HotelOrderInfo = HotelOrderInfo()
        hotelOrder.customerType = "CUSTOMER_TYPE_PERSONAL"
    
        //入住人 校验 是否为空
        for index in 1..<tableViewDataSourcesArr[0].count
        {
            if tableViewDataSourcesArr[0][index].content.isEmpty
            {
                showSystemAlertView(titleStr: "提示", message: "填写入住人信息")
                return
            }
            
        }
        
        //联系人 校验 是否为空
        for index in 0..<tableViewDataSourcesArr[2].count
        {
            if tableViewDataSourcesArr[2][index].content.isEmpty
            {
                showSystemAlertView(titleStr: "提示", message: "填写联系人信息")
                return
            }
            
        }
        
        
        
        
        
        //产品信息
        var hp:HotelOrderInfo.HotelProductParameters  = HotelOrderInfo.HotelProductParameters()
        hp.country = ""
        hp.cityId = searchCondition.cityId
        hp.hotelId = hotelDetailForm.hotelId
        
        let ratePlanIdNumber = roomModel.ratePlanId as NSNumber
        hp.ratePlanId = ratePlanIdNumber.stringValue
        hp.roomTypeId = roomModel.roomTypeId
        
        
        hp.arrivalDate = searchCondition.arrivalDate
        hp.departureDate = searchCondition.departureDate
        hotelOrder.hotelProductParameters = hp
        //房间客人信息
        
        //
        var room:HotelOrderInfo.OrderHotelRoom = HotelOrderInfo.OrderHotelRoom()
        room.earliestArrivalTime = "13:00"//这个变量 没有交互性
        room.latestArrivalTime = tableViewDataSourcesArr[1][1].content
        room.noteToHotelBed  = reserveRoomViewCategoryRequireOfBedType
        room.noteToHotels = reserveRoomViewCategoryRequireOfSpecial
        room.orderHotelRoomCustomersList = Array()
        hotelOrder.orderHotelRoomList =  Array()
        
        //入住人信息
        for index in 1..<tableViewDataSourcesArr[0].count
        {
            
            var customer:HotelOrderInfo.OrderHotelRoomCustomer = HotelOrderInfo.OrderHotelRoomCustomer()
            customer.name = tableViewDataSourcesArr[0][index].content
            customer.phone = ""
            room.orderHotelRoomCustomersList?.append(customer)
        }
        
        hotelOrder.orderHotelRoomList?.append(room)
        
        
        
        //联系人信息
        var contactPersoner:HotelOrderInfo.OrderHotelContact = HotelOrderInfo.OrderHotelContact()
        
        let  contactPersonerInfo:[(title:String,content:String)] = self.tableViewDataSourcesArr[2]
        contactPersoner.contactName = contactPersonerInfo.first?.content
        contactPersoner.contactPhone = contactPersonerInfo[1].content
        hotelOrder.orderHotelContact = contactPersoner
        showLoadingView()
        weak var weakSelf = self
        print("request parameter",hotelOrder)
        HotelService.sharedInstance
            .commit(order: hotelOrder)
            .subscribe{ event in
                
                weakSelf?.hideLoadingView()
                if case .next(let e) = event {
                    print(e)
                    //weakSelf?.showSystemAlertView(titleStr: "成功", message: "下单成功")
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
        //orderStatusView.topBackEvent = OrderDetailsBackEvent.homePage
        self.navigationController?.pushViewController(orderStatusView, animated: true)
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
