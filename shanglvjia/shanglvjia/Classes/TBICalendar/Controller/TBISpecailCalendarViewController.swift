//
//  TBISpecailCalendarViewController.swift
//  shop
//
//  Created by manman on 2017/5/2.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit


typealias HotelSelectedDateAcomplishBlock = (Array<String>) ->Void

class TBISpecailCalendarViewController: CompanyBaseViewController,FSCalendarDataSource,FSCalendarDelegate {

    public let calendar = FSCalendar()
    public var hotelSelectedDateAcomplishBlock:HotelSelectedDateAcomplishBlock!
    //默认可以点击多次   这个字段 需和 selectedDates 一致
    public var isMultipleTap:Bool = false
    ///这个字段 需和 isMultipleTap 一致 "yyyy-MM-dd HH:mm:ss"
    public var selectedDates:[String] = Array()
    public var showDateTitle:[String] = Array()
    
    public var bacButtonImageName:String = ""
    public var titleColor:UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBackButton(backImage: bacButtonImageName)
        if (titleColor != nil) {
            setTitle(titleStr: "选择日期",titleColor:titleColor!)
        }
        else
        {
            setTitle(titleStr: "选择日期")    
        }
        
        // Do any additional setup after loading the view.
        setDataSources()
        setUIViewAutolayout()
    }

    
    func setDataSources() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var tmpCheckinDate:Date = Date()
        var tmpCheckoutDate:Date = Date()
        if isMultipleTap == true
        {
            if selectedDates.count != 2 {
                return
            }
            if selectedDates[0].characters.count > 0
            {
                tmpCheckinDate  = dateFormatter.date(from:selectedDates[0])!
                calendar.selectedDates.add(tmpCheckinDate)
            }
            if selectedDates[1].characters.count > 0 {
                tmpCheckoutDate = dateFormatter.date(from:selectedDates[1])!
                calendar.selectedDates.add(tmpCheckoutDate)
            }
            
        }else
        {
            if selectedDates.count != 1 {
                return
            }
            if selectedDates[0].characters.count > 0
            {
                tmpCheckinDate  = dateFormatter.date(from:selectedDates[0])!
                calendar.selectedDates.add(tmpCheckinDate)
            }
        }
        if showDateTitle.count > 0 {
            calendar.showTitleArr = showDateTitle
        }
    }

    func setUIViewAutolayout()  {
        
        calendar.backgroundColor = UIColor.white
        calendar.dataSource = self
        calendar.delegate = self
        calendar.pagingEnabled = false
        calendar.allowsMultipleSelection = isMultipleTap
        calendar.firstWeekday = 2
        calendar.placeholderType = FSCalendarPlaceholderType.fillHeadTail
        calendar.appearance.borderRadius = 0
        weak var weakSelf = self
        calendar.selectedDateBlock = {(parameter ) in
            weakSelf?.selectedDateAction(parameters: parameter as NSArray);
        }
        self.view.addSubview(calendar)
        calendar.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print(calendar.selectedDates)
        calendar.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //返回的数据 只是想要的 其他的需要过滤  转化为String类型
    func selectedDateAction(parameters:NSArray) {
        var resultArr:[String] = Array()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if isMultipleTap
        {
            if parameters.count >= 2 {
                resultArr.append(formatter.string(from: parameters[0] as! Date))
                resultArr.append(formatter.string(from: parameters[1] as! Date))
            }
        }
        else
        {
            if parameters.count > 0
            {
                resultArr.append(formatter.string(from: parameters[0] as! Date))
            }
        }
        self.hotelSelectedDateAcomplishBlock(resultArr)
        self.perform(#selector(backButtonAction(sender:)), with: nil, afterDelay: 0.2)
    }
    
    

    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
