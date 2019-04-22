//
//  TravelManyConditionFilterView.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/7/12.
//  Copyright © 2017年 TBI. All rights reserved.
//

//旅游的多条件筛选View


import UIKit
import SwiftDate

class TravelManyConditionFilterView: UIView
{
    let navBgView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 20 + 44))
    
    fileprivate var lastNavVC:UIViewController! = nil
    
    fileprivate static var instance:TravelManyConditionFilterView! = nil
    fileprivate static weak var lastRootViewController:UIViewController! = nil
    fileprivate static weak var currentRootViewController:UIViewController! = nil
    {
        willSet
        {
            lastRootViewController = currentRootViewController
        }
    }
    
    var isLocalTravel = false
    var delegateMethod:((_ clickAction:ClickActionEnum,_ start1Date:Date?,_ start2Date:Date?,_ journeyDayIndex:Int,_ priceAreaIndex:Int)->Void)! = nil
    
    let defaultStart0Date:Date = Date().nextMonth.prevMonth
    fileprivate var selectedStart0Date:Date! = nil
    fileprivate var selectedStart1Date:Date! = nil
    
    fileprivate let  leftTableViewCellIdentify = "AirInfoViewLeftTableViewCellIdentify"
    fileprivate let  rightTableViewCellIdentify = "AirInfoViewRightTableViewCellIdentify"
    
    fileprivate let specialTableCellIndex = 0
    
    fileprivate var  rightSelectedDataSources:[NSInteger] = [0,0,0]
    fileprivate var leftTableViewDataSources:[String] = ["出发日期","行程天数","价格区间"]
//    {
//        didSet
//        {
//            for _ in 0..<leftTableViewDataSources.count
//            {
//                rightSelectedDataSources.append(0)
//            }
//            
//        }
//    }
    
    fileprivate var rightTableViewDataSources:[[String]] = []
    
    
    fileprivate let myContentView = UIView()
    private var titleBackgroundView:UIView = UIView()
    
    private var cancelButton:UIButton = UIButton()
    private var clearButton:UIButton = UIButton()
    private var okayButton:UIButton = UIButton()
    
    fileprivate var leftTableView = UITableView()
    fileprivate var leftSelectedIndex:NSInteger = 0
    
    fileprivate var rightTableView = UITableView()
    fileprivate var rightSelectedIndex:NSInteger = 0
    
    fileprivate init(frame: CGRect,isLocalTravel:Bool)
    {
        super.init(frame: frame)
        
        self.isLocalTravel = isLocalTravel
        setDataSource()
        initView()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setDataSource() -> Void
    {
        rightTableViewDataSources = [[],[],[]]
        //出发日期 组
        rightTableViewDataSources[0] = ["",""]
        //行程天数 组
        if !isLocalTravel
        {
            rightTableViewDataSources[1] = ["不限","≤5天","6-8天","9-10天","≥10天"]
        }
        else
        {
            rightTableViewDataSources[1] = ["不限","1天","2天","≥3天"]
        }
        
        //价格区间
        rightTableViewDataSources[2] = ["不限","≤2000","2001-5000","5001-9999","10000-20000","≥20000"]
        
    }
    
    
    func initView() -> Void
    {
        navBgView.backgroundColor = UIColor(r:0,g:0,b:0,alpha:0.6)
        KeyWindow?.addSubview(navBgView)
        
        self.backgroundColor = UIColor(r:0,g:0,b:0,alpha:0.6)//TBIThemeBackgroundViewColor
        
        myContentView.backgroundColor = .white
        self.addSubview(myContentView)
        myContentView.snp.makeConstraints{(make)->Void in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(226)
        }
        
        setUIViewAutolayout()
    }

    func setUIViewAutolayout()
    {
        
        titleBackgroundView.backgroundColor = TBIThemeLinkColor
        myContentView.addSubview(titleBackgroundView)
        titleBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        cancelButton.setTitle("取消", for: UIControlState.normal)
        cancelButton.titleLabel?.font = UIFont.systemFont( ofSize: 16)
        cancelButton.addTarget(self, action: #selector(cancelButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        titleBackgroundView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.height.equalTo(16)
            make.width.equalTo(50)
        }
        
        //上方的执行取消动作的按钮🔘
        let cancelBgView = UIView()
        self.addSubview(cancelBgView)
        cancelBgView.snp.makeConstraints{(make)->Void in
            make.left.right.equalToSuperview()
            make.top.equalTo(-100)
            make.bottom.equalTo(myContentView.snp.top)
        }
        //点击空白处相当于点击 取消 按钮🔘
        cancelBgView.addOnClickListener(target: self, action: #selector(cancelButtonAction))
        
        clearButton.setTitle("清空已选", for: UIControlState.normal)
        clearButton.titleLabel?.font = UIFont.systemFont( ofSize: 14)
        clearButton.addTarget(self, action: #selector(clearButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        titleBackgroundView.addSubview(clearButton)
        clearButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(16)
            make.width.equalTo(100)
        }
        
        okayButton.setTitle("确定", for: UIControlState.normal)
        okayButton.titleLabel?.font = UIFont.systemFont( ofSize: 16)
        okayButton.addTarget(self, action: #selector(okayButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        titleBackgroundView.addSubview(okayButton)
        okayButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(16)
            make.width.equalTo(50)
        }
        
        leftTableView.delegate = self
        leftTableView.dataSource = self
        leftTableView.showsVerticalScrollIndicator = false
        leftTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        leftTableView.backgroundColor = TBIThemeBaseColor
        leftTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: leftTableViewCellIdentify)
        myContentView.addSubview(leftTableView)
        leftTableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleBackgroundView.snp.bottom)
            make.left.bottom.equalToSuperview()
            make.width.equalTo(125)
        }
        
        
        rightTableView.delegate = self
        rightTableView.dataSource = self
        rightTableView.showsVerticalScrollIndicator = false
        rightTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        rightTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: rightTableViewCellIdentify)
        myContentView.addSubview(rightTableView)
        rightTableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleBackgroundView.snp.bottom)
            make.right.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(125 + 15)
        }
        
    }
    
}

