//
//  SpecialProductViewController.swift
//  shop
//
//  Created by manman on 2017/7/4.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import MJRefresh


/// 旅游类型
///
/// - airHotel: 机+酒
/// - airTicket: 机票
/// - airCar: 机+专车
/// - airVisa: 机+签证
/// - hotelAdmission: 酒+门票
/// - hotelTicket: 酒+餐券
/// - holiday: 度假产品
/// - travel: 旅游产品

//{"code":100,"message":"成功","content":[{"id":"2","productType":"机票"},{"id":"3","productType":"机+车"},{"id":"4","productType":"机+签"},{"id":"5","productType":"酒+门票"},{"id":"6","productType":"酒+餐券"},{"id":"7","productType":"度假产品"}]}
//默认 为全部
enum SpecialProductCategory:String {
    case Flight = "2"
    case SpecialCar = "3"
    case Visa = "4"
    case Default
    
}




class SpecialProductViewController: CompanyBaseViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource{

    public var titleTopCategoryListDataSources:[SpecialProductCategoryModel] = Array()

    public var selectedCategoryIndex:SpecialProductCategory = SpecialProductCategory.Default
    private let leftTableViewCellIdentify:String = "leftTableViewCellIdentify"
    private let midTableViewCellIdentify:String = "midTableViewCellIdentify"
    private let rightTableViewCellIdentify:String = "rightTableViewCellIdentify"
    private var allButtonWidth:CGFloat = 0
    private let categoryWidth:CGFloat = 30
    private let categorySpace:CGFloat = 10
    private let categoryHeight:CGFloat = 32
    private var searchCondition:SpecialProductListRequestModel = SpecialProductListRequestModel()
    private var titleCustomView:UIView = UIView()
    private var searchBarView:TBISearchBarView = TBISearchBarView()
    private var titleTopCategoryListBackgroundScrollView:UIScrollView = UIScrollView()
    //指示器
    private var titleTopCategoryViewScrollIndicator:UILabel = UILabel()
    private var selectedCategoryButtonIndexButton = UIButton()
    private var titleTopCategoryList:[(index:NSInteger,localFrame:CGRect)] = Array()
    //默认显示全部
    private var currentIndex:NSInteger = 0
    private var leftIndex:NSInteger = 0
    private var rightIndex:NSInteger = 0
    
    
    private var currentNetIndex:NSInteger = 1
    
    private var contentBackgroundScrollView:UIScrollView = UIScrollView()
    
    private var leftTableView:UITableView = UITableView()
    private var midTableView:UITableView = UITableView()
    private var rightTableView:UITableView = UITableView()
    private let bag = DisposeBag()
    private var tableViewDataSources:[[TravelListItem]] = [[]]
    private var scaleScrollIndicator:CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeWhite
        setTitle(titleStr: "")
        
        // Do any additional setup after loading the view.
        //现设置模拟数据
        
        /// 旅游类型
        ///
        /// - airHotel: 机+酒
        /// - airTicket: 机票
        /// - airCar: 机+专车
        /// - airVisa: 机+签证
        /// - hotelAdmission: 酒+门票
        /// - hotelTicket: 酒+餐券
        /// - holiday: 度假产品
        /// - travel: 旅游产品
//        titleTopCategoryListDataSources = ["全部","机+酒","机票","机+专车","机+签证","酒+门票","酒+餐券","度假产品","旅游产品"]
        
        
        searchCondition.pageIndex = NSNumber.init(value: currentNetIndex)
        searchCondition.pageSize = NSNumber.init(value: 10)
        searchCondition.orderByKey = "sort"
        //searchCondition.region = "1"
        
        
        setUIViewAutolayout()
        
