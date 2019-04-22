//
//  TravelDIYIntentOrderController.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/7/6.
//  Copyright © 2017年 TBI. All rights reserved.
//

//定制旅游意向单Controller


import UIKit
import RxSwift

class TravelDIYIntentOrderController: CompanyBaseViewController
{
    let bag = DisposeBag()
    var travelOrderForm:TravelDIYIntentOrder = TravelDIYIntentOrder()
    
    var selectStartCity:(cityName:String,cityCode:String)!
    var selectStartDateStr:String!
    
    
    let contentYOffset:CGFloat = 20 + 44
    var myContentView:TravelDIYIntentOrderView! = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        //设置头部的导航栏
        self.title = "定制旅游"  //"定制旅游"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 16),NSForegroundColorAttributeName:UIColor.white]
        setNavigationBackButton(backImage: "back")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIColor.creatImageWithColor(color: TBIThemeBlueColor), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        

        initView()
    }

    //重写  头部左侧的🔙Btn
    override func backButtonAction(sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
        //self.navigationController?.navigationBar.shadowImage = UIImage.init(named: "border")
    }
    
    
    
    func initView() -> Void
    {
        myContentView = TravelDIYIntentOrderView(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight - contentYOffset))
        self.view.addSubview(myContentView)
        
        myContentView.startCityContainer.addOnClickListener(target: self, action: #selector(selectStartCityClk))
        myContentView.startDateContainer.addOnClickListener(target: self, action: #selector(nextToCalendarView))//birthdayAction
        myContentView.bottomCommitBtn.addOnClickListener(target: self, action: #selector(commitTravelOrderClk))
    }
    
}

extension TravelDIYIntentOrderController
{
    //选择出发城市
    func selectStartCityClk() -> Void
    {
        //print("^_^ 选择出发城市")
        
        let citySelectorViewController = CitySelectorViewController()
        citySelectorViewController.citySelectorBlock = { (cityName,cityCode) in
            self.selectStartCity = (cityName:cityName,cityCode:cityCode)
            self.myContentView.startCityRightField.text = self.selectStartCity.cityName
        }
        citySelectorViewController.setCityType(type: .hotelCity)
        CityService.sharedInstance.getGroups(.hotelCity).subscribe{ event in
            if case .next(let e) = event {
                citySelectorViewController.city = e
                self.navigationController?.pushViewController(citySelectorViewController, animated: true)
                //self.present(citySelectorViewController, animated: true, completion: nil)
            }
            }.addDisposableTo(self.bag)
    }
    
    //选择出发日期📅
    func selectStartDateClk() -> Void
    {
        self.view.endEditing(true)
        print("^_^ 选择出发日期📅")
        let datePicker = TBIDatePickerView(frame: ScreenWindowFrame)
        datePicker.date = self.selectStartDateStr ?? ""
        datePicker.datePickerResultBlock = { (date) in
           self.selectStartDateStr = date
           self.myContentView.startDateRightField.text = self.selectStartDateStr
        }
        KeyWindow?.addSubview(datePicker)
    }
    
    
    func birthdayAction() {
        weak var weakSelf = self
        let birthdayView =  TBIBirthdayDateView.init(frame: ScreenWindowFrame)
        birthdayView.birthdayDateViewResult = { (result) in
//            weakSelf?.model.birthday = result
//            weakSelf?.travellerPersonView.birthday.textField.text = result
            weakSelf?.selectStartDateStr = result
            weakSelf?.myContentView.startDateRightField.text = result
            
        }
        KeyWindow?.addSubview(birthdayView)
    }
    
    func nextToCalendarView() {
        let calendarView = TBICalendarViewController()
        calendarView.calendarAlertType = TBICalendarAlertType.Travel
        calendarView.calendarTypeAlert = ["请选择出发日期"]
        //calendarView.selectedDates = [paramater[HotelListSelectedCheckinDate] as! String,paramater[HotelListSelectedCheckoutDate] as! String]
        calendarView.isMultipleTap = false
        calendarView.showDateTitle = ["出发"]
        weak var weakSelf = self
        calendarView.hotelSelectedDateAcomplishBlock = { (parameters,action) in
            guard action == TBICalendarAction.Done else {
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone!
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let checkinDate =  dateFormatter.date(from: (parameters?[0])!)
            
            weakSelf?.selectStartDateStr = (checkinDate?.string(format: .custom("YYYY-MM-dd")))!
            weakSelf?.myContentView.startDateRightField.text = (checkinDate?.string(format: .custom("YYYY-MM-dd")))!
        }
        
        
        self.navigationController?.pushViewController(calendarView, animated: true)
    }
    
    
    
    
    
    
    //提交定制旅游意向单
    func commitTravelOrderClk() -> Void
    {
        print("^_^ 提交定制旅游意向单")
        
        guard checkTravelOrderForm() else   //检查“提交表单实体“  失败时执行
        {
            print("检查 提交表单实体 失败")
            
            return
        }
        
//        //TODO:测试时使用
//        travelOrderForm = TravelDIYIntentOrder(destination: "北京（目的地）", togetherCount: 3, travelDate: "2017-7-30", travelDays: 5, departureCity: "天津", budget: "1000", specialNeeds: "无特殊需求", customerName: "张三", phoneNum: "15811111111", email: "792@163.com")
        
        submitDIYTravelFormToServer(travelForm: travelOrderForm)
        
        
    }
}

extension TravelDIYIntentOrderController
{
    //提交定制旅游意向单 到 服务器
    func submitDIYTravelFormToServer(travelForm:TravelDIYIntentOrder) -> Void
    {
        self.showLoadingView()
        let userDetail = UserService.sharedInstance.userDetail()
        travelOrderForm.id = userDetail?.id
        let travelService = TravelService.sharedInstance
        travelService.submitCustomTravelForm(travelOrderForm: travelOrderForm).subscribe{ event in
            self.hideLoadingView()
            if case .next(let e) = event
            {
                print(e)
                
                self.showAlertView(messageStr: "提交订单成功")
                {
                    //TODO:成功后要做的处理
                    self.navigationController?.popToRootViewController(animated: false)
                    let tabbarView:BaseTabBarController = UIApplication.shared.keyWindow?.rootViewController as!BaseTabBarController
                    tabbarView.selectedIndex = 0
                }
            }
            if case .error(let e) = event
            {
                print("=====失败======\n \(e)")
                //处理异常
                try? self.validateHttp(e)
            }
            }.disposed(by: bag)
    }
    
    //检查“提交表单实体“对应的视图内容 是否 有值
    func checkTravelOrderForm() -> Bool
    {
        var flag = true
        
        //旅行目的地
        var textStr = self.myContentView.travelArrivePlaceRightField.text
        if !checkStrEmptyOrNil(myStr: textStr)
        {
            travelOrderForm.destination = textStr
            
            if (textStr?.characters.count)! > 25
            {
                self.showAlertView(messageStr: "输入旅行目的地文字过长，请修改", okActionMethod: nil)
                flag = false
                return flag
            }
        }
        else
        {
            print("未输入旅行目的地")
            self.showAlertView(messageStr: "未输入旅行目的地", okActionMethod: nil)
            
            flag = false
            return flag
        }
        //出发城市
        textStr = self.myContentView.startCityRightField.text
        if !checkStrEmptyOrNil(myStr: textStr)
        {
            travelOrderForm.departureCity = textStr
            
            if (textStr?.characters.count)! > 25
            {
                self.showAlertView(messageStr: "输入出发城市文字过长，请修改", okActionMethod: nil)
                flag = false
                return flag
            }
        }
        else
        {
            print("未输入出发城市")
            self.showAlertView(messageStr: "未输入出发城市", okActionMethod: nil)
            
            flag = false
            return flag
        }
        //出发日期
        textStr = self.myContentView.startDateRightField.text
        if !checkStrEmptyOrNil(myStr: textStr)
        {
            travelOrderForm.travelDate = textStr
            
            if (textStr?.characters.count)! > 25
            {
                self.showAlertView(messageStr: "输入出发日期文字过长，请修改", okActionMethod: nil)
                flag = false
                return flag
            }
        }
        else
        {
            print("未输入出发日期")
            self.showAlertView(messageStr: "未输入出发日期", okActionMethod: nil)
            
            flag = false
            return flag
        }
        //同行人数
        if self.myContentView.ansyPeopleNumRightStepper.currentValue > 0
        {
            travelOrderForm.togetherCount = self.myContentView.ansyPeopleNumRightStepper.currentValue
        }
        else
        {
            print("出行人数至少为1")
            self.showAlertView(messageStr: "出行人数至少为1", okActionMethod: nil)
            
            flag = false
            return flag
        }
        //游玩天数
        if self.myContentView.playDayNumRightStepper.currentValue > 0
        {
            travelOrderForm.travelDays = self.myContentView.playDayNumRightStepper.currentValue
        }
        else
        {
            print("游玩天数至少为1")
            self.showAlertView(messageStr: "游玩天数至少为1", okActionMethod: nil)
            
            flag = false
            return flag
        }
        //TODO:人均预期
        textStr = self.myContentView.travelAveCostRightField.text
        if !checkStrEmptyOrNil(myStr: textStr)
        {
            var nsStr = textStr! as NSString
            if (textStr?.characters.count)! > 10
            {
                nsStr = nsStr.substring(to: 10) as NSString
                textStr = nsStr as String
            }
            travelOrderForm.budget = textStr
            
            //print("*** 人均预期 = " + textStr!)
        }
        else
        {
            print("未输入人均预期")
            self.showAlertView(messageStr: "未输入人均预期", okActionMethod: nil)
            
            flag = false
            return flag
        }
        //特殊需求说明  非必填
        textStr = self.myContentView.diyDemandContentTextView.text ?? ""
        travelOrderForm.specialNeeds = textStr
        if (textStr?.characters.count)! > 50
        {
            self.showAlertView(messageStr: "输入特殊需求说明文字过长，请修改", okActionMethod: nil)
            flag = false
            return flag
        }
//        if !checkStrEmptyOrNil(myStr: textStr)
//        {
//            travelOrderForm.specialNeeds = textStr
//        }
//        else
//        {
//            print("未输入特殊需求说明")
//            self.showAlertView(messageStr: "未输入特殊需求说明", okActionMethod: nil)
//            
//            flag = false
//            return flag
//        }
        
        
        
        //称呼
        textStr = self.myContentView.travelNameRightField.text
        if !checkStrEmptyOrNil(myStr: textStr)
        {
            travelOrderForm.customerName = textStr
            
            if (textStr?.characters.count)! > 25
            {
                self.showAlertView(messageStr: "输入称呼文字过长，请修改", okActionMethod: nil)
                flag = false
                return flag
            }
        }
        else
        {
            print("未输入您的称呼")
            self.showAlertView(messageStr: "未输入您的称呼", okActionMethod: nil)
            
            flag = false
            return flag
        }
        //手机号码
        textStr = self.myContentView.travelPhoneRightField.text
        if !checkStrEmptyOrNil(myStr: textStr)
        {
            travelOrderForm.phoneNum = textStr
            
            if !self.validatePhoneNum(phoneNum: textStr!)
            {
                self.showAlertView(messageStr: "输入手机号格式不正确，请修改", okActionMethod: nil)
                flag = false
                return flag
            }
        }
        else
        {
            print("未输入手机号码")
            self.showAlertView(messageStr: "未输入手机号码", okActionMethod: nil)
            
            flag = false
            return flag
        }
        //邮箱📮
        textStr = self.myContentView.travelEmailRightField.text
        if !checkStrEmptyOrNil(myStr: textStr)
        {
            travelOrderForm.email = textStr
            
            if !self.validateEmail(email: textStr!)
            {
                self.showAlertView(messageStr: "输入邮箱格式不正确，请修改", okActionMethod: nil)
                flag = false
                return flag
            }
        }
        else
        {
            print("未输入您的邮箱")
            self.showAlertView(messageStr: "未输入您的邮箱", okActionMethod: nil)
            
            flag = false
            return flag
        }
        
        //  提交订单
        print("^_^  提交的实体\(travelOrderForm)")
        
        return flag
    }
    
    
    //检出字符串为空或者nil
    func checkStrEmptyOrNil(myStr:String?) -> Bool
    {
        if myStr == nil
        {
            return true
        }
        if (myStr?.isEmpty)!
        {
            return true
        }
        
        return false
    }
    
    //显示AlertView
    func showAlertView(titleStr:String = "",messageStr:String,isHasCancel:Bool = false,okActionMethod:(()->Void)!) -> Void
    {
        let alertController = UIAlertController(title: titleStr, message: messageStr,preferredStyle: .alert)
        
        if isHasCancel
        {
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            cancelAction.setValue(TBIThemePrimaryTextColor, forKey: "_titleTextColor")
            alertController.addAction(cancelAction)
        }
        
        let okAction = UIAlertAction(title: "确定", style: .default, handler:
        {action in
            if okActionMethod != nil
            {
                okActionMethod()
            }
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //验证邮箱📮
    func validateEmail(email: String) -> Bool
    {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    //验证手机号📱
    func validatePhoneNum(phoneNum: String) -> Bool
    {
        let phoneRegex = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"
        let phoneTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNum)
    }
    
}









