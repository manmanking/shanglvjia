//
//  CoVipViewController.swift
//  shop
//
//  Created by TBI on 2018/2/2.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class CoVipViewController: CompanyBaseViewController {

    fileprivate let tableView = UITableView()
    
    fileprivate let coVipTableCellViewIdentify = "coVipTableCellViewIdentify"
    
    fileprivate let list:[(city:String,airport:String,flag:Bool)] = [(city:"北京",airport:"北京首都机场",flag:true),(city:"上海",airport:"上海浦东机场",flag:true),(city:"上海",airport:"上海虹桥机场",flag:true),(city:"广州",airport:"广州白云机场",flag:true),(city:"成都",airport:"成都双流机场",flag:true),(city:"杭州",airport:"杭州萧山机场",flag:true),(city:"长春",airport:"长春龙嘉机场",flag:true),(city:"天津",airport:"天津滨海机场",flag:true),(city:"阿克苏",airport:"阿克苏机场",flag:true),(city:"黄山",airport:"屯溪机场",flag:true),(city:"包头",airport:"包头机场",flag:true),(city:"巴彦淖尔",airport:"巴彦淖尔机场",flag:true),(city:"常州",airport:"奔牛机场",flag:true),(city:"呼和浩特",airport:"白塔国际机场",flag:true),(city:"大理",airport:"大理坝机场",flag:true),(city:"德宏",airport:"德宏芒市机场",flag:true),(city:"恩施",airport:"许家坪机场",flag:true),(city:"济南",airport:"遥墙国际机场",flag:true),(city:"昆明",airport:"长水国际机场",flag:true),(city:"丽江",airport:"三义国际机场",flag:true),(city:"腾冲",airport:"驼峰机场",flag:true),(city:"西双版纳",airport:"嘎洒机场",flag:true),(city:"大庆",airport:"萨尔图机场",flag:true),(city:"福州",airport:"长乐国际机场",flag:true),(city:"桂林",airport:"两江国际机场",flag:true),(city:"合肥",airport:"新桥国际机场",flag:true),(city:"临沂",airport:"临沂机场",flag:true),(city:"绵阳",airport:"绵阳南郊机场",flag:true),(city:"武夷山",airport:"武夷山机场",flag:true),(city:"榆林",airport:"榆阳机场",flag:true),(city:"唐山",airport:"三女河机场",flag:true),(city:"丹东",airport:"浪头机场",flag:true),(city:"南通",airport:"兴东机场",flag:true),(city:"泉州",airport:"晋江机场",flag:true),(city:"乌鲁木齐",airport:"地窝堡国际机场",flag:true),(city:"徐州",airport:"观音机场",flag:true),(city:"西宁",airport:"曹家堡机场",flag:true),(city:"九寨",airport:"黄龙机场",flag:true),(city:"珠海",airport:"三灶国际机场",flag:true),(city:"重庆",airport:"江北国际机场",flag:true),(city:"石家庄",airport:"正定国际机场",flag:true),(city:"海口",airport:"美兰国际机场",flag:true),(city:"三亚",airport:"凤凰国际机场",flag:true),(city:"哈尔滨",airport:"太平国际机场",flag:true),(city:"大连",airport:"周水子国际机场",flag:true),(city:"长沙",airport:"黄花国际机场",flag:true),(city:"南昌",airport:"昌北国际机场",flag:true),(city:"郑州",airport:"新郑国际机场",flag:false),(city:"厦门",airport:"高崎国际机场",flag:false),(city:"南京",airport:"禄口国际机场",flag:false),(city:"沈阳",airport:"桃仙国际机场",flag:false),(city:"青岛",airport:"流亭国际机场",flag:false),(city:"太原",airport:"武宿国际机场",flag:false),(city:"北京",airport:"南苑机场",flag:false),(city:"常德",airport:"桃花源机场",flag:false),(city:"无锡",airport:"苏南硕放国际机场",flag:false),(city:"包头",airport:"二里半机场",flag:false),(city:"烟台",airport:"莱山国际机场",flag:false),(city:"张家界",airport:"荷花国际机场",flag:false),(city:"武夷山",airport:"元翔机场",flag:false),(city:"拉萨",airport:"贡嘎机场",flag:false),(city:"淮安",airport:"涟水机场",flag:false),(city:"郑州",airport:"郑州高铁站",flag:false),(city:"深圳",airport:"深圳高铁站",flag:false),(city:"广州",airport:"广州高铁站",flag:false),(city:"长沙",airport:"长沙高铁站",flag:false),(city:"丽水",airport:"丽水高铁站",flag:false),(city:"西安",airport:"西安北站",flag:false),(city:"兰州",airport:"兰州西站",flag:false),(city:"沈阳",airport:"沈阳北站",flag:false),(city:"南宁",airport:"南宁站",flag:false),(city:"南宁",airport:"南宁东站",flag:false),(city:"桂林",airport:"桂林站",flag:false),(city:"桂林",airport:"桂林北",flag:false),(city:"北京",airport:"北京西站",flag:false),(city:"温州",airport:"温州南站",flag:false),(city:"杭州",airport:"杭州东站",flag:false)]
    
    fileprivate  let textLabel = UILabel(text: "如有预订需求，请拨打客服电话咨询", color: TBIThemeWhite, size: 14)
    
    fileprivate var time = 0
    override func viewWillAppear(_ animated: Bool) {
        setBlackTitleAndNavigationColor(title:"VIP服务")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        /// 新版订单更新
        //setNavigation(title:"VIP服务")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "ic_hotel_tel", target: self, action: #selector(rightItemClick(sender:)))
       
        self.view.backgroundColor = TBIThemeBaseColor
        initTableView()
        textLabel.layer.cornerRadius = 5
        textLabel.clipsToBounds = true
        textLabel.textAlignment = .center
        textLabel.backgroundColor = TBIThemeBackgroundViewColor
        self.view.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.height.equalTo(40)
            make.width.equalTo(240)
        }
        
//        UIView.animate(withDuration: 3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
//                self.textLabel.alpha = 0
//        }, completion: { (finished) -> Void in
//
//        })
        
        let checkTime = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(checkTime(timer:)), userInfo: self, repeats: true)
        checkTime.fire()
    }
    
    func checkTime(timer:Timer) {
        if time >= 1 {
            timer.invalidate()
            textLabel.isHidden = true
        }
        time = time + 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
extension  CoVipViewController {
    
    func initView () {
        
    }
}

extension  CoVipViewController {
    
    func rightItemClick(sender:UIButton) {
        getHotLine()
    }
}

extension CoVipViewController:  UITableViewDelegate,UITableViewDataSource {
    func initTableView() {
        //设置tableview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        //tableView.isScrollEnabled = false
        tableView.register(CoVipTableCellView.self, forCellReuseIdentifier: coVipTableCellViewIdentify)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
    
    
    func click (tap:UITapGestureRecognizer) {
        let view = CoVipAlertView(frame: ScreenWindowFrame)
        KeyWindow?.addSubview(view)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 28
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vi = CoVipHeaderView()
        vi.addOnClickListener(target: self, action: #selector(click(tap:)))
        return vi
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  list.count
    }
    
    // MARK: 创建cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: coVipTableCellViewIdentify, for: indexPath) as! CoVipTableCellView
        cell.selectionStyle = .none
        cell.fullCell(model: list[indexPath.row])
        return cell
    }
    // MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: row高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

