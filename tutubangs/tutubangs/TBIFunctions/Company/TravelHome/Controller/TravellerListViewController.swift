//
//  TravellerListViewController.swift
//  shop
//
//  Created by TBI on 2017/7/5.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftDate

class TravellerListViewController: CompanyBaseViewController {

    
    //选择人闭包回掉
    typealias PersonSelectedResultBlock = (TravellerListItem?)->Void
    
    public var personSelectedResultBlock:PersonSelectedResultBlock!
    
    
    fileprivate let bag = DisposeBag()
    
    fileprivate let tableView:UITableView = UITableView()
    
    fileprivate let headerView:TravellerHeaderView = TravellerHeaderView()
    
    fileprivate let footerView:TravellerFootersView = TravellerFootersView()
    
    fileprivate var data:[TravellerListItem]?
    
    fileprivate let travellerTableViewCellIdentify = "travellerTableViewCellIdentify"
    
    fileprivate var selectIndex:Int = 0
    
    var region:TravelForm.Search.Region?
    
    //已经选中的人
    var selectPersonInfoList:[TravelForm.OrderSpecialInfo.OrderSpecialPersonInfo]?
    // 1成人 2儿童
    var personType:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation(title:"选择出行人")
        initView()
    }

    override func viewWillAppear(_ animated: Bool) {
        initData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
extension TravellerListViewController{
    
    
    /// 过滤已经选中的人
    func filterData(){
        guard let list = data else {
            return
        }
        for index in 0..<(data?.count ?? 0){
            let count = selectPersonInfoList?.filter{$0.personIdCard == list[index].idCard}.count ?? 0
            if  count > 0{
                data?.remove(at: index)
            }
        }
        
    }
    //设置数据
    func  initData(){
        showLoadingView()
        TravelService.sharedInstance.travellerList().subscribe{ event in
            self.hideLoadingView()
            switch event{
            case .next(let e):
                self.data = e
                //self.filterData()
                self.tableView.reloadData()
            case .error(let e):
                try? self.validateHttp(e)
            case .completed:
                break
            }
            }.addDisposableTo(self.bag)
    }
    
    func initView (){
         initTableView()
    }
}
extension TravellerListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func initTableView (){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.tableHeaderView = headerView
        //tableView.tableFooterView = footerView
        self.view.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        tableView.register(TravellerTableViewCell.classForCoder(), forCellReuseIdentifier: travellerTableViewCellIdentify)
        self.view.addSubview(tableView)
        footerView.okBtn.addTarget(self, action: #selector(okButton(sender:)), for: .touchUpInside)
        headerView.addBtn.addTarget(self, action: #selector(addButton(sender:)), for: .touchUpInside)
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(-50)
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    // MARK: 创建cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: travellerTableViewCellIdentify, for: indexPath) as! TravellerTableViewCell
        cell.fillCell(model: data?[indexPath.row], index: indexPath.row, selectIndex: selectIndex)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.updateBtn.tag = indexPath.row
        cell.updateBtn.addTarget(self, action: #selector(updateButton(sender:)), for: .touchUpInside)
        return cell
    }
    
    // MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        tableView.reloadData()
    }
    
    // MARK: row高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    
    func updateButton(sender: UIButton) {
        selectIndex = sender.tag
        tableView.reloadData()
        let vc = TravellerAddViewController()
        vc.item = data?[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    func addButton(sender: UIButton) {
        let vc = TravellerAddViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /// 确定
    ///
    /// - Parameter sender:
    func okButton(sender: UIButton) {
        guard data != nil else {
            return
        }

        if data?.isEmpty ?? true{
            self.alertView(title: "提示", message: "请选择出行人")
            return
        }
        
        //        if !((data?.count)! > selectIndex)
//        {
//            
//            return
//        }
        
        
        if data?[selectIndex].travelType !=  personType{
            self.alertView(title: "提示", message: "出行人类型不对,请重新选择")
            return
        }
        //如果是国际校验是否有身份证
        if region == TravelForm.Search.Region.international {
           let passport = data?[selectIndex].passport
            if passport?.isEmpty ?? true{
                self.alertView(title: "提示", message: "国外出行,请填写正确的护照信息,方便您的出行")
                return
            }
        }
        let count = selectPersonInfoList?.filter{$0.personIdCard == data?[selectIndex].idCard}.count ?? 0
        if count > 0 {
            self.alertView(title: "提示", message: "已选择该出行人")
            return
        }
      personSelectedResultBlock(data?[selectIndex])
      _ = self.navigationController?.popViewController(animated: true)
    }

    
}
