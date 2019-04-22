//
//  WellcomeViewController.swift
//  shop
//
//  Created by manman on 2017/6/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class WellcomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    typealias WellcomeViewControllerSelectedResult = (Bool)->Void
    
    public var wellcomeViewControllerSelectedResult:WellcomeViewControllerSelectedResult!
    private var dataSources:[String] = Array()
    private var collectionView:UICollectionView!
    private var wellComeShow:Bool = true
    private let collectionViewCellIdentify = "collectionViewCellIdentify"
    private let choiceRoleView:UIView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSources = ["wellcomeViewFirst_V3","wellcomeViewSecond_V3","wellcomeViewThird_V3"]
        setUIViewAutolayout()
        setRoleView()
//        if UserDefaults.standard.object(forKey: firstTime) != nil {
//            verifyUserRoleView()
//        }
       
    }
    
    private func setUIViewAutolayout()
    {
        let collectionFllow = UICollectionViewFlowLayout()
        collectionView = UICollectionView.init(frame: self.view.frame, collectionViewLayout: collectionFllow)
        collectionFllow.itemSize = ScreenWindowFrame.size
        collectionFllow.minimumLineSpacing = 0
        collectionFllow.scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionFllow.minimumInteritemSpacing = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: collectionViewCellIdentify)
        self.view.addSubview(collectionView)
  
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSources.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentify, for: indexPath)
        let imageView = UIImageView.init(image: UIImage.init(named: dataSources[indexPath.row]))
        cell.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if dataSources.count > 1 && dataSources.count - 1 == indexPath.row {
            //verifyUserRoleView()
            wellcomeViewControllerSelectedResult(true)
        }
    }
    
    
    func setRoleView() {
        self.view.addSubview(choiceRoleView)
        choiceRoleView.backgroundColor = UIColor.white
        choiceRoleView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        let roleImageBackgroundView = UIImageView()
        roleImageBackgroundView.image = UIImage.init(named: "choiceRoleViewBackground")
        choiceRoleView.addSubview(roleImageBackgroundView)
        roleImageBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        let companyButton = UIButton()//564*508
        //companyButton.setTitle("企业", for: UIControlState.normal)
        companyButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        companyButton.setImage(UIImage.init(named: "choiceRoleViewCompany"), for: UIControlState.normal)
        companyButton.addTarget(self, action: #selector(companyButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        choiceRoleView.addSubview(companyButton)
        companyButton.snp.makeConstraints { (make) in
            make.top.equalTo((ScreentWindowHeight - 254 * 2 - 12)/2)
            make.centerX.equalToSuperview()
            make.width.equalTo(282)
            make.height.equalTo(254)
        }
        let regularButton = UIButton()
        //regularButton.setTitle("随便看看", for: UIControlState.normal)
        regularButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        regularButton.setImage(UIImage.init(named: "choiceRoleViewPerson"), for: UIControlState.normal)
        regularButton.addTarget(self, action: #selector(regularButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        choiceRoleView.addSubview(regularButton)
        regularButton.snp.makeConstraints { (make) in
            make.top.equalTo(companyButton.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(282)
            make.height.equalTo(254)
        }
        self.choiceRoleView.isHidden = true
    }
    
 
    //跳转到 企业登陆页面
    func companyButtonAction(sender:UIButton) {
        wellcomeViewControllerSelectedResult(true)
    }
    
    
    
    func regularButtonAction(sender:UIButton) {
        //直接跳转到首页
        wellcomeViewControllerSelectedResult(false)
    }
    
    
    func verifyUserRoleView() {
        
        guard UserDefaults.standard.object(forKey: TOKEN_KEY) != nil else {
            self.choiceRoleView.isHidden = false
            return
        }
        let isValid:String = UserDefaults.standard.object(forKey: TOKEN_KEY) as! String
        if isValid.isEmpty {
            //展示角色选择页面
            self.choiceRoleView.isHidden = false
            
        }else
        {
            //直接跳转到首页
            print(isValid)
            wellcomeViewControllerSelectedResult(false)
            
        }
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}






