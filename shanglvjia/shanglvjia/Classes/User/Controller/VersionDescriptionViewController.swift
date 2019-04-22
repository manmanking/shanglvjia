//
//  VersionDescriptionViewController.swift
//  shop
//
//  Created by manman on 2017/10/12.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class VersionDescriptionViewController: CompanyBaseViewController ,UITableViewDelegate,UITableViewDataSource{
    private let tableViewCellIdentify:String = "tableViewCellIdentify"
    private let baseBackgroundView:UIView = UIView()
    private let tableView:UITableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    private var dataSourcesArr:[(title:String,content:String)] = Array()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        setBlackTitleAndNavigationColor(title:"版本说明")
        dataSourcesArr = [(title:"1.0.1版本更新说明",content:"")]
        
        setUIViewAutolayout()
    }
    
    private func setUIViewAutolayout() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier:tableViewCellIdentify)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.bottom.right.equalToSuperview()
        }
        
        
        
        
        
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourcesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentify)!
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textLabel?.text = dataSourcesArr[indexPath.row].title
        
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.navigationController?.pushViewController(VersionDescriptionDetailViewController(), animated: true)
        
        
    }
    
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
