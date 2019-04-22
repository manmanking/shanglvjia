//
//  CitySelectorViewController.swift
//  shop
//
//  Created by TBI on 2017/4/23.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON






class CitySelectorViewController: CompanyBaseViewController {
    
    typealias CitySelectorBlock = (String,String) ->Void
    
    fileprivate let nomalCell = "nomalCell"
    fileprivate let hotCityCell = "hotCityCell"
    fileprivate let currentCell = "currentCityCell"
    fileprivate let resultCell = "resultCell"
    fileprivate let citySelectorViewHistoryCityTableViewCell = "CitySelectorViewHistoryCityTableViewCell"
    fileprivate let citySelectorViewCityHistoryHeaderSection = "citySelectorViewCityHistoryHeaderSection"
    
    
    var  citySelectorBlock:CitySelectorBlock?
    
    fileprivate let service = CityService.sharedInstance
    
    fileprivate let mapManager =  MapManager.sharedInstance
    
    fileprivate let bag = DisposeBag()
    
    public var cityShowType:CityType = CityType.CityType_Default
    
      
    // true城市 false 机场
    var cityType:Bool?
    
    fileprivate var type:CitySearchType?
    
    fileprivate var resultArray:[HotelCityModel] = []
    
    var city:[CityGroup]?
    public var hotelCity:[HotelCityGroup]?
    
    fileprivate var locationCity:String = "-"
    
    /// 表格
    fileprivate lazy var tableView: UITableView = UITableView(frame: self.view.frame, style: .plain)
    
    /// 表格
    fileprivate lazy var resultTableView: UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight), style: .plain)
    
    /// 搜索结果控制器
    //lazy var searchResultVC: ResultTableViewController = ResultTableViewController()
    
    fileprivate let bgTitleView = UIView()
    
    fileprivate let textField = UITextField(placeholder: "",fontSize: 13)
    
    fileprivate var isShowHistoryRecordHistory:NSInteger = 0
    
    fileprivate var localHistoryCity:[HotelCityModel] = Array()
    
    
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

    /// 懒加载 热门城市
    fileprivate lazy var hotCities: [Dictionary<String,String>] = {
        let path = Bundle.main.path(forResource: "hotCities.plist", ofType: nil)
        let array = NSArray(contentsOfFile: path ?? "") as? [Dictionary<String,String>]
        return array ?? []
    }()
    
    var trainHotCities:[Dictionary<String,String>] = []
    
    /// 懒加载 标题数组
