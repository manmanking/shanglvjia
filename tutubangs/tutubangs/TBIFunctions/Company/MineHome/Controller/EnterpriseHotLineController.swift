//
//  EnterpriseHotLineController.swift
//  shop
//
//  Created by zhanghao on 2017/7/14.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import SwiftyJSON

class EnterpriseHotLineController : CompanyBaseViewController {
    var phoneContentView:UIView! = nil
    var phoneTableView:UITableView! = nil
    public var dataArray:[ServicesPhoneModel] = Array()
    var phoneArray = ["缺失",DefHotLine]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = TBIThemeBaseColor
        //initData()
        servicesPhone()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        initView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initView() -> Void{
        setBlackTitleAndNavigationColor(title: "联系客服")

        navigationController?.setNavigationBarHidden(false, animated: false)
        
        phoneContentView = UIView(frame: CGRect(x: 0, y: 1, width: ScreenWindowWidth, height: ScreentWindowHeight))
        self.view.addSubview(phoneContentView)
        
        phoneTableView = UITableView()
        phoneTableView.delegate = self
        phoneTableView.dataSource = self
        phoneTableView.backgroundColor = TBIThemeBaseColor
        self.phoneContentView.addSubview(phoneTableView)
        phoneTableView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.bottom.equalTo(0)
        }
        phoneTableView.tableFooterView = UIView()
        phoneTableView.separatorStyle = .none
        phoneTableView.rowHeight = UITableViewAutomaticDimension
        phoneTableView.estimatedRowHeight = 44
    }
    override func backButtonAction(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func initData() -> Void{
        weak var weakSelf = self
        let userInfo = UserDefaults.standard.string(forKey: USERINFO)
        if userInfo != nil {
            let json = JSON(parseJSON: userInfo!)
            let userDetail = UserDetail(jsonData:json)
            let form = HotLineRequest(userName: userDetail.userName)
            UserService.sharedInstance
                .getHotLine(form)
                .subscribe{ event in
                if case .next(let e) = event {
                    
                    weakSelf?.dataArray.removeAll()
                    for element in e
                    {
                        if element.platform.range(of: "nw") == nil
                        {
                            weakSelf?.dataArray.append(element)
                        }
                    }
                    weakSelf?.phoneTableView.reloadData()
                }
            }
        }
    }
    
    func servicesPhone() {
        dataArray.removeAll()
        let userInfo = DBManager.shareInstance.userDetailDraw()
        if userInfo?.busLoginInfo.userBaseInfo.corpBsaeInfo.airHotline.isEmpty == false {
            let servicesPhone:ServicesPhoneModel = ServicesPhoneModel()
            servicesPhone.phoneNum = userInfo?.busLoginInfo.userBaseInfo.corpBsaeInfo.airHotline ?? ""
            servicesPhone.platform =  EnterpriseHotLineController
                .TBIServicesCategoryServicesPhoneLocal.Air_ServicesPhone.rawValue
            dataArray.append(servicesPhone)
        }
        if userInfo?.busLoginInfo.userBaseInfo.corpBsaeInfo.hotelHotline.isEmpty == false {
            let servicesPhone:ServicesPhoneModel = ServicesPhoneModel()
            servicesPhone.phoneNum = userInfo?.busLoginInfo.userBaseInfo.corpBsaeInfo.hotelHotline ?? ""
            servicesPhone.platform =  EnterpriseHotLineController
                .TBIServicesCategoryServicesPhoneLocal.Hotel_ServicesPhone.rawValue
            dataArray.append(servicesPhone)
        }
        if userInfo?.busLoginInfo.userBaseInfo.corpBsaeInfo.trainHotline.isEmpty == false {
            let servicesPhone:ServicesPhoneModel = ServicesPhoneModel()
            servicesPhone.phoneNum = userInfo?.busLoginInfo.userBaseInfo.corpBsaeInfo.trainHotline ?? ""
            servicesPhone.platform =  EnterpriseHotLineController
                .TBIServicesCategoryServicesPhoneLocal.Train_ServicesPhone.rawValue
            dataArray.append(servicesPhone)
        }
        if userInfo?.busLoginInfo.userBaseInfo.corpBsaeInfo.carHotline.isEmpty == false {
            let servicesPhone:ServicesPhoneModel = ServicesPhoneModel()
            servicesPhone.phoneNum = userInfo?.busLoginInfo.userBaseInfo.corpBsaeInfo.carHotline ?? ""
            servicesPhone.platform =  EnterpriseHotLineController
                .TBIServicesCategoryServicesPhoneLocal.Car_ServicesPhone.rawValue
            dataArray.append(servicesPhone)
        }
        
    }
    
    
    enum TBIServicesCategoryServicesPhoneNET:String {
        case Air_ServicesPhone = "air"
        case Hotel_ServicesPhone = "Hotel"
        case Train_ServicesPhone = "Train"
        case Car_ServicesPhone = "Car"
        
        init(type:String){
            if type == "air" {
                self = .Air_ServicesPhone
            }else if type == "hotel" {
                self = .Hotel_ServicesPhone
            }else if type == "train"
            {
                self = .Train_ServicesPhone
            }else
            {
              self = .Car_ServicesPhone
            }
        }
    }
    
    enum TBIServicesCategoryServicesPhoneLocal:String {
        case Air_ServicesPhone = "air"
        case Air_OverTimeServicesPhone = "nwair"
        case Hotel_ServicesPhone = "hotel"
        case Hotel_OverTimeServicesPhone = "nwhotel"
        case Train_ServicesPhone = "train"
        case Train_OverTimeServicesPhone = "nwtrain"
        case Car_ServicesPhone = "car"
        case Car_OverTimeServicesPhone = "nwcar"
        
        init(type:String){
            if type == "air" {
                self = .Air_ServicesPhone
            }else if type == "nwair"
            {
                self = .Air_OverTimeServicesPhone
            }
            else if type == "hotel" {
                self = .Hotel_ServicesPhone
            }else if type == "nwhotel"
            {
                self = .Hotel_OverTimeServicesPhone
            }
            else if type == "train"
            {
                self = .Train_ServicesPhone
            }else if type == "nwtrain"
            {
                self = .Train_OverTimeServicesPhone
            }else if type == "car"
            {
                self = .Car_ServicesPhone
            }
            else
            {
                self = .Car_OverTimeServicesPhone
            }
        }
    }
   
    func servicesCategoryServicesPhoneNETConvertChinese(type:TBIServicesCategoryServicesPhoneNET)->String {
        switch type {
        case .Air_ServicesPhone:
            return "机票客服"
        case .Hotel_ServicesPhone:
            return "酒店客服"
        case .Train_ServicesPhone:
            return "火车票客服"
        case .Car_ServicesPhone:
            return "专车客服"
            
        }
    }
 
}
extension EnterpriseHotLineController:UITableViewDelegate,UITableViewDataSource{
    // cell内容的显示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EnterpriseHotLineCell(style: .default, reuseIdentifier: "a")
        let servicesType:TBIServicesCategoryServicesPhoneNET = TBIServicesCategoryServicesPhoneNET.init(type:dataArray[indexPath.row].platform)
        cell.leftLabel.text = servicesCategoryServicesPhoneNETConvertChinese(type:servicesType)
        cell.rightLabel.text = dataArray[indexPath.row].phoneNum
        return cell
    }
    // 返回行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    // 选中状态
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        UIApplication.shared.openURL(NSURL(string :"tel://"+dataArray[indexPath.row].phoneNum)! as URL)
    }
}
