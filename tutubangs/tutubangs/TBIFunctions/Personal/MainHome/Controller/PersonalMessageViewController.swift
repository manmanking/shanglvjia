//
//  PersonalMessageViewController.swift
//  shanglvjia
//
//  Created by tbi on 05/09/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit
import RxSwift
import MJRefresh

class PersonalMessageViewController: PersonalBaseViewController {

    /// 1 是订单  2 是 优惠服务
    public var messageType:String = ""
    
    
    fileprivate var detailTable = UITableView()
    
    private var selectedContinentButton:MyTitleButton = MyTitleButton()
    fileprivate let titleArr = ["订单服务","优惠活动"]
    
    fileprivate let buttonsView = PersonalMineShadowView()
    
    fileprivate var messageArr:[PersonalMessageModel.PushListVo] = Array()
    
    fileprivate var page:Int = 1
    
    fileprivate let bag = DisposeBag()
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        self.automaticallyAdjustsScrollViewInsets = false
        UserDefaults.standard.set(false, forKey: pushNewMessage)
        initTableView()
        initTopView()
        if messageType.isEmpty == true {
            messageType = "1"
            getPersonalMessageOrder()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBlackTitleAndNavigationColor(title: "消息列表")
        if messageType.isEmpty == false {
            if messageType == "1" {
                getPersonalMessageOrder()
            }else {
                getPersonalMessageOther()
            }
        }
        
    }
    func initTableView() {
        self.view.addSubview(detailTable)
        detailTable.backgroundColor = TBIThemeBaseColor
        detailTable.separatorStyle=UITableViewCellSeparatorStyle.none
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        detailTable.estimatedRowHeight = 200
        detailTable.delegate = self
        detailTable.dataSource = self
        detailTable.rowHeight = UITableViewAutomaticDimension
        detailTable.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(54)
            make.bottom.equalToSuperview()
        }
        
