//
//  DBManager.swift
//  shanglvjia
//
//  Created by manman on 2018/3/12.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class DBManager: NSObject {
    
    
    private var localNotificationNumCompany:NSInteger = 0
    
    private var localNotificationNumPersonal:NSInteger = 0

    private let PersonalAccountActiveKey:String = "AccountActiveKey"
    
    private let PersonalAccountRightKey:String = "AccountRightKey"
    
    /// 记录当前账户的 权限
    private var accountRight:AccountAllRight = AccountAllRight.Only_Company
    
    /// 记录 当前 激活 状态是否为 企业状态  默认设置为企业状态
    private var isCompanyActive:AppActiveStatus = AppActiveStatus.Company_Active
    
    static let shareInstance = DBManager()
    
    
    override init() {
      super.init()
//        UserDefaults.standard.set(isCompanyActive.rawValue, forKey: PersonalAccountActiveKey)
//        UserDefaults.standard.set(accountRight.rawValue, forKey: PersonalAccountRightKey)
        initLocalDataSources()
    }
    

    /// 初始化 本地数据
    private func initLocalDataSources(){
        localNotificationNumCompany = 0
        localNotificationNumPersonal = 0
        initAccountRight()
    }
    
    private func initAccountRight() {
        
        guard userDetailDraw() != nil else {
            return
        }
       
        let userDetail = userDetailDraw()
        setAccountRight(userDetail: userDetail!)
    }
    
    
    public func setUserNotificationPersonalNum(personal num:NSInteger) {
        localNotificationNumPersonal = num
    }
    
    public func setUserNotificationCompanyNum(company num:NSInteger) {
        localNotificationNumCompany = num
    }
    
    func userNotificationNum() ->NSInteger {
        return localNotificationNumCompany + localNotificationNumPersonal
    }
    
    
    
    
    
    /// 设置 当前 激活状态 为 企业状态
    public func currentActiveCompany() {
        isCompanyActive = AppActiveStatus.Company_Active
        UserDefaults.standard.set(isCompanyActive.rawValue, forKey: PersonalAccountActiveKey)
    }
    
    /// 设置当前 激活状态 为 个人状态
    public func currentActivePersonal() {
        isCompanyActive = AppActiveStatus.Personal_Active
        UserDefaults.standard.set(isCompanyActive.rawValue, forKey: PersonalAccountActiveKey)
    }
    
    /// 获取当前 app 激活状态
    public func getCurrentActive() -> AppActiveStatus {
        if let isCurrentActive = UserDefaults.standard.object(forKey: PersonalAccountActiveKey) {
            let  isCompanyActiveInt = isCurrentActive as! NSInteger
            isCompanyActive = AppActiveStatus.init(rawValue: isCompanyActiveInt)!
            return isCompanyActive
        }
        return AppActiveStatus.Company_Active
    }
    
    /// 获取当前 account 权限
    public func getCurrentAccountRight()->AccountAllRight{
        
        if let accountRightInt = UserDefaults.standard.object(forKey: PersonalAccountRightKey) {
            //let accountRightInt = UserDefaults.standard.object(forKey: PersonalAccountRightKey) as! NSInteger
            accountRight = AccountAllRight.init(rawValue: accountRightInt as! NSInteger)!
            return accountRight
        }
        accountRight = AccountAllRight.Only_Company
        return AccountAllRight.Only_Company
    }
    
    
    private func setAccountRight(userDetail:LoginResponse) {
        if userDetail.busLoginInfo.token.isEmpty == false && userDetail.cusLoginInfo.userStatus == "0" {
            accountRight = AccountAllRight.Both
        }
       
        if userDetail.busLoginInfo.token.isEmpty == true && userDetail.cusLoginInfo.userStatus == "0" {
            accountRight = AccountAllRight.Only_Personal
        }
        
        if (userDetail.busLoginInfo.token.isEmpty == false && userDetail.cusLoginInfo.userStatus == "1"){
            accountRight = AccountAllRight.Only_Company
        }
        UserDefaults.standard.set(accountRight.rawValue, forKey: PersonalAccountRightKey)
        
    }
    
    
    public func userDetailStore(userDetail:LoginResponse) {
        guard userDetail.busLoginInfo.token.isEmpty == false || userDetail.cusLoginInfo.token.isEmpty == false else {
            return
        }
        
        setAccountRight(userDetail: userDetail)
        let encodeData:Data = NSKeyedArchiver.archivedData(withRootObject: userDetail)
        UserDefaults.standard.set(encodeData, forKey: kUserDetail)
        
    }
    
    public func userDetailDraw()->LoginResponse? {
        guard UserDefaults.standard.object(forKey: kUserDetail) != nil else {
            return nil
        }
        let encodeData:Data = UserDefaults.standard.object(forKey: kUserDetail) as! Data
        let userModel:LoginResponse = NSKeyedUnarchiver.unarchiveObject(with: encodeData) as! LoginResponse
        return userModel
    }
    //删除 用户信息
    public func userDetailDelete() {
        UserDefaults.standard.removeObject(forKey: kUserDetail)
        UserDefaults.standard.removeObject(forKey: PersonalContactPersonerNameKey)
        UserDefaults.standard.removeObject(forKey: PersonalContactPersonerPhoneKey)
        UserDefaults.standard.removeObject(forKey: PersonalContactPersonerEmailKey)
        
    }
    
    /// 城市 历史记录 保存
   public func userHistoryCityRecordStore(cityArr:[HotelCityModel]) {
        guard cityArr.count > 0 else {
            return
        }
        var localCityArr:[HotelCityModel] = Array()
        if cityArr.count > 4 {
            for (index,element) in cityArr.enumerated() {
                if index < 4 {
                    localCityArr.append(element)
                }else{
                    break
                }
            }
        }else{
            localCityArr.append(contentsOf: cityArr)
        }
        
        let encodeData:Data = NSKeyedArchiver.archivedData(withRootObject: localCityArr)
        UserDefaults.standard.set(encodeData, forKey: userHistoryRecordKey)
    }
    
    
    /// 添加城市
    public func userHistoryCityRecordAdd(city:HotelCityModel) {
        guard city.cityCode.isEmpty == false else {
            return
        }
        
        var historyCity:[HotelCityModel] = userHistoryCityRecordDraw() ?? Array()
        var isContainTmpCity:Bool = false
        isContainTmpCity = historyCity.contains(where: { (element) -> Bool in
            if element.elongId == city.elongId {
                return true
            }
            return false
        })
        if isContainTmpCity == true {
            for (index,element) in historyCity.enumerated() {
                if element.elongId == city.elongId {
                    historyCity.remove(at: index)
                    historyCity.insert(city, at: 0)
                    userHistoryCityRecordStore(cityArr: historyCity)
                    break
                }
            }
            
            
            return
        }
        
        while historyCity.count >= 4 {
            if historyCity.count == 4 {
                historyCity.removeFirst()
                break
            }
            historyCity.removeLast()
        }
        historyCity.append(city)
        userHistoryCityRecordStore(cityArr: historyCity)
        
        
    }
    
    /// 城市 历史记录 提取
    public func userHistoryCityRecordDraw() ->  [HotelCityModel]?{
        guard UserDefaults.standard.object(forKey: userHistoryRecordKey) != nil else {
            return nil
        }
        let encodeData:Data = UserDefaults.standard.object(forKey: userHistoryRecordKey) as! Data
        let historyCity:[HotelCityModel] = NSKeyedUnarchiver.unarchiveObject(with: encodeData) as! [HotelCityModel]
        return historyCity
    }
    
    /// 城市 历史记录 删除 所有
    public func userHistoryCityRecordDeleteAll() {
        guard UserDefaults.standard.object(forKey: userHistoryRecordKey) != nil else {
            return
        }
        UserDefaults.standard.removeObject(forKey:userHistoryRecordKey)
    }
    ///needFilterPolicy
    public func verifySpecialFilterPolicy(passenger:QueryPassagerResponse) -> Bool {
        guard passenger.uid.isEmpty == false else {
            return false
        }
        
        if passenger.isSpecial == "1" {
            return true
        }
        return false
        
    }
    
    
    
    /// 获得联系人 姓名
    public func personalContactNameDraw() ->String  {
        guard UserDefaults.standard.object(forKey: PersonalContactPersonerNameKey) != nil else {
            return ""
        }
        let name:String = UserDefaults.standard.object(forKey: PersonalContactPersonerNameKey) as! String
        return name
    }
    
    /// 存储联系人 姓名
    public func personalContactNameStore(name:String) {
        guard name.isEmpty == false else {
            return
        }
        UserDefaults.standard.set(name, forKey:PersonalContactPersonerNameKey)
    }
    
    /// 获得联系人手机号
    public func personalContactPhoneDraw() ->String  {
        guard UserDefaults.standard.object(forKey: PersonalContactPersonerPhoneKey) != nil else {
            return ""
        }
        let phone:String = UserDefaults.standard.object(forKey: PersonalContactPersonerPhoneKey) as! String
        return phone
    }
    
    public func personalContactPhoneStore(phone:String) {
        guard phone.isEmpty == false else {
            return
        }
        UserDefaults.standard.set(phone, forKey:PersonalContactPersonerPhoneKey)
    }
    
    /// 获得联系人 email
    public func personalContactEmailDraw() ->String  {
        guard UserDefaults.standard.object(forKey: PersonalContactPersonerEmailKey) != nil else {
            return ""
        }
        let email:String = UserDefaults.standard.object(forKey: PersonalContactPersonerEmailKey) as! String
        return email
    }
   
    public func personalContactEmailStore(email:String) {
        guard email.isEmpty == false else {
            return
        }
        UserDefaults.standard.set(email, forKey:PersonalContactPersonerEmailKey)
    }
 
    
    
    
    
    /// app 激活状态
    enum AppActiveStatus:NSInteger {
        case Company_Active = 1
        case Personal_Active = 2
    }
    
    
    /// 用户权限
    enum AccountAllRight:NSInteger {
        case Both = 1
        case Only_Company = 2
        case Only_Personal = 3
    }
    
    
    
    
    
}
