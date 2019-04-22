//
//  VisaListViewController.swift
//  shop
//
//  Created by TBI on 2017/7/30.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class VisaListViewController:  PersonalBaseViewController{
    
    

    ///导航头
    private var topView:PersonalNavbarTopView = PersonalNavbarTopView()
    /// 广告头
    private lazy var cycleScrollView: UIImageView = {

        let headerView = UIImageView()
        headerView.frame = CGRect(x: 0, y: 0, width: Int(ScreenWindowWidth), height: 140 + kNavigationHeight - 44)
        return headerView
    }()
    private let bag = DisposeBag()
     var  visaTableView = UITableView()///上面的table
     var  visaListTableView = UITableView()///下面签证列表的table
    
    
    fileprivate var selectedContinentAndCountryDefaultMax:Int = 99
    
    /// 记录选择的国家
    fileprivate var selectedCountryIndex:Int = 0
    
    /// 记录选择的洲分类
    fileprivate var selectedContinentIndex:Int = 0
    
    fileprivate var visaProductResult:VisaProductListResponse = VisaProductListResponse()
    
    fileprivate var continentResultArr:[ContinentModel] = Array()
    
    fileprivate var visaRequest:VisaProductListRequest = VisaProductListRequest()
    
    fileprivate var VisaListCellIdentify:String = "VisaListCellIdentify"
    
    fileprivate var moreChoicesTipDefault:String = "更多"
    
    fileprivate var countryImage = UIImageView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeWhite
        setUIViewAutolayout()
        
        
        fillLocalDataSources()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
    }
    
    
    func fillLocalDataSources() {
        
        printDebugLog(message: DBManager.shareInstance.userDetailDraw()?.cusLoginInfo.token)
        
        // 模拟数据 一进来默认不搜索国家
        visaRequest.country = ""
        visaRequest.num = "1"
        visaRequest.hotVisa = "1"
        visaRequest.size = "10"
        visaRequest.visaName = ""
        selectedContinentIndex = 0
        selectedCountryIndex = 99
       // getVisaListFromNET(requestParameters: visaRequest, isFresh: true)
        getCountryListFromNET()
        
    }
    
    
    func initTopView() {
        topView.frame = CGRect(x:0,y:0,width:Int(ScreenWindowWidth),height:kNavigationHeight)
        topView.leftButton.setImage(UIImage(named:"ic_left_white"), for: UIControlState.normal)
        topView.leftButton.addTarget(self, action: #selector(leftButtonClick), for: UIControlEvents.touchUpInside)
        topView.creatSearchView()
        weak var weakSelf = self
        topView.personalNavbarTopViewSearchBlock = { (searchKeyword) in
            weakSelf?.searchKeyword(searchKeyword: searchKeyword)
            
        }
        self.view.addSubview(topView)
    }
    func leftButtonClick(){
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- 定制视图
    func setUIViewAutolayout() {
        
        if PersonalBannerManager.shareInstance.getPersonalVisaBannerList().isEmpty == false {
            let bannerUrl:URL = URL.init(string: PersonalBannerManager.shareInstance.getPersonalVisaBannerList().first ?? "\(BASE_URL)/static/banner/subpage/visa/ios/banner_visa@3x.png") as! URL
            cycleScrollView.sd_setImage(with:bannerUrl , placeholderImage: UIImage.init(named: "bg_default_travel"))
        }else {
            cycleScrollView.sd_setImage(with:URL.init(string: "\(BASE_URL)/static/banner/subpage/visa/ios/banner_visa@3x.png"))
        }
        
        visaTableView.delegate = self
        visaTableView.dataSource = self
        visaTableView.bounces = false
        visaTableView.backgroundColor = TBIThemeBaseColor
        visaTableView.separatorStyle = .none
        visaTableView.tableHeaderView =  cycleScrollView
        visaTableView.estimatedRowHeight = 50
        visaTableView.register(VisaCountryCell.self, forCellReuseIdentifier: "VisaCountryCell")
        //         visaTableView.register(VisaListCell.self, forCellReuseIdentifier: "VisaListCell")
        self.view.addSubview( visaTableView)
        
        visaListTableView.delegate = self
        visaListTableView.dataSource = self
        visaListTableView.backgroundColor = TBIThemeBaseColor
        visaListTableView.separatorStyle = .none
        visaListTableView.estimatedRowHeight = 50
        visaListTableView.showsVerticalScrollIndicator = false
        visaListTableView.register(VisaListCell.self, forCellReuseIdentifier: VisaListCellIdentify)
        visaListTableView.register(UINib(nibName: "TableNoDateView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableNoDateView")
        self.view.addSubview( visaListTableView)
        visaListTableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(visaTableView.snp.bottom)
        }
        initTopView()
        
    }
    func initHeaderView(){
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMoreCountryView() {
        weak var weakSelf = self
        let moreCountryView = PersonalVisaCountryViewController()
        moreCountryView.continentResultArr = continentResultArr
        moreCountryView.selectedContinrnCategoryIndex = selectedContinentIndex
        self.navigationController?.pushViewController(moreCountryView, animated: true)
        moreCountryView.personalVisaCountrySelectedBlock = { continentIndex,countryIndex in
            weakSelf?.selectedContinentIndex = continentIndex
            weakSelf?.selectedCountryIndex = countryIndex
            weakSelf?.visaRequest.country = weakSelf?.continentResultArr[continentIndex].data[countryIndex].countryCode ?? ""
            weakSelf?.visaRequest.visaName = ""
            weakSelf?.topView.fillDataSources(keyword: "")
            weakSelf?.visaTableView.reloadData()
            weakSelf?.getVisaListFromNET(requestParameters: (weakSelf?.visaRequest)!, isFresh:true)
        }
//        for element in continentResultArr[selectedContinentIndex].data {
//            if element.countryNameCn == selectedCountry {
//                if selectedContinentIndex != 0 {
//                    visaRequest.hotVisa = "0"
//                }
//
//            }
//        }
        
        
        
    }
    
    
    
    
    
    
    //MARK:-----NET------
    func getVisaListFromNET(requestParameters:VisaProductListRequest,isFresh:Bool) {
        weak var weakSelf = self
        //showLoadingView()
        VisaServices.sharedInstance
            .getVisaList(request: requestParameters)
            .subscribe { (event) in
                //weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    printDebugLog(message: element)
                    weakSelf?.visaProductResult = element
                    ///weakSelf?.countryImage.sd_setImage(with: URL.init(string: element.responses.first?.pic ?? ""))
                    weakSelf?.visaListTableView.reloadData()
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                    
                }
        }.addDisposableTo(self.bag)
    }
    
    
    func getCountryListFromNET() {
        weak var weakSelf = self
        //showLoadingView()
        VisaServices.sharedInstance
            .getCountryList()
            .subscribe { (event) in
                //weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    printDebugLog(message: element)
                    weakSelf?.continentResultArr = element
                    weakSelf?.visaTableView.reloadData()
                    weakSelf?.selectedContinent(selectedIndex: (weakSelf?.selectedContinentIndex)!)
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                    
                }
            }.addDisposableTo(self.bag)
    }
    
    
    //MARK:------ Action------
    
    /// 选择 洲
    func selectedContinent(selectedIndex:NSInteger) {
        selectedContinentIndex = selectedIndex
        selectedCountryIndex = 0
        visaTableView.reloadData()
        visaTableView.snp.remakeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(44-kNavigationHeight)
            make.height.equalTo((isIPhoneX ? 207 : 182) + kNavigationHeight + 40 * (returnCount(count:continentResultArr[selectedContinentIndex].data.count)))
        })
        visaListTableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(visaTableView.snp.bottom)
        }
        selectedCountry(selectedCountry: continentResultArr[selectedContinentIndex].data.first?.countryNameCn ?? "")
    }
    
    
    /// 选择城市
    func selectedCountry(selectedCountry:String) {
        guard selectedCountry != moreChoicesTipDefault else {
            showMoreCountryView()
            return
        }
        for element in continentResultArr[selectedContinentIndex].data {
            if element.countryNameCn == selectedCountry {
                if selectedContinentIndex != 0 {
                    visaRequest.hotVisa = "0"
                }
                visaRequest.country = element.countryCode
                visaRequest.visaName = ""
                topView.fillDataSources(keyword: "")
                getVisaListFromNET(requestParameters: visaRequest, isFresh:true)
            }
        }
        
    }
    
    
    
    /// 搜索关键字
    func searchKeyword(searchKeyword:String) {
        guard searchKeyword.isEmpty == false else {
            return
        }
        visaRequest.country = ""
        visaRequest.hotVisa = ""
        visaRequest.num = "1"
        visaRequest.size = "10"
        visaRequest.visaName = searchKeyword
        selectedCountryIndex = selectedContinentAndCountryDefaultMax
        getVisaListFromNET(requestParameters: visaRequest, isFresh: true)
        visaTableView.reloadData()
        
        
        
    }
    
    
    
    
    
    

}
extension VisaListViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == visaTableView{
            return nil
        }else{
            /*
            let headView:VisaSectionHeaderView = VisaSectionHeaderView()
            headView.titleLabel.text = "人气产品"
            headView.addSubview(countryImage)
            countryImage.layer.borderColor = PersonalThemeMinorTextColor.cgColor
            countryImage.layer.cornerRadius = 2.0
            countryImage.layer.borderWidth = 0.5
            countryImage.clipsToBounds = true
            countryImage.snp.makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().inset(15)
                make.width.equalTo(36)
                make.height.equalTo(24)
            })
            return headView*/
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView == visaTableView ? 0 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == visaTableView {
            return 1
        }else{
            return visaProductResult.responses.count
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == visaListTableView
        {
            if visaProductResult.responses.count == 0{
                return tableView.frame.height
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == visaListTableView
        {
            if (visaProductResult.responses.count ) == 0{
                if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableNoDateView") as? TableNoDateView {
                    footer.setType(.noPersonal)
                    footer.messageLabel.text="暂无符合条件的产品"
                    return footer
                }
            }
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == visaTableView{
//            if continentResultArr.count > selectedCountryIndex {
            if continentResultArr.count > 0 {
               return CGFloat(46 + 5 + 5 + 40  * ( returnCount(count:continentResultArr[selectedContinentIndex].data.count)))
            }
            return 46 + 5 + 5

//            }//+ 20
//            return 60
            
        }else{
            //return UITableViewAutomaticDimension
             return 100
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == visaTableView{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "VisaCountryCell",for: indexPath) as! VisaCountryCell
            if continentResultArr.count > 0 {
                cell.setCellWithData(contientArr: continentResultArr,currentContinentIndex:selectedContinentIndex,currentCountryIndex:  selectedCountryIndex)
                weak var weakSelf = self
                cell.tclickBlock = {(selectedIndex) in
                    weakSelf?.selectedContinent(selectedIndex: selectedIndex)
                }
                
                cell.visaCountryCellSelectedCountryBlock = { selectedCountry in
                    weakSelf?.selectedCountry(selectedCountry: selectedCountry)
                }
                
                
            }
           
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: VisaListCellIdentify,for: indexPath) as! VisaListCell
            if visaProductResult.responses.count > indexPath.row {
                cell.fillDataSources(model: visaProductResult.responses[indexPath.row])
            }
            if indexPath.row == visaProductResult.responses.count - 1{
                cell.bottomLine.isHidden = true
            }else{
                cell.bottomLine.isHidden = false
            }
            
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView != visaTableView {
            
            guard indexPath.row < visaProductResult.responses.count else{
                return
            }
            let visaDetailView:VisaDetailViewController = VisaDetailViewController()
            
            visaDetailView.visaItem = visaProductResult.responses[indexPath.row]
            self.navigationController?.pushViewController(visaDetailView, animated: true)
        }
    }
    func returnCount(count:Int) -> Int {
        return count > 4 ? 2 : 1
       // return count%4 == 0 ? 1 : 2//(1+(count/4))
    }
}
