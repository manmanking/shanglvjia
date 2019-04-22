//
//  CoTrainPassengerController.swift
//  shop
//
//  Created by TBI on 2018/1/4.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CoTrainPassengerController: CompanyBaseViewController {
    
    typealias TrainPassengerResultBlock = (CoTrainCommitForm.SubmitTrainInfo.PassengerInfo,Int)->Void
    
    public var trainPassengerResultBlock:TrainPassengerResultBlock!
    
    fileprivate let tableView = UITableView()
    
    fileprivate let coTrainPassengerTableViewCellIdentify = "coTrainPassengerTableViewCellIdentify"
    
    fileprivate let footerView:CoTrainPassengerFooter = CoTrainPassengerFooter()
    
    var passenger:CoTrainCommitForm.SubmitTrainInfo.PassengerInfo?
    
    var updateRow:Int = 0
    
    fileprivate let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation(title:"乘车人")
        if passenger?.passportTypeseId.isEmpty == true {
            passenger?.passportTypeseId = "2"
        }
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

extension CoTrainPassengerController:  UITableViewDelegate,UITableViewDataSource {
    
    func initTableView() {
        //设置tableview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(CoTrainPassengerTableViewCell.self, forCellReuseIdentifier: coTrainPassengerTableViewCellIdentify)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
        footerView.submitButton.addTarget(self, action: #selector(submit(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    func submit(sender:UIButton){
        if passenger?.passportTypeseId == "1" {
            guard (passenger?.passportNo.value.validate(.card))! else {
                showSystemAlertView(titleStr: "提示", message: "证件号不正确")
                return
            }
        }
        trainPassengerResultBlock(passenger!,updateRow)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: coTrainPassengerTableViewCellIdentify, for: indexPath) as! CoTrainPassengerTableViewCell
        cell.selectionStyle = .none
        cell.fillCell(index: indexPath.row,model:passenger)
        if indexPath.row == 2 {
            cell.nameLabel.rx.text.orEmpty.bind(to: (passenger?.passportNo)!).addDisposableTo(bag)
        }
        
        return cell
    }
    // MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            weak var weakSelf = self
            let titleArr:[String] = ["身份证","护照"]
            let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
            roleView.fontSize = UIFont.systemFont(ofSize: 16)
            roleView.finderViewSelectedResultBlock = { (cellIndex) in
                weakSelf?.passenger?.passportTypeseId = "\(cellIndex + 1)"
                weakSelf?.tableView.reloadData()
            }
            KeyWindow?.addSubview(roleView)
            roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
        }
    }
    
    // MARK: row高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

