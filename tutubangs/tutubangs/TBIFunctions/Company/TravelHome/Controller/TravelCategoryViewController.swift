//
//  TravelCategoryViewController.swift
//  shop
//
//  Created by TBI on 2017/6/28.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftDate

class TravelCategoryViewController: CompanyBaseViewController {

    fileprivate let bag = DisposeBag()
    
    fileprivate let scrollView: UIScrollView = UIScrollView()//.init(frame: UIScreen.main.bounds)
    
    fileprivate let calenadrCollectionViewCellIdentify = "calenadrCollectionViewCellIdentify"
    
    fileprivate let calenadrCollectionReusableViewIdentify = "calenadrCollectionReusableViewIdentify"
    
    fileprivate let travelProductCollectionViewCellIdentify = "travelProductCollectionViewCellIdentify"
    
    fileprivate let travelProductCollectionReusableViewIdentify = "travelProductCollectionReusableViewIdentify"
    
    /// tableView
    fileprivate let travelHeaderOneViewIdentify = "travelHeaderOneViewIdentify"
    
    fileprivate let travelHeaderTwoViewIdentify = "travelHeaderTwoViewIdentify"
    
    fileprivate let travelCategoryTableViewCellIdentify = "travelCategoryTableViewCellIdentify"
    
    fileprivate var collectionView:UICollectionView?
    
    fileprivate var productCollectionView:UICollectionView?
    
    fileprivate let dateBgView = UIView()
    
    fileprivate var  dataSourceManager:CalenadrDataSource!
    
    fileprivate var weekCount:Int?
    
    fileprivate var data:[SpecialPriceListItem]?
    
    fileprivate var selectData:SpecialPriceListItem?
    
    fileprivate let dateHeaderView:DateHeaderView = DateHeaderView()
    
    fileprivate var date:Date = Date()
    
    
    //产品月份
    fileprivate var firstDate:Date = Date()
    
    fileprivate let tableView = UITableView()
    
    fileprivate let travelNewDateView:TravelNewDateView = TravelNewDateView()
    
    //var productId:String?
    
    var travelItem:TravelListItem?
    
    fileprivate var categorysList:[TravelCategorys]?
    
    fileprivate var categoryIdIndex:Int = 0
    
    fileprivate var tableSectionOneData:[[String:Any]] = []
    
    fileprivate var tableSectionTwoData:[[String:Any]] = []
    
    fileprivate var tableSectionOne:Int = 0
    
    fileprivate var tableSectionTwo:Int = 0
    
    fileprivate var tableSectionThree:Int = 0
    
    fileprivate let footerView:TravelOrderFooterView = TravelOrderFooterView()
    
    
    let  img = UIImageView(imageName: "ic_no_date_grey")
    
    let  messageLabel = UILabel(text: "产品已售馨,请挑选其他产品", color: TBIThemePlaceholderTextColor, size: 14)
    
    //有么有数据
    var noDataFlag:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation(title:"旅游预订")
        initData()
        //initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func travelNewDateViewAction()  {
        
        let newDateView = TravelNewDateViewController()
        newDateView.travelListItem = travelItem!
        self.navigationController?.pushViewController(newDateView, animated: true)
    }
    
    
}
extension TravelCategoryViewController {
    
    func initData(){
        showLoadingView()
        TravelService.sharedInstance.categorys(travelItem?.productId ?? "").subscribe{ event in
            self.hideLoadingView()
            if case .next(let e) = event {
                self.categorysList = e
                if  e.isEmpty {
                    _ = self.navigationController?.popViewController(animated: true)
                }else {
                    self.updateProductCollectionView()
                }
                
            }
            if case .error(let e) = event {
                try? self.validateHttp(e)
                
            }
            }.disposed(by: bag)

    }
    
