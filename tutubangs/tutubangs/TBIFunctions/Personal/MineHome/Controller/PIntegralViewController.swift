//
//  PIntegralViewController.swift
//  shanglvjia
//
//  Created by tbi on 07/09/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit

class PIntegralViewController: PersonalBaseViewController {

    fileprivate var detailTable = UITableView()
    fileprivate var headerView = PIntegralHeaderView()
    
    override func viewWillAppear(_ animated: Bool) {
        setBlackTitleAndNavigationColor(title: "")
        self.navigationController?.navigationBar.setNavigationColor(color:TBIThemeBaseColor,alpha:1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = TBIThemeBaseColor
        self.automaticallyAdjustsScrollViewInsets = false
        
        initTableView()
    }

    func initTableView() {
        self.view.addSubview(detailTable)
        detailTable.backgroundColor = TBIThemeBaseColor
        detailTable.separatorStyle=UITableViewCellSeparatorStyle.none
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        detailTable.estimatedRowHeight = 75
        detailTable.delegate = self
        detailTable.dataSource = self
        detailTable.tableHeaderView = initHeaderView()
        detailTable.rowHeight = UITableViewAutomaticDimension
        detailTable.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        detailTable.register(PIntegralListCell.self, forCellReuseIdentifier: "PIntegralListCell")
        
        
    }
    
    func initHeaderView() ->PIntegralHeaderView{
        let headerView = PIntegralHeaderView()
        headerView.frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 230)
        return headerView
    }
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension PIntegralViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
            return 55
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
            let headView:VisaSectionHeaderView = VisaSectionHeaderView()
            headView.titleLabel.text = "积分明细"
            return headView
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PIntegralListCell = tableView.dequeueReusableCell(withIdentifier: "PIntegralListCell") as! PIntegralListCell
        cell.fillCell()
        return cell
    }
    
    
}
