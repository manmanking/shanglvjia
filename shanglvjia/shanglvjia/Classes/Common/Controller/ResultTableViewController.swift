//
//  ResultTableViewController.swift
//  shop
//
//  Created by TBI on 2017/4/23.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit




class ResultTableViewController: UITableViewController {

    var resultArray:[String] = []
    var isFrameChange = false
    /// 点击cell回调闭包
    var callBack: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        // 控制器根据所在界面的status bar，navigationbar，与tabbar的高度，不自动调整scrollview的 inset
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.separatorColor = TBIThemeGrayLineColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        cell.textLabel?.text = resultArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        print(cell?.textLabel?.text ?? "")
        
        // 点击cell调用闭包
        callBack()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // 设置view的frame
        if isFrameChange == false {
            view.frame = CGRect(x: 0, y: 64, width: ScreenWindowWidth, height: ScreentWindowHeight - 64)
            isFrameChange = true
        }
        
    }

}