        //getSpecialProductList() // 二次调用数据
        tableViewDataSources = Array.init(repeating: [], count: titleTopCategoryListDataSources.count)
 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBackButton(backImage: "")
        //setTopCategoryListView(categoryDataSources: titleTopCategoryListDataSources)
        showSelectedCategory(selectedCategory: self.selectedCategoryIndex)
    }
    
    
    
    func setUIViewAutolayout() {
        setTitleView()
        setTopCategoryListView(categoryDataSources: titleTopCategoryListDataSources)
        setContentView()
        setTableView()
        
    }
    
    
    private func setTitleView() {
        titleCustomView.frame = CGRect(x:0,y:0,width:ScreenWindowWidth - 60,height:35)
        titleCustomView.addSubview(searchBarView)
        titleCustomView.layer.cornerRadius = 4
        titleCustomView.clipsToBounds = true
        searchBarView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        let baseBackgroundView:UIView = UIView.init(frame: CGRect(x:0,y:0,width:ScreenWindowWidth - 60,height:30))
        self.navigationItem.titleView = baseBackgroundView
        baseBackgroundView.addSubview(titleCustomView)
        titleCustomView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(5)
        }
        
        
        
        weak var  weakSelf = self
        searchBarView.searchBarViewBlock = { (keyWords) in
           print("controller",keyWords)
           weakSelf?.searchBarAction(keyWords: keyWords)
        }
        
        //self.navigationItem.titleView?.frame = CGRect(x:-20,y:0,width:ScreenWindowWidth - 60,height:35)
    }
    func setContentView() {
        contentBackgroundScrollView.showsHorizontalScrollIndicator = false
        contentBackgroundScrollView.showsVerticalScrollIndicator = false
        contentBackgroundScrollView.isPagingEnabled = true
        contentBackgroundScrollView.isScrollEnabled = true
        contentBackgroundScrollView.bounces = false
        contentBackgroundScrollView.delegate = self
        self.view.addSubview(contentBackgroundScrollView)
        contentBackgroundScrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(categoryHeight)
            make.left.bottom.right.equalToSuperview()
        }
    }
    func setTableView() {
        leftTableView.delegate = self
        leftTableView.dataSource = self
        leftTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        leftTableView.frame = CGRect(x:ScreenWindowWidth * 0,y:0,width:ScreenWindowWidth,height:ScreentWindowHeight - 64 - categoryHeight)
        leftTableView.register(SpecialListTableViewCell.classForCoder(), forCellReuseIdentifier:leftTableViewCellIdentify)
        contentBackgroundScrollView.addSubview(leftTableView)
        
        midTableView.delegate = self
        midTableView.dataSource = self
        midTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        midTableView.frame = CGRect(x:ScreenWindowWidth * 1,y:0,width:ScreenWindowWidth,height:ScreentWindowHeight - 64 - categoryHeight)
        midTableView.register(SpecialListTableViewCell.classForCoder(), forCellReuseIdentifier:midTableViewCellIdentify)
        midTableView.register(UINib(nibName: "TableNoDateView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableNoDateView")
        contentBackgroundScrollView.addSubview(midTableView)
        midTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction:#selector(midTableViewRefreshAction))
        midTableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(midTableViewGetMoreAction))
        
        rightTableView.delegate = self
        rightTableView.dataSource = self
        rightTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        rightTableView.frame = CGRect(x:ScreenWindowWidth * 2,y:0,width:ScreenWindowWidth,height:ScreentWindowHeight - 64 - categoryHeight)
        rightTableView.register(SpecialListTableViewCell.classForCoder(), forCellReuseIdentifier:rightTableViewCellIdentify)
        contentBackgroundScrollView.addSubview(rightTableView)
        contentBackgroundScrollView.contentSize = CGSize.init(width: ScreenWindowWidth * 3, height: 0)//ScreentWindowHeight - 64 - categoryHeight

        
    }
    
    
    
    
    
    private func setTopCategoryListView(categoryDataSources:[SpecialProductCategoryModel]) {
        titleTopCategoryListBackgroundScrollView.bounces = false
        titleTopCategoryListBackgroundScrollView.showsHorizontalScrollIndicator = false
        titleTopCategoryListBackgroundScrollView.frame = CGRect(x:0,y:0,width:ScreenWindowWidth,height:32)
        self.view.addSubview(titleTopCategoryListBackgroundScrollView)
        titleTopCategoryViewScrollIndicator.backgroundColor = TBIThemeBlueColor
        titleTopCategoryViewScrollIndicator.frame = CGRect(x:categorySpace,y:categoryHeight - 1,width:categoryWidth,height:1)
        titleTopCategoryListBackgroundScrollView.addSubview(titleTopCategoryViewScrollIndicator)
        
        
        
        for (index,value) in categoryDataSources.enumerated() {
            let buttonWidth =  getTextWidth(textStr: value.productType, font: UIFont.systemFont( ofSize: 14), height: categoryHeight - 1)
            let button = UIButton()
            button.tag = index + 1
            button.setTitle(value.productType, for: UIControlState.normal)
            button.titleLabel?.font = UIFont.systemFont( ofSize: 14)
            button.setTitleColor(TBIThemePrimaryTextColor, for: UIControlState.normal)
            button.setTitleColor(TBIThemeBlueColor, for: UIControlState.selected)
            button.addTarget(self, action: #selector(categoryButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            if index == 0 {
                button.isSelected = true
                selectedCategoryButtonIndexButton = button
                
            }
            var currentButtonWidth:CGFloat = categoryWidth
            if currentButtonWidth >= buttonWidth + 2 * categorySpace {
                allButtonWidth += currentButtonWidth
            }else
            {
                currentButtonWidth = buttonWidth + 2 * categorySpace
                allButtonWidth += currentButtonWidth
            }
            
            
            
            let buttonFrame:CGRect = CGRect(x: categorySpace * ( CGFloat( index + 1 ))  + allButtonWidth - currentButtonWidth , y:0,width:currentButtonWidth,height:categoryHeight - 1)
            button.frame = buttonFrame
            titleTopCategoryListBackgroundScrollView.addSubview(button)
            titleTopCategoryList.append((index: button.tag, localFrame: button.frame))
            if index == 0 {
                titleTopCategoryViewScrollIndicator.frame = CGRect(x:categorySpace,y:categoryHeight - 1,width:currentButtonWidth,height:1)
            }
        }
        
        
        let contenWidth:CGFloat = categorySpace * ( CGFloat(categoryDataSources.count + 1)) + allButtonWidth
        titleTopCategoryListBackgroundScrollView.contentSize = CGSize.init(width: contenWidth, height: categoryHeight)
        
        
    }
    //MARK:-----展示制定分类
    private func showSelectedCategory(selectedCategory:SpecialProductCategory) {
       
        if tableViewDataSources.count > 1 {
            tableViewDataSources.removeAll()
            tableViewDataSources = Array.init(repeating: [], count: titleTopCategoryListDataSources.count)
        }
        
        self.selectedCategoryIndex = selectedCategory
        for ( index, element)in titleTopCategoryListDataSources.enumerated()
        {
            if selectedCategory == SpecialProductCategory.init(rawValue: element.id!) {
                let selectedCategoryButton:UIButton = self.titleTopCategoryListBackgroundScrollView.viewWithTag(index + 1) as! UIButton
                categoryButtonAction(sender: selectedCategoryButton)
                
                return
            }
            
        }
        let selectedCategoryDefault:UIButton = self.titleTopCategoryListBackgroundScrollView.viewWithTag(1) as! UIButton
        categoryButtonAction(sender: selectedCategoryDefault)
        
        
    }
    
    
    
    
    func getTextWidth(textStr:String?,font:UIFont,height:CGFloat) -> CGFloat {
        
        if textStr?.characters.count == 0 || textStr == nil {
            return 0.0
        }
        let normalText: NSString = textStr! as NSString
        let size = CGSize(width:10000,height:height)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        return stringSize.width
    }
    //简单X轴平移动画 更正
    func basicAnimate(toFrame:CGRect) {
        UIView.animate(withDuration: 1) { () -> Void in
            self.titleTopCategoryViewScrollIndicator.frame.origin.x = toFrame.origin.x
            self.titleTopCategoryViewScrollIndicator.frame.origin.y = toFrame.origin.y + toFrame.size.height
            self.titleTopCategoryViewScrollIndicator.frame.size.width = toFrame.size.width
        }
    }
    
    //当前刷新数据
    func midTableViewRefreshAction() {
        print("refresh data ")
        weak var weakSelf = self
        currentNetIndex = 1
        searchCondition.pageIndex = currentNetIndex as NSNumber
        print("before ",self.currentIndex)
        showLoadingView()
        SpecialProductService.sharedInstance
            .getList(form: searchCondition.mj_keyValues() as! Dictionary<String, Any>)
            .subscribe{ result in
                weakSelf?.hideLoadingView()
                weakSelf?.midTableView.mj_header.endRefreshing()
                if case .next(let result) = result {
                    print(result)
                    if (weakSelf?.tableViewDataSources[(weakSelf?.currentIndex)!].count)! > 0
                    {
                        weakSelf?.tableViewDataSources[(weakSelf?.currentIndex)!].removeAll()
                    }
                    weakSelf?.tableViewDataSources[(weakSelf?.currentIndex)!].append(contentsOf: result)
                    weakSelf?.leftTableView.reloadData()
                    weakSelf?.midTableView.reloadData()
                    weakSelf?.rightTableView.reloadData()
                    weakSelf?.caculateShowTime(current: (weakSelf?.currentIndex)!)
                    print("into network",weakSelf?.currentIndex)
                    
                }
                if case .error(let e) = result {
                    print(e)
                    weakSelf?.showSystemAlertView(titleStr: "失败", message: "获取数据失败")
                }
            }.disposed(by: bag)

        
        
        
        
        
    }
    //当前加载更多
    func midTableViewGetMoreAction() {
        print("get more data  ")
        weak var weakSelf = self
        currentNetIndex += 1
        searchCondition.pageIndex = currentNetIndex as NSNumber
        print("before ",self.currentIndex)
        showLoadingView()
        SpecialProductService.sharedInstance
            .getList(form: searchCondition.mj_keyValues() as! Dictionary<String, Any>)
            .subscribe{ result in
                weakSelf?.hideLoadingView()
                weakSelf?.midTableView.mj_footer.endRefreshing()
                if case .next(let result) = result {
                    print(result)
                    weakSelf?.tableViewDataSources[(weakSelf?.currentIndex)!].append(contentsOf: result)
                    weakSelf?.leftTableView.reloadData()
                    weakSelf?.midTableView.reloadData()
                    weakSelf?.rightTableView.reloadData()
                    weakSelf?.caculateShowTime(current: (weakSelf?.currentIndex)!)
                    print("into network",weakSelf?.currentIndex)
                    
                    
                }
                if case .error(let e) = result {
                    print(e)
                    weakSelf?.showSystemAlertView(titleStr: "失败", message: "获取数据失败")
                }
            }.disposed(by: bag)
    }
    
    func searchBarAction(keyWords:String) {
        searchCondition.searchKey = keyWords
        getSpecialProductList()
        
    }
    
    func clearLocalDataSources() {
        searchCondition.searchKey = ""
    }
    
    
    
    //MARK:---获得数据
    func getSpecialProductList()  {
        
        //print("before ",self.currentIndex,"type",searchCondition.productType,"title",titleTopCategoryListDataSources[currentIndex].productType)
        weak var weakSelf = self
        showLoadingView()
        SpecialProductService.sharedInstance
                        .getList(form: searchCondition.mj_keyValues() as! Dictionary<String, Any>)
                        .subscribe{ result in
                                weakSelf?.hideLoadingView()
                                if case .next(let result) = result {
                                    //print(result)
                                    if (weakSelf?.tableViewDataSources[(weakSelf?.currentIndex)!].count)! > 0
                                    {
                                        weakSelf?.tableViewDataSources[(weakSelf?.currentIndex)!].removeAll()
                                    }
                                    weakSelf?.tableViewDataSources[(weakSelf?.currentIndex)!].append(contentsOf: result)
                                    weakSelf?.leftTableView.reloadData()
                                    weakSelf?.midTableView.reloadData()
                                    weakSelf?.rightTableView.reloadData()
                                    weakSelf?.caculateShowTime(current: (weakSelf?.currentIndex)!)
                                    //print("into network",weakSelf?.currentIndex)
    
                                }
                                if case .error(let e) = result {
                                    print(e)
                                    weakSelf?.showSystemAlertView(titleStr: "失败", message: "获取数据失败")
                                }
                            }.disposed(by: bag)
        
    }
    
    //MARK:---- UIScrollViewDelegate
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      if scrollView.contentOffset.y == 0
      {
            let currentIndexTagForButton:NSInteger = currentIndex + 1
            let currentButton:UIButton = self.titleTopCategoryListBackgroundScrollView.viewWithTag(currentIndexTagForButton) as! UIButton
            var nextButton:UIButton = UIButton()
            var offset:CGFloat = scrollView.contentOffset.x
            if scrollView.contentOffset.x > ScreenWindowWidth {
                offset = offset - ScreenWindowWidth
                //print("左滑","offset",offset)
                if currentIndex != self.titleTopCategoryListDataSources.count - 1 {
                    nextButton = self.titleTopCategoryListBackgroundScrollView.viewWithTag(currentIndexTagForButton + 1) as! UIButton
                }
            }else
            {
                //print("右滑","offset",offset)
                if currentIndex != 0 && offset < ScreenWindowWidth && offset != 0 {
                   nextButton = self.titleTopCategoryListBackgroundScrollView.viewWithTag(currentIndexTagForButton - 1) as! UIButton
                }
            }
            //第一次
            if nextButton.frame.origin.x == 0 {
                return
            }
            let frame = self.titleTopCategoryViewScrollIndicator.frame
            var pointX = frame.origin.x
            //滑动比例
            let indexScale = offset / ScreenWindowWidth
            // 修改wayLength  左滑  右滑 分开 
            var wayLengthNew:CGFloat = 0
            if nextButton.frame.origin.x > currentButton.frame.origin.x {
                wayLengthNew = nextButton.frame.origin.x - currentButton.frame.origin.x - currentButton.frame.size.width
                if indexScale < scaleScrollIndicator {
                    pointX = pointX - (indexScale - scaleScrollIndicator ) * wayLengthNew
                }else
                {
                    pointX = pointX + (indexScale - scaleScrollIndicator ) * wayLengthNew
                }
            }
            else
            {
                wayLengthNew = currentButton.frame.origin.x - nextButton.frame.origin.x - nextButton.frame.size.width
                if indexScale < scaleScrollIndicator {
                    pointX = pointX + (indexScale - scaleScrollIndicator ) * wayLengthNew
                }else
                {
                    pointX = pointX - (indexScale - scaleScrollIndicator ) * wayLengthNew
                }
            }
            scaleScrollIndicator = indexScale
            self.titleTopCategoryViewScrollIndicator.frame = CGRect.init(x: pointX , y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let point:CGPoint = scrollView.contentOffset
            if scrollView == contentBackgroundScrollView {
                currentNetIndex = 1
                searchCondition.pageIndex = currentNetIndex as NSNumber
                // judge critical value，first and third imageView's contentoffset
                let criticalValue:CGFloat = 2.0
                if (point.x > 2 * scrollView.bounds.width - criticalValue) {
                    currentIndex = (currentIndex + 1) % tableViewDataSources.count;
                } else if (point.x < criticalValue) {
                    currentIndex = (currentIndex + tableViewDataSources.count - 1) % tableViewDataSources.count
                }
                let button:UIButton = self.titleTopCategoryListBackgroundScrollView.viewWithTag(currentIndex + 1) as! UIButton
                categoryButtonAction(sender: button)
            }
    }
    
    
    func catoryAndContentAccord(){
        titleTopCategoryListBackgroundScrollView.scrollRectToVisible(titleTopCategoryViewScrollIndicator.frame, animated: true)
    }
    
    
    
    
    //
    func caculateShowTime(current:NSInteger) {
        if current >= 0
        {
            currentIndex = current
            let categoryCount:NSInteger = tableViewDataSources.count
            leftIndex = (current + categoryCount - 1)%categoryCount
            rightIndex = (current + 1)%categoryCount
            leftTableView.reloadData()
            midTableView.reloadData()
            rightTableView.reloadData()
            setContentViewOffsetView()
        }
    }
    
    
    func setContentViewOffsetView() {
        contentBackgroundScrollView.contentOffset = CGPoint.init(x: ScreenWindowWidth, y: 0)
    }
    
//    
//    - (void)setScrollViewContentOffsetCenter {
//    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0);
//    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tableViewDataSources.count > leftIndex && tableViewDataSources.count > currentIndex && tableViewDataSources.count > rightIndex else {
            return 0
        }
        switch tableView {
        case leftTableView:
            return tableViewDataSources[leftIndex].count
        case midTableView:
            return tableViewDataSources[currentIndex].count
        case rightTableView:
            return tableViewDataSources[rightIndex].count
        default:
            return 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case leftTableView:
            
            return configLeftTableView(indexPath: indexPath)
            
            
        case midTableView:
            return configCurrentTableView(indexPath: indexPath)
        case rightTableView:
            return configRightTableView(indexPath: indexPath)
            
        default:
            break
        }
        
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier:"placeHolder")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "placeHolder")
            
        }
        
        
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected ",indexPath)
        let vc = SpecialDetailViewController()
        vc.productId = tableViewDataSources[currentIndex][indexPath.row].productId
        vc.travelItem = tableViewDataSources[currentIndex][indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let orders:[TravelListItem] =  self.tableViewDataSources[currentIndex] {
            if orders.count == 0 {
                return tableView.frame.height
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableNoDateView") as? TableNoDateView {
            footer.setType(.noData)
            return footer
        }
        return nil
    }
    
    
    
    
    func  configLeftTableView(indexPath:IndexPath) -> SpecialListTableViewCell {
        
        let cell:SpecialListTableViewCell = leftTableView.dequeueReusableCell(withIdentifier: leftTableViewCellIdentify) as! SpecialListTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.fillCell(model: tableViewDataSources[leftIndex][indexPath.row])
        return cell
        
        
        
    }
    func  configCurrentTableView(indexPath:IndexPath) -> SpecialListTableViewCell {
        let cell:SpecialListTableViewCell = midTableView.dequeueReusableCell(withIdentifier: midTableViewCellIdentify) as! SpecialListTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.fillCell(model: tableViewDataSources[currentIndex][indexPath.row])
        return cell
    }
    func  configRightTableView(indexPath:IndexPath) -> SpecialListTableViewCell {
        let cell:SpecialListTableViewCell = rightTableView.dequeueReusableCell(withIdentifier: rightTableViewCellIdentify) as! SpecialListTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.fillCell(model: tableViewDataSources[rightIndex][indexPath.row])
        return cell
    }
    
    
    
    
    //MARK:----Action
    
    //MARK:----分类标签事件
    func categoryButtonAction(sender:UIButton) {
        print(sender.tag)
        selectedCategoryButtonIndexButton.isSelected = false
        selectedCategoryButtonIndexButton = sender
        selectedCategoryButtonIndexButton.isSelected = true
        let targetFrame =  titleTopCategoryList[sender.tag - 1].localFrame
        caculateShowTime(current: sender.tag - 1)
        basicAnimate(toFrame: targetFrame)
        catoryAndContentAccord()
        searchCondition.productType =   titleTopCategoryListDataSources[currentIndex].id //currentIndex.description
        if currentIndex == 0 {
            searchCondition.productType = ""
        }
        
        getSpecialProductList()
    }
    
    
    
    
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
