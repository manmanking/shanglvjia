//
//  LoadingView.swift
//  shop
//
//  Created by TBI on 2017/6/2.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    private var baseBackgroundView:UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseBackgroundView.backgroundColor = TBIThemeBackgroundViewColor
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        let jeremyGif = UIImage.gif(name:"loading")
        let imageView = UIImageView(image: jeremyGif)
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(120)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}


class TrainLoadingView: UIView {
    
    private var baseBackgroundView:UIView = UIView()
    
    let textLabel: UILabel = UILabel(text: "占座中,请稍等片刻...", color: TBIThemeWhite, size: 15)
    
    let timeLabel: UILabel = UILabel(text: "", color: TBIThemeWhite, size: 15)
    
    fileprivate var time = 120
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initData()
        baseBackgroundView.backgroundColor = TBIThemeBackgroundViewColor
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        let jeremyGif = UIImage.gif(name:"train_loading")
        let imageView = UIImageView(image: jeremyGif)
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.height.width.equalTo(50)
        }
        self.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
           make.centerX.equalToSuperview()
           make.top.equalTo(imageView.snp.bottom).offset(45)
        }
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(textLabel.snp.bottom).offset(15)
        }
        
    }
    
    func initData () {
        let checkTime = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkTime(timer:)), userInfo: self, repeats: true)
        checkTime.fire()
    }
    
    func checkTime(timer:Timer) {
        if time == 0 {
            timer.invalidate()
            return
        }
        time -= 1
        let minutes = time/60 < 1 ? 0:Int(time/60)
        let seconds = time - minutes * 60
        timeLabel.text = "\(minutes):\(seconds)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
