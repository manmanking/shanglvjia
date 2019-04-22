//
//  CoTrainListFooterView.swift
//  shop
//
//  Created by TBI on 2017/12/26.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CoTrainListFooterView: UIView {
    
    typealias TrainSortBlock = (TrainSort) ->Void
    typealias TrainFliterBlock = ([[(index:Int,selected:Bool,value:String)]]) ->Void
    
    //选中过滤条件
    var selectedData:[[(index:Int,selected:Bool,value:String)]] = [[]]

    
    //过滤条件
    var filterData:[[(index:Int,selected:Bool,value:String)]] = [[(index:0,selected:false,value:"高铁 G/城际 C"),(index:1,selected:false,value:"动车 D"),(index:2,selected:false,value:"直达 Z"),(index:3,selected:false,value:"特快 T"),(index:4,selected:false,value:"快速 K"),(index:5,selected:false,value:"其他")],
        [(index:0,selected:false,value:"00:00 - 06:00"),(index:1,selected:false,value:"06:00 - 12:00"),(index:2,selected:false,value:"12:00 - 18:00"),(index:3,selected:false,value:"18:00 - 24:00")],
            [],
        [(index:0,selected:false,value:"始发"),(index:1,selected:false,value:"路过")]]
    
    private var baseBackgroundView = UIView()
    private var subBackgroundView = UIView()
    
    // 筛选
    var trainFliterButton = UIButton()
    fileprivate var trainFliterTitleLabel = UILabel()
    var trainFliterBlock:TrainFliterBlock!
    
    
    // 出发时间排序
    var startTimeSortButton = UIButton()
    fileprivate var startTimeSortTitleLabel = UILabel()

    
    // 到达时间排序
    var endTimeSortButton = UIButton()
    fileprivate var endTimeSortTitleLabel = UILabel()
    var trainSortBlock:TrainSortBlock!
    
    // 消耗时间排序
    var consumingTimeSortButton = UIButton()
    fileprivate var consumingTimeSortTitleLabel = UILabel()
    
    //0 默认 1升  2降
    private var startTimeSortFlag:Int = 0
    
    //0 默认 1升  2降
    private var endTimeSortFlag:Int = 0
    
    //0 默认 1升  2降
    private var runTimeSortFlag:Int = 0
    
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
        
        setUIViewAutolayout()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCityData (cityData:[String],flag:Bool) -> [[(index:Int,selected:Bool,value:String)]] {
        /// 如果第一次加载数据初始化帅选条件   第二次就保留
        if flag {
            self.trainFliterButton.isSelected = false
            self.startTimeSortButton.isSelected = false
            self.endTimeSortButton.isSelected = false
            self.consumingTimeSortButton.isSelected = false
            self.trainFliterTitleLabel.text = "筛选"
            self.startTimeSortTitleLabel.text = "出发"
            self.endTimeSortTitleLabel.text = "到达"
            self.consumingTimeSortTitleLabel.text = "耗时"
            filterData[2].removeAll()
            for inde in 0..<cityData.count {
                filterData[2].append((index: inde,selected:false, value: cityData[inde]))
            }
            for index in 0..<filterData.count {
                for ind in 0..<filterData[index].count {
                    filterData[index][ind].selected  = false
                }
            }
            
            
            if TrainManager.shareInstance.trainSearchConditionDraw().isGt {
                self.trainFliterButton.isSelected = true
                filterData[0][0].selected = true
                filterData[0][1].selected = true
            }
        }
        
        return filterData
    }
    
    func setUIViewAutolayout() {
        trainFliterButton.isSelected = false
        startTimeSortButton.isSelected = false
        endTimeSortButton.isSelected = false
        consumingTimeSortButton.isSelected = false
        let  edge = (UIScreen.main.bounds.width-72)/8
        
        let  width = (UIScreen.main.bounds.width-108)/5
        
        startTimeSortButton.addTarget(self, action: #selector(startTimeSortButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        startTimeSortButton.setImage(UIImage.init(named: "ic_price_white"), for: UIControlState.normal)
        startTimeSortButton.setImage(UIImage.init(named: "ic_price_orange"), for: UIControlState.selected)
        
        startTimeSortButton.setTitle("出发", for: UIControlState.normal)
        startTimeSortButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        startTimeSortButton.setEnlargeEdgeWithTop(6 ,left: edge, bottom: 20, right:edge)
        subBackgroundView.addSubview(startTimeSortButton)
        
        startTimeSortButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(3)
            make.left.equalToSuperview().offset(width)
            make.width.equalTo(27)
            make.height.equalTo(27)
        }
        
        startTimeSortTitleLabel.text = "出发"
        startTimeSortTitleLabel.font = UIFont.systemFont(ofSize: 11)
        startTimeSortTitleLabel.textColor = UIColor.white
        subBackgroundView.addSubview(startTimeSortTitleLabel)
        startTimeSortTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(startTimeSortButton.snp.centerX).offset(-2)
            make.bottom.equalToSuperview().offset(-6)
        }
        
        
        endTimeSortButton.addTarget(self, action: #selector(endTimeSortButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        endTimeSortButton.setImage(UIImage.init(named: "ic_price_white"), for: UIControlState.normal)
        endTimeSortButton.setImage(UIImage.init(named: "ic_price_orange"), for: UIControlState.selected)
        
        endTimeSortButton.setTitle("到达", for: UIControlState.normal)
        endTimeSortButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        endTimeSortButton.setEnlargeEdgeWithTop(6 ,left: edge, bottom: 20, right:edge)
        subBackgroundView.addSubview(endTimeSortButton)
        
        endTimeSortButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(3)
            make.left.equalToSuperview().offset(width*2+27)
            make.width.equalTo(27)
            make.height.equalTo(27)
        }
        
        endTimeSortTitleLabel.text = "到达"
        endTimeSortTitleLabel.font = UIFont.systemFont(ofSize: 11)
        endTimeSortTitleLabel.textColor = UIColor.white
        subBackgroundView.addSubview(endTimeSortTitleLabel)
        endTimeSortTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(endTimeSortButton.snp.centerX).offset(-2)
            make.bottom.equalToSuperview().offset(-6)
        }
        
        
        
        consumingTimeSortButton.addTarget(self, action: #selector(consumingTimeSortButtonSortButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        consumingTimeSortButton.setImage(UIImage.init(named: "ic_time_white"), for: UIControlState.normal)
        consumingTimeSortButton.setImage(UIImage.init(named: "ic_time_orange"), for: UIControlState.selected)
        consumingTimeSortButton.setTitle("耗时", for: UIControlState.normal)
        consumingTimeSortButton.setEnlargeEdgeWithTop(6 ,left: edge, bottom: 20, right:edge)
        consumingTimeSortButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        subBackgroundView.addSubview(consumingTimeSortButton)
        
        consumingTimeSortButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(3)
            make.left.equalToSuperview().offset(width*3+54)
            make.width.equalTo(27)
            make.height.equalTo(27)
        }
        
        consumingTimeSortTitleLabel.text = "耗时"
        consumingTimeSortTitleLabel.font = UIFont.systemFont(ofSize: 11)
        consumingTimeSortTitleLabel.textColor = UIColor.white
        subBackgroundView.addSubview(consumingTimeSortTitleLabel)
        consumingTimeSortTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(consumingTimeSortButton.snp.centerX).offset(-2)
            make.bottom.equalToSuperview().offset(-6)
        }
        
        
        
        trainFliterButton.addTarget(self, action: #selector(trainFliterButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        trainFliterButton.setImage(UIImage.init(named: "ic_filter_white"), for: UIControlState.normal)
        trainFliterButton.setImage(UIImage.init(named: "ic_filter_orange"), for: UIControlState.selected)
        trainFliterButton.setTitle("筛选", for: UIControlState.normal)
        trainFliterButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        trainFliterButton.setEnlargeEdgeWithTop(6 ,left: edge, bottom: 20, right:edge)
        subBackgroundView.addSubview(trainFliterButton)
        
        trainFliterButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(3)
            make.left.equalToSuperview().offset(width*4+81)
            make.width.equalTo(27)
            make.height.equalTo(27)
        }
        
        trainFliterTitleLabel.text = "筛选"
        trainFliterTitleLabel.font = UIFont.systemFont(ofSize: 11)
        trainFliterTitleLabel.textColor = UIColor.white
        subBackgroundView.addSubview(trainFliterTitleLabel)
        trainFliterTitleLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-6)
            make.centerX.equalTo(trainFliterButton.snp.centerX).offset(-2)
        }
 
        
        
        
        
    }
    
    
    //MARK:- Action
    func trainFliterButtonAction(sender:UIButton) {
        let trainFilterView = CoTrainFilterView(frame: ScreenWindowFrame)
        trainFilterView.filterData =  self.filterData
        trainFilterView.initData()
        weak var weakSelf = self
        trainFilterView.trainSelectedResultBlock = { (data) in
            weakSelf?.filterData = data
            let count = data.reduce([],{$0 + $1}).filter{$0.selected == true}.count
            if count > 0 {
                weakSelf?.trainFliterButton.isSelected = true
            }else {
                weakSelf?.trainFliterButton.isSelected = false
            }
            weakSelf?.trainFliterBlock(data)
        }

        KeyWindow?.addSubview(trainFilterView)
    }
    

    func startTimeSortButtonAction(sender:UIButton) {
       
        runTimeSortFlag = 0
        endTimeSortFlag = 0
        endTimeSortButton.isSelected = false
        consumingTimeSortButton.isSelected = false
        endTimeSortTitleLabel.text  = "到达"
        consumingTimeSortTitleLabel.text = "耗时"
        
        switch  startTimeSortFlag{
        case 0,1:
            //升序
            sender.isSelected = true
            trainSortBlock(TrainSort.startTimeAsc)
            startTimeSortTitleLabel.text = "早-晚"
            startTimeSortFlag = 2
        case 2:
            //降序
            sender.isSelected = true
            trainSortBlock(TrainSort.startTimeDesc)
            startTimeSortTitleLabel.text = "晚-早"
            startTimeSortFlag = 1
        default:
            break
        }
    }
    
    func endTimeSortButtonAction(sender:UIButton) {
        runTimeSortFlag = 0
        startTimeSortFlag = 0
        startTimeSortButton.isSelected = false
        consumingTimeSortButton.isSelected = false
        startTimeSortTitleLabel.text  = "出发"
        consumingTimeSortTitleLabel.text = "耗时"
        switch  endTimeSortFlag{
        case 0,1:
            //升序
            sender.isSelected = true
            trainSortBlock(TrainSort.endTimeAsc)
            endTimeSortTitleLabel.text = "早-晚"
            endTimeSortFlag = 2
        case 2:
            //降序
            sender.isSelected = true
            trainSortBlock(TrainSort.endTimeDesc)
            endTimeSortTitleLabel.text = "晚-早"
            endTimeSortFlag = 1
        default:
            break
        }
        
    }
    
    
    func consumingTimeSortButtonSortButtonAction(sender:UIButton) {
        endTimeSortFlag = 0
        startTimeSortFlag = 0
        startTimeSortButton.isSelected = false
        endTimeSortButton.isSelected = false
        startTimeSortTitleLabel.text  = "出发"
        endTimeSortTitleLabel.text = "到达"
        
        switch  runTimeSortFlag{
        case 0,1:
            //升序
            sender.isSelected = true
            trainSortBlock(TrainSort.runTimeAsc)
            consumingTimeSortTitleLabel.text = "短-长"
            runTimeSortFlag = 2
        case 2:
            //降序
            sender.isSelected = true
            trainSortBlock(TrainSort.runTimeDesc)
            consumingTimeSortTitleLabel.text = "长-短"
            runTimeSortFlag = 1
        default:
            break
        }
        
    }
    
   
}
