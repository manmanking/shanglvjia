//
//  CoCarPersonController.swift
//  shop
//
//  Created by TBI on 2018/1/25.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

import UIKit
import RxCocoa
import RxSwift

class CoCarPersonController: CompanyBaseViewController {
    
    typealias CarPersonResultBlock = (CoCarForm.CarPassenger,Int)->Void
    
    public var carPersonResultBlock:CarPersonResultBlock!
    
    fileprivate let tableView = UITableView()
    
    fileprivate let coTrainContactTableViewCellIdentify = "coTrainContactTableViewCellIdentify"
    
    fileprivate let footerView:CoTrainContactFooter = CoTrainContactFooter()
    
    var passenger:CoCarForm.CarPassenger?
    
    var updateRow:Int = 0
    
    fileprivate let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation(title:"乘车人")
        initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}

extension CoCarPersonController:  UITableViewDelegate,UITableViewDataSource {
    func initTableView() {
        //设置tableview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(CoTrainContactTableViewCell.self, forCellReuseIdentifier: coTrainContactTableViewCellIdentify)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
        footerView.submitButton.addTarget(self, action: #selector(submit(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    func submit(sender:UIButton){
        guard (passenger?.phone.value.validate(.phone))! else {
            self.alertView(title: "提示", message: "联系人手机格式不正确")
            return
        }
        carPersonResultBlock(passenger!,updateRow)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vi = UIView()
        vi.backgroundColor = TBIThemeBaseColor
        return vi
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 76
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    // MARK: 创建cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: coTrainContactTableViewCellIdentify, for: indexPath) as! CoTrainContactTableViewCell
        cell.selectionStyle = .none
        cell.carFillCell(index: indexPath.row,model:passenger)
        if indexPath.row == 1 {
            cell.nameLabel.rx.text.orEmpty.bind(to: (passenger?.phone)!).addDisposableTo(bag)
        }
        return cell
    }
    // MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: row高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
