//
//  FlightOrdersTableViewController.swift
//  shop
//
//  Created by akrio on 2017/5/11.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import MJRefresh
class FlightOrdersTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none //去掉item下方横线
        self.tableView.backgroundColor = TBIThemeMinorColor
        
        //监听下拉刷新 上啦加载
        tableView.mj_header = MJRefreshNormalHeader{
            
        }
        //初始化上拉加载
        tableView.mj_footer = MJRefreshAutoNormalFooter{
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FlightOrderTableViewCell()
        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187.5
    }

}

extension FlightOrdersTableViewController {
    func loadmore(){
        
    }
    func refresh() {
        
    }
}
