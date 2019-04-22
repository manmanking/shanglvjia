//
//  FamilyListViewController.swift
//  shop
//
//  Created by manman on 2017/9/25.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class FamilyListViewController: CompanyBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    private let tableView:UITableView = UITableView()
    private let cellReuseIdentifier:String = "cellReuseIdentifier"
    private var dataSource:[TravellerForm] = Array()//,"父亲","母亲","配偶父亲","配偶母亲","孩子1","孩子2"
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setTitle(titleStr: "家属管理")
        navigationController?.setNavigationBarHidden(false, animated: false)
        setNavigationBackButton(backImage: "")
        setUIViewAutolayout()
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getFamilyList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUIViewAutolayout() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(FamilyMemberRelationshipCell.classForCoder(), forCellReuseIdentifier: cellReuseIdentifier)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        
        
        
    }
    
    
    
    
    func getFamilyList() {
        weak var weakSelf = self
        self.showLoadingView()
        TravelService.sharedInstance.getFamilyMemberList()
            .subscribe{event in
                weakSelf?.hideLoadingView()
                if case .next(let e) = event {
                    print("=====成功======")
                    print(e)
                    weakSelf?.dataSource = e
                    weakSelf?.tableView.reloadData()
                   
                    
                }
                if case .error(let e) = event {
                    try? weakSelf?.validateHttp(e)
                    
                }
            }
            .disposed(by: bag)
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return dataSource.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return 27
        }
        return 66
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        setCellViewAutolayout(cell: cell!, row:indexPath)
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "您的家属可以同样享有机票协议价格等特权"
            cell.textLabel?.textAlignment = NSTextAlignment.center
            return
        }
        
//        let relation:Int = Int(dataSource[indexPath.row].relation ?? "1")!
//        
//        switch relation{
//        case FamilyMemberRelationship.Father:
//            print("relation ship fation ")
//            break
//            
//        default:
//            break
//        }
//        
        
        let member = FamilyMemberRelationship.fromPermanentID(id:(dataSource[indexPath.row].relation?.description)!)
        cell.textLabel?.text = dataSource[indexPath.row].relation
        cell.textLabel?.textAlignment = NSTextAlignment.left
        return
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 10
        }
        return 0
    
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let headerView:UIView = UIView()
            headerView.frame = CGRect.init(x: 0, y: 0, width: ScreenWindowWidth, height: 10)
            headerView.backgroundColor = TBIThemeBaseColor
            return headerView
            
        }
        
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectedRow(title: "", selectedRow: indexPath)
    }
    
    
    func setCellViewAutolayout(cell:UITableViewCell,row:IndexPath) {
        
        
        
    }
    func didSelectedRow(title:String,selectedRow:IndexPath) {
        
        print(#function,#line)
        
        if selectedRow.section == 0 {
            self.navigationController?.pushViewController(FamilyMemberViewController(), animated: true)
        }else
        {
            //选中家属 带回上一页数据 然后 返回
            backButtonAction(sender: UIButton())
        }
        
        
        
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


class FamilyMemberRelationshipCell: UITableViewCell {
    
    let leftMargin:NSInteger =  15
    
    // 基础背景
    fileprivate var baseBackgroundView = UIView()
    // 子背景 边缘 灰色圈
    fileprivate var subBackgroundView = UIView()
    
    fileprivate var familyMemberTitleLabel = UILabel()
    
    fileprivate var familyMemberTitleContentLabel = UILabel()
    
    fileprivate var detailButton:UIButton = UIButton()
    
    fileprivate var bottomLine = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.backgroundColor = UIColor.white
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
            
        }
        setUIViewAutolayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setUIViewAutolayout() {
        
        familyMemberTitleLabel.font = UIFont.systemFont(ofSize: 13)
        familyMemberTitleLabel.adjustsFontSizeToFitWidth = true
        baseBackgroundView.addSubview(familyMemberTitleLabel)
        familyMemberTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(leftMargin)
            make.left.equalToSuperview().inset(leftMargin)
            make.height.equalTo(26)
    
        }
        familyMemberTitleContentLabel.font = UIFont.systemFont(ofSize: 13)
        familyMemberTitleContentLabel.adjustsFontSizeToFitWidth = true
        baseBackgroundView.addSubview(familyMemberTitleContentLabel)
        familyMemberTitleContentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(familyMemberTitleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(leftMargin)
            make.height.equalTo(26)
        }
        
        
        baseBackgroundView.addSubview(detailButton)
        detailButton.setImage(UIImage.init(named: "ic_edit"), for: UIControlState.normal)
        detailButton.addTarget(self, action: #selector(detailButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        detailButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(leftMargin)
            make.width.height.equalTo(20)
            
        }
        
        
        
        
        
        
    }
    
    func fillDataSource(title:String,content:String){
        familyMemberTitleLabel.text = title
        familyMemberTitleContentLabel.text = content
    }
    
    
    
    
    
    
    @objc private func detailButtonAction(sender:UIButton) {
        
        print(#function)
        
        
        
    }
    
    
    
    
    
    
}







