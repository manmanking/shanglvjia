//
//  FamilyMemberViewController.swift
//  shop
//
//  Created by manman on 2017/9/25.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class FamilyMemberViewController: CompanyBaseViewController,UITableViewDelegate,UITableViewDataSource{

    
    private let tableView:UITableView = UITableView()
    private let cellReuseIdentifier:String = "cellReuseIdentifier"
    private let dataSource:[String] = ["父亲","母亲","配偶父亲","配偶母亲","孩子1","孩子2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setTitle(titleStr: "家属关系")
        navigationController?.setNavigationBarHidden(false, animated: false)
        setNavigationBackButton(backImage: "")
        setUIViewAutolayout()
        
    }
    
    func setUIViewAutolayout() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellReuseIdentifier)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        
        
        
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        setCellViewAutolayout(cell: cell!, row:indexPath)
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = dataSource[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectedRow(title: "", selectedRow: indexPath)
    }
    
    
    func setCellViewAutolayout(cell:UITableViewCell,row:IndexPath) {
        
    }
    func didSelectedRow(title:String,selectedRow:IndexPath) {
        
        print(#function,#line)
        
        let addMember = TravellerAddViewController()
        addMember.whereFrom = TravellerType.FamilyMember
        addMember.travellerFamilyRelationship = FamilyMemberRelationship.Father
        
        self.navigationController?.pushViewController(addMember, animated: true)
    
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
        
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
