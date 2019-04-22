//
//  HotelGroupSubsidiarySearchViewController.swift
//  shop
//
//  Created by manman on 2017/5/15.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftyJSON




class HotelGroupSubsidiarySearchViewController: CompanyBaseViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {

    typealias HotelGroupSubsidiarySearchBlock = (FilialeItemModel)->Void
    
    public var hotelGroupSubsidiarySearchBlock:HotelGroupSubsidiarySearchBlock!
    public var subsidiaryCity:String = ""
    
    private let HotelGroupSubsidiarySearchViewIdentify = "HotelGroupSubsidiarySearchViewIdentify"
    private var searchBar:TBISearchBar = TBISearchBar()
    private var tableView:UITableView = UITableView()
    private var tableViewDataSourcesArr:[FilialeItemModel] = Array<FilialeItemModel>()
    private var searchBarResultDataSourcesArr:[FilialeItemModel] = Array<FilialeItemModel>()
    
    private let bag = DisposeBag()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setNavigationBackButton(backImage: "")
        setUIViewAutolayout()
        
//        let subsidiary = HotelSubsidiary()
//        subsidiary.branchName = "全部"
//        tableViewDataSourcesArr.append(subsidiary)
//        getGroupSubsidiaryFromNetwork
        
        if #available(iOS 11.0, *) {
            searchBar.contentInset = UIEdgeInsets.init(top: 6, left:40, bottom: 6, right:20)
        }else
        {
            searchBar.contentInset = UIEdgeInsets.init(top: 6, left:0, bottom: 6, right:20)
        }
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
            if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
                if let backgroundview = textfield.subviews.first {
                    
                    // Background color
                    backgroundview.backgroundColor = UIColor.white
                    
                    // Rounded corner
                    backgroundview.layer.cornerRadius = 5;
                    backgroundview.clipsToBounds = true;
                    
                }
            }
            
        }
        
        
        searchBar.text = HotelManager.shareInstance.searchConditionUserDraw().cityName //subsidiaryCity
        getFilialeList()
        //getGroupSubsidiaryFromNetwork()
        
    }
    
    
    
    
    func setUIViewAutolayout() {
        searchBar.placeholder = "输入分公司名称"
        searchBar.frame = CGRect(x:0,y:20,width:ScreenWindowWidth - 40,height:28)
        searchBar.delegate = self
        searchBar.tintColor = UIColor.blue
        //searchBar.keyboardType = UIKeyboardType.webSearch
        //searchBar.becomeFirstResponder()
        self.navigationItem.titleView = searchBar
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(GroupSubsidiaryCell.classForCoder(), forCellReuseIdentifier:HotelGroupSubsidiarySearchViewIdentify)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBgColor(color: TBIThemeBlueColor)
        
        
        
    }
    
    
    
    
    //MARK:------UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchBarResultDataSourcesArr.count == 0 || searchBar.text?.isEmpty == true {
            return tableViewDataSourcesArr.count
        }else
        {
            return searchBarResultDataSourcesArr.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:GroupSubsidiaryCell = tableView.dequeueReusableCell(withIdentifier:HotelGroupSubsidiarySearchViewIdentify)as! GroupSubsidiaryCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        //cell?.textLabel?.text = "index" + String(indexPath.row)
        if searchBar.text?.isEmpty == true || searchBarResultDataSourcesArr.count == 0 {
           
            cell.fillDataSources(title:tableViewDataSourcesArr[indexPath.row].branchName)
            
        }else
        {
            cell.fillDataSources(title:searchBarResultDataSourcesArr[indexPath.row].branchName)
        }
        
        
        
        
        return cell
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        
        if indexPath.row == 0 && searchBarResultDataSourcesArr.count == 0  {
            let selectedSubsidiary:FilialeItemModel = FilialeItemModel()
            self.hotelGroupSubsidiarySearchBlock(selectedSubsidiary)
            backButtonAction(sender: UIButton())
            return
        }
        
        var selectedSubsidiary:FilialeItemModel = FilialeItemModel()
        
        
        if searchBarResultDataSourcesArr.count > 0 {
            selectedSubsidiary = searchBarResultDataSourcesArr[indexPath.row]
        }else
        {
            selectedSubsidiary = tableViewDataSourcesArr[indexPath.row]
        }
        
        
        self.hotelGroupSubsidiarySearchBlock(selectedSubsidiary)
        backButtonAction(sender: UIButton())
    }
    
    
    
    
    
    
    //MARK:-------UISearchBarDelegate
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print("searchBar click ...")
        searchBar.resignFirstResponder()
        if (searchBar.text?.characters.count)! > 0 {
            
            if tableViewDataSourcesArr.count == 0 {
                subsidiaryCity = searchBar.text!
                getFilialeList()
                // getGroupSubsidiaryFromNetwork()
            }else
            {
                searchBarResultDataSourcesArr =  caculateMatchKeyword(dataSourcesArr: tableViewDataSourcesArr, keyword: searchBar.text!)
            }
            
            
            
        }else
        {
            if searchBarResultDataSourcesArr.count  > 0{
                searchBarResultDataSourcesArr.removeAll()
            }
            
        }
        
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing click ...")
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange click ...",searchText)
        printDebugLog(message:searchBar.text)
        
        if searchBar.text?.characters.count == 0
        {
            print("我来了 。。")
            searchBar.resignFirstResponder()
            self.tableView.reloadData()
        }
        
    }
    
    
    
    
    
    
    func caculateMatchKeyword(dataSourcesArr:Array<FilialeItemModel>,keyword:String)->Array<FilialeItemModel> {
        var  resultArr:Array<FilialeItemModel> = Array()
        resultArr = dataSourcesArr.filter { (element) -> Bool in
            
             if element.branchName.range(of: keyword) == nil
             {
                return false
            }
            
            return  true
                
            
        }
        return resultArr
    }
    
    
    
    
    
    
    
    
    //MARK:-------NET---------------
    
    func getFilialeList() {
        weak var weakSelf = self
        showLoadingView()
        HotelService.sharedInstance
            .getFiliale(city: searchBar.text ?? "")
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    printDebugLog(message: element)
                    let all:FilialeItemModel = FilialeItemModel()
                    all.branchName = "全部"
                    weakSelf?.tableViewDataSourcesArr = element
                    weakSelf?.tableViewDataSourcesArr.insert(all, at: 0)
                    //weakSelf?.searchBarResultDataSourcesArr = (weakSelf?.tableViewDataSourcesArr)!
                    weakSelf?.tableView.reloadData()
                case .error(let error):
                     try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
            }.disposed(by: bag)
        
    }
    
    