//    fileprivate lazy var titleArray: [String] = Array()
    fileprivate lazy var titleArray:[String] = { () -> [String] in
        var array = [String]()
        for element in self.hotelCity! {
            array.append(element.firstCharacter.uppercased())
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.view.backgroundColor = TBIThemeBaseColor
        
        initView()
        if cityType ?? false{//如果是城市就定位
            weak var weakSelf = self
            mapManager.startLocation()
            mapManager.locationCityBlock = { (cityName,_) in
                if cityName.isNotEmpty{
                    weakSelf?.locationCity = cityName
                    weakSelf?.locationCity.remove(at: cityName.index(before: cityName.endIndex))
                    weakSelf?.tableView.reloadSections([0 + (weakSelf?.isShowHistoryRecordHistory)!], with: UITableViewRowAnimation.none)
                }
            }
        }
        
        self.textField.addTarget(self, action: #selector(textFieldChangeMethod(textField:)), for: UIControlEvents.editingChanged)
        //getAirportNET()
        // 模拟数据
//        let tmpCityModel:HotelCityModel = HotelCityModel()
//        tmpCityModel.elongId = "0101"
//        tmpCityModel.cnName = "北京"
//        let tmp2CityModel:HotelCityModel = HotelCityModel()
//        tmp2CityModel.elongId = "2333"
//        tmp2CityModel.cnName = "巴中市"
//        let tmp3CityModel:HotelCityModel = HotelCityModel()
//        tmp3CityModel.elongId = "0301"
//        tmp3CityModel.cnName = "天津"
//        let tmp4CityModel:HotelCityModel = HotelCityModel()
//        tmp4CityModel.elongId = "2001"
//        tmp4CityModel.cnName = "广州"
//        var historyCityModelArr:[HotelCityModel] = Array()
//        historyCityModelArr.append(contentsOf: [tmpCityModel,tmp2CityModel,tmp3CityModel,tmp4CityModel])
//        DBManager.shareInstance.userHistoryCityRecordStore(cityArr: historyCityModelArr)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        fillLocalDataSourcesDefault()
    }
    
    
    /// 设置 默认设置 数据
    func fillLocalDataSourcesDefault() {
        
        hotCities = hotCities.filter({ (hotCity) -> Bool in
            
            let hotCityName:String = hotCity["name"] ?? ""
            for groupElement in hotelCity! {
                for cityelement in groupElement.cities {
                    if hotCityName == cityelement.cnName {
                        return true
                    }
                }
            }
            return false
        })
        
        
        localHistoryCity = DBManager.shareInstance.userHistoryCityRecordDraw() ?? Array()
        if localHistoryCity.count > 0 && cityShowType == CityType.CityType_Hotel {
            isShowHistoryRecordHistory = 1
            titleArray.insert("历史", at: 0)
        }
        tableView.yw_index = YWIndexView.IndexViewWith(sectionTitles: self.titleArray.map{ $0 })!
        tableView.reloadData()
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
    
    
    
    enum CityType:NSInteger {
        case CityType_Train = 1
        case CityType_Hotel = 2
        case CityType_Default = 3
    }
    
    

}

extension CitySelectorViewController{
    func initView (){
        bgTitleView.frame = CGRect(x: 30, y: 0, width:ScreenWindowWidth - 30, height: 44)
        bgTitleView.backgroundColor = UIColor.red
        textField.tintColor = TBIThemeBlueColor
        textField.returnKeyType = .search
        textField.delegate  = self
        textField.placeholder = self.cityType == true ? "输入城市名或拼音查询" : "输入机场"
        let vi = UIView(frame: CGRect(x: 0, y: 0, width:ScreenWindowWidth - 50, height: 32))
        vi.layer.cornerRadius = 2
        vi.layer.borderWidth = 1
        vi.layer.borderColor = TBIThemeGrayLineColor.cgColor
        vi.backgroundColor = TBIThemeWhite
        let img = UIImageView.init(imageName: "searchBarFlag")
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
        tableView.register(CityHistoryHeaderSection.self, forHeaderFooterViewReuseIdentifier: citySelectorViewCityHistoryHeaderSection)
        tableView.register(HistoryCityTableViewCell.self, forCellReuseIdentifier: citySelectorViewHistoryCityTableViewCell)
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
            make.left.bottom.top.equalToSuperview()
            make.right.equalTo(-30)
        }
        
        
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.separatorColor = TBIThemeGrayLineColor
        resultTableView.register(UITableViewCell.self, forCellReuseIdentifier: resultCell)
        self.view.addSubview(resultTableView)
        resultTableView.isHidden = true
        
    }
}

// MARK: tableView 代理方法、数据源方法
extension CitySelectorViewController: UITableViewDataSource, UITableViewDelegate {
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
        if cityType == false || section > 1 + isShowHistoryRecordHistory {
            let key = titleArray[section]
            return (hotelCity?.first{$0.firstCharacter == key }?.cities.count)!
        }
        return 1
    }
    
    // MARK: 创建cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == resultTableView {//返回结果
            let cell = tableView.dequeueReusableCell(withIdentifier: resultCell, for: indexPath)
            cell.textLabel?.text = resultArray[indexPath.row].cnName
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.textLabel?.textColor = TBIThemePrimaryTextColor
            return cell
        }
        //城市列表
        if cityType == true {
            weak var weakSelf = self
            
            if indexPath.section == 0 && isShowHistoryRecordHistory == 1 { //历史
              
                printDebugLog(message: localHistoryCity.first?.mj_keyValues())
                let historyCityCell:HistoryCityTableViewCell = tableView.dequeueReusableCell(withIdentifier: citySelectorViewHistoryCityTableViewCell) as! HistoryCityTableViewCell
                historyCityCell.fillDataSources(historyCityArr: localHistoryCity)
                historyCityCell.historyCityTableViewCellSelectedHistoryCityBlock = { selectedCity in
                    
                    weakSelf?.selectedCityAction(cityName:selectedCity.cnName , cityCode: selectedCity.elongId)
                }
                return historyCityCell
                
            }else if indexPath.section == 0 + isShowHistoryRecordHistory { // 定位城市
                let cell = tableView.dequeueReusableCell(withIdentifier: currentCell, for: indexPath) as! CurrentCityTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.fillCell(cityName: locationCity)
                cell.hotCityBlock = {(cityName) in
                    let code = weakSelf?.hotelCity?.reduce([]){ $0 + $1.cities}.first{$0.cnName == cityName}?.elongId
                    weakSelf?.selectedCityAction(cityName:cityName , cityCode: code ?? "")
                   
                }
                return cell
                
            }else if indexPath.section == 1 + isShowHistoryRecordHistory { //热门城市
                let cell = tableView.dequeueReusableCell(withIdentifier: hotCityCell, for: indexPath) as! HotCityTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.trainHotCities = trainHotCities
                cell.setupUI(hotcitys: hotCities)
                cell.hotCityBlock = {(cityName) in
                    let code = weakSelf?.hotelCity?.reduce([]){ $0 + $1.cities}.first{$0.cnName == cityName}?.elongId
                    weakSelf?.selectedCityAction(cityName:cityName , cityCode: code ?? "")
                }
                
                return cell
            }else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: nomalCell, for: indexPath) as! CityTableViewCell
                
                let key = titleArray[indexPath.section]
                //let cityName = city?.first{$0.code == key }?.cities[indexPath.row].name
                let newCityName = hotelCity?.first{$0.firstCharacter == key}?.cities[indexPath.row].cnName
                cell.fillCell(cityName: newCityName ?? "", index: indexPath.row)
                return cell
            }
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: nomalCell, for: indexPath) as! CityTableViewCell
            let key = titleArray[indexPath.section]
            //let cityName = city?.first{$0.code == key }?.cities[indexPath.row].name
            let newCityName = hotelCity?.first{$0.firstCharacter == key}?.cities[indexPath.row].cnName
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
            let cityCode = hotelCity?.reduce([]){$0 + $1.cities}.first{$0.cnName == cell?.textLabel?.text}?.elongId
            
            selectedCityAction(cityName:cell?.textLabel?.text ?? "" , cityCode: cityCode ?? "")
            return
        }
        if indexPath.section != 0 && indexPath.section != 1 + isShowHistoryRecordHistory {
            tableView.deselectRow(at: indexPath, animated: false)
            let cell = tableView.cellForRow(at: indexPath) as! CityTableViewCell
            //let code = city?.reduce([]){ $0 + $1.cities}.first{$0.name == cell.cityLable.text}?.code
            let cityCode = hotelCity?.reduce([]){$0 + $1.cities}.first{$0.cnName == cell.cityLable.text}?.elongId
            selectedCityAction(cityName:cell.cityLable.text ?? "" , cityCode: cityCode ?? "")
            
            //            self.citySelectorBlock!(cell.cityLable.text ?? "", cityCode ?? "")
//            _ = self.navigationController?.popViewController(animated: true)
            return
        }
        if cityType == false {
            tableView.deselectRow(at: indexPath, animated: false)
            let cell = tableView.cellForRow(at: indexPath) as! CityTableViewCell
            //let code = city?.reduce([]){ $0 + $1.cities}.first{$0.name == cell.cityLable.text}?.code
            let cityCode = hotelCity?.reduce([]){$0 + $1.cities}.first{$0.cnName == cell.cityLable.text}?.elongId
            selectedCityAction(cityName:cell.cityLable.text ?? "" , cityCode: cityCode ?? "")
            //            self.citySelectorBlock!(cell.cityLable.text ?? "", cityCode ?? "")
//            _ = self.navigationController?.popViewController(animated: true)
            return
        }
        
    }
    
    
    
    func selectedCityAction(cityName:String,cityCode:String) {
        if citySelectorBlock != nil {
            citySelectorBlock!(cityName,cityCode)
            _ = self.navigationController?.popViewController(animated: true)
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
        weak var weakSelf = self
        if section == 0 && isShowHistoryRecordHistory == 1 {
            
            let historyHeaderView:CityHistoryHeaderSection = tableView.dequeueReusableHeaderFooterView(withIdentifier: citySelectorViewCityHistoryHeaderSection) as! CityHistoryHeaderSection
            historyHeaderView.cityHistoryHeaderSectionDeleteBlock = {
                weakSelf?.deleteAllHistory()
            }
            return historyHeaderView
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 20))
        let title = UILabel(frame: CGRect(x: 15, y: (section == 0 + isShowHistoryRecordHistory  || section == 1 + isShowHistoryRecordHistory ) && cityType == true ? 10:3.5, width: ScreenWindowWidth - 15, height: 11))
        //var titleArr = titleArray
//        if cityType == true {
//            //titleArr[0] =
//            //titleArr[1] = "热门城市"
//            titleArr.insert("定位城市", at: 0 + isShowHistoryRecordHistory)
//            titleArr.insert("热门城市", at: 1 + isShowHistoryRecordHistory)
//        }
        var tmpTitle:String = ""
        if section == 0 + isShowHistoryRecordHistory {
            tmpTitle = "定位城市"
        } else if section == 1 + isShowHistoryRecordHistory {
            tmpTitle = "热门城市"
        }else {
            tmpTitle = titleArray[section].uppercased()
        }
        
        
        title.text = tmpTitle //titleArr[section + isShowHistoryRecordHistory]
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
        return 20
//        if cityType == true && section == 0{//城市列表
//            return 21
//        }else {
//            return 20
//        }
    }
    
    // MARK: row高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == resultTableView {//返回结果
            return 45
        }
        if cityType == true {//城市列表
            if indexPath.section == 0 + isShowHistoryRecordHistory {
                return 40
            }else if indexPath.section == 1 + isShowHistoryRecordHistory  {
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
    
    //MARK:-------Action -------
    func deleteAllHistory() {
        
        DBManager.shareInstance.userHistoryCityRecordDeleteAll()
        isShowHistoryRecordHistory = 0
        titleArray.remove(at: 0)
        tableView.reloadData()
    }
    
    
    
    
}

extension CitySelectorViewController: UITextFieldDelegate {
    
    
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
extension CitySelectorViewController: UISearchBarDelegate {
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
extension CitySelectorViewController {
    
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
    }
    
    
    func getKeywordCity(keyword:String) {
        guard keyword.isEmpty == false else {
            return
        }
        resultArray.removeAll()
        for elementGroup in hotelCity! {
            for element in elementGroup.cities {
                if element.cnName.contains(keyword) {
                    resultArray.append(element)
                }
            }
        }
    }
    
    
    
    
}

