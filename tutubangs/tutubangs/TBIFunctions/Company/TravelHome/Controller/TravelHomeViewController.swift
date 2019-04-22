//
//  TravelHomeViewController.swift
//  shop
//
//  Created by TBI on 2017/7/10.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift
var cityName:String = "北京"

class TravelHomeViewController: CompanyBaseViewController {

    fileprivate let bag = DisposeBag()
    
    fileprivate let travelHomeCollectionViewCellIdentify = "travelHomeCollectionViewCellIdentify"
    
    fileprivate let travelHomeCollectionReusableViewIdentify = "travelHomeCollectionReusableViewIdentify"
    
    fileprivate let recommendView:TravelHomeHeaderCellView = TravelHomeHeaderCellView(title:"推荐" , img:"ic_p_recommend")
    fileprivate let groupView:TravelHomeHeaderCellView = TravelHomeHeaderCellView(title:"跟团游" , img:"ic_p_team")
    fileprivate let freeView:TravelHomeHeaderCellView = TravelHomeHeaderCellView(title:"自由行" , img:"ic_p_freedom")
    fileprivate let localView:TravelHomeHeaderCellView = TravelHomeHeaderCellView(title:"当地参团" , img:"ic_p_local")
    fileprivate let customView:TravelHomeHeaderCellView = TravelHomeHeaderCellView(title:"定制旅游" , img:"ic_p_custom")
    
    fileprivate var data:[TravelAdvListResponse]?
    
    fileprivate var filterData:[TravelAdvListResponse]?
    
