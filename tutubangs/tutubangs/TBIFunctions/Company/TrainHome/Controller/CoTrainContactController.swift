//
//  CoTrainContactController.swift
//  shop
//
//  Created by TBI on 2018/1/4.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CoTrainContactController: CompanyBaseViewController {
    
    typealias TrainContactResultBlock = (CoTrainCommitForm.ContactInfo)->Void
    
    public var trainContactResultBlock:TrainContactResultBlock!
    
    fileprivate let tableView = UITableView()
    
    fileprivate let coTrainContactTableViewCellIdentify = "coTrainContactTableViewCellIdentify"
    
    fileprivate let footerView:CoTrainContactFooter = CoTrainContactFooter()
    
    var contact:CoTrainCommitForm.ContactInfo?
    
    fileprivate let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        initNavigation(title: "修改联系人")
        setBlackTitleAndNavigationColor(title:"修改联系人")
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

extension CoTrainContactController:  UITableViewDelegate,UITableViewDataSource {
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
        guard contact?.contactName.value.isNotEmpty ?? true else {
            self.alertView(title: "提示", message: "联系人姓名不能为空")
            return
        }
        guard (contact?.contactPhone.value.validate(.phone))! else {
            self.alertView(title: "提示", message: "请输入正确的手机号码")
            return
        }
        trainContactResultBlock(contact!)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  3
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
        cell.fillCell(index: indexPath.row,model:contact)
        if indexPath.row == 0 {
            cell.nameLabel.rx.text.orEmpty.bind(to: (contact?.contactName)!).addDisposableTo(bag)
        }else if indexPath.row == 1 {
            cell.nameLabel.rx.text.orEmpty.bind(to: (contact?.contactPhone)!).addDisposableTo(bag)
        }else {
            cell.nameLabel.rx.text.orEmpty.bind(to: (contact?.contactEmail)!).addDisposableTo(bag)
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
