//
//  TravelDestinationViewController.swift
//  shop
//
//  Created by TBI on 2017/7/10.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class TravelDestinationViewController: CompanyBaseViewController {

    fileprivate let bag = DisposeBag()
    
    fileprivate var searchKey:String = ""
    
//    fileprivate lazy var searchBar: UISearchBar = {
//        let searchBar = UISearchBar()
//        searchBar.placeholder = "关键字/目的地"
//        searchBar.layer.cornerRadius = 2
//        searchBar.backgroundColor = TBIThemeWhite
//        searchBar.backgroundImage = UIColor.creatImageWithColor(color: UIColor.clear)
//        searchBar.delegate = self
//        return searchBar
//    }()
    fileprivate let textField = UITextField(placeholder: "关键字/目的地",fontSize: 13)
    
    fileprivate lazy var searchBar: UIView = {
        let vi = UIView()
        vi.layer.cornerRadius = 2
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
            make.left.equalTo(img.snp.right).offset(5)
        }
        return vi
    }()

    //左侧表单选项
    fileprivate let tableView:UITableView = UITableView()
    //选中cell
    var selectIndex:Int = 0
    
    fileprivate let travelDestinationTableViewCellIdentify = "travelDestinationTableViewCellIdentify"
    
    fileprivate var tableViewData:[String] = ["出境跟团游","出境自由行","国内跟团游","国内自由行"]
    
    //下面网格布局
    fileprivate var collectionView:UICollectionView?
    
    fileprivate let travelDestinationColllectionReusableViewIdentify = "travelDestinationColllectionReusableViewIdentify"
    
    fileprivate let travelDestinationHotColllectionViewCellIdentify = "travelDestinationHotColllectionViewCellIdentify"
    
    fileprivate let travelDestinationRegionColllectionViewCellIdentify = "travelDestinationRegionColllectionViewCellIdentify"
    
    fileprivate var data:TravelAdvListResponse?
    
    fileprivate var cityData:[CitsCitys]?
    
    // 1 国内 2国际
    fileprivate var region:Int = 1
    
    fileprivate lazy var searchBarView: UIView = {
        let vi = UIView()
        vi.backgroundColor = TBIThemeBlueColor
        return vi
    }()
    
    fileprivate var rightBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation(title:"选择目的地")
        initData ()
        setRightBar()
        initSearchBarView()
        initTableView()
        initCollectionView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rightBtn.setTitle(cityName, for: UIControlState.normal)
    }
    
    
    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
}
//点击跳转事件
extension TravelDestinationViewController {
    
    func getType () -> String {
        var type:String = "6"
        switch selectIndex {
        case 0:
            type = "6"
            region = 2
        case 1:
            type = "7"
            region = 2
        case 2:
            type = "8"
            region = 1
        case 3:
            type = "9"
            region = 1
        default:
            break
        }
        return type

    }
    