    fileprivate lazy var searchBar: UIView = {
        let vi = UIView()
        vi.layer.cornerRadius = 2
        vi.backgroundColor = TBIThemeWhite
        let img = UIImageView.init(imageName: "searchBarFlag")
        let label = UILabel(text: "关键字/目的地", color: TBIThemePlaceholderLabelColor, size: 14)
        vi.addSubview(img)
        vi.addSubview(label)
        img.snp.makeConstraints{ (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
        label.snp.makeConstraints{ (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(img.snp.right).offset(5)
        }
        return vi
    }()
    
    fileprivate let headerBgView = UIView()
    
    fileprivate let scrollView: UIScrollView = UIScrollView()
    
    //第一个横滑
    fileprivate let travelHomeScrollView:TravelHomeScrollView = TravelHomeScrollView()
    
    //下面网格布局
    fileprivate  var collectionView:UICollectionView?
    
    fileprivate  var travelHomeSDCycleCellView:TravelHomeSDCycleCellView!
    
    //var imgList:[HomeInfoModel.AdvPic]?
    
    fileprivate lazy var searchBarView: UIView = {
        let vi = UIView()
        vi.backgroundColor = TBIThemeBlueColor
        return vi
    }()
    
    fileprivate var rightBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //定位 测试下
        setNavigation(title:"旅游路线")
        initData()
        setRightBar()
        initSearchBarView()
        initHeaderView()
        
        initContentView()
        initCollectionView()
        travelHomeSDCycleCellView.sdCycleScrollView.delegate = self
       
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

extension TravelHomeViewController {
    /// 初始化数据
    func initData() {
        let  model = AdvsModel(type: "", departure: cityName)
        self.showLoadingView()
        SpecialProductService.sharedInstance.advs(model).subscribe{ event in
            self.hideLoadingView()
            if case .next(let e) = event {
                self.data = e
                self.initDataView()
            }
            if case .error(let e) = event {
                try? self.validateHttp(e)
            }
        }.disposed(by: bag)
    }
    
    /// 请求数据后更换页面数据
    func initDataView(){
        let sdModel:TravelAdvListResponse? = self.data?.filter{$0.type == "1"}.first
        //轮播图设置数据
        travelHomeSDCycleCellView.fillCell(model: sdModel )
        let scModel:TravelAdvListResponse? = self.data?.filter{$0.type == "2"}.first
        //设置横向滑动data
        travelHomeScrollView.fillCell(model: scModel)
        
        filterData = data?.filter{ !($0.type.contains("1") || $0.type.contains("2"))}
        
        var height:Float = 0.0
        for index in 0..<(filterData?.count ?? 0) {
            height += (130 + 41 + 12) * ceilf(Float(filterData?[index].travelAdvResponseList.count ?? 0)/2)
        }
        height +=  Float(filterData?.count ?? 0) * 54
        collectionView?.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(travelHomeScrollView.snp.bottom)
            make.width.equalTo(ScreenWindowWidth)
            make.height.equalTo(height)
            make.bottom.equalTo(0)
        }
        
        collectionView?.reloadData()
    }
}

extension TravelHomeViewController: SDCycleScrollViewDelegate{
    
    
    /// 轮播图滚动回掉
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didScrollTo index: Int) {
        let model = data?.filter{$0.type == "1"}.first?.travelAdvResponseList[index]
        travelHomeSDCycleCellView.titleLabel.text = model?.title
    }
    
    //／ 轮播图点击回掉
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        let model = data?.filter{$0.type == "1"}.first?.travelAdvResponseList[index]
        if model?.routeId != nil && model?.routeId != "" {//跳到详情页面
            let travelProductView = TravelDetailViewController()
            let productId = model?.routeId
            travelProductView.productId = productId
            self.navigationController?.pushViewController(travelProductView, animated: true)
        }else {//跳到列表页面
            let vc = TravelListViewController()
            var travelForm = TravelForm.Search(pageIndex: 1, pageSize: 10,searchKey: model?.keyword)
            travelForm.startCity = cityName
            travelForm.arriveCity = model?.destinationchs
            travelForm.destId = model?.destinationids
            travelForm.searchType = model?.searchType
            travelForm.type = "1"
            vc.travelForm = travelForm
            vc.bakTravelForm = travelForm
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    //搜索点击事件
    func  searchBarClick(tap:UITapGestureRecognizer){
        self.navigationController?.pushViewController(TravelDestinationViewController(), animated: true)
    }
    
    //首页点击图片跳转
    func  imgClick(model:TravelAdvResponse?){
        let type = Int(model?.searchType ?? "1")
        
        if model?.routeId != nil && model?.routeId != "" {//跳到详情页面
            let travelProductView = TravelDetailViewController()
            let productId = model?.routeId
            travelProductView.productId = productId
            self.navigationController?.pushViewController(travelProductView, animated: true)
        }else {//跳到列表页面
            let vc = TravelListViewController()
            var travelForm = TravelForm.Search(pageIndex: 1, pageSize: 10,searchKey: model?.keyword)
            travelForm.startCity = cityName
            travelForm.arriveCity = model?.destinationchs
            travelForm.destId = model?.destinationids
            travelForm.searchType = model?.searchType
            travelForm.type = String(type!+5)
            vc.travelForm = travelForm
            vc.bakTravelForm = travelForm
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /// 更多点击
    ///
    /// - Parameter tap:
    func  moreClick(tap:UITapGestureRecognizer){
        let vi = tap.view as! UILabel
        print(vi.tag)
        let vc = TravelDestinationViewController()
        
        switch vi.tag {
        case 6:
            vc.selectIndex = 0
            self.navigationController?.pushViewController(vc, animated: true)
        case 7:
            vc.selectIndex = 1
            self.navigationController?.pushViewController(vc, animated: true)
        case 8:
            vc.selectIndex = 2
            self.navigationController?.pushViewController(vc, animated: true)
        case 9:
            vc.selectIndex = 3
            self.navigationController?.pushViewController(vc, animated: true)
        case 10:
            let travelLocalCityViewController = TravelLocalCityViewController()
            self.navigationController?.pushViewController(travelLocalCityViewController, animated: true)
        default:
            break
        }

    }
    
    /// header点击
    ///
    /// - Parameter tap:
    func  headerViewCellClick(tap:UITapGestureRecognizer){
//        recommendView.line.isHidden = true
//        groupView.line.isHidden = true
//        freeView.line.isHidden = true
//        localView.line.isHidden = true
//        customView.line.isHidden = true
        let view = tap.view as! TravelHomeHeaderCellView
        let vc = TravelDestinationViewController()
        
        switch view {
        case recommendView:
            break
            //recommendView.line.isHidden = false
        case groupView:
            //groupView.line.isHidden = false
            vc.selectIndex = 0
            self.navigationController?.pushViewController(vc, animated: true)
        case freeView:
            //freeView.line.isHidden = false
            vc.selectIndex = 1
            self.navigationController?.pushViewController(vc, animated: true)
        case localView:
            //localView.line.isHidden = false
            self.navigationController?.pushViewController(TravelLocalCityViewController(), animated: true)
        case customView:
            //customView.line.isHidden = false
            if self.islogin() {
                self.navigationController?.pushViewController(TravelDIYIntentOrderController(), animated: true)
            }
        default:
            break
        }

    }

}
// CollectionVie
extension TravelHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func  initCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        
        //设置cell的大小
       
        
        let width = ScreenWindowWidth - 45
        
        let cellSize = width/2
        layout.itemSize = CGSize(width: cellSize,height: 130 + 41)

        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.backgroundColor = TBIThemeWhite
        collectionView?.register(TravelHomeCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: travelHomeCollectionViewCellIdentify)
        collectionView?.register(TravelHomeCollectionReusableView.classForCoder(), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: travelHomeCollectionReusableViewIdentify)
        collectionView?.isScrollEnabled = false
        self.scrollView.addSubview(collectionView!)
        let height =  ((130 + 41 + 12)*2) * 2 + (2 * 54)
        collectionView?.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(travelHomeScrollView.snp.bottom)
            make.width.equalTo(ScreenWindowWidth)
            make.height.equalTo(height)
            make.bottom.equalTo(0)
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  filterData?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterData?[section].travelAdvResponseList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: travelHomeCollectionViewCellIdentify, for: indexPath) as! TravelHomeCollectionViewCell
        cell.fillCell(model: filterData?[indexPath.section].travelAdvResponseList[indexPath.row])
        return cell
    }
    
    //返回HeadView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
       let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: travelHomeCollectionReusableViewIdentify, for: indexPath) as! TravelHomeCollectionReusableView
        cell.fillCell(model: filterData?[indexPath.section].firstTravelAdvResponse)
        cell.moreLabel.addOnClickListener(target: self, action: #selector(moreClick(tap:)))
       return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 12, right: 15)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize.init(width: ScreenWindowWidth, height: 54)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = String(indexPath.section + 3)
        let selectData = self.data?.filter{$0.type == type}.first
        if  selectData != nil {
            self.imgClick(model:selectData?.travelAdvResponseList[indexPath.row])
        }
        
    }
    
}
extension TravelHomeViewController {