        detailTable.register(UINib(nibName: "TableNoDateView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableNoDateView")
        detailTable.register(PersonalMessageCell.self, forCellReuseIdentifier: "PersonalMessageCell")
        
        //监听下拉刷新 上啦加载
        detailTable.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(PersonalMessageViewController.initData))
        detailTable.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(PersonalMessageViewController.loadMoreData))
        detailTable.mj_header.beginRefreshing()
        
        
    }
    func initTopView(){
        self.view.addSubview(buttonsView)
        buttonsView.backgroundColor = TBIThemeWhite
        buttonsView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(-2)
            make.right.equalToSuperview().offset(2)
            make.height.equalTo(44)
        }
        
        for i in 0...titleArr.count-1 {
            let titileButton:MyTitleButton = MyTitleButton.init(type: UIButtonType.custom)
            titileButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            titileButton.setTitleColor(TBIThemeMinorTextColor, for: .normal)
            titileButton.setTitle(titleArr[i], for: .normal)
            titileButton.tag = i
            titileButton.addTarget(self, action: #selector(titileButtonClick(sender:)), for: UIControlEvents.touchUpInside)
            buttonsView.addSubview(titileButton)
            titileButton.snp.makeConstraints({ (make) in
                make.top.equalToSuperview()
                make.height.equalTo(44)
                make.left.equalTo(i*Int(ScreenWindowWidth/2))
                make.width.equalToSuperview().dividedBy(2)
            })
            if messageType.isEmpty == true {
                if i == 0 {
                    selectedContinentButton = titileButton
                    selectedContinentButton.setTitleColor(PersonalThemeDarkColor, for: .normal)
                    selectedContinentButton.lineLable.isHidden = false
                }
            }else {
                if messageType == "1" {
                    if i == 0 {
                        selectedContinentButton = titileButton
                        selectedContinentButton.setTitleColor(PersonalThemeDarkColor, for: .normal)
                        selectedContinentButton.lineLable.isHidden = false
                    }
                }else {
                    if i == 1 {
                        selectedContinentButton = titileButton
                        selectedContinentButton.setTitleColor(PersonalThemeDarkColor, for: .normal)
                        selectedContinentButton.lineLable.isHidden = false
                    }
                }
                
                
            }
           
        }
        
    }
    func initData(){
        page = 1
        if selectedContinentButton.tag == 0{
            getPersonalMessageOrder()
        }else{
            getPersonalMessageOther()
        }
        
    }
    func loadMoreData(){
        page  = page + 1
        if selectedContinentButton.tag == 0{
            getPersonalMessageOrder()
        }else{
            getPersonalMessageOther()
        }
    }
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func titileButtonClick(sender:MyTitleButton){
        // 选择分类的时候 默认选中第一个国家
        
        if  selectedContinentButton == sender{
            selectedContinentButton.setTitleColor(PersonalThemeDarkColor, for: .normal)
            selectedContinentButton.lineLable.isHidden = false
        }else{
            selectedContinentButton.setTitleColor(TBIThemeMinorTextColor, for: .normal)
            sender.setTitleColor(PersonalThemeDarkColor, for: .normal)
            selectedContinentButton.lineLable.isHidden = true
            sender.lineLable.isHidden = false
            selectedContinentButton = sender;
        }
        page = 1
        
        if sender.tag == 0{
            getPersonalMessageOrder()
            messageType = "1"
        }else{
            getPersonalMessageOther()
            messageType = "2"
        }
        
    }

}
extension PersonalMessageViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArr.count
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (messageArr.count ) == 0 {
            return tableView.frame.height
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (messageArr.count ) == 0 {
            if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableNoDateView") as? TableNoDateView {
                footer.setType(.noPersonal)
                footer.messageLabel.text="竟然一条消息都没有"
                return footer
            }
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalMessageCell",for: indexPath) as! PersonalMessageCell
        cell.setCellWithModel(model:messageArr[indexPath.row],type:messageType)
        return cell
    }
    
    func getPersonalMessageOrder(){
        weak var weakSelf = self
        if page != 1{
            showLoadingView()
        }
        PersonalMessageService.sharedInstance
            .getPersonalMessageOrder(pageNo: page.description)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                weakSelf?.detailTable.mj_header.endRefreshing()
                switch event {
                case .next(let element):
                    printDebugLog(message: element)
                    if element.pushLists.count < 10 {
                        weakSelf?.detailTable.mj_footer.endRefreshingWithNoMoreData()
                    }else {
                        weakSelf?.detailTable.mj_footer.endRefreshing()
                    }
                    
                    if weakSelf?.page == 1 {
                        weakSelf?.messageArr.removeAll()
                    }
                    
                    for orderInf in (element.pushLists)
                    {
                        weakSelf?.messageArr.append(orderInf)
                    }
                    weakSelf?.detailTable.reloadData()
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                    
                }
            }.addDisposableTo(self.bag)
    }
    func getPersonalMessageOther(){
        weak var weakSelf = self
        if page != 1{
            showLoadingView()
        }
        PersonalMessageService.sharedInstance
            .getPersonalMessageOther(pageNo: page.description)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                 weakSelf?.detailTable.mj_header.endRefreshing()
                switch event {
                case .next(let element):
                    printDebugLog(message: element)
                    
                    if element.pushLists.count < 10 {
                        weakSelf?.detailTable.mj_footer.endRefreshingWithNoMoreData()
                    }else {
                        weakSelf?.detailTable.mj_footer.endRefreshing()
                    }
                    
                    if weakSelf?.page == 1 {
                        weakSelf?.messageArr.removeAll()
                    }
                    
                    for orderInf in (element.pushLists)
                    {
                        weakSelf?.messageArr.append(orderInf)
                    }
                    weakSelf?.detailTable.reloadData()
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                    
                }
            }.addDisposableTo(self.bag)
    }
}
