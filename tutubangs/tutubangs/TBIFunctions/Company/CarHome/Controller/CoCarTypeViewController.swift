//
//  CoCarTypeViewController.swift
//  shop
//
//  Created by TBI on 2018/1/20.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

//选择车型
protocol CoCarTypeListener
{
    func onClickListener(row:Int) -> Void
}


class CoCarTypeViewController: CompanyBaseViewController {

    fileprivate let bgScrollView:UIScrollView =  UIScrollView(frame: UIScreen.main.bounds)
    
    fileprivate let tableView = UITableView()
    
    //let footerView:CoBgFooterView = CoBgFooterView()
    
    fileprivate let coCarTypeScrollTableViewCellIdentify = "coCarTypeScrollTableViewCellIdentify"
    
    fileprivate let coCarTypeDetailTableViewCellIdentify = "coCarTypeDetailTableViewCellIdentify"
    
    fileprivate let coCarTypeDetailMessageTableViewCellIdentify = "coCarTypeDetailMessageTableViewCellIdentify"
    
    fileprivate let coCarTableViewFooterViewIdentify = "coCarTableViewFooterViewIdentify"
    
    fileprivate let carList:[(carType:String,carImage:String)] = [(carType:"五人座公务用车",carImage:"ic_car_crown"),(carType:"七人座商务车",carImage:"ic_car_gl8")]
    
    fileprivate var selectCarType:Int = 0
    
    fileprivate var carDetail:[[(title:String,image:String,number:String)]] = [[(title:"最多可容纳乘客",image:"ic_car_people",number:"x4"),(title:"24寸以下行李",image:"ic_car_baggage_small",number:"x2")],[(title:"最多可容纳乘客",image:"ic_car_people",number:"x6"),(title:"24寸以上行李",image:"ic_car_baggage_big",number:"x2"),(title:"或24寸以下行李",image:"ic_car_baggage_small",number:"x2")]]
    
    var coCarForm:CoCarForm.CarVO = CoCarForm.CarVO()
    
    var travelNo:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBlackTitleAndNavigationColor(title: "选择车型")
        setNavigationBackButton(backImage: "left")
        
    }
    
    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

}

extension CoCarTypeViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    
    func initTableView () {
        bgScrollView.backgroundColor = TBIThemeBaseColor
        bgScrollView.showsVerticalScrollIndicator = false
        bgScrollView.contentSize =  CGSize(width: 0, height: ScreentWindowHeight)
        self.view.addSubview(bgScrollView)
        bgScrollView.snp.makeConstraints { (make) in
            make.left.top.bottom.right.equalToSuperview()
        }
      
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.isScrollEnabled = false
        self.bgScrollView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(ScreenWindowWidth)
            make.height.equalTo(341)
        }
        tableView.register(MineHomeTableViewFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: mineHomeTableViewHeaderViewIdentify)
        tableView.register(CoCarTableViewFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: coCarTableViewFooterViewIdentify)
        tableView.register(CoCarTypeDetailTableViewCell.self, forCellReuseIdentifier: coCarTypeDetailTableViewCellIdentify)
        tableView.register(CoCarTypeScrollTableViewCell.self, forCellReuseIdentifier: coCarTypeScrollTableViewCellIdentify)
        tableView.register(CoCarTypeDetailMessageTableViewCell.self, forCellReuseIdentifier: coCarTypeDetailMessageTableViewCellIdentify)
        
//        self.bgScrollView.addSubview(footerView)
//        footerView.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview()
//            make.top.equalTo(tableView.snp.bottom).offset(85)
//            make.width.equalTo(ScreenWindowWidth)
//            make.height.equalTo(90)
//            make.bottom.equalToSuperview()
//        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
             return 10
        }
        return 77
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let footerView:MineHomeTableViewFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: mineHomeTableViewHeaderViewIdentify) as! MineHomeTableViewFooterView
            return footerView
        }else {
            let footerView:CoCarTableViewFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: coCarTableViewFooterViewIdentify) as! CoCarTableViewFooterView
            footerView.submitButton.addTarget(self, action: #selector(nextButton(sender:)), for: UIControlEvents.touchUpInside)
            return footerView
        }
    }
    
    //MARK:- UITableViewDataSources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return carDetail[selectCarType].count + 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 125
        }else if indexPath.section == 1 {
            if indexPath.row < carDetail[selectCarType].count {
                return 35
            }else {
                return 58
            }
        }
        return 92
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: coCarTypeScrollTableViewCellIdentify, for: indexPath) as! CoCarTypeScrollTableViewCell
            cell.coCarTypeListener = self
            cell.fullCell(data:carList,selectdIndex: selectCarType)
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 1 {
            if indexPath.row < carDetail[selectCarType].count {
                let cell = tableView.dequeueReusableCell(withIdentifier: coCarTypeDetailTableViewCellIdentify, for: indexPath) as! CoCarTypeDetailTableViewCell
                cell.fullCell(data:carDetail[selectCarType][indexPath.row])
                cell.selectionStyle = .none
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: coCarTypeDetailMessageTableViewCellIdentify, for: indexPath) as! CoCarTypeDetailMessageTableViewCell
            cell.selectionStyle = .none
            return cell
            
        }
        return UITableViewCell()
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}

extension  CoCarTypeViewController: CoCarTypeListener{
    
    func onClickListener(row:Int) -> Void {
        selectCarType = row
        if row == 1 {
            tableView.snp.updateConstraints { (make) in
                make.height.equalTo(341+58)
            }
        }else {
            tableView.snp.updateConstraints { (make) in
                make.height.equalTo(341)
            }
        }
        //self.tableView.reloadSections([1], with: UITableViewRowAnimation.automatic)
        self.tableView.reloadData()
    }
    
    
    func nextButton(sender:UIButton){
        let vc = CoCarOrderViewController()
        self.coCarForm.carTypeId = "\(selectCarType + 1)"
        vc.coCarForm = self.coCarForm
        vc.travelNo = self.travelNo
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

