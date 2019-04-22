//
//  TBICommonOptionsView.swift
//  shop
//
//  Created by TBI on 2017/6/21.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

enum OptionsType{
    case single    //单选
    case multiple  //多选
}

class TBICommonOptionsView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    typealias CommonOptionsBlock = ([String])->Void
    
    public  var commonOptionsBlock:CommonOptionsBlock?
    
    
    private let commonOptionsTableViewCellIdentify = "commonOptionsTableViewCellIdentify"
    
    private let baseBackgroundView = UIView()
    
    private let subBackgroundView = UIView()
    
    private let subTitleBackgroundView = UIView()

    private let tableView = UITableView()

    //取消按钮
    private let cancelButton = UIButton()
    
    private let clearsButton = UIButton()
    
    //确定按钮
    private let okButton = UIButton()
    
    //数据源
    public  var datasource:[String] = Array()
    
    public  var optionsType:OptionsType = OptionsType.single
    
    //选中 条件的 角标 集合
    public var selectedData:[String] = Array()
    
    init(frame: CGRect,count:Int) {
        super.init(frame: frame)
        baseBackgroundView.backgroundColor = TBIThemeBackgroundViewColor
        baseBackgroundView.addOnClickListener(target: self, action: #selector(cancelButtonAction))
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        initView(count)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func initView(_ count:Int) {
        
        subBackgroundView.backgroundColor = UIColor.white
        self.addSubview(subBackgroundView)
        subBackgroundView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(count * 45 + 50 )
        }
        subTitleBackgroundView.backgroundColor = TBIThemeLinkColor
        subBackgroundView.addSubview(subTitleBackgroundView)
        subTitleBackgroundView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(50)
        }
        setSubTitleViewAutolayout()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(TBICommonOptionsTableViewCell.classForCoder(), forCellReuseIdentifier:commonOptionsTableViewCellIdentify)
        subBackgroundView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleBackgroundView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    func setSubTitleViewAutolayout() {
        cancelButton.setTitle("取消", for: UIControlState.normal)
        cancelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        cancelButton.titleLabel?.font = UIFont.systemFont( ofSize: 16)
        cancelButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: UIControlEvents.touchUpInside)
        subTitleBackgroundView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.height.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        clearsButton.setTitle("清空", for: UIControlState.normal)
        clearsButton.titleLabel?.font = UIFont.systemFont( ofSize: 16)
        clearsButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        clearsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        clearsButton.addTarget(self, action: #selector(clearsButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        subTitleBackgroundView.addSubview(clearsButton)
        clearsButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(15)
            
        }
        
        okButton.setTitle("确定", for: UIControlState.normal)
        okButton.titleLabel?.adjustsFontSizeToFitWidth = true
        okButton.titleLabel?.font = UIFont.systemFont( ofSize: 16)
        okButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        okButton.addTarget(self, action: #selector(okButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        subTitleBackgroundView.addSubview(okButton)
        okButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(30)
        }
    }
    
    /// 填写数据
    public func fillDataSources(data:[String]) {
        datasource = data
        tableView.reloadData()
    }
    
    
    //MARK:-- UITableViewDataSource start of line
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell:TBICommonOptionsTableViewCell = tableView.dequeueReusableCell(withIdentifier: commonOptionsTableViewCellIdentify) as! TBICommonOptionsTableViewCell
        if selectedData.contains(datasource[indexPath.row]) {
            cell.cellConfig(title:datasource[indexPath.row], selected: true ,index:indexPath.row)
        }else
        {
            cell.cellConfig(title:datasource[indexPath.row], selected: false,index:indexPath.row)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch optionsType {
        case .single:
            selectedData.removeAll()
            selectedData.append(datasource[indexPath.row])
        case .multiple:
            if selectedData.contains(datasource[indexPath.row]) {//如果选中包含再点击取消
                selectedData = selectedData.filter{ $0 != datasource[indexPath.row]}
            }else {// 如果未选中添加
                selectedData.append(datasource[indexPath.row])
            }
        default:
            break
        }
        
        tableView.reloadData()
    }
    
    /// 清空
    ///
    /// - Parameter sender:
    func clearsButtonAction(sender:UIButton) {
        self.selectedData.removeAll()
        tableView.reloadData()
    }
    
    /// 取消
    ///
    /// - Parameter sender:
    func cancelButtonAction() {
        
        self.removeFromSuperview()
    }
    /// 确定
    ///
    /// - Parameter sender:
    func okButtonAction(sender:UIButton) {
        commonOptionsBlock?(selectedData)
        self.removeFromSuperview()
    }
    
}
