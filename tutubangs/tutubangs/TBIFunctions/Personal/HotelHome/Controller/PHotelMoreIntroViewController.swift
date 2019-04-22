//
//  PHotelMoreIntroViewController.swift
//  tutubangs
//
//  Created by tbi on 2018/10/25.
//  Copyright © 2018 manman. All rights reserved.
//

import UIKit

class PHotelMoreIntroViewController: PersonalBaseViewController,UITableViewDelegate,UITableViewDataSource {

    private let replaceStr = "暂无"
    public var hotelName:String = String()
    public var introModel = PersonalHotelIntroModel()
    
    private var tableView:UITableView = UITableView()
     private var hotelImageViewArr:[String] = Array()
    ///酒店介绍
    private var hotelIntroArr:[(oneTitle:String,oneContent:String,twoTitle:String,twoContent:String)] = Array()
    ///酒店政策
    private var hotelPolicyArr:[(oneTitle:String,oneContent:String,twoTitle:String,twoContent:String)] = Array()
    ///酒店设施
     private var hotelSettingArr:[(oneTitle:String,oneContent:String)] = Array()
    //酒店描述
    public var hotelDescription:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.alpha = 1
        self.automaticallyAdjustsScrollViewInsets = true
        setBlackTitleAndNavigationColor(title: hotelName)
         self.view.backgroundColor = TBIThemeWhite
        
        if hotelDescription?.isEmpty == false && hotelDescription != nil{
            hotelImageViewArr.append("酒店描述")
        }
        hotelImageViewArr.append("酒店介绍")
        hotelImageViewArr.append("酒店政策")
        hotelImageViewArr.append("酒店设施")
        
        fillData()
        
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.delegate = self
        tableView.dataSource  = self
        tableView.bounces = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension        
        tableView.register(VisaTitleCell.self, forCellReuseIdentifier: "VisaTitleCell")
        tableView.register(PersonalHotelIntroDetailCell.classForCoder(), forCellReuseIdentifier:"PersonalHotelIntroDetailCell")
         tableView.register(PersonalHotelIntroCell.classForCoder(), forCellReuseIdentifier:"PersonalHotelIntroCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(0)
        }
    }
    
    func fillData(){
        hotelIntroArr.append(("酒店星级","酒店星级","行政区",CommonTool.return(introModel.distName, replaceStr: replaceStr)))
        hotelIntroArr.append(("开业时间",CommonTool.return(introModel.openTime, replaceStr: replaceStr),"装修时间",CommonTool.return(introModel.renovationTime, replaceStr: replaceStr)))
         hotelIntroArr.append(("电话",CommonTool.return(introModel.hotelfax, replaceStr: replaceStr),"",""))
         hotelIntroArr.append(("所属品牌",CommonTool.return(introModel.brandName, replaceStr: replaceStr),"",""))
         hotelIntroArr.append(("商圈",CommonTool.return(introModel.bussinessName, replaceStr: replaceStr),"",""))
        
        hotelPolicyArr.append(("入住时间",CommonTool.return(introModel.arivalTime, replaceStr: replaceStr),"离店时间",CommonTool.return(introModel.depTime, replaceStr: replaceStr)))
        
        hotelSettingArr.append(("网络",CommonTool.return(introModel.networkDesc, replaceStr: replaceStr)))
        hotelSettingArr.append(("停车",CommonTool.return(introModel.parkDesc, replaceStr: replaceStr)))
        hotelSettingArr.append(("周边交通",CommonTool.return(introModel.trafficDesc, replaceStr: replaceStr)))
        hotelSettingArr.append(("商务服务",CommonTool.return(introModel.conferenceAmenities, replaceStr: replaceStr)))
        hotelSettingArr.append(("餐饮",CommonTool.return(introModel.diningAmenities, replaceStr: replaceStr)))
    }

    override func backButtonAction(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return hotelImageViewArr.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
            let headView:VisaSectionHeaderView = VisaSectionHeaderView()
            headView.titleLabel.text = hotelImageViewArr[section]
            headView.rightButton.isHidden = true
            return headView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hotelImageViewArr[section] == "酒店描述"
        {
            return 1
        }else if hotelImageViewArr[section] == "酒店介绍"
        {
            return hotelIntroArr.count
        }else if hotelImageViewArr[section] == "酒店政策"
        {
            return hotelPolicyArr.count
        }else {
            return hotelSettingArr.count
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if hotelImageViewArr[section] == "酒店描述"
        {
            return 0
        }
        return 10
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init()
        view.backgroundColor = TBIThemeWhite
        return view
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if hotelImageViewArr[indexPath.section] == "酒店描述"{
            let cell:VisaTitleCell = tableView.dequeueReusableCell(withIdentifier: "VisaTitleCell") as! VisaTitleCell
            cell.fillDataSources(visaName:hotelDescription!)
            cell.titleLabel.font = UIFont.systemFont(ofSize: 13)
            cell.titleLabel.textColor = PersonalThemeMinorTextColor
            return cell
        }else if hotelImageViewArr[indexPath.section] == "酒店介绍"{
            if indexPath.row < 2{
                let cell:PersonalHotelIntroCell = tableView.dequeueReusableCell(withIdentifier: "PersonalHotelIntroCell") as! PersonalHotelIntroCell
                cell.setCellWithData(oneTitle: hotelIntroArr[indexPath.row].oneTitle, oneContent: hotelIntroArr[indexPath.row].oneContent, twoTitle: hotelIntroArr[indexPath.row].twoTitle, twoContent: hotelIntroArr[indexPath.row].twoContent)
                return cell
            }else{
                let cell:PersonalHotelIntroDetailCell  = tableView.dequeueReusableCell(withIdentifier: "PersonalHotelIntroDetailCell") as! PersonalHotelIntroDetailCell
                cell.setCell(leftStr: hotelIntroArr[indexPath.row].oneTitle, rightStr: hotelIntroArr[indexPath.row].oneContent)
                return cell
            }
            
        }else if hotelImageViewArr[indexPath.section] == "酒店政策"
        {
            let cell:PersonalHotelIntroCell = tableView.dequeueReusableCell(withIdentifier: "PersonalHotelIntroCell") as! PersonalHotelIntroCell
            cell.setCellWithData(oneTitle: hotelPolicyArr[indexPath.row].oneTitle, oneContent: hotelPolicyArr[indexPath.row].oneContent, twoTitle: hotelPolicyArr[indexPath.row].twoTitle, twoContent: hotelPolicyArr[indexPath.row].twoContent)
            return cell
        }else{
            let cell:PersonalHotelIntroDetailCell  = tableView.dequeueReusableCell(withIdentifier: "PersonalHotelIntroDetailCell") as! PersonalHotelIntroDetailCell
            cell.setCell(leftStr: hotelSettingArr[indexPath.row].oneTitle, rightStr: hotelSettingArr[indexPath.row].oneContent)
            return cell
        }
        
    }
   
}
