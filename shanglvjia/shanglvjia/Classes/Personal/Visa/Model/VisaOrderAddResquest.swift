//
//  VisaOrderAddResquest.swift
//  shanglvjia
//
//  Created by manman on 2018/7/19.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class VisaOrderAddResquest: NSObject{
    
    /// "收货地址"
    var address:String = ""
    var contactEmail:String = ""
    var contactName:String = ""
    var contactPhone:String = ""
    
    ///  出行时间 ,yyyy-MM-dd
    var deptDate:String = ""
    var expense:VisaOrderExpenseResquest? // = VisaOrderExpenseResquest()
    
    /// "0:不需要开发票；1：需要开发票"
    var needInvoice:String = "0"
    /// "0:不需要保险；1：需要保险"
    var needSurance:String = "0"
    
    /// "0:不需要寄送；1：需要寄送"
    var needSend:String = ""
    /// "单数")
    var orderCount:String = ""
    var passengers:[SubmitHotelOrderRequest.HotelPassengerInfo] = Array()
    
    
    var surances:[TravelSuranceResponse] = Array()
    var priceDetail:String = ""
    /// "签证产品ID"
    var productId:String = ""
    
    /// "签证名称")
    var productName:String = ""
    
    /// "寄送费"
    var sendRate:String = "0"
    
    /// "总价"
    var totalRate:String = ""
    
    
    override init() {
        
    }
    
    class VisaOrderExpenseResquest: NSObject {
        
        ///  (number, optional): 发票金额 ,
        var exAmount:String = ""
        
        ///  (string, optional): 开户银行 ,
        var exBank:String = ""
        
        ///  (string, optional): 银行账户号 ,
        var exBankNo:String = ""
        
        ///  (string, optional): 公司地址 ,
        var exCompanyAddress:String = ""
        
        ///  (string, optional): 公司电话 ,
        var exCompanyPhone:String = ""
        
        ///  (string, optional): 发票内容 ,
        var exContent:String = ""
        
        ///  (string, optional): 纳税人识别号/统一社会信用代码 ,
        var exItin:String = ""
        
        /// (integer, optional): 发票种类0电子发票1纸质发票 ,
        var exKind:String = ""
        
        ///  (string, optional): 发票名称 ,
        var exName:String = ""
        
        ///  (string, optional): 姓名（针对个人） ,
        var exPersonName:String = ""
        
        ///  (string, optional): 报销单抬头 ,
        var exTitle:String = ""
        
        ///  (integer, optional): 0:个人；1：公司
        var exType:String = ""
        
        /// : 收件地址
        var address:String = ""
        
        
        override init() {
            
        }
    }
    
    class TravelSuranceResponse:NSObject,ALSwiftyJSONAble{
        var id:String = ""
        
        /// 成本费 ,
        var suranceAgentPrice:NSNumber = 0
        
        /// 保险公司 ,
        var suranceCompany:String = ""
        
        /// 保险详情 ,
        var suranceDesc:String = ""
        
        ///  保险id ,
        var suranceId:String = ""
        
        ///  保险名称 ,
        var suranceName:String = ""
        
        /// 产品编号 ,
        var suranceProductNo:String = ""
        
        ///  销售价
        var suranceSalePrice:NSNumber = 0
        
        
        
        override init() {
            
        }
        required init?(jsonData: JSON) {
            id = jsonData["id"].stringValue
            suranceAgentPrice = jsonData["suranceAgentPrice"].numberValue
            suranceCompany = jsonData["suranceCompany"].stringValue
            suranceDesc = jsonData["suranceDesc"].stringValue
            suranceId = jsonData["suranceId"].stringValue
            suranceName = jsonData["suranceName"].stringValue
            suranceProductNo = jsonData["suranceProductNo"].stringValue
            suranceSalePrice = jsonData["suranceSalePrice"].numberValue
        }
    }
    
    class BaseVisaPassengerVo: NSObject {
        var vpName:String = ""
        var vpPassportno:String = ""
        var vpPassportType:String = ""
        override init() {
            
        }
    }
    

}