extension TravelManyConditionFilterView:UITableViewDelegate,UITableViewDataSource
{
    //MARK:-----UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if leftTableView == tableView
        {
            return leftTableViewDataSources.count
        }
        else
        {
            return rightTableViewDataSources[leftSelectedIndex].count
            
        }
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        if tableView == leftTableView
        {
            return  configLeftCell(tableView: tableView, indexPath: indexPath)
        }
        else
        {
            return configRightCell(tableView:tableView ,indexPath:indexPath)
        }
        
    }
    
    
    
    func configLeftCell(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell
    {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: leftTableViewCellIdentify)!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if indexPath.row < leftTableViewDataSources.count
        {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.text = leftTableViewDataSources[indexPath.row]
            cell.textLabel?.textAlignment = NSTextAlignment.center
            cell.textLabel?.textColor = TBIThemePrimaryTextColor
            cell.contentView.backgroundColor = TBIThemeBaseColor
        }
        if leftSelectedIndex == indexPath.row
        {
            cell.textLabel?.textColor = TBIThemeBlueColor
            cell.contentView.backgroundColor = UIColor.white
        }
        
        return cell
        
    }
    
    func configRightCell(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: rightTableViewCellIdentify)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let cellContentView = UIView()
        cell.contentView.addSubview(cellContentView)
        cellContentView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.bottom.equalTo(0)
        }
        
        if leftSelectedIndex == specialTableCellIndex
        {
            var leftLabelText = ""
            if indexPath.row == 0
            {
                leftLabelText = "选择最早出发日期"
            }
            else //if indexPath.row == 1
            {
                leftLabelText = "选择最晚出发日期"
            }
            
            let leftTopContentLabel = UILabel(text: leftLabelText, color: TBIThemeTipTextColor, size: 14)
            cellContentView.addSubview(leftTopContentLabel)
            leftTopContentLabel.snp.remakeConstraints{(make)->Void in
                make.left.equalTo(0)
                make.top.equalTo(11)
            }
            let leftBottomContentLabel = UILabel(text: rightTableViewDataSources[leftSelectedIndex][indexPath.row], color: TBIThemePrimaryTextColor, size: 14)
            cellContentView.addSubview(leftBottomContentLabel)
            leftBottomContentLabel.snp.remakeConstraints{(make)->Void in
                make.left.equalTo(0)
                make.top.equalTo(leftTopContentLabel.snp.bottom).offset(4)
                
            }
            
            //***设置Label显示的位置,当未选择日期时，上方的Label显示在Y轴的中间
            if indexPath.row == 0   //最早出发日期
            {
                if selectedStart0Date == nil
                {
                    leftTopContentLabel.snp.remakeConstraints{(make)->Void in
                        make.left.equalTo(0)
                        make.centerY.equalToSuperview()
                    }
                }
            }
            else //if indexPath.row == 1    最晚出发日期
            {
                if selectedStart1Date == nil
                {
                    leftTopContentLabel.snp.remakeConstraints{(make)->Void in
                        make.left.equalTo(0)
                        make.centerY.equalToSuperview()
                    }
                }
            }
        }
        else
        {
            
            let leftContentLabel = UILabel(text: rightTableViewDataSources[leftSelectedIndex][indexPath.row], color: TBIThemePrimaryTextColor, size: 14)
            cellContentView.addSubview(leftContentLabel)
            leftContentLabel.snp.makeConstraints{(make)->Void in
                make.left.equalTo(0)
                make.centerY.equalToSuperview()
            }
            
        }
        
        let rightArrowView = UIImageView(imageName: "ic_single_selection")
        cellContentView.addSubview(rightArrowView)
        rightArrowView.snp.makeConstraints{(make)->Void in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        let bottomSegLine = UIView()
        bottomSegLine.backgroundColor = TBIThemeGrayLineColor
        cellContentView.addSubview(bottomSegLine)
        bottomSegLine.snp.makeConstraints{(make)->Void in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        rightArrowView.isHidden = true
        
        if (rightSelectedDataSources[leftSelectedIndex] == indexPath.row) && (leftSelectedIndex != specialTableCellIndex)
        {
            rightArrowView.isHidden = false
        }
        
        return cell
    }
    
    
    
    //MARK:-----UITableViewDataDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (leftSelectedIndex == specialTableCellIndex) && (tableView == rightTableView)
        {
            return 60
        }
        
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if leftTableView == tableView
        {
            leftSelectedIndex = indexPath.row
            self.reloadDataSources()
            
            // 让UITableView自动滑动（定位）到某一行cell
            rightTableView.scrollToRow(at: IndexPath(row: rightSelectedDataSources[leftSelectedIndex], section: 0), at: .middle, animated: false)
        }
        
        if rightTableView == tableView
        {
            rightSelectedDataSources[leftSelectedIndex] = indexPath.row
            self.reloadDataSources()
            
            //TODO:选择出发时间   *********
            if (leftSelectedIndex == specialTableCellIndex)
            {
                print("^_^ 选择出发时间📅")
//                let datePicker = TBIDatePickerView(frame: ScreenWindowFrame)
//                //datePicker.date = self.selectStartDateStr ?? ""
//                datePicker.datePickerResultBlock = { (dateStr) in
//                    let weekDays = ["周日","周一","周二","周三","周四","周五","周六"]
//                    let formatter = DateFormatter()
//                    //日期样式
//                    formatter.dateFormat = "yyyy-MM-dd"
//                    let dateStr0 = (dateStr == "") ? formatter.string(from: Date()) : dateStr
//                    let selectedDateStr = dateStr0 + " \(weekDays[formatter.date(from: dateStr0)!.weekday - 1])"
//                    
//                    self.rightTableViewDataSources[0][indexPath.row] = selectedDateStr
//                    self.reloadDataSources()
//                    
//                    if indexPath.row == 0
//                    {
//                        self.selectedStart0Date = formatter.date(from: dateStr0)
//                    }
//                    else
//                    {
//                        self.selectedStart1Date = formatter.date(from: dateStr0)
//                    }
//                }
//                KeyWindow?.addSubview(datePicker)
                //TODO:选择出发时间
                self.navBgView.frame.size.height = 0
                
                let vc:TBICalendarViewController = TBICalendarViewController()
                vc.calendarAlertType = TBICalendarAlertType.Hotel
                let formatter = DateFormatter()
                formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone!
                //日期样式
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                var dateStr0 = ""
                var dateStr1 = ""
                if indexPath.row == 0
                {
                    vc.calendarTypeAlert = ["请选择最早出发日期","请选择最晚出发日期"]
                    
                    dateStr0 = (selectedStart0Date == nil) ? formatter.string(from: Date()) : formatter.string(from: selectedStart0Date)
                    dateStr1 = (selectedStart1Date == nil) ? formatter.string(from: Date()) : formatter.string(from: selectedStart1Date)
                    vc.showDateTitle = ["最早","最晚"]
                    vc.isMultipleTap = true
                    vc.selectedDates = [dateStr0,dateStr1]
                }
                else
                {
                    vc.calendarTypeAlert = ["请选择最晚出发日期"]
                    
                    dateStr0 = (selectedStart1Date == nil) ? formatter.string(from: defaultStart0Date) : formatter.string(from: selectedStart1Date)
                    vc.showDateTitle = ["最晚"]
                    vc.isMultipleTap = false
                    vc.selectedDates = [dateStr0]
                }
                print("***" + dateStr0)
                vc.titleColor = TBIThemePrimaryTextColor
                vc.bacButtonImageName = "back"
                vc.hotelSelectedDateAcomplishBlock = { (parameters,action) in
                    
                    //self.navBgView.frame.size.height = 20 + 44
                    guard action == TBICalendarAction.Done else {
                        return
                    }
                    
                    let dateString0 = parameters?[0]
                    let date0:Date = DateInRegion(string: dateString0!, format: .custom("YYYY-MM-dd hh:mm:ss"), fromRegion: regionRome)!.absoluteDate
                    if (dateString0 == "") //点击了取消按钮 🔘
                    {
                        return
                    }
                    
                    let weekDays = ["周日","周一","周二","周三","周四","周五","周六"]
                    let formatter0 = DateFormatter()
                    //日期样式
                    formatter0.dateFormat = "yyyy-MM-dd"
                    
                    if indexPath.row == 0
                    {
                        let dateString1 = parameters?[1]
                        let date1:Date = DateInRegion(string: dateString1!, format: .custom("YYYY-MM-dd hh:mm:ss"), fromRegion: regionRome)!.absoluteDate
                        
                        self.selectedStart0Date = date0
                        self.selectedStart1Date = date1
                        
                        
                        let dateStr0 = formatter0.string(from: self.selectedStart0Date)
                        let selectedDateStr0 = dateStr0 + " \(weekDays[formatter0.date(from: dateStr0)!.weekday - 1])"
                        self.rightTableViewDataSources[0][indexPath.row] = selectedDateStr0
                        
                        let dateStr1 = formatter0.string(from: self.selectedStart1Date)
                        let selectedDateStr1 = dateStr1 + " \(weekDays[formatter0.date(from: dateStr1)!.weekday - 1])"
                        self.rightTableViewDataSources[0][1] = selectedDateStr1
                    }
                    else
                    {
                        self.selectedStart1Date = date0
                        
                        let dateStr0 = formatter0.string(from: self.selectedStart1Date)
                        let selectedDateStr = dateStr0 + " \(weekDays[formatter0.date(from: dateStr0)!.weekday - 1])"
                        self.rightTableViewDataSources[0][indexPath.row] = selectedDateStr
                    }
                    
                    self.reloadDataSources()
                }
                
                TravelManyConditionFilterView.currentRootViewController.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func reloadDataSources()
    {
        leftTableView.reloadData()
        rightTableView.reloadData()
    }
}


extension TravelManyConditionFilterView
{
    //MARK:------Action
    @objc fileprivate func cancelButtonAction(sender:UIButton?)
    {
        //printDebugLog(message: "cancelButtonAction ...")
        self.removeFromSuperview()
        self.navBgView.frame.size.height = 0
        
        if delegateMethod != nil
        {
            self.delegateMethod(.cancel,nil,nil,rightSelectedDataSources[1],rightSelectedDataSources[2])
        }
    }
    
    
    
    @objc fileprivate func clearButtonAction(sender:UIButton)
    {
        
        //printDebugLog(message: "clearButtonAction ...")
        //rightSelectedDataSources[leftSelectedIndex] = 0
        for i in 0..<rightSelectedDataSources.count
        {
            rightSelectedDataSources[i] = 0
        }
        
        self.selectedStart0Date = nil
        self.selectedStart1Date = nil
        
//        let weekDays = ["周日","周一","周二","周三","周四","周五","周六"]
//        let formatter = DateFormatter()
//        //日期样式
//        formatter.dateFormat = "yyyy-MM-dd"
//        let dateStr0 = formatter.string(from: selectedStart0Date)
//        let selectedDateStr = dateStr0 + " \(weekDays[formatter.date(from: dateStr0)!.weekday - 1])"
        
        self.rightTableViewDataSources[0][0] = ""
        self.rightTableViewDataSources[0][1] = ""
        
        self.reloadDataSources()
    }
    
    
    @objc fileprivate func okayButtonAction(sender:UIButton) {
        //printDebugLog(message: "okayButtonAction ...")
        self.removeFromSuperview()
        self.navBgView.frame.size.height = 0
        
        if delegateMethod != nil
        {
            self.delegateMethod(.ok,selectedStart0Date,selectedStart1Date,rightSelectedDataSources[1],rightSelectedDataSources[2])
        }
    }
    
    enum ClickActionEnum
    {
        case ok
        case cancel
    }
    
    //UIVIew平移的动画
    func viewTranslateAnimation(view:UIView,fromYPosition:CGFloat,toYPosition:CGFloat,duration:Double = 0.5) -> Void
    {
        
//        //2.在动画中更改布局
//        [UIView animateWithDuration:1.0 animations:^{
//            self.lineView.transform = CGAffineTransformRotate(self.lineView.transform, M_PI);
//            [self layoutIfNeeded];//调用更改约束的view 的父视图的layoutIfNeeded 不要掉自己self.lineView
//            } completion:^(BOOL finished) {
//            
//            }];
        navBgView.backgroundColor = UIColor(r:0,g:0,b:0,alpha:0)
        
        view.transform = CGAffineTransform(translationX: 0, y: fromYPosition)
        self.backgroundColor = UIColor(r:0,g:0,b:0,alpha:0)
        
        UIView.animate(withDuration: duration, animations: {_ in
            
            self.navBgView.backgroundColor = UIColor(r:0,g:0,b:0,alpha:0.6)
            
            view.transform = CGAffineTransform(translationX: 0, y: toYPosition)
            self.backgroundColor = UIColor(r:0,g:0,b:0,alpha:0.6)
        }, completion: nil)
        
    }
    
    
}


extension TravelManyConditionFilterView
{
    /**
     isLocalTravel:Bool 是否当地游
    */
    //新创建实例
    public static func getNewInstance(isLocalTravel:Bool,resultBlock:((_ clickAction:ClickActionEnum,_ start1Date:Date?,_ start2Date:Date?,_ journeyDayIndex:Int,_ priceAreaIndex:Int)->Void)?)->TravelManyConditionFilterView
    {
        instance = TravelManyConditionFilterView(frame: ScreenWindowFrame, isLocalTravel: isLocalTravel)
        instance.delegateMethod = resultBlock
        
        instance.viewTranslateAnimation(view: instance.myContentView, fromYPosition: 226, toYPosition: 0)
        
        return instance
    }
    
    //单实例
    static func getInstance(viewController:UIViewController,isLocalTravel:Bool,resultBlock:((_ clickAction:ClickActionEnum,_ start1Date:Date?,_ start2Date:Date?,_ journeyDayIndex:Int,_ priceAreaIndex:Int)->Void)?)->TravelManyConditionFilterView
    {
        
        TravelManyConditionFilterView.currentRootViewController = viewController
        
        if (instance == nil) || (TravelManyConditionFilterView.lastRootViewController == nil) || (TravelManyConditionFilterView.lastRootViewController != TravelManyConditionFilterView.currentRootViewController)
        {
            var frame = ScreenWindowFrame
            frame.size.height = frame.height  //- 20 - 44
            frame.origin.y = -(20 + 44)
            instance = TravelManyConditionFilterView(frame: frame, isLocalTravel: isLocalTravel)
        }
        instance.navBgView.frame.size.height = 20 + 44
        instance.delegateMethod = resultBlock
        instance.viewTranslateAnimation(view: instance.myContentView, fromYPosition: 226, toYPosition: 0)
        
        instance.leftSelectedIndex = 0
        instance.reloadDataSources()
        
        viewController.navigationController?.delegate = instance
        
        return instance
    }
    
    
//    //视图对应的ViewController
//    var rootViewController:UIViewController!
//    {
//        var myViewOption = self.superview
//        while let myView = myViewOption
//        {
//            let nextResponder = myView.next
//            if let vc = (nextResponder as? UIViewController)
//            {
//                return vc
//            }
//            
//            myViewOption = myViewOption?.superview
//        }
//        
//        return nil
//    }
    
}

extension TravelManyConditionFilterView:UINavigationControllerDelegate
{

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool)
    {
        
        let clazz = TravelManyConditionFilterView.currentRootViewController.classForCoder
        
        if (lastNavVC != nil) && (lastNavVC is TBICalendarViewController) && (viewController.classForCoder == clazz)
        {
            self.navBgView.frame.size.height = 20 + 44
        }
        
        lastNavVC = viewController
        
    }
}











