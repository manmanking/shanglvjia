//
//  FlightSelectPersonViewController.swift
//  shop
//
//  Created by TBI on 2017/6/6.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class FlightSelectPersonViewController: BaseViewController {

    typealias CustomerSelecteResult = ([UserDetail.Customer])->Void
    
    fileprivate var tableView:UITableView = UITableView()
    
    fileprivate var submitButton:UIButton = UIButton()
    
    fileprivate let flightSelectPersonTableViewCellIdentify = "flightSelectPersonTableViewCellIdentify"
    
    public var customerList:[UserDetail.Customer]?
    
    public var selectCustomerList:[UserDetail.Customer] = []
    
    public var customerSelecteResult:CustomerSelecteResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController ()
        initTableView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigationController (){
        setTitle(titleStr: "选择常用旅客")
        self.view.backgroundColor = TBIThemeBaseColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        setNavigationBgColor(color:TBIThemeBlueColor)
        setNavigationBackButton(backImage: "back")
    }
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
extension FlightSelectPersonViewController: UITableViewDelegate,UITableViewDataSource {
    
    func initTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.register(MineHomeTableViewFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: mineHomeTableViewHeaderViewIdentify)
        tableView.register(FlightSelectPersonTableViewCell.classForCoder(), forCellReuseIdentifier:flightSelectPersonTableViewCellIdentify)

        let footerView = UIView.init(frame: CGRect(x:0,y:0,width:ScreenWindowWidth,height:82))
        tableView.tableFooterView = footerView
        submitButton.setTitle("确定", for: UIControlState.normal)
        submitButton.backgroundColor = TBIThemeOrangeColor
        submitButton.layer.cornerRadius = 2
        submitButton.addTarget(self, action: #selector(submitButtonAction), for: UIControlEvents.touchUpInside)
        
        footerView.addSubview(submitButton)
        submitButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(30)
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            
        }
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return customerList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let footerView:MineHomeTableViewFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: mineHomeTableViewHeaderViewIdentify) as! MineHomeTableViewFooterView
        return footerView
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: flightSelectPersonTableViewCellIdentify) as! FlightSelectPersonTableViewCell
        cell.fillCell(model: customerList?[indexPath.row], index: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    // MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FlightSelectPersonTableViewCell
        if cell.buttom.isSelected {
            cell.buttom.isSelected = false
            selectCustomerList = selectCustomerList.filter{$0.cardNo != customerList?[indexPath.row].cardNo}
        }else {
            cell.buttom.isSelected = true
            selectCustomerList.append((customerList?[indexPath.row])!)
        }
       
    }
    func submitButtonAction()  {
        if selectCustomerList.count < 1  {
            alertView(title: "提示",message: "请选择常用旅客")
            return
        }
        customerSelecteResult?(selectCustomerList)
        _ = self.navigationController?.popViewController(animated: true)
    }
    

}
