//
//  CompanyHomeTripModel.swift
//  shop
//
//  Created by SLMF on 2017/4/20.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

struct CompanyHomeTripModel: DictionaryAble {
    /// 业务类型
    let typeLabel: String
    /// 行程日期，XX月XX日
    let dateLabel: String
    /// 起飞时间，XX：XX
    let startTimeLabel: String
    /// 起飞机场
    let startAirportLabel: String
    /// 到达时间，XX：XX
    let arriveTimeLabel: String
    /// 到达机场
    let arriveAirportLabel: String
    /// 航空公司+航班号
    let airlineCompanyLabel: String
    /// noticeLabel
    let noticeLabel: String
}