//
//    ///网络请求数据
//    func getGroupSubsidiaryFromNetwork() {
//
//        showLoadingView()
//        weak var weakSelf = self
//        HotelCompanyService.sharedInstance
//            .subsidiaryList(cityName:subsidiaryCity)
//            .subscribe { (result) in
//                weakSelf?.hideLoadingView()
//                if case .next(let result) = result {
//                    //print(result)
//                    let all:HotelSubsidiary = HotelSubsidiary()
//                    all.branchName = "全部"
//                    weakSelf?.tableViewDataSourcesArr = result
//                    weakSelf?.tableViewDataSourcesArr.insert(all, at: 0)
//                    //weakSelf?.searchBarResultDataSourcesArr = (weakSelf?.tableViewDataSourcesArr)!
//                    weakSelf?.tableView.reloadData()
//
//
//                }
//                if case .error(let result) = result {
//                    print(result)
//                    try? weakSelf?.validateHttp(result)
//                    // weakSelf?.showSystemAlertView(titleStr: "提示", message: String(describing: result))
//
//
//                }
//            }.disposed(by: bag)
//
//    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    
    
    
    override func backButtonAction(sender: UIButton) {
        searchBar.resignFirstResponder()
       _ = self.navigationController?.popViewController(animated: true)
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

class GroupSubsidiaryCell: UITableViewCell {
    
    
    private var titleLabel:UILabel = UILabel()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.left.equalToSuperview().inset(15)
        }
        let bottomLine:UILabel = UILabel()
        bottomLine.backgroundColor = TBIThemeGrayLineColor
        self.contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(0.5)
            make.height.equalTo(0.5)
            make.right.equalToSuperview()
        }
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillDataSources(title:String) {
        titleLabel.text = title
    }
    
    
    
}



