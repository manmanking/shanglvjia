//
//  PCommonHotelListFilterView.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/1.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PCommonHotelListFilterView: UIView {

//    typealias RecommendSortButtonBlock = (String,NSInteger) -> Void
//    typealias RecommendIndexButtonBlock = (String,NSInteger) -> Void
//    typealias HotelStarButtonBlock = (String,NSInteger) -> Void
    
//    var recommendSortButtonBlock:RecommendSortButtonBlock!
//    var recommendIndexButtonBlock:RecommendIndexButtonBlock!
   
    
    let recommendSortButton = UIButton.init(title: "推荐排序", titleColor: UIColor.black, titleSize: 13)
    let recommendIndexButton = UIButton.init(title: "推荐指数", titleColor: UIColor.black, titleSize: 13)
    let hotelStarButton = UIButton.init(title: "酒店星级", titleColor: UIColor.black, titleSize: 13)
    private let lineLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = TBIThemeWhite
        creatView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func creatView(){
        self.addSubview(recommendSortButton)
        self.addSubview(recommendIndexButton)
        self.addSubview(hotelStarButton)
        self.addSubview(lineLabel)
        
        
        recommendSortButton.setImage(UIImage(named:"HotelDownSolidTriangle"), for: UIControlState.normal)
        recommendSortButton.setImage(UIImage(named:"ic_hotel_up"), for: UIControlState.selected)
        recommendSortButton.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
            make.height.equalTo(40)
        }
        let imageWithSort = recommendSortButton.imageView?.bounds.size.width;
        let labelWidthSort = recommendSortButton.titleLabel?.bounds.size.width;
        recommendSortButton.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidthSort!, 0, -labelWidthSort!);
        recommendSortButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWithSort!-5, 0, imageWithSort!+5);
        
        recommendIndexButton.setImage(UIImage(named:"HotelDownSolidTriangle"), for: UIControlState.normal)
        recommendIndexButton.setImage(UIImage(named:"ic_hotel_up"), for: UIControlState.selected)
        recommendIndexButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(recommendSortButton.snp.right)
            make.width.equalToSuperview().dividedBy(3)
            make.height.equalTo(recommendSortButton)
        }
        let imageWithIndex = recommendSortButton.imageView?.bounds.size.width;
        let labelWidthIndex = recommendSortButton.titleLabel?.bounds.size.width;
        recommendIndexButton.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidthIndex!, 0, -labelWidthIndex!);
        recommendIndexButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWithIndex!-5, 0, imageWithIndex!+5);
        
        hotelStarButton.setImage(UIImage(named:"HotelDownSolidTriangle"), for: UIControlState.normal)
        hotelStarButton.setImage(UIImage(named:"ic_hotel_up"), for: UIControlState.selected)
        hotelStarButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(recommendIndexButton.snp.right)
            make.width.equalToSuperview().dividedBy(3)
            make.height.equalTo(recommendSortButton)
        }
        let imageWithStar = recommendSortButton.imageView?.bounds.size.width;
        let labelWidthStar = recommendSortButton.titleLabel?.bounds.size.width;
        hotelStarButton.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidthStar!, 0, -labelWidthStar!);
        hotelStarButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWithStar!-5, 0, imageWithStar!+5);
        
        lineLabel.backgroundColor = TBIThemeGrayLineColor
        lineLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
    }
    
}