    //首页点击图片跳转
    func  imgClick(model:TravelAdvResponse?){
        let type = getType()
        if model?.routeId != nil && model?.routeId != "" {//跳到详情页面
            let travelProductView = TravelDetailViewController()
            let productId = model?.routeId
            travelProductView.productId = productId
            self.navigationController?.pushViewController(travelProductView, animated: true)
        }else {//跳到列表页面
            let vc = TravelListViewController()
            var travelForm = TravelForm.Search(pageIndex: 1, pageSize: 20,searchKey: model?.keyword)
            travelForm.startCity = cityName
            travelForm.arriveCity = model?.destinationchs
            travelForm.destId = model?.destinationids
            travelForm.searchType = model?.searchType
            travelForm.type = type
            travelForm.region = self.region
            vc.travelForm = travelForm
            vc.bakTravelForm = travelForm
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /// 开发
    func  cityClick(codes:String,names:String){
            let type = getType()
            let vc = TravelListViewController()
            var travelForm = TravelForm.Search(pageIndex: 1, pageSize: 10,searchKey: "")
            travelForm.startCity = cityName
            travelForm.arriveCity = names
            travelForm.destId = codes
            travelForm.region = self.region
            travelForm.type = type
            vc.travelForm = travelForm
            vc.bakTravelForm = travelForm
            self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension TravelDestinationViewController {
    
    //初始化数据
    func initData () {
        let type = getType()
        let  model = AdvsModel(type: type, departure: cityName)
        SpecialProductService.sharedInstance.advs(model).subscribe{ event in
            self.hideLoadingView()
            if case .next(let e) = event {
                self.data = e.first
                self.initDataView()
            }
            if case .error(let e) = event {
                try? self.validateHttp(e)
            }
        }.disposed(by: bag)
        
        let cityModel = DestinationsModel(type: type, departure: cityName, destId: "",keyWord: "")
        CitsService.sharedInstance.getDestinations(form: cityModel).subscribe{ event in
            self.hideLoadingView()
            if case .next(let e) = event {
                self.cityData = e
                self.initDataView()
            }
            if case .error(let e) = event {
                try? self.validateHttp(e)
            }
        }.disposed(by: bag)
        
    }
    
    func initDataView () {
        collectionView?.reloadData()
    }

}
// CollectionVie
extension TravelDestinationViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func  initCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        
        //设置cell的大小
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.indicatorStyle = .white
        collectionView?.backgroundColor = TBIThemeWhite
        collectionView?.register(TravelDestinationHotColllectionViewCell.classForCoder(), forCellWithReuseIdentifier: travelDestinationHotColllectionViewCellIdentify)
        collectionView?.register(TravelDestinationRegionColllectionViewCell.classForCoder(), forCellWithReuseIdentifier: travelDestinationRegionColllectionViewCellIdentify)
        
        collectionView?.register(TravelDestinationColllectionReusableView.classForCoder(), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: travelDestinationColllectionReusableViewIdentify)
        self.view.addSubview(collectionView!)
        collectionView?.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.left.equalTo(tableView.snp.right)
            make.top.equalTo(searchBarView.snp.bottom)
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if region == 1 { //国内
            return 1 + (cityData?.first?.citys.count ?? 0)
        }else { //国际
            return  1 + (cityData?.count ?? 0)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.data?.travelAdvResponseList.count ?? 0
        }else {
            if region == 1 { //国内
                return  cityData?.first?.citys[section - 1].citys.count ?? 0
            }else { //国际
                return  cityData?[section - 1].citys.count ?? 0
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: travelDestinationHotColllectionViewCellIdentify, for: indexPath) as! TravelDestinationHotColllectionViewCell
            cell.fillCell(model: self.data?.travelAdvResponseList[indexPath.row])
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: travelDestinationRegionColllectionViewCellIdentify, for: indexPath) as! TravelDestinationRegionColllectionViewCell
            if region == 1 { //国内
                cell.fillCell(title:cityData?.first?.citys[indexPath.section - 1].citys[indexPath.row].name)
            }else { //国际
                cell.fillCell(title:cityData?[indexPath.section - 1].citys[indexPath.row].name)
            }
            return cell
        }
        
    }
    
    //返回HeadView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: travelDestinationColllectionReusableViewIdentify, for: indexPath) as! TravelDestinationColllectionReusableView
        if indexPath.section == 0 {
            cell.fillCell(title: "热门")
        }else {
            if region == 1 { //国内
                cell.fillCell(title: cityData?.first?.citys[indexPath.section - 1].name ?? "")
            }else { //国际
                cell.fillCell(title: cityData?[indexPath.section - 1].name ?? "")
                
            }
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }else {
            return UIEdgeInsets(top: 0, left: 15, bottom: 8, right: 15)
        }
        
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 11
        }else {
            return 8
        }
    }
   
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 11
        }else {
            return 8
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let width = ScreenWindowWidth - 104 - 41
            let cellSize = width/2
            return CGSize.init(width: cellSize, height: 90)
        }else {
            let width = ScreenWindowWidth - 104 - 46
            let cellSize = width/3
            return CGSize.init(width: cellSize, height: 36)
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize.init(width: ScreenWindowWidth - 104, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            self.imgClick(model:data?.travelAdvResponseList[indexPath.row])
        }else {
            if region == 1 { //国内
                let citysBean = cityData?.first?.citys[indexPath.section - 1].citys[indexPath.row]
                self.cityClick(codes: citysBean?.code ?? "", names: citysBean?.name ?? "")
            }else { //国际
                let citysBean = cityData?[indexPath.section - 1].citys[indexPath.row]
                self.cityClick(codes: citysBean?.child_codes ?? "", names: citysBean?.child_names ?? "")
                
            }
        }

    }
    
}


