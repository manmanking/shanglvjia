//
//  TravelLocalCityViewController.swift
//  shop
//
//  Created by TBI on 2017/7/15.
//  Copyright © 2017年 TBI. All rights reserved.
//
import UIKit
import RxSwift

class TravelLocalCityViewController: CompanyBaseViewController {

    fileprivate let bag = DisposeBag()
    
    fileprivate let bgImg = UIImageView.init(imageName: "bg_local_destination")
    
    fileprivate var collectionView:UICollectionView?
    
    fileprivate let travelLocalCityCollectionReusableViewIdentify = "travelLocalCityCollectionReusableViewIdentify"
    
    fileprivate let travelLocalCityCollectionViewCellIdentify = "travelLocalCityCollectionViewCellIdentify"
    
    fileprivate var data:[LocalCitys]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation(title:"当地参团游")
        self.view.addSubview(bgImg)
        bgImg.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
        initCollectionView()
        initData ()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    

}
extension TravelLocalCityViewController{
    //初始化数据
    func initData () {
        
        let cityModel = DestinationsModel(type: "10", departure: cityName, destId: "", keyWord: "")
        showLoadingView()
        CitsService.sharedInstance.getLocalDestinations(form: cityModel).subscribe{ event in
            self.hideLoadingView()
            if case .next(let e) = event {
                self.data = e
                self.collectionView?.reloadData()
            }
            if case .error(let e) = event {
                try? self.validateHttp(e)
            }
        }.disposed(by: bag)
    }
}
extension TravelLocalCityViewController:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func initCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        
        //设置cell的大小
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.indicatorStyle = .white
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.register(TravelLocalCityCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: travelLocalCityCollectionViewCellIdentify)
        
        collectionView?.register(TravelLocalCityCollectionReusableView.classForCoder(), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: travelLocalCityCollectionReusableViewIdentify)
        self.view.addSubview(collectionView!)
        collectionView?.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.data?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.data?.filter{$0.name == "国际"}.first?.citys.count ?? 0
        }else if section == 1 {
            return self.data?.filter{$0.name == "国内"}.first?.citys.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: travelLocalCityCollectionViewCellIdentify, for: indexPath) as! TravelLocalCityCollectionViewCell
        if indexPath.section == 0 {
            let city = self.data?.filter{$0.name == "国际"}.first?.citys
            cell.fillCell(name: city?[indexPath.row].start_place ?? "")
        }else if indexPath.section == 1 {
            let city = self.data?.filter{$0.name == "国内"}.first?.citys
            cell.fillCell(name: city?[indexPath.row].start_place ?? "")
        }
        return cell
        
    }
    
    //返回HeadView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: travelLocalCityCollectionReusableViewIdentify, for: indexPath) as! TravelLocalCityCollectionReusableView
        if indexPath.section == 0 {
            let city = self.data?.filter{$0.name == "国际"}.first?.name
            cell.fillCell(name: city ?? "")
        }else if indexPath.section == 1 {
            let city = self.data?.filter{$0.name == "国内"}.first?.name
            cell.fillCell(name: city ?? "")
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 35)
        
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ScreenWindowWidth - 70 - 30
        let cellSize = width/3
        return CGSize.init(width: cellSize, height: 36)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize.init(width: ScreenWindowWidth, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TravelLocalListViewController()
        if indexPath.section == 0  {
            vc.citys = self.data?.filter{$0.name == "国际"}.first?.citys ?? []
            vc.city = self.data?.filter{$0.name == "国际"}.first?.citys[indexPath.row]
            vc.region = 2
        }else {
            vc.citys = self.data?.filter{$0.name == "国内"}.first?.citys ?? []
            vc.city = self.data?.filter{$0.name == "国内"}.first?.citys[indexPath.row]
            //vc.citys = self.data?[indexPath.section].citys ?? []
            //c.city =  self.data?[indexPath.section].citys[indexPath.row]
            vc.region = 1
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
