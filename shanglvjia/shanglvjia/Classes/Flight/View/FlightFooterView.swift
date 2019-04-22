//
//  FlightFooterView.swift
//  shop
//
//  Created by SLMF on 2017/5/2.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit



class FlightFooterView: UIView {
    
    typealias FlightFliterBlock = ([[(index:NSInteger,content:String)]]) ->Void
    typealias FlightPriceSortBlock = (FlightSort) ->Void
    typealias FlightSortBlock = (FlightSort) ->Void
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    //选中过滤条件
    var selectedData:[[(index:NSInteger,content:String)]] = [[(index:0,content:"")],[(index:0,content:"")],[(index:0,content:"")],[(index:0,content:"")]]
    //舱位信息
    public var allCabin:[String] = Array()
    //航空公司
    public var allCompany:[String] = Array()
    
    //是否直达
    private var throughCategory:[String] = ["不限","直达","非直达"]
    
    //起飞时间
    private var takeoffTime:[String] = ["不限","上午(6-12点)","下午(12-18点)","晚上(18-24点)"]
    
    
    //TODO: ^_^666
    private var airInfoView:AirInfoView = AirInfoView()
    
    private var baseBackgroundView = UIView()
    private var subBackgroundView = UIView()
    //价格筛选
    var flightFliterButton = UIButton()
    fileprivate var flightFliterTitleLabel = UILabel()
    var flightFliterBlock:FlightFliterBlock!
    
    
    //价格排序
    var flightPriceSortButton = UIButton()
    var flightPriceSortTitleLabel = UILabel()
    var flightPriceSortBlock:FlightPriceSortBlock!
    
    // 时间筛选
    var flightTimeSortkButton = UIButton()
    var flightTimeSortTitleLabel = UILabel()
    var flightSortBlock:FlightSortBlock!
    
    //0 默认 1升  2降
    private var priceSortFlag:Int = 0
    
