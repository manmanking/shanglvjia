//
//  ReserveRoomChoiceStaffView.swift
//  shop
//
//  Created by manman on 2017/5/23.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class ReserveRoomChoiceStaffView: UIView,UITableViewDelegate,UITableViewDataSource {

    let reserveRoomChoiceStaffTableViewCellIdentify = "ReserveRoomChoiceStaffTableViewCellIdentify"
    
    
    typealias ReserveRoomChoiceStaffResultBlock  = (NSInteger)->Void
    
    
    
    public  var reserveRoomChoiceStaffResultBlock:ReserveRoomChoiceStaffResultBlock!
    public var tableViewDataSourcesArr:[Traveller] = Array()
    
    public var tableViewDataSourcesSVArr:[QueryPassagerResponse] = Array()
    
    private let selectedDefaultIndex:NSInteger = 100
    
    private var baseBackgroundView = UIView()
    private var subBackgroundView = UIView()
    private var tableView = UITableView()
    private var selectedIndex:NSInteger = 0//self.selectedDefaultIndex //默认值
    private var okayButton:UIButton = UIButton()
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        baseBackgroundView.addOnClickListener(target: self, action: #selector(cancelAction))
        
        baseBackgroundView.backgroundColor = UIColor.black
        baseBackgroundView.alpha = 0.2
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        self.addSubview(subBackgroundView)
        subBackgroundView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(270)
            make.height.equalTo(44 * 3)
            
        }
        
        selectedIndex = selectedDefaultIndex
        
        setUIViewAutolayout()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    private func setUIViewAutolayout() {
        subBackgroundView.backgroundColor = UIColor.red
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.register(ReserveRoomChoiceStaffTableViewCell.classForCoder(), forCellReuseIdentifier: reserveRoomChoiceStaffTableViewCellIdentify)
        subBackgroundView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(44)
        }
        
        okayButton.setTitle("添加", for: UIControlState.normal)
        okayButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        okayButton.addTarget(self, action: #selector(okayButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        okayButton.backgroundColor = UIColor.white
        subBackgroundView.addSubview(okayButton)
        okayButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSourcesSVArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ReserveRoomChoiceStaffTableViewCell = tableView.dequeueReusableCell(withIdentifier:reserveRoomChoiceStaffTableViewCellIdentify) as! ReserveRoomChoiceStaffTableViewCell
        weak var weakSelf = self
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.reserveRoomChoiceStaffSelectedBlock = { (cellIndex) in
            
            weakSelf?.selectedIndex = cellIndex
            weakSelf?.reloadDataSource()
            print(cellIndex)
            
        }
        
        if tableViewDataSourcesSVArr.count > indexPath.row {
            var state:Bool = false
            if selectedIndex == indexPath.row {
                state = true
            }
            let name:String = tableViewDataSourcesSVArr[indexPath.row].name
            let phone:String = tableViewDataSourcesSVArr[indexPath.row].mobiles.first ?? ""
            cell.fillDataSources(name: name, phone: phone, selectedState: state, index: indexPath.row)
        }
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
    public func reloadDataSource() {
        tableView.reloadData()
    }
    
    public func reloadDataSources(passenger:[QueryPassagerResponse]){
        selectedIndex = selectedDefaultIndex
        tableViewDataSourcesSVArr = passenger
        subBackgroundView.snp.updateConstraints { (make) in
            make.height.equalTo(tableViewDataSourcesSVArr.count * 67 + 44)
        }
        tableView.reloadData()
    }
    
    @objc private func okayButtonAction(sender:UIButton)  {
        if selectedIndex == selectedDefaultIndex {
            return
        }
        reserveRoomChoiceStaffResultBlock(selectedIndex)
        cancelAction()
    }
    
   @objc private func cancelAction() {
        self.removeFromSuperview()
    }
    
    

}
