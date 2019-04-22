//
//  CoCarAddressViewController.swift
//  shop
//
//  Created by TBI on 2018/1/24.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class CoCarAddressViewController: CompanyBaseViewController {

    var coCarClickListener:CoCarClickListener!
    
    var row:Int = 0
    
    fileprivate let tableView = UITableView()
    
    fileprivate let searchBar:TBISearchBar = TBISearchBar()
    
    fileprivate let coCarAddressTableViewCelldentify = "coCarAddressTableViewCelldentify"
    
    /// POI搜索
    fileprivate let amapSearch:AMapSearchAPI = AMapSearchAPI()
    
    fileprivate var addressList:[CoPointAddressModel] = []
    
    fileprivate var KeywordsRequest:AMapPOIKeywordsSearchRequest = AMapPOIKeywordsSearchRequest()
    
    var city:String = ""
    
    var latitude:String = ""
    
    var longitude:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        initNavigation(title:"",bgColor:TBIThemeDarkBlueColor,alpha:1,isTranslucent:false)
        
        
        initTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        setWhiteTitleAndNavigationColor(title:"")
        initSearchBar()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
extension CoCarAddressViewController: UISearchBarDelegate,AMapSearchDelegate{
    
    func initSearchBar (){
        amapSearch.delegate = self
        searchBar.placeholder = "请输入出发地/目的地"
        searchBar.frame = CGRect(x:200,y:0,width:ScreenWindowWidth - 40,height:32)
        if #available(iOS 11.0, *) {
            searchBar.contentInset = UIEdgeInsets.init(top: 6, left:40, bottom: 6, right:20)
        }else
        {
            searchBar.contentInset = UIEdgeInsets.init(top: 6, left:0, bottom: 6, right:20)
        }
        
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        searchBar.tintColor = UIColor.blue
        self.navigationItem.titleView = searchBar
        
    
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
            if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
                if let backgroundview = textfield.subviews.first {
                    backgroundview.backgroundColor = UIColor.white
                    backgroundview.layer.cornerRadius = 5;
                    backgroundview.clipsToBounds = true;
                    
                }
            }
            
        }
    }
    
    
    //MARK:----------AMapSearchDelegate-----------
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        
    }
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        addressList.removeAll()
        guard KeywordsRequest == request else {
            return
        }
        for  element in response.pois {
            let mylocal:CoPointAddressModel = CoPointAddressModel.localPOI(poi: element, city: "")
            if mylocal.uid.isEmpty == false {
                self.addressList.append(mylocal)
                
            }
        }
        tableView.reloadData()
    }
    
    func onInputTipsSearchDone(_ request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {
    
        for  element in response.tips {
            let mylocal:CoPointAddressModel = CoPointAddressModel.localTip(tip: element, city: "")
            if mylocal.uid.isEmpty == false {
                self.addressList.append(mylocal)

            }
            
        }
        tableView.reloadData()
    }
    
    
    func requestMapPoi(keyword:String) {
        let request:AMapPOIKeywordsSearchRequest = AMapPOIKeywordsSearchRequest()
        request.requireExtension = true
        request.offset = 20
        request.keywords = keyword
        
        //request.location = AMapGeoPoint.location(withLatitude: CGFloat.init(self.latitude), longitude: CGFloat.init(self.longitude))
        if self.city.isNotEmpty {
            request.city  = self.city
        }else {
            request.cityLimit = true
        }
        amapSearch.aMapPOIKeywordsSearch(request)
        KeywordsRequest = request
        
//        let re = AMapInputTipsSearchRequest()
//        re.keywords = keyword
//        amapSearch.aMapInputTipsSearch(re)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        requestMapPoi(keyword:searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
}
extension CoCarAddressViewController: UITableViewDelegate,UITableViewDataSource {
    
    
    func initTableView () {
        self.view.backgroundColor = TBIThemeBaseColor
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        //tableView.isScrollEnabled = false
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.top.right.equalToSuperview()
        }
        tableView.register(CoCarAddressTableViewCell.self, forCellReuseIdentifier: coCarAddressTableViewCelldentify)
    }

    
    //MARK:- UITableViewDataSources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressList.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: coCarAddressTableViewCelldentify) as! CoCarAddressTableViewCell
        cell.selectionStyle = .none
        if addressList.count > indexPath.row {
            cell.fullCell(title:addressList[indexPath.row].name, message:addressList[indexPath.row].address)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if addressList.count > indexPath.row {
            coCarClickListener.onAddressClickListener(model: addressList[indexPath.row], row: self.row)
            _ = self.navigationController?.popViewController(animated: true)
        }
       
    }
}

