//
//  TableNoDateView.swift
//  shop
//
//  Created by akrio on 2017/5/26.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class TableNoDateView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var refreshButton: BaseButton!
    
    func setType(_ type:NoDataType) {
        image.image = UIImage(named: type.rawValue)
        messageLabel.text = type.text
        if case .noNetwork = type {
            refreshButton.isHidden = false
        }
    }
    
    /// 图片类型
    //
    // - noOrder: 无订单
    // - noApproval: 无审批订单
    // - noData: 无数据
    // - noNetwork: 网络不可用
    // - noTrip: 没有行程单
    enum NoDataType:String {
        case noOrder = "ic_no_order"
        case noApproval = "ic_no_approve"
        case noData = "ic_no_content"
        case noNetwork = "ic_no_wifi"
        case noTrip = "ic_no_trip"
        case noNewOrder = "ic_no_neworder"
        case noPersonal = "personal_null_image"
        var text:String{
            switch self {
            case .noOrder:
                return "您好像暂无出行订单"
            case .noApproval:
                return "您好像暂无审批订单"
            case .noData:
                return "暂无数据看看新页面"
            case .noNetwork:
                return "您的手机网络貌似不太流畅"
            case .noTrip:
                return "您近期好像暂无行程"
            case .noNewOrder:
                return "您近期好像暂无行程"
            case .noPersonal:
                return "您近期好像暂无行程"
            }
        }
    }
}