    //0 默认 1早-晚  2晚到早
    private var timeSortFlag:Int = 0
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        baseBackgroundView.backgroundColor = UIColor.black
        baseBackgroundView.alpha = 0.6
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            
            make.top.left.bottom.right.equalToSuperview()
            
        }
        
        baseBackgroundView.addSubview(subBackgroundView)
        subBackgroundView.snp.makeConstraints { (make) in
            
            make.top.left.bottom.right.equalToSuperview()
            
        }
        
        //setUIViewAutolayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setUIViewAutolayout() {
        flightFliterButton.isSelected = false
        flightTimeSortkButton.isSelected = false
        flightPriceSortButton.isSelected = false
        
        
        
        flightFliterButton.addTarget(self, action: #selector(flightFliterButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        flightFliterButton.setImage(UIImage.init(named: "ic_filter_white"), for: UIControlState.normal)
        flightFliterButton.setImage(UIImage.init(named: "ic_filter_orange"), for: UIControlState.selected)
        flightFliterButton.setTitle("筛选", for: UIControlState.normal)
        flightFliterButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        let  edge = (UIScreen.main.bounds.width-72)/6
        //flightFliterButton.setEnlargeEdge(top: 6, left: edge, bottom: 20, right: edge)
        flightFliterButton.setEnlargeEdgeWithTop(6 ,left: edge, bottom: 20, right:edge)
        subBackgroundView.addSubview(flightFliterButton)
        
        flightFliterButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(3)
            make.left.equalTo(64)
            //make.centerX.equalTo(flightFliterTitleLabel.snp.centerX)
            make.width.equalTo(27)
            make.height.equalTo(27)
        }
        
        flightFliterTitleLabel.text = "筛选"
        flightFliterTitleLabel.font = UIFont.systemFont(ofSize: 11)
        flightFliterTitleLabel.textColor = UIColor.white
        subBackgroundView.addSubview(flightFliterTitleLabel)
        flightFliterTitleLabel.snp.makeConstraints { (make) in
            //make.left.equalToSuperview().offset(64)
            make.bottom.equalToSuperview().offset(-6)
            make.centerX.equalTo(flightFliterButton.snp.centerX).offset(-2)
        }

        
      
        
        flightTimeSortkButton.addTarget(self, action: #selector(flightTimeSortkButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        flightTimeSortkButton.setImage(UIImage.init(named: "ic_time_white"), for: UIControlState.normal)
        flightTimeSortkButton.setImage(UIImage.init(named: "ic_time_orange"), for: UIControlState.selected)
        flightTimeSortkButton.setTitle("时间", for: UIControlState.normal)
        //flightTimeSortkButton.setEnlargeEdge(top: 6, left: edge, bottom: 20, right: edge)
        flightTimeSortkButton.setEnlargeEdgeWithTop(6 ,left: edge, bottom: 20, right:edge)
        flightTimeSortkButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        subBackgroundView.addSubview(flightTimeSortkButton)
        
        flightTimeSortkButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(3)
            make.centerX.equalToSuperview()
            //make.centerX.equalTo(flightTimeSortTitleLabel.snp.centerX)
            make.width.equalTo(27)
            make.height.equalTo(27)
        }
        
        flightTimeSortTitleLabel.text = "时间"
        flightTimeSortTitleLabel.font = UIFont.systemFont(ofSize: 11)
        flightTimeSortTitleLabel.textColor = UIColor.white
        subBackgroundView.addSubview(flightTimeSortTitleLabel)
        flightTimeSortTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(flightTimeSortkButton.snp.centerX).offset(-2)
            //make.left.equalTo(flightFliterTitleLabel.snp.right).offset((ScreenWindowWidth - 88 - 88 - 24) / 2)
            make.bottom.equalToSuperview().offset(-6)
        }
        
        
       
        flightPriceSortButton.addTarget(self, action: #selector(flightPriceSortButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        flightPriceSortButton.setImage(UIImage.init(named: "ic_price_white"), for: UIControlState.normal)
        flightPriceSortButton.setImage(UIImage.init(named: "ic_price_orange"), for: UIControlState.selected)
        flightPriceSortButton.setTitle("价格", for: UIControlState.normal)
        flightPriceSortButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        flightPriceSortButton.setEnlargeEdgeWithTop(6 ,left: edge, bottom: 20, right:edge)
        subBackgroundView.addSubview(flightPriceSortButton)
        
        flightPriceSortButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(3)
            make.right.equalToSuperview().offset(-64)
            make.width.equalTo(27)
            make.height.equalTo(27)
        }
        
        flightPriceSortTitleLabel.text = "价格"
        flightPriceSortTitleLabel.font = UIFont.systemFont(ofSize: 11)
        flightPriceSortTitleLabel.textColor = UIColor.white
        subBackgroundView.addSubview(flightPriceSortTitleLabel)
        flightPriceSortTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(flightPriceSortButton.snp.centerX).offset(-2)
            make.bottom.equalToSuperview().offset(-6)
        }
        
    }
    
    
    //MARK:- Action
    func flightFliterButtonAction(sender:UIButton) {
        printDebugLog(message: "flightFliterButtonAction  view ...")
        let airInfoView = AirInfoView.init(frame: ScreenWindowFrame)
        airInfoView.leftTableViewDataSources = ["是否直达","起飞时间","舱位","航空公司"]
        airInfoView.rightSelectedDataSources =  selectedData
        airInfoView.rightTableViewDataSources = [throughCategory,takeoffTime,allCabin,allCompany]
        weak var weakSelf = self
        airInfoView.airInfoSelectedResultBlock = { (selectedArr) in
            weakSelf?.flightFliterBlock(selectedArr)
            weakSelf?.selectedData = selectedArr
            // 如果价格排序不为空
            if weakSelf?.priceSortFlag != 0 {
               weakSelf?.priceSortFlag = self.priceSortFlag == 1 ? 2:1
               weakSelf?.flightPriceSortButtonAction(sender: self.flightPriceSortButton)
            }
            // 如果时间排序不为空
            if weakSelf?.timeSortFlag != 0 {
               weakSelf?.timeSortFlag = self.timeSortFlag == 1 ? 2:1
               weakSelf?.flightTimeSortkButtonAction(sender: self.flightTimeSortkButton)
            }
           
        }
        airInfoView.airInfoViewCancelBlock = { (data) in
            print("取消")
        }
       
        
        
        KeyWindow?.addSubview(airInfoView)
    }
    
    func flightPriceSortButtonAction(sender:UIButton) {
        flightTimeSortkButton.isSelected = false
        //flightFliterButton.isSelected = false
        
        // 初始化事件筛选
        flightTimeSortTitleLabel.text = "时间"
        sender.isSelected = false
        timeSortFlag = 0
        
        switch  priceSortFlag{
        case 0,1:
            //升序
            sender.isSelected = true
            flightSortBlock(FlightSort.priceAsc)
            flightPriceSortTitleLabel.text = "从低到高"
            priceSortFlag = 2
        case 2:
            //降序
            sender.isSelected = true
            flightSortBlock(FlightSort.priceDesc)
            flightPriceSortTitleLabel.text = "从高到低"
            priceSortFlag = 1
        default:
            break
        }
    }
    
    func flightTimeSortkButtonAction(sender:UIButton) {
        flightPriceSortButton.isSelected = false
        //flightFliterButton.isSelected = false
        
        //初始化价格筛选
        flightPriceSortTitleLabel.text = "价格"
        sender.isSelected = false
        priceSortFlag = 0
        
        switch  timeSortFlag{
        case 0,1:
            //降序
            timeSortFlag = 2
            sender.isSelected = true
            flightSortBlock(FlightSort.timeAsc)
            flightTimeSortTitleLabel.text = "从早到晚"
        case 2:
            //降序
            timeSortFlag = 1
            sender.isSelected = true
            flightSortBlock(FlightSort.timeDesc)
            flightTimeSortTitleLabel.text = "从晚到早"
        default:
            break
        }
        
    }
    
    
    func setButtonState(sender:UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
        }else
        {
            sender.isSelected = true
        }
    }
    
    
    
}