    //没有数据
    func noData () {
        dateHeaderView.isHidden = true
        collectionView?.isHidden  = true
        img.isHidden = false
        messageLabel.isHidden = false
        dateBgView.snp.remakeConstraints { (make) in
            make.height.equalTo(194)
            make.width.equalTo(ScreenWindowWidth)
            make.top.equalTo(productCollectionView?.snp.bottom ?? 0).offset(10)
            make.left.right.equalToSuperview()
        }
        dateBgView.addSubview(img)
        img.snp.makeConstraints { (make) in
            make.top.equalTo(80)
            make.centerX.equalToSuperview().offset(-100)
            //make.left.equalTo(36)
            make.width.equalTo(94)
            make.height.equalTo(70)
        }
        dateBgView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(img.snp.right).offset(20)
            make.centerY.equalTo(img.snp.centerY)
            //make.right.equalTo(-44)
        }
        
        tableView.isHidden = true
        noDataFlag = true
        travelNewDateView.newDayLabel.isHidden = true
        footerView.submitButton.backgroundColor = TBIThemeGrayLineColor
    }
    
    func yesData () {
        dateHeaderView.isHidden = false
        img.isHidden = true
        messageLabel.isHidden = true
        collectionView?.isHidden  = false
        noDataFlag = false
        travelNewDateView.newDayLabel.isHidden = false
        footerView.submitButton.backgroundColor = TBIThemeOrangeColor
    }
    
    func initView(){
        self.view.addSubview(footerView)
        footerView.submitButton.setTitle("下一步", for: UIControlState.normal)
        footerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        footerView.submitButton.addTarget(self, action: #selector(nextStep(sender:)), for: .touchUpInside)
        weekCount = dataSourceManager.weeksInMonth(0)
        //dataSourceManager.selectionType = .Single
        self.view.addSubview(scrollView)
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor  = TBIThemeBaseColor
        scrollView.addSubview(dateBgView)
        scrollView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
        }
        //scrollView.contentSize = CGSize.init(width: 0, height: 850)
        initCollectionView()
        initTableView()
        
        
        if categorysList?.first?.firstMonth.isEmpty ?? true{
            self.noData()
        }

    }
    
    //下一步
    func nextStep(sender: UIButton) {
        if self.islogin() {
            if noDataFlag {
                return
            }
            var sum:Int = 0
            var buyListOne:[[String:Any]] = []
            var buyListTwo:[[String:Any]] = []
            
            for index in 0..<tableSectionOneData.count {
                let price = Int(tableSectionOneData[index]["price"] as? Double ?? 0)
                sum += price * (tableSectionOneData[index]["number"] as? Int ?? 0)
                if (tableSectionOneData[index]["number"] as? Int ?? 0) != 0 {
                    var da = tableSectionOneData[index]
                    if (da["type"] as? PriceType) == .adultPrice{//"adultPrice"
                        da["title"] = "成人"
                        buyListOne.append(da)
                    }else {
                        buyListOne.append(da)
                    }
                    
                }
            }
            for index in 0..<tableSectionTwoData.count {
                let price = Int(tableSectionTwoData[index]["price"] as? Double ?? 0)
                sum += price * (tableSectionTwoData[index]["number"] as? Int ?? 0)
                if (tableSectionTwoData[index]["number"] as? Int ?? 0) != 0 {
                    buyListTwo.append(tableSectionTwoData[index])
                }
            }
            if sum == 0 {
               self.alertView(title:"提示",message:"请选择数量")
               return
            }
            let vc = TravelOrderViewController()
            vc.setData(travelItem: travelItem, travelCategorys: categorysList?[categoryIdIndex], priceData: selectData, buyListOne: buyListOne, buyListTwo: buyListTwo)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
extension TravelCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func updateProductCollectionView(){
        productCollectionView?.snp.updateConstraints{ (make) in
            make.height.equalTo(33+(40*(self.categorysList?.count ?? 1)))
        }
        productCollectionView?.reloadData()
        
        if categorysList?.first?.firstMonth.isNotEmpty ?? false{
              date = DateInRegion(string: (categorysList?.first?.firstMonth ?? "2017-08")+"-01", format: .custom("yyyy-MM-dd"), fromRegion: regionRome)!.absoluteDate
        }else {
            date = Date()
        }
      
        firstDate = date
        let startDate = date
        let endDate =  startDate + 30.month
        dataSourceManager = CalenadrDataSource(startDate:startDate,endDate:endDate)
        dataSourceManager.selectionType = .Single
        
        let saleDate = DateInRegion(absoluteDate: date).string(custom: "yyyy-MM")
        self.initPrice(id:self.categorysList?.first?.categoryId ?? "",dateMonth:saleDate)
        initView()
    }
    
    func initPrice (id:String, dateMonth:String){
        let form = TravelForm.SpecialPriceSearch(saleDate: dateMonth)
        showLoadingView()
        TravelService.sharedInstance.searchPrice(id: travelItem?.productId ?? "1", categoryId: id, form).subscribe{ event in
            self.hideLoadingView()
            if case .next(let e) = event {
                self.data = e
                self.collectionView?.reloadData()
                let item = e.filter{$0.status == 1}.first
                guard let da = item else {
                    self.refreshTableView(data: nil)
                    return
                }
                self.selectData = da
                self.refreshTableView(data: da)
            }
            if case .error(let e) = event {
                try? self.validateHttp(e)
            }
            }.disposed(by: bag)
    }
    
    //刷新价格
    func refreshTableView(data:SpecialPriceListItem?){
        tableSectionOneData.removeAll()
        tableSectionTwoData.removeAll()
        tableSectionOne = 0
        tableSectionTwo = 0
        tableSectionThree = 0
        
        if data?.adultPrice != 0 && data?.adultPrice != nil{ //成人价格
            tableSectionOneData.append(["title":"成人","type":PriceType.adultPrice,"price":data?.adultPrice ?? 0,"number":data?.stock == 0 ? 0 : 1])
        }
        if data?.childBedPrice != 0 && data?.childBedPrice != nil{//儿童占床
            if travelItem?.productFlag == .tbi {
                tableSectionOneData.append(["title":"儿童(占床)","type":PriceType.childBedPrice,"price":data?.childBedPrice ?? 0,"number":0])
            }else if travelItem?.productFlag == .cits {
                tableSectionOneData.append(["title":"儿童","type":PriceType.childBedPrice,"price":data?.childBedPrice ?? 0,"number":0])
            }
           
        }
        if data?.childNobedPrice != 0 && data?.childBedPrice != nil{//儿童不占床
            tableSectionOneData.append(["title":"儿童(不占床)","type":PriceType.childBedPrice,"price":data?.childNobedPrice ?? 0,"number":0])
        }
        if !tableSectionOneData.isEmpty {
            tableSectionOne = 1
        }
        if data?.singleRoomDifference != 0 && data?.singleRoomDifference != nil{//单房差
            tableSectionTwoData.append(["title":"单房差","type":PriceType.singleRoomDifference,"price":data?.singleRoomDifference ?? 0,"number":0])
            tableSectionTwo = 1
        }
        if travelItem?.confirm ?? true{
            tableSectionThree = 1
        }
        self.sumPrice()
        tableView.reloadData()
        self.updateTableViewHeight()
    }
    
    func initCollectionView(){
        
        
        /// ===== cell
        let productLayout = UICollectionViewFlowLayout()
        
        productCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: productLayout)
        
        //设置cell的大小
        productLayout.minimumLineSpacing = 10
        
        productLayout.minimumInteritemSpacing = 10
        
        let pcellSize = (ScreenWindowWidth - 45)/2
        
        productLayout.collectionView?.contentInset.left = 15
        productLayout.collectionView?.contentInset.right = 15
        
        productLayout.itemSize = CGSize(width: pcellSize,height: 30)
        
        productLayout.headerReferenceSize = CGSize(width: ScreenWindowWidth, height: 33)
        
        productCollectionView?.delegate = self
        productCollectionView?.dataSource = self
        productCollectionView?.register(TravelProductCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: travelProductCollectionViewCellIdentify)
        productCollectionView?.register(TravelProductCollectionReusableView.classForCoder(), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: travelProductCollectionReusableViewIdentify)
        
        self.scrollView.addSubview(productCollectionView!)
        productCollectionView?.backgroundColor = TBIThemeWhite
        
        productCollectionView?.snp.makeConstraints({ (make) in
            make.width.equalTo(ScreenWindowWidth)
            make.top.equalTo(10)
            make.height.equalTo(33+(40*2))
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        })

        /// =========
        
        
        dateBgView.backgroundColor = TBIThemeWhite
        scrollView.addSubview(dateBgView)
        dateBgView.snp.makeConstraints { (make) in
            make.height.equalTo(111+(Double(weekCount ?? 0)*49.28))
            make.width.equalTo(ScreenWindowWidth)
            make.top.equalTo(productCollectionView?.snp.bottom ?? 0).offset(10)
            make.left.equalToSuperview()
        }
        dateBgView.addSubview(dateHeaderView)
        dateBgView.addSubview(travelNewDateView)
        travelNewDateView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(44)
        }
        dateHeaderView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(travelNewDateView.snp.bottom)
            make.height.equalTo(37)
        }
        
        
        weak var weakSelf = self
        travelNewDateView.travelNewDateViewBlock = { (parameter) in
            
            weakSelf?.travelNewDateViewAction()
        }
        
        
        dateHeaderView.dayLabel.text = DateInRegion(absoluteDate: date).string(custom: "yyyy年M月")

        let layout = UICollectionViewFlowLayout()
      
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        
        //设置cell的大小
        layout.minimumLineSpacing = 0
        
        layout.minimumInteritemSpacing = 0
        
        let width = ScreenWindowWidth - 30
        
        let cellSize = width/7
        
        layout.collectionView?.contentInset.left = 15
        layout.collectionView?.contentInset.right = 15
        layout.itemSize = CGSize(width: cellSize,height: 49.28)
        layout.headerReferenceSize = CGSize(width: ScreenWindowWidth, height: 30)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(CalenadrCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: calenadrCollectionViewCellIdentify)
        collectionView?.register(CalenadrCollectionReusableView.classForCoder(), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: calenadrCollectionReusableViewIdentify)
        self.dateBgView.addSubview(collectionView!)
        collectionView?.backgroundColor = TBIThemeWhite
        collectionView?.isScrollEnabled = false
        collectionView?.snp.makeConstraints({ (make) in
            make.width.equalTo(ScreenWindowWidth)
            make.left.right.equalToSuperview()
            make.top.equalTo(dateHeaderView.snp.bottom)
            make.height.equalTo(30+(Double(weekCount ?? 0)*49.28))
        })
        dateHeaderView.lastMonth.addTarget(self, action: #selector(lastMonth(sender:)), for: .touchUpInside)
        dateHeaderView.nextMonth.addTarget(self, action: #selector(nextMonth(sender:)), for: .touchUpInside)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productCollectionView{
            return categorysList?.count ?? 0
        }else {
            return dataSourceManager.daysInMonth(section)
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == productCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: travelProductCollectionViewCellIdentify, for: indexPath) as! TravelProductCollectionViewCell
            cell.title.text = categorysList?[indexPath.row].categoryName
            if indexPath.row == categoryIdIndex {
                cell.title.backgroundColor = TBIThemeOrangeColor
                cell.title.textColor  = TBIThemeWhite
            }else {
                cell.title.backgroundColor = TBIThemeBaseColor
                cell.title.textColor  = TBIThemeTipTextColor
            }
            return cell
        }else { //日历 collectionView
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calenadrCollectionViewCellIdentify, for: indexPath) as! CalenadrCollectionViewCell
            
            let (date,dayState) = dataSourceManager.dayState(indexPath)
            
            print(date)
            let button = cell.dayLabel
            
            button.text = dataSourceManager.StringDayFromDate(date)
            button.textColor = TBIThemePrimaryTextColor
            button.backgroundColor = TBIThemeWhite
            cell.priceLabel.textColor = TBIThemeOrangeColor
            
            button.isHidden = dayState.contains(.NotThisMonth)
            cell.priceLabel.isHidden = dayState.contains(.NotThisMonth)
            cell.inventoryLabel.isHidden = dayState.contains(.NotThisMonth)
            
            guard !button.isHidden else{
                return cell
            }
            
            let day = data?.filter{$0.saleDate.absoluteDate == date}.first
            
            let state = dayInfo(day)
            
            let stock = day?.stock ?? 0
            if stock <= 5 && stock != 0{
                cell.inventoryLabel.text = "余\(String(stock))"
            }else {
                cell.inventoryLabel.text = ""
            }

            
            guard !dayState.contains(.UnSelectable) else{
                button.textColor = TBIThemePlaceholderTextColor
                cell.priceLabel.text = ""
                return cell
            }
            guard !state.contains(.UnSelectable) else{
                button.textColor = TBIThemePlaceholderTextColor
                cell.priceLabel.text = ""
                return cell
            }
            
            guard !state.contains(.SoldOut) else{
                button.backgroundColor = TBIThemeMinorColor
                button.textColor = TBIThemePlaceholderTextColor
                cell.priceLabel.textColor = TBIThemePlaceholderTextColor
                cell.priceLabel.text = "售罄"
                return cell
            }
            
            guard !state.contains(.Overdue) else{
                button.backgroundColor = TBIThemeMinorColor
                button.textColor = TBIThemePlaceholderTextColor
                cell.priceLabel.textColor = TBIThemePlaceholderTextColor
                cell.priceLabel.text = "过期"
                return cell
            }
            
            
            cell.priceLabel.text = "¥\(String(format: "%.0f", day?.adultPrice ?? 0))"
            
            if state.contains(.Selected) {
                button.textColor = UIColor.white
                button.backgroundColor = TBIThemeBlueColor
                cell.priceLabel.textColor = UIColor.white
            }
            
