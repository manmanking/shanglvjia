//
//  PersonalTravelViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/25.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import MJRefresh

class PersonalTravelViewController: PersonalBaseViewController,UITableViewDelegate,UITableViewDataSource{

    ///数据源
    fileprivate var travelList:[PTravelProductListResponse.BaseTravelProductListVo] = Array()
    fileprivate var page : Int = 1
    fileprivate var type : String = "2"
    
    private var travelTable = UITableView()
    
    /// 广告头 44 - kNavigationHeight  //140 + 45 + kNavigationHeight - 44
    private lazy var cycleScrollView: SDCycleScrollView = {
        let headerView = SDCycleScrollView()
        headerView.frame = CGRect(x: 0, y:0 , width: Int(ScreenWindowWidth), height:180)
        headerView.imageURLStringsGroup = ["\(Html_Base_Url)/static/banner/subpage/visa/ios/banner_visa@3x.png"]
        return headerView
    }()
    
    
    //标题和内容
    var pageTitleView:SGPageTitleView?
    var pageContentView:SGPageContentView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeWhite
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        setUIViewAutolayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNavigation(title:"",bgColor:TBIThemeBlueColor,alpha:0,isTranslucent:true)
        setNavigationBackButton(backImage: "BackCircle")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func initTableView() {
        ///kNavigationHeight-45-(140 + kNavigationHeight - 44)
        travelTable.dataSource=self
        travelTable.delegate=self
        travelTable.separatorStyle=UITableViewCellSeparatorStyle.none
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        travelTable.estimatedRowHeight = 210
        travelTable.rowHeight = UITableViewAutomaticDimension
        travelTable.register(PTravelListCell.self, forCellReuseIdentifier: "PTravelListCell")
        travelTable.register(UINib(nibName: "TableNoDateView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableNoDateView")
        self.view.addSubview(travelTable)
        travelTable.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo((pageTitleView?.snp.bottom)!)
        }
        //监听下拉刷新 上啦加载
        travelTable.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(PersonalTravelViewController.initData))
        travelTable.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(PersonalTravelViewController.loadMoreData))
        travelTable.mj_header.beginRefreshing()
        
    }
    
    func initData(){
        page = 1
        getPersonalTravelListFromNET(type:type)
    }
    func loadMoreData(){
        page  = page + 1
        getPersonalTravelListFromNET(type:type)
    }


    //MARK:- 定制视图
    func setUIViewAutolayout() {
        self.view.addSubview(cycleScrollView)
//        cycleScrollView.snp.makeConstraints { (make) in
//            make.top.left.right.equalToSuperview()
//            make.height.equalTo(140 + kNavigationHeight - 44)
//        }
//        cycleScrollView.imageURLStringsGroup = ["http://60.28.158.166:10081/static/banner/subpage/visa/ios/banner_visa@3x.png"]
//        //cycleScrollView.placeholderImage = ""
        let titleArr=["自由行","周边玩乐"]
        let configuration = SGPageTitleViewConfigure()
        configuration.titleColor=UIColor.gray
        configuration.titleFont=UIFont.systemFont(ofSize: 14)
        configuration.titleSelectedColor=PersonalThemeMajorTextColor
        configuration.indicatorColor=PersonalThemeDarkColor
        configuration.titleSelectedFont=UIFont.boldSystemFont(ofSize: 15)
        configuration.indicatorHeight = 2;
        configuration.bottomSeparatorColor=TBIThemeGrayLineColor
        //标题视图
        self.pageTitleView=SGPageTitleView(frame:CGRect(x:0,y:Int(cycleScrollView.frame.origin.y+cycleScrollView.frame.size.height),width:Int(ScreenWindowWidth),height:45),delegate:self,titleNames:titleArr,configure:configuration)
        self.pageTitleView?.selectedIndex=0
        self.pageTitleView?.backgroundColor=TBIThemeWhite
        
        
        // 内容视图
        self.pageContentView = SGPageContentView(frame: CGRect(x: 0, y: Int((self.pageTitleView?.frame.origin.y)!)+Int((self.pageTitleView?.frame.size.height)!), width:Int(ScreenWindowWidth), height: Int(ScreentWindowHeight) - 141), parentVC: self, childVCs: self.childViewControllers)

        //self.pageContentView!.delegatePageContentView = self
       // self.view.addSubview(self.pageContentView!)
        self.view.addSubview(self.pageTitleView!)
//        pageTitleView?.snp.makeConstraints({ (make) in
//            make.left.bottom.right.equalToSuperview()
//            make.top.equalTo(cycleScrollView.snp.bottom)
//
//        })
        initTableView()
    }
    
    //MARK:------UITableViewDataSource-----
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return travelList.count
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if travelList.count == 0  {
            return tableView.frame.height
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if travelList.count == 0 {
            if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableNoDateView") as? TableNoDateView {
                footer.setType(.noPersonal)
                footer.messageLabel.text="当前条件下暂未查询到产品"
                return footer
            }
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PTravelListCell  = tableView.dequeueReusableCell(withIdentifier: "PTravelListCell") as! PTravelListCell
        cell.fillDataSources(model: travelList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = PTravelDetailViewController()
        detailView.idStr = travelList[indexPath.row].id
        detailView.typeStr = type
        detailView.productName = travelList[indexPath.row].name
        detailView.productPrice = travelList[indexPath.row].minPrice
        self.navigationController?.pushViewController(detailView, animated: true)
        
    }
    
  
    //MARK:--------Action-------
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:------NET-------
    func getPersonalTravelListFromNET(type:String) {
        if page != 1{
            showLoadingView()
        }        
        let request = PTravelProductListRequest()
        request.num = page.description
        request.size = "10"
        request.type = type
        weak var weakSelf = self
        PersonalTravelServices.sharedInstance
            .personalTravelList(request: request)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                weakSelf?.travelTable.mj_header.endRefreshing()
                switch event {
                case .next(let result):
                    printDebugLog(message: result.mj_keyValues())
                    if result.list.count <= 10 {
                        weakSelf?.travelTable.mj_footer.endRefreshingWithNoMoreData()
                    }else {
                        weakSelf?.travelTable.mj_footer.endRefreshing()
                    }
                    if weakSelf?.page == 1 {
                        weakSelf?.travelList.removeAll()
                    }
                    weakSelf?.travelList.append(contentsOf: result.list)
                    weakSelf?.travelTable.reloadData()
                case .error(let error):
                    weakSelf?.travelTable.mj_header.endRefreshing()
                    weakSelf?.hideLoadingView()
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
        }
        
        
    }
    
    
}
////MARK: - SGPageTitleViewDelegate
extension PersonalTravelViewController: SGPageTitleViewDelegate, SGPageContentViewDelegate {
    /// 联动 pageContent 的方法
    func pageTitleView(_ pageTitleView: SGPageTitleView!, selectedIndex: Int) {
        printDebugLog(message: selectedIndex)
        page = 1
        type = selectedIndex == 0 ? "2" : "0"
        getPersonalTravelListFromNET(type:type)
      
    }
    /// 联动 SGPageTitleView 的方法
    func pageContentView(_ pageContentView: SGPageContentView!, progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        self.pageTitleView!.setPageTitleViewWithProgress(progress, originalIndex: originalIndex, targetIndex: targetIndex)
    }
}