    func initContentView(){
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerBgView.snp.bottom)
        }

        travelHomeSDCycleCellView = TravelHomeSDCycleCellView()
        travelHomeSDCycleCellView.backgroundColor = TBIThemeWhite
        
        scrollView.addSubview(travelHomeSDCycleCellView)
        travelHomeSDCycleCellView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.width.equalTo(ScreenWindowWidth)
            make.top.equalTo(10)
            make.height.equalTo(277)
        }
        scrollView.addSubview(travelHomeScrollView)
        travelHomeScrollView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(travelHomeSDCycleCellView.snp.bottom).offset(10)
            make.height.equalTo(182)
            make.width.equalTo(ScreenWindowWidth)
        }
        travelHomeScrollView.travelHomeScrollViewBlock = { (index) in
            let selectData = self.data?.filter{$0.type == "2"}.first
            if  selectData != nil {
                self.imgClick(model:selectData?.travelAdvResponseList[index])
            }
            
        }
        travelHomeSDCycleCellView.moreLabel.addOnClickListener(target: self, action: #selector(moreClick(tap:)))
        travelHomeScrollView.headerView.moreLabel.addOnClickListener(target: self, action: #selector(moreClick(tap:)))
    }
}

extension TravelHomeViewController {
    
    func initHeaderView(){
        headerBgView.backgroundColor = TBIThemeWhite
        recommendView.addOnClickListener(target: self, action: #selector(headerViewCellClick(tap:)))
        groupView.addOnClickListener(target: self, action: #selector(headerViewCellClick(tap:)))
        freeView.addOnClickListener(target: self, action: #selector(headerViewCellClick(tap:)))
        localView.addOnClickListener(target: self, action: #selector(headerViewCellClick(tap:)))
        customView.addOnClickListener(target: self, action: #selector(headerViewCellClick(tap:)))
        
        
        self.view.addSubview(headerBgView)
        headerBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(87)
            make.top.equalTo(searchBarView.snp.bottom)
        }
        headerBgView.addSubview(recommendView)
        recommendView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(ScreenWindowWidth/5)
        }
        headerBgView.addSubview(groupView)
        groupView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(ScreenWindowWidth/5)
            make.left.equalTo(recommendView.snp.right)
        }
        headerBgView.addSubview(freeView)
        freeView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(ScreenWindowWidth/5)
            make.left.equalTo(groupView.snp.right)
        }
        headerBgView.addSubview(localView)
        localView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(ScreenWindowWidth/5)
            make.left.equalTo(freeView.snp.right)
        }
        headerBgView.addSubview(customView)
        customView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(ScreenWindowWidth/5)
            make.left.equalTo(localView.snp.right)
        }
        
    }

}
extension TravelHomeViewController: UISearchBarDelegate {
    //设置搜索框
    func initSearchBarView() {
        self.view.addSubview(searchBarView)
        searchBarView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(38)
        }
        searchBarView.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview()
            make.height.equalTo(32)
            //make.bottom.equalToSuperview().offset(-6)
        }
        searchBar.addOnClickListener(target: self, action: #selector(searchBarClick(tap:)))
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool{
        self.navigationController?.pushViewController(TravelDestinationViewController(), animated: true)
        return false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getSearchResultArray(searchBarText: searchText)
    }
    
    // MARK: 搜索逻辑
    fileprivate func getSearchResultArray(searchBarText: String) {
        
    }

    

    
}

extension TravelHomeViewController {
    
    
    /// 设置右边按钮
    func setRightBar() {
        rightBtn = UIButton(frame:CGRect(x:ScreenWindowWidth - 20,y:5,width:30,height:20))
        rightBtn.setTitle(cityName, for: UIControlState.normal)
        //因为需求需要隐藏天津出发暂时先注释
        //rightBtn.setImage(UIImage.init(named:"ic_down_white"), for: UIControlState.normal)
        ////let imgSize = rightBtn.imageView?.image?.size
        ////let textSize = rightBtn.titleLabel?.frame.size
        //rightBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -60)
        //rightBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -20, bottom: 0, right: 0)
        rightBtn.setTitleColor(TBIThemeWhite, for: UIControlState.normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightBtn.backgroundColor = TBIThemeBlueColor
        rightBtn.addOnClickListener(target: self, action: #selector(rightItemClick(sender:)))
        let itemBar = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = itemBar
    }
    
    func rightItemClick(sender:UIButton) {
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
            self.initData()
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
        
    }
}
