//
//  FlightPersonListViewController.swift
//  shop
//
//  Created by zhangwangwang on 2017/7/28.
//  Copyright © 2017年 zhangwangwang. All rights reserved.
//

import UIKit
import RxSwift

class FlightPersonListViewController: BaseViewController {

    //选择人闭包回掉 
    typealias PersonSelectedResultBlock = ([TravellerListItem]?)->Void
    
    public var personSelectedResultBlock:PersonSelectedResultBlock!
    
    
    fileprivate let bag = DisposeBag()
    
    fileprivate let tableView:UITableView = UITableView()
    
    fileprivate let headerView:TravellerHeaderView = TravellerHeaderView()
    
    fileprivate let footerView:TravellerFootersView = TravellerFootersView()
    
    fileprivate var data:[TravellerListItem]?
    
    fileprivate let flightPersonListTableViewCellIdentify = "flightPersonListTableViewCellIdentify"
    
    var selectUid:[Int] = []
    
    //按钮点击事件标示位
    fileprivate var clickFlag:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation(title:"选择乘机人")
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func backButtonAction(sender:UIButton) {
        let selectData = data?.filter{$0.selectFlag == true}
        personSelectedResultBlock(selectData)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
extension FlightPersonListViewController{
    
    func filterData() {
        for index in 0..<(data?.count ?? 0){
           let count = selectUid.filter{$0 == data?[index].guid}.count
           if  count > 0 {
               data?[index].selectFlag = true
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
                self.filterData()
                self.tableView.reloadData()
            case .error(let e):
                try? self.validateHttp(e)
            case .completed:
                break
            }
            }.addDisposableTo(self.bag)
    }
    
    func deletePerson(index:IndexPath) {
        
        let alertController = UIAlertController(title: "提示", message: "是否删除该常用旅客信息?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel){ action in
            alertController.removeFromParentViewController()
            
        }
        let okAction = UIAlertAction(title: "确定", style: .default){ action in
            alertController.removeFromParentViewController()
            let selectData = self.data?[index.row]
            TravelService.sharedInstance.deleteTraveller(String(selectData?.guid ?? 0)).subscribe{ event in
                self.hideLoadingView()
                switch event{
                case .next(_):
                    self.initData()
                case .error(let e):
                    try? self.validateHttp(e)
                case .completed:
                    break
                }
                }.addDisposableTo(self.bag)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
        
        
    }
    
    func initView (){
        initTableView()
    }
}
extension FlightPersonListViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        tableView.register(FlightPersonListTableViewCell.classForCoder(), forCellReuseIdentifier: flightPersonListTableViewCellIdentify)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: flightPersonListTableViewCellIdentify, for: indexPath) as! FlightPersonListTableViewCell
        cell.fillCell(model: data?[indexPath.row], index: indexPath.row)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.updateBtn.tag = indexPath.row
        cell.updateBtn.addTarget(self, action: #selector(updateButton(sender:)), for: .touchUpInside)
        return cell
    }
    
    // MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  data?[indexPath.row].selectFlag ?? true {
            data?[indexPath.row].selectFlag = false
        } else {
            data?[indexPath.row].selectFlag = true
        }
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        return "删除"
    }
    
    
    ///
    ///
    /// - Parameters:
    ///   - tableView:
    ///   - indexPath:
    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        clickFlag = false
        print("begin======")
    }
    
    ///
    ///
    /// - Parameters:
    ///   - tableView:
    ///   - indexPath:
    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        clickFlag = true
        print("end======")
    }
    
    // 更多按钮设置
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
//    {
//        let delete = UITableViewRowAction(style: .normal, title: "删除") {
//            action, index in
//            print("share button tapped")
//            print("删除")
//        }
//        delete.backgroundColor = UIColor.red
//        
//        return [delete]
//    }
    //点击删除按钮事件
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.delete {
            self.deletePerson(index:indexPath)
            tableView.reloadData()
        }
    }
    
    // MARK: row高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    
    /// 修改人
    ///
    /// - Parameter sender:
    func updateButton(sender: UIButton) {
        if clickFlag {
            saveSelectUid ()
            let vc = TravellerAddViewController()
            vc.item = data?[sender.tag]
            vc.setRightBar()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func addButton(sender: UIButton) {
        saveSelectUid ()
        let vc = TravellerAddViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func saveSelectUid () {
        selectUid = self.data?.filter{$0.selectFlag == true}.map{$0.guid} ?? []
    }
    
    /// 确定
    ///
    /// - Parameter sender:
    func okButton(sender: UIButton) {
        let selectData = data?.filter{$0.selectFlag == true}
        if selectData?.isEmpty ?? true{
           self.alertView(title: "提示", message: "请选择乘机人")
           return
        }
        personSelectedResultBlock(selectData)
        _ = self.navigationController?.popViewController(animated: true)
    }
    

}
