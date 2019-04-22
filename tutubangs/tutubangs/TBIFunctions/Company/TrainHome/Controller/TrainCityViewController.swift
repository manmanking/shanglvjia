//
//  TrainCityViewController.swift
//  shanglvjia
//
//  Created by manman on 2018/4/24.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON

private let nomalCell = "nomalCell"
private let hotCityCell = "hotCityCell"
private let currentCell = "currentCityCell"
private let resultCell = "resultCell"


typealias TrainCitySelectorBlock = (String,String) ->Void


class TrainCityViewController: CompanyBaseViewController {
        
        var  citySelectorBlock:TrainCitySelectorBlock?
        
        fileprivate let service = CityService.sharedInstance
        
        fileprivate let mapManager =  MapManager.sharedInstance
        
        fileprivate let bag = DisposeBag()
        
        
        // true城市 false 机场
        var cityType:Bool?
        
        fileprivate var type:CitySearchType?
        
        fileprivate var resultArray:[City] = []
        
        var city:[CityGroup]?
//        public var hotelCity:[HotelCityGroup]?
    
        fileprivate var locationCity:String = "-"
        
        /// 表格
        fileprivate lazy var tableView: UITableView = UITableView(frame: self.view.frame, style: .plain)
        
        /// 表格
        fileprivate lazy var resultTableView: UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight), style: .plain)
        
        /// 搜索结果控制器
        //lazy var searchResultVC: ResultTableViewController = ResultTableViewController()
        
        fileprivate let bgTitleView = UIView()
        
        fileprivate let textField = UITextField(placeholder: "",fontSize: 13)
        
        fileprivate lazy var searchBar: UIView = {
            let vi = UIView()
            vi.layer.cornerRadius = 2
            vi.layer.borderWidth = 1
            vi.layer.borderColor = TBIThemeGrayLineColor.cgColor
            vi.backgroundColor = TBIThemeWhite
            let img = UIImageView.init(imageName: "searchBarFlag")
            //let label = UILabel(text: "关键字/目的地", color: TBIThemePlaceholderLabelColor, size: 14)
            vi.addSubview(img)
            vi.addSubview(self.textField)
            img.snp.makeConstraints{ (make) in
                make.left.equalToSuperview().offset(10)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(12)
            }
            self.textField.snp.makeConstraints{ (make) in
                make.centerY.equalToSuperview()
                make.top.bottom.right.equalToSuperview()
                make.height.equalTo(32)
                make.width.equalTo(ScreenWindowWidth-67)
                make.height.equalTo(32)
                make.left.equalTo(img.snp.right).offset(5)
            }
            return vi
        }()
        
        //    fileprivate lazy var searchBar: UISearchBar = {
        //        let searchBar = UISearchBar()
        //        searchBar.tintColor = TBIThemeBlueColor
        //        searchBar.frame = CGRect(x: 11, y: 0, width: ScreenWindowWidth - 54, height: 44)
        //        searchBar.placeholder = self.cityType == true ? "输入城市名或拼音查询" : "输入机场"
        //        searchBar.backgroundImage = UIColor.creatImageWithColor(color: UIColor.clear)
        //        searchBar.delegate = self
        //        return searchBar
        //    }()
        
        /// 懒加载 城市数据
        fileprivate lazy var cityDic: [String: [Dictionary<String,String>]] = { () -> [String : [Dictionary<String,String>]] in
            let path = Bundle.main.path(forResource: "cits.plist", ofType: nil)
            let dic = NSDictionary(contentsOfFile: path ?? "") as? [String: [Dictionary<String,String>]]
            return dic ?? [:]
        }()
        /// 懒加载 热门城市
        fileprivate lazy var hotCities: [Dictionary<String,String>] = {
            let path = Bundle.main.path(forResource: "hotCities.plist", ofType: nil)
            let array = NSArray(contentsOfFile: path ?? "") as? [Dictionary<String,String>]
            return array ?? []
        }()
        
        var trainHotCities:[Dictionary<String,String>] = []
        
        /// 懒加载 标题数组
        //    fileprivate lazy var titleArray: [String] = Array()
        fileprivate lazy var titleArray: [String] = { () -> [String] in
            var array = [String]()
            for element in self.city! {
                array.append(element.code)
            }
            // 标题排序
            array.sort()
            if self.cityType == true {
                array.insert("热门", at: 0)
                array.insert("定位", at: 0)
            }
            return array
        }()
        
        
        
        //MARK:------------NEWOBT------------
        var airportInfosDataSources:[AirportInfoResponseSVModel] = Array()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            setNavigationBgColor(color:TBIThemeBlueColor)
            setNavigationBackButton(backImage: "")
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.setBackgroundImage(UIColor.creatImageWithColor(color: TBIThemeBlueColor), for: .any, barMetrics: .default)
            //titleArray = ["A","B","C","D","E"]
            initView()
            weak var weakSelf = self
            if cityType ?? false{//如果是城市就定位
                mapManager.startLocation()
                mapManager.locationCityBlock = { (cityName,_) in
                    if cityName.isNotEmpty{
                        weakSelf?.locationCity = cityName
                        weakSelf?.locationCity.remove(at: cityName.index(before: cityName.endIndex))
                        weakSelf?.tableView.reloadSections([0], with: UITableViewRowAnimation.none)
                    }
                }
            }
            
            self.textField.addTarget(self, action: #selector(textFieldChangeMethod(textField:)), for: UIControlEvents.editingChanged)
            //getAirportNET()
            
        }
        override func viewWillAppear(_ animated: Bool) {
            NSLog("into here  ...")
            self.navigationController?.navigationBar.isTranslucent = false
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        override func backButtonAction(sender:UIButton) {
            if resultTableView.isHidden == false {
                resultTableView.isHidden = true
                tableView.yw_index?.isHidden = false
                return
            }
            _ = self.navigationController?.popViewController(animated: true)
            
        }
        
        
        func textFieldChangeMethod(textField:UITextField) {
            print(#function,#line,"im here")
            getSearchResultArray(searchBarText: textField.text ?? "")
        }
        
        
        //MARK:-----------NET------------
        func getAirportNET() {
            weak var weakSelf = self
            CityService.sharedInstance
                .getAirport()
                .subscribe{ event in
                    
                    switch event{
                    case .next(let e):
                        weakSelf?.airportInfosDataSources = e.airportInfos
                        printDebugLog(message: weakSelf?.airportInfosDataSources)
                    case .error(let error):
                        try? weakSelf?.validateHttp(error)
                        
                    case .completed:
                        break
                    }
                }.disposed(by: self.bag)
            
        }
        
        
        
        
    }
    
    extension TrainCityViewController{
        func initView (){
            bgTitleView.frame = CGRect(x: 30, y: 0, width:ScreenWindowWidth - 30, height: 44)
            bgTitleView.backgroundColor = UIColor.red
            
            textField.tintColor = TBIThemeBlueColor
            textField.returnKeyType = .search
            textField.delegate  = self
            textField.placeholder = self.cityType == true ? "输入城市名或拼音查询" : "输入机场"
            
            // 在导航条添加searchBar
            //let titleView = UIView(frame: CGRect(x: 0, y: 0, width:ScreenWindowWidth - 50, height: 44))
            
            
            let vi = UIView(frame: CGRect(x: 0, y: 0, width:ScreenWindowWidth - 50, height: 32))
            vi.layer.cornerRadius = 2
            vi.layer.borderWidth = 1
            vi.layer.borderColor = TBIThemeGrayLineColor.cgColor
            vi.backgroundColor = TBIThemeWhite
            let img = UIImageView.init(imageName: "searchBarFlag")
            
            //        bgTitleView.addSubview(vi)
            //        vi.snp.makeConstraints { (make) in
            //            make.centerY.equalToSuperview()
            //            make.left.equalTo(5)
            //            make.right.equalTo(-9)
            //            make.width.equalTo(ScreenWindowWidth-50)
            //            make.height.equalTo(32)
            //        }
            
            vi.addSubview(img)
            
            img.snp.makeConstraints{ (make) in
                make.left.equalToSuperview().offset(10)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(12)
            }
            vi.addSubview(self.textField)
            self.textField.snp.makeConstraints{ (make) in
                make.centerY.equalToSuperview()
                make.top.bottom.right.equalToSuperview()
                make.height.equalTo(32)
                make.width.equalTo(ScreenWindowWidth-80)
                make.left.equalTo(img.snp.right).offset(5)
            }
            
            
            self.navigationItem.titleView = vi
            
            
            
            // 设置tableView
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(CityTableViewCell.self, forCellReuseIdentifier: nomalCell)
            tableView.register(CurrentCityTableViewCell.self, forCellReuseIdentifier: currentCell)
            tableView.register(HotCityTableViewCell.self, forCellReuseIdentifier: hotCityCell)
            tableView.separatorStyle = .none
            // 右边索引
            tableView.sectionIndexColor = TBIThemeMinorTextColor
            tableView.sectionIndexBackgroundColor = UIColor.clear
            tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0)
            tableView.separatorColor = TBIThemeGrayLineColor
            //tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            self.view.addSubview(tableView)
            tableView.snp.makeConstraints { (make) in
                make.left.right.bottom.top.equalToSuperview()
            }
            tableView.yw_index = YWIndexView.IndexViewWith(sectionTitles: self.titleArray.map{ $0 })!
            
            resultTableView.delegate = self
            resultTableView.dataSource = self
            resultTableView.separatorColor = TBIThemeGrayLineColor
            resultTableView.register(UITableViewCell.self, forCellReuseIdentifier: resultCell)
            self.view.addSubview(resultTableView)
            resultTableView.isHidden = true
            
        }
    }
    
    // MARK: tableView 代理方法、数据源方法
    extension TrainCityViewController: UITableViewDataSource, UITableViewDelegate {
        func numberOfSections(in tableView: UITableView) -> Int {
            if tableView == resultTableView {//返回结果
                return 1
            }
            return titleArray.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tableView == resultTableView {//返回结果
                return resultArray.count
            }
            if cityType == false || section > 1 {
                let key = titleArray[section]
                return (city?.first{$0.code == key }?.cities.count)!
            }
            return 1
        }
        
        // MARK: 创建cell
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if tableView == resultTableView {//返回结果
                let cell = tableView.dequeueReusableCell(withIdentifier: resultCell, for: indexPath)
                cell.textLabel?.text = resultArray[indexPath.row].name
                cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
                cell.textLabel?.textColor = TBIThemePrimaryTextColor
                return cell
            }
            if cityType == true {//城市列表
                weak var weakSelf = self
                if indexPath.section == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: currentCell, for: indexPath) as! CurrentCityTableViewCell
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell.fillCell(cityName: locationCity)
                    cell.hotCityBlock = {(cityName) in
                        let code = self.city?.reduce([]){ $0 + $1.cities}.first{$0.name == cityName}?.code
                        weakSelf?.citySelectorBlock!(cityName,code ?? "")
                        _ = weakSelf?.navigationController?.popViewController(animated: true)
                    }
                    return cell
                    
                }else if indexPath.section == 1 { //热门城市
                    let cell = tableView.dequeueReusableCell(withIdentifier: hotCityCell, for: indexPath) as! HotCityTableViewCell
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell.trainHotCities = trainHotCities
                    cell.setupUI()
                    cell.hotCityBlock = {(cityName) in
                        let code = self.city?.reduce([]){ $0 + $1.cities}.first{$0.name == cityName}?.code
                        weakSelf?.citySelectorBlock!(cityName,code ?? "")
                        _ = weakSelf?.navigationController?.popViewController(animated: true)
                    }
                    
                    return cell
                }else {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: nomalCell, for: indexPath) as! CityTableViewCell
                    
                    let key = titleArray[indexPath.section]
                    //let cityName = city?.first{$0.code == key }?.cities[indexPath.row].name
                    let newCityName = city?.first{$0.code == key}?.cities[indexPath.row].name
                    cell.fillCell(cityName: newCityName ?? "", index: indexPath.row)
                    return cell
                }
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: nomalCell, for: indexPath) as! CityTableViewCell
                
                let key = titleArray[indexPath.section]
                //let cityName = city?.first{$0.code == key }?.cities[indexPath.row].name
                let newCityName = city?.first{$0.code == key}?.cities[indexPath.row].name
                cell.fillCell(cityName: newCityName ?? "", index: indexPath.row)
                return cell
            }
            
        }
        // MARK: 点击cell
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if tableView == resultTableView{
                tableView.deselectRow(at: indexPath, animated: false)
                let cell = tableView.cellForRow(at: indexPath)
                //let code = city?.reduce([]){ $0 + $1.cities}.first{$0.name == cell?.textLabel?.text}?.code
                let cityCode = city?.reduce([]){$0 + $1.cities}.first{$0.name == cell?.textLabel?.text}?.code
                self.citySelectorBlock!(cell?.textLabel?.text ?? "", cityCode ?? "")
                _ = self.navigationController?.popViewController(animated: true)
                return
            }
            if indexPath.section != 0 && indexPath.section != 1 {
                tableView.deselectRow(at: indexPath, animated: false)
                let cell = tableView.cellForRow(at: indexPath) as! CityTableViewCell
                //let code = city?.reduce([]){ $0 + $1.cities}.first{$0.name == cell.cityLable.text}?.code
                let cityCode = city?.reduce([]){$0 + $1.cities}.first{$0.name == cell.cityLable.text}?.code
                self.citySelectorBlock!(cell.cityLable.text ?? "", cityCode ?? "")
                _ = self.navigationController?.popViewController(animated: true)
                return
            }
            if cityType == false {
                tableView.deselectRow(at: indexPath, animated: false)
                let cell = tableView.cellForRow(at: indexPath) as! CityTableViewCell
                //let code = city?.reduce([]){ $0 + $1.cities}.first{$0.name == cell.cityLable.text}?.code
                let cityCode = city?.reduce([]){$0 + $1.cities}.first{$0.name == cell.cityLable.text}?.code
                self.citySelectorBlock!(cell.cityLable.text ?? "", cityCode ?? "")
                _ = self.navigationController?.popViewController(animated: true)
                return
            }
            
        }
        
        // MARK: 右边索引
        //func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        //    return titleArray
        //}
        
        // MARK: section头视图
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            if tableView == resultTableView {//返回结果
                return nil
            }
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 20))
            //let title = UILabel(frame: CGRect(x: 15, y: section == 0 && cityType == true ? 10:3.5, width: ScreenWindowWidth - 15, height: 11))
            let title = UILabel(frame: CGRect(x: 15, y: (section == 0 || section == 1) && cityType == true ? 10:3.5, width: ScreenWindowWidth - 15, height: 11))
            var titleArr = titleArray
            if cityType == true {
                titleArr[0] = "定位城市"
                titleArr[1] = "热门城市"
            }
            title.text = titleArr[section]
            title.textColor = TBIThemeMinorTextColor
            title.font = UIFont.systemFont(ofSize: 11)
            view.addSubview(title)
            view.backgroundColor = TBIThemeBaseColor
            return view
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            if tableView == resultTableView {//返回结果
                return 0
            }
            if cityType == true && section == 0{//城市列表
                return 21
            }else {
                return 20
            }
        }
        
        // MARK: row高度
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if tableView == resultTableView {//返回结果
                return 45
            }
            if cityType == true {//城市列表
                if indexPath.section == 0 {
                    return 40
                }else if indexPath.section == 1 {
                    let n:Int = Int(ScreenWindowWidth/(75 + 10))
                    var row = 1
                    if trainHotCities.count != 0 {
                        row = (trainHotCities.count - 1) / n
                    }else {
                        row = (hotCities.count - 1) / n
                    }
                    
                    return (30+15) + (5 + 30) * CGFloat(row)
                }else{
                    return 45
                }
            } else {
                return 45
            }
            
        }
    }
    
    extension TrainCityViewController: UITextFieldDelegate {
        
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            getSearchResultArray(searchBarText: newText)
            return true
        }
        
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
            getSearchResultArray(searchBarText: textField.text ?? "")
            return true
        }
        
        
    }
    
    // MARK: searchBar 代理方法
    extension TrainCityViewController: UISearchBarDelegate {
        func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool{
            //tableView.yw_index?.isHidden = true
            //resultTableView.isHidden = false
            return true
        }
        
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            getSearchResultArray(searchBarText: searchText)
        }
        
        
        
    }
    
    // MARK: 搜索逻辑
    extension TrainCityViewController {
        
        func setCityType(type:CitySearchType){
            self.type = type
            switch type {
            case .trainCity:
                cityType = true
                break
            case .hotelCity:
                cityType = true
                break
            case .flightCity:
                cityType = true
                break
            case .flightAirport:
                cityType = false
                break
            case .carAirport:
                cityType = false
                break
            default:
                break
            }
        }
        
        fileprivate func getSearchResultArray(searchBarText: String) {
            
            if searchBarText == "" {
                resultTableView.isHidden = true
                tableView.yw_index?.isHidden = false
                resultTableView.reloadData()
                return
            }
            resultTableView.isHidden = false
            tableView.yw_index?.isHidden = true
            getKeywordCity(keyword: searchBarText)
            resultTableView.reloadData()
            
//            service.getCities(searchBarText, type: self.type ?? .flightCity).subscribe{ event in
//                if case .next(let e) = event {
//                    self.resultArray = e
//                    self.resultTableView.reloadData()
//                }
//                }.addDisposableTo(self.bag)
//            
//            
//            
        }
        
        
        func getKeywordCity(keyword:String) {
            guard keyword.isEmpty == false else {
                return
            }
            resultArray.removeAll()
            for elementGroup in self.city! {
                for element in elementGroup.cities {
                    if element.name.contains(keyword) {
                        resultArray.append(element)
                    }
                }
            }
        }
        
        
        
}