//            if dayState.contains(.Selected){
//                if dayState.contains(.Today){
//                    button.textColor = UIColor.red
//                    button.backgroundColor = TBIThemeBlueColor
//                    cell.priceLabel.textColor = UIColor.white
//                }else{
//                    button.textColor = UIColor.white
//                    button.backgroundColor = TBIThemeBlueColor
//                    cell.priceLabel.textColor = UIColor.white
//                }
//            }
            
            return cell
        }
        
        
    }
    
 

    
    //返回HeadView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if collectionView == productCollectionView{
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: travelProductCollectionReusableViewIdentify, for: indexPath) as! TravelProductCollectionReusableView
            return cell
        }else {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: calenadrCollectionReusableViewIdentify, for: indexPath) as! CalenadrCollectionReusableView
            return cell
        }
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productCollectionView{
            didProductCellClick(indexPath)
        }else {
            didDateCellClick(indexPath)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if collectionView == productCollectionView{
//            didProductCellClick(indexPath)
//        }else {
//            didDateCellClick(indexPath)
//        }
//
//    }
    
    /// 选中产品
    ///
    /// - Parameter indexPath:
    func didProductCellClick(_ indexPath: IndexPath){
        categoryIdIndex = indexPath.row
        productCollectionView?.reloadData()
        
        if categorysList?[indexPath.row].firstMonth.isNotEmpty ?? false{
            date = DateInRegion(string: (categorysList?[indexPath.row].firstMonth ?? "2017-08")+"-01", format: .custom("yyyy-MM-dd"), fromRegion: regionRome)!.absoluteDate
        }else {
            date = Date()
        }

      
        firstDate = date
        let startDate = date
        let endDate =  startDate + 30.month
        dataSourceManager = CalenadrDataSource(startDate:startDate,endDate:endDate)
        dataSourceManager.selectionType = .Single
        dateHeaderView.dayLabel.text = date.string(custom: "yyyy年M月")
        dateHeaderView.lastMonth.isSelected = false
        let saleDate = DateInRegion(absoluteDate: date).string(custom: "yyyy-MM")
        
        weekCount = dataSourceManager.weeksInMonth(dataSourceManager.monthSection)
        updateDateHeight()
        
        self.initPrice(id:self.categorysList?[categoryIdIndex].categoryId ?? "",dateMonth:saleDate)
    }
    
    /// 选中日期
    ///
    /// - Parameter indexPath:
    func didDateCellClick(_ indexPath: IndexPath){
        let (date,dayState) = dataSourceManager.dayState(indexPath)
        if dayState.contains(.NotThisMonth) || dayState.contains(.UnSelectable){
            return
        }
        let day = data?.filter{$0.saleDate.absoluteDate == date}.first
        let state = dayInfo(day)
        if  state.contains(.UnSelectable){
            return
        }
        if  state.contains(.Overdue){
            return
        }
        
        if dataSourceManager.didSelectItemAtIndexPath(indexPath){
            self.collectionView?.reloadData()
            self.selectData = day //选中日期
            self.refreshTableView(data:day)
        }
        
    }
    
    func updateTableViewHeight(){
        
        var height = (tableSectionOneData.count  + tableSectionTwoData.count) * 44
        if tableSectionTwoData.count == 0{
            height += 57
        }else {
            height += 107
        }
        if tableSectionThree == 1{
            height += 37
        }
        
        tableView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }
    
    func updateDateHeight(){
        dateBgView.snp.updateConstraints { (make) in
            make.height.equalTo(111+(Double(weekCount ?? 0)*49.28))
        }

        collectionView?.snp.updateConstraints{ (make) in
            make.height.equalTo(30+(Double(weekCount ?? 0)*49.28))
        }
    }
    
    
    
    //上一月
    func lastMonth(sender: UIButton) {
        if date.year == firstDate.year {
            if date.month <= firstDate.month {
                self.dateHeaderView.lastMonth.isSelected = false
                return
            }
            if (date.month - 1) == firstDate.month {
                self.dateHeaderView.lastMonth.isSelected = false
                }
        }
        date = date - 1.month
        self.dataSourceManager.lastMonth()
        weekCount = dataSourceManager.weeksInMonth(dataSourceManager.monthSection)
        updateDateHeight()
        let saleDate = DateInRegion(absoluteDate: date).string(custom: "yyyy-MM")
        self.dateHeaderView.dayLabel.text = DateInRegion(absoluteDate: date).string(custom: "yyyy年M月")
        self.initPrice(id:self.categorysList?[categoryIdIndex].categoryId ?? "",dateMonth:saleDate)
        
    }
    
    //下一月
    func nextMonth(sender: UIButton) {
        date = date + 1.month
        self.dataSourceManager.nextMonth()
        weekCount = dataSourceManager.weeksInMonth(dataSourceManager.monthSection)
        updateDateHeight()
        let saleDate = DateInRegion(absoluteDate: date).string(custom: "yyyy-MM")
        self.dateHeaderView.dayLabel.text = DateInRegion(absoluteDate: date).string(custom: "yyyy年M月")
        self.dateHeaderView.lastMonth.isSelected = true
        self.initPrice(id:self.categorysList?[categoryIdIndex].categoryId ?? "",dateMonth:saleDate)
        
    }
    
    /// 日历控件需要
    ///
    /// - Parameter model:
    /// - Returns:
    func dayInfo(_ model:SpecialPriceListItem?) ->DayStateOptions{
        var options =  DayStateOptions(rawValue:0)
        if model == nil {
            options = [options,.UnSelectable]
        }
        if model?.saleDate == selectData?.saleDate {
            options = [options,.Selected]
        }
        switch model?.status ?? 0 {
        case 2: //售罄
            options = [options,.SoldOut]
        case 3: //过期
            options = [options,.Overdue]
        default:
            break
        }
        return options
    }


}

extension TravelCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func initTableView () {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.isScrollEnabled = false
        tableView.register(TravelCategoryTableViewCell.classForCoder(), forCellReuseIdentifier: travelCategoryTableViewCellIdentify)
        tableView.register(TravelHeaderOneView.classForCoder(), forHeaderFooterViewReuseIdentifier: travelHeaderOneViewIdentify)
        tableView.register(TravelHeaderTwoView.classForCoder(), forHeaderFooterViewReuseIdentifier: travelHeaderTwoViewIdentify)
        self.scrollView.addSubview(tableView)
        var height = (tableSectionOneData.count  + tableSectionTwoData.count) * 44 + 87
        if tableSectionThree == 1{
            height += 37
        }
        tableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(ScreenWindowWidth)
            make.top.equalTo(collectionView?.snp.bottom ?? 0)
            make.height.equalTo(height)
            make.bottom.equalToSuperview()
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSectionOne + tableSectionTwo + tableSectionThree
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tableSectionOneData.count
        }else if section == 1 && tableSectionTwo != 0{
            return tableSectionTwoData.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section ==  0 {
            return 47
        }else if  section == 1 && tableSectionTwo != 0{
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section ==  0 {
            let headerView  = tableView.dequeueReusableHeaderFooterView(withIdentifier: travelHeaderOneViewIdentify) as? TravelHeaderOneView
            return headerView
        }else if section == 1 && tableSectionTwo != 0{
            let headerView  = tableView.dequeueReusableHeaderFooterView(withIdentifier: travelHeaderTwoViewIdentify) as? TravelHeaderTwoView
            return headerView
        }
        return nil
    }
    
    // MARK: 创建cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: travelCategoryTableViewCellIdentify, for: indexPath) as! TravelCategoryTableViewCell
            cell.addBtn.addTarget(self, action: #selector(addBtn(btn:)), for: .touchUpInside)
            cell.addBtn.tag = 100 + indexPath.row
            cell.subtractBtn.addTarget(self, action: #selector(subtractBtn(btn:)), for: .touchUpInside)
            cell.subtractBtn.tag = 200 + indexPath.row
            cell.selectionStyle = .none
            cell.fillCell(model: tableSectionOneData[indexPath.row],stock:selectData?.stock ?? 0)//selectData?.stock ?? 99
            return cell
        }else if indexPath.section == 1 && tableSectionTwo != 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: travelCategoryTableViewCellIdentify, for: indexPath) as! TravelCategoryTableViewCell
            cell.addBtn.addTarget(self, action: #selector(addBtn(btn:)), for: .touchUpInside)
            cell.addBtn.tag = 300 + indexPath.row
            cell.subtractBtn.addTarget(self, action: #selector(subtractBtn(btn:)), for: .touchUpInside)
            cell.subtractBtn.tag = 400 + indexPath.row
            cell.selectionStyle = .none
            cell.fillCell(model: tableSectionTwoData[indexPath.row],stock:selectData?.stock ?? 0)//selectData?.stock ?? 99
            return cell
        }
        return TravelMessageTableViewCell()
        
    }
    // MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: row高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section ==  2{
            return 37
        }
        return 44
    }
    
    func sumPrice (){
        var sum:Int = 0
        for index in 0..<tableSectionOneData.count {
            let price = Int(tableSectionOneData[index]["price"] as? Double ?? 0)
            sum += price * (tableSectionOneData[index]["number"] as? Int ?? 0)
        }
        for index in 0..<tableSectionTwoData.count {
            let price = Int(tableSectionTwoData[index]["price"] as? Double ?? 0)
            sum += price * (tableSectionTwoData[index]["number"] as? Int ?? 0)
        }
        footerView.priceCountLabel.text = String(sum)
    }
    //添加
    func addBtn(btn:UIButton) {
        if btn.tag < 300 {
            let index = btn.tag  - 100
            tableSectionOneData[index]["number"] = ((tableSectionOneData[index]["number"] as? Int)  ?? 0) + 1
        }else {
            let index = btn.tag  - 300
            tableSectionTwoData[index]["number"] = ((tableSectionTwoData[index]["number"] as? Int)  ?? 0) + 1
        }
        sumPrice ()
        tableView.reloadData()
    }
    
    //减少
    func subtractBtn(btn:UIButton) {
        
        if btn.tag < 300 {
            let index = btn.tag  - 200
            if ((tableSectionOneData[index]["number"] as? Int)  ?? 0) > 0 {
                tableSectionOneData[index]["number"] = ((tableSectionOneData[index]["number"] as? Int)  ?? 0) - 1
            }
        }else {
            let index = btn.tag  - 400
            if ((tableSectionTwoData[index]["number"] as? Int)  ?? 0) > 0 {
                tableSectionTwoData[index]["number"] = ((tableSectionTwoData[index]["number"] as? Int)  ?? 0) - 1
            }
        }
       sumPrice ()
       tableView.reloadData()
    }
    
}
