//
//  RecommendedFlightView.swift
//  shanglvjia
//
//  Created by manman on 2018/4/2.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class RecommendedFlightView: UIView,UITableViewDelegate,UITableViewDataSource{

    typealias RecommendedFlightViewSelectedFlightCabinBlock = (NSInteger)->Void
    
    public var recommendedFlightViewSelectedFlightCabinBlock:RecommendedFlightViewSelectedFlightCabinBlock!
    
    private var recommendFlightTripArr:[FlightSVSearchResultVOModel.AirfareVO] = Array()
    
    
    private let tableViewCellIdentify:String = "tableViewCellIdentify"
    private let baseBackgroundView:UIView = UIView()
    
    private let subBaseBackgroundView:UIView = UIView()
    private let tableView:UITableView = UITableView()
    
    private var selectedIndex:NSInteger = 0
    
    
    /// 请求的仓位 是否违背政策
    private var requestCabinsPolicy:Bool = false
    
    private let confirmButton:UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseBackgroundView.backgroundColor = UIColor.black
        baseBackgroundView.alpha = 0.6
        baseBackgroundView.addOnClickListener(target: self, action: #selector(cancelAction))
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        subBaseBackgroundView.backgroundColor = TBIThemeWhite
        subBaseBackgroundView.clipsToBounds = true
        subBaseBackgroundView.layer.cornerRadius = 4
        self.addSubview(subBaseBackgroundView)
        subBaseBackgroundView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(160)
            make.left.right.equalToSuperview().inset(15)
        }
        setUIViewAutoLayout()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUIViewAutoLayout() {
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(RecommendedFlightTableViewCell.classForCoder(), forCellReuseIdentifier: tableViewCellIdentify)
        subBaseBackgroundView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
            make.left.right.equalToSuperview()
        }

        
        confirmButton.setTitle("违背预订", for: UIControlState.normal)
        confirmButton.addTarget(self, action: #selector(selectedFlightCabin(sender:)), for: UIControlEvents.touchUpInside)
        confirmButton.setTitleColor(TBIThemeWhite, for: UIControlState.normal)
        confirmButton.backgroundColor = TBIThemeRedColor
        subBaseBackgroundView.addSubview(confirmButton)
        confirmButton.layer.cornerRadius = 4
        confirmButton.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
 
    }
    
    //MARK:------fillDataSources-----
    
    func fillDataSources(recommendDataSources:[RecommendFlightResultVOModel]) {
        if (recommendDataSources.first?.result.airfares.count ?? 0) > 0 {
            recommendFlightTripArr = (recommendDataSources.first?.result.airfares)!
        }
        requestCabinsPolicy = recommendDataSources.first?.contraryPolicy ?? false
        tableView.reloadData()
      setConfirmButtonStatus(isAccordPolicy: requestCabinsPolicy)
    }
    
    
    /// 设置 按钮状态
    func setConfirmButtonStatus(isAccordPolicy:Bool) {
        if isAccordPolicy == false {
            confirmButton.setTitle("预订", for: UIControlState.normal)
            confirmButton.backgroundColor = TBIThemeGreenColor
        }else
        {
            confirmButton.setTitle("违背预订", for: UIControlState.normal)
            confirmButton.backgroundColor = TBIThemeRedColor
        }
    }
    
    
    
    
    
    
    
    //MARK:---------UITableViewDataSources----------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendFlightTripArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RecommendedFlightTableViewCell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentify)! as! RecommendedFlightTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        var isSelected:Bool = false
        
        if selectedIndex == indexPath.row {
            isSelected = true
        }
        
        if indexPath.row == 0 {
            let flightInfo:FlightSVSearchResultVOModel.AirfareVO = FlightManager.shareInStance.selectedFlightTripDraw().last!
            let cabinsInfo:FlightSVSearchResultVOModel.CabinVO = flightInfo.cabins[flightInfo.selectedCabinIndex ?? 0]
            cell.fillDataSources(flight: flightInfo, cabins: cabinsInfo, isAccordPolicy: requestCabinsPolicy, index: indexPath.row, selected: isSelected)
        }else
        {
            cell.fillDataSources(flight: (recommendFlightTripArr.first)!, cabins: (recommendFlightTripArr.first?.cabins.first)!, isAccordPolicy: false, index: indexPath.row, selected: isSelected)
           
        }
        weak var weakSelf = self
        cell.recommendedFlightTableViewCellSelectedBlock = {(selected ,index) in
            weakSelf?.modifySelectedStatus(selectedStatus: selected, index: index)
        }
        //cell.fillDataSources(airInfo:recommendFlightTripArr[indexPath.row] , cabins: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 174
    }
    
 
    
    //MARK:--------Action-------
    
    /// 取消
    @objc private func cancelAction() {
        self.removeFromSuperview()
    }
    
    
    
    @objc private func selectedFlightCabin(sender:UIButton) {
        guard verifyWetherContraryPolicyCanOrder(index: selectedIndex) == true else {
            recommendedFlightViewSelectedFlightCabinBlock(0)
            return 
        }
        
        self.removeFromSuperview()
        if recommendedFlightViewSelectedFlightCabinBlock != nil {
            recommendedFlightViewSelectedFlightCabinBlock(selectedIndex)
        }
    }
    /// 验证是否可以预订
    /// 在 返回 true 可以预订 false 不可以
    func verifyWetherContraryPolicyCanOrder(index:NSInteger) -> Bool {
        let userInfo = DBManager.shareInstance.userDetailDraw()
        if userInfo?.busLoginInfo.userBaseInfo.canOrder == "0" && index == 0 {
            return false
        }
        return true
    }
    
    
    private func modifySelectedStatus(selectedStatus:Bool,index:NSInteger) {
        selectedIndex = index
        tableView.reloadData()
        if selectedIndex == 0 {
            setConfirmButtonStatus(isAccordPolicy: requestCabinsPolicy)
        }else
        {
            setConfirmButtonStatus(isAccordPolicy: false)
        }
    }
    
    
    
}
