//
//  CityAndAirportViewController.swift
//  shanglvjia
//
//  Created by manman on 2018/3/15.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class CityAndAirportSVViewController: CompanyBaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{

    typealias CityAndAirportSVViewSelectedResultBlock = (AirportInfoResponseSVModel)->Void
    
    public var cityAndAirportSVViewSelectedResultBlock:CityAndAirportSVViewSelectedResultBlock!
    
    
    private let tableViewCellIdentify:String = "tableViewCellIdentify"
    
    private let tableView:UITableView = UITableView()
    
    private let searchBarTextField:UITextField = UITextField()
    
    private var tableViewDataSources:[AirportGroup] = Array()
    
    private var searchKeywordResultDataSources:[AirportInfoResponseSVModel] = Array()
    
    fileprivate lazy var titleSearchIndexArray: [String] =  Array()
    
    /// 默认关闭显示搜索结果
    private var isSearchFunction:Bool = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBackButton(backImage: "")
        self.navigationController?.navigationBar.isTranslucent = false
        setNavigationBgColor(color: TBIThemeBlueColor)
        setUIViewAutolayout()
        getAirportNET()
    }

    override func viewWillAppear(_ animated: Bool) {
        isSearchFunction = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUIViewAutolayout() {
        setSearchBarView()
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellIdentify)
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    func setSearchBarView() {
        let searchBarBackgroundView:UIView = UIView(frame:CGRect(x:0,y:0,width:ScreenWindowWidth - 50, height: 32))
        searchBarBackgroundView.layer.cornerRadius = 2
        searchBarBackgroundView.layer.borderWidth = 1
        searchBarBackgroundView.layer.borderColor = TBIThemeGrayLineColor.cgColor
        searchBarBackgroundView.backgroundColor = TBIThemeWhite
        
        let searchBarFlagImageView = UIImageView.init(imageName: "searchBarFlag")
        searchBarBackgroundView.addSubview(searchBarFlagImageView)
        searchBarFlagImageView.snp.makeConstraints{ (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
        searchBarTextField.tintColor = TBIThemeBlueColor
        searchBarTextField.returnKeyType = .search
        searchBarTextField.delegate  = self
        searchBarTextField.placeholder = "输入机场" //"输入城市名或拼音查询" :
        searchBarBackgroundView.addSubview(searchBarTextField)
        searchBarTextField.snp.makeConstraints{ (make) in
            make.centerY.equalToSuperview()
            make.top.bottom.right.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(ScreenWindowWidth-80)
            make.left.equalTo(searchBarFlagImageView.snp.right).offset(5)
        }
        searchBarTextField.addTarget(self, action: #selector(textChange), for: .editingChanged)
        self.navigationItem.titleView = searchBarBackgroundView
    }
    
   
    func computerSearchIndex() {
        
        for element in self.tableViewDataSources {
            titleSearchIndexArray.append(element.firstCharacter)
        }
        tableView.yw_index = YWIndexView.IndexViewWith(sectionTitles: self.titleSearchIndexArray.map{ $0 })!
        
    }
    
    
    
    
    //MARK:-----------NET------------
    func getAirportNET() {
        weak var weakSelf = self
      _ = CityService.sharedInstance
            .getAirport()
            .subscribe{ event in
                
                switch event{
                case .next(let e):
                    weakSelf?.tableViewDataSources = e.airportSort(airportArr: e.airportInfos)
                    printDebugLog(message: weakSelf?.tableViewDataSources)
                    weakSelf?.computerSearchIndex()
                    weakSelf?.tableView.reloadData()
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                    
                case .completed:
                    break
                }
            }
        
    }
    
    
    //MARK:----------------UITableViewDataSources------------
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchKeywordResultDataSources.count > 0 {
            return 1
        }
        return tableViewDataSources.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchKeywordResultDataSources.count > 0 {
            return searchKeywordResultDataSources.count
        }
        
        guard tableViewDataSources.count > section else {
            return 0
        }
        return tableViewDataSources[section].airportarr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentify)!
        if searchKeywordResultDataSources.count > 0 {
            let element:AirportInfoResponseSVModel = searchKeywordResultDataSources[indexPath.row]
            cell.textLabel?.text = element.airportName
            return cell
        } else {
            //if tableViewDataSources.count > indexPath.section && tableViewDataSources[indexPath.section].airportarr.count > indexPath.row
            let element:AirportInfoResponseSVModel = tableViewDataSources[indexPath.section].airportarr[indexPath.row]
            cell.textLabel?.text = element.airportName
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchKeywordResultDataSources.count > 0 {
            return ""
        }
        if tableViewDataSources.count > section{
            let element:AirportGroup = tableViewDataSources[section]
            return element.firstCharacter
        }
        return ""
    }
    //MARK:------------------UITableViewDelegate------------------
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchKeywordResultDataSources.count > indexPath.row {
            selectedAirport(airport: searchKeywordResultDataSources[indexPath.row])
            return
        }
        if tableViewDataSources.count > indexPath.row {
            selectedAirport(airport: tableViewDataSources[indexPath.section].airportarr[indexPath.row])
            return
        }
    }
    
    
    
    func textChange(){
        searchKeywordResultDataSources.removeAll()
        
        let keyword:String = searchBarTextField.text!
        printDebugLog(message: keyword)
        for groupElement in tableViewDataSources {
            for airportElement in groupElement.airportarr{
                if airportElement.airportName.contains(keyword) {
                    searchKeywordResultDataSources.append(airportElement)
                }
            }
        }
        
        if searchKeywordResultDataSources.count > 0 {
            tableView.yw_index?.isHidden = true
        }
        
        tableView.reloadData()
    }
    
    //MARK:--------------UITextFieldViewDelegate--------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("intohere")
        textField.resignFirstResponder()
        searchKeywordResultDataSources.removeAll()
        guard textField.text?.isEmpty == false  else {
            tableView.yw_index?.isHidden = false
            tableView.reloadData()
            return true
        }
        let keyword:String = textField.text ?? ""
        for groupElement in tableViewDataSources {
            for airportElement in groupElement.airportarr{
                if airportElement.airportName.contains(keyword) {
                    searchKeywordResultDataSources.append(airportElement)
                }
            }
        }
        
        if searchKeywordResultDataSources.count > 0 {
            tableView.yw_index?.isHidden = true
        }
        
        tableView.reloadData()
        return true
    }
    
    
//    func searchKeyword(keyword:String,dataSources:[AirportGroup])->[AirportInfoResponseSVModel] {
//        var searchResult:[AirportInfoResponseSVModel] = Array()
//        for element in dataSources {
//            for groupElement in element.airportarr{
//
//            }
//        }
//
//        return searchResult
//    }
    
    
    //MARK:------------Action---------
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    
    func selectedAirport(airport:AirportInfoResponseSVModel) {
        
        if cityAndAirportSVViewSelectedResultBlock != nil {
            cityAndAirportSVViewSelectedResultBlock(airport)
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
}