extension TravelDestinationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func initTableView(){
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(TravelDestinationTableViewCell.self, forCellReuseIdentifier: travelDestinationTableViewCellIdentify)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(200)
            make.top.equalTo(searchBarView.snp.bottom)
            make.width.equalTo(104)
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    // MARK: 创建cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: travelDestinationTableViewCellIdentify, for: indexPath) as! TravelDestinationTableViewCell
        cell.fillCell(title: tableViewData[indexPath.row], selectFlag: selectIndex == indexPath.row)
        return cell
    }
    
    // MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        initData ()
        textField.resignFirstResponder()
        tableView.reloadData()
    }
    
    // MARK: row高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}

extension TravelDestinationViewController: UISearchBarDelegate,UITextFieldDelegate {
    //设置搜索框
    func initSearchBarView() {
        self.view.addSubview(searchBarView)
        searchBarView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(38)
        }
        textField.returnKeyType = .search
        textField.delegate  = self
        searchBarView.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview()
            make.height.equalTo(32)
            //make.bottom.equalToSuperview().offset(-6)
        }
    }
    
    
    
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let type = getType()
        let vc = TravelListViewController()
        var travelForm = TravelForm.Search(pageIndex: 1, pageSize: 10,searchKey: "")
        travelForm.startCity = cityName
        travelForm.type = type
        travelForm.region = self.region
        travelForm.searchKey = textField.text
        vc.travelForm = travelForm
        vc.bakTravelForm = travelForm
        self.navigationController?.pushViewController(vc, animated: true)
        return true
    }
    
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool{
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getSearchResultArray(searchBarText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        let type = getType()
        
        let vc = TravelListViewController()
        var travelForm = TravelForm.Search(pageIndex: 1, pageSize: 10,searchKey: "")
        travelForm.startCity = cityName
        travelForm.type = type
        travelForm.region = self.region
        travelForm.searchKey = searchBar.text
        vc.travelForm = travelForm
        vc.bakTravelForm = travelForm
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: 搜索逻辑
    fileprivate func getSearchResultArray(searchBarText: String) {
       
        
    }
    
    
}


extension TravelDestinationViewController{
    
    /// 设置右边按钮
    func setRightBar() {
        rightBtn = UIButton(frame:CGRect(x:ScreenWindowWidth - 15,y:5,width:30,height:20))
        rightBtn.setTitle(cityName, for: UIControlState.normal)
        //需求需要注释掉天津出发
//        rightBtn.setImage(UIImage.init(named:"ic_down_white"), for: UIControlState.normal)
//        //let imgSize = btn.imageView?.image?.size
//        //let textSize = btn.titleLabel?.frame.size
        rightBtn.setTitleColor(TBIThemeWhite, for: UIControlState.normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightBtn.backgroundColor = TBIThemeBlueColor
//        rightBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -60)
//        rightBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -20, bottom: 0, right: 0)
        rightBtn.addOnClickListener(target: self, action: #selector(rightItemClick(sender:)))
        let itemBar = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = itemBar
        
    }
    
    func rightItemClick(sender:UIButton) {
        textField.resignFirstResponder()
        let titleArr:[String] = ["北京出发"]//["天津出发","北京出发"]
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
//            if cellIndex == 0 {
//                cityName = "天津"
//                self.rightBtn.setTitle("天津", for: UIControlState.normal)
//            }else {
//                cityName = "北京"
//                self.rightBtn.setTitle("北京", for: UIControlState.normal)
//            }
            cityName = "北京"
            self.rightBtn.setTitle("北京", for: UIControlState.normal)
            self.initData ()
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
    }

}
