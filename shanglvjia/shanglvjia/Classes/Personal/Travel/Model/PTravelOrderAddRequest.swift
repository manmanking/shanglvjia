//
//  PTravelOrderAddRequest.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/14.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PTravelOrderAddRequest: NSObject {

    ///成人数量
    var adultCount:String = ""
    var adultTicketRate:String = ""
    var childCount:String = ""
    var childTicketRate:String = ""
    ///联系人
    var contactEmail:String = ""
    var contactName:String = ""
    var contactPhone:String = ""
    ///出发时间
    var deptDate:String = ""
    var stockId:String = ""
    
    var expense:TravelOrderExpenseResquest = TravelOrderExpenseResquest()
    /// "0:不需要开发票；1：需要开发票"
    var needInvoice:String = "0"
    ///needTcConfirm (integer, optional): 需要确认0否1是 ,
    var needTcConfirm:String = ""
    var needSurance:String = ""
    ///出行人
    var passengers:[BaseVisaPassengerVo] = Array()
    var products:[BaseTravelOrderProductVo] = Array()
    var surances:[BaseSuranceOrderProductVo] = Array()
    
    ///费用明细
    var priceDetail:String = ""
    var productId:String = ""
    var productName:String = ""
    
    ///房间数量
    var roomCount:String = ""
    ///房费 ,
    var roomRate:String = ""
    ///总金额
    var totalRate:String = ""
    ///
    var type:String = ""

    
    class TravelOrderExpenseResquest: NSObject {
        
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
        
        ///address (string, optional): 收件地址
        var address:String = ""
        
        
        override init() {
            
        }
    }
    class BaseVisaPassengerVo: NSObject {
        ///  生日 ,
        var gtpBirthday:String = ""
        
        ///  证件有效期 ,
        var gtpCertDate:String = ""
        
        ///  证件号 ,
        var gtpCertNo:String = ""
        
        /// 证件类型 ,
        var gtpCertType:String = ""
        
        ///  中文名 ,
        var gtpChName:String = ""
        
        /// 英文姓 ,
        var gtpEnFirstname:String = ""
        
        ///  英文名 ,
        var gtpEnLastname:String = ""
        
        ///  手机号 ,
        var gtpPhone:String = ""
        
        /// 乘客类型0成人；1儿童
        var gtpType:String = ""
        ///性别
        var gtpSex:String = ""
        override init() {
            
        }
    }
    class BaseTravelOrderProductVo:NSObject{
        ///count (integer, optional): 数量 ,
        var count:String = ""
        ///nightNum (integer, optional): 几晚 ,
        var nightNum:String = ""
        ///personNum (integer, optional): 每间房几人 ,
        var personNum:String = ""
        ///productName (string, optional): 产品名称 ,
        var productName:String = ""
        ///productType (integer, optional): 1机票2酒店3签证4用车5目的地旅游6保险 ,
        var productType:String = ""
        ///saleRate (number, optional): 单价 ,
        var saleRate:String = ""
        ///supplier (string, optional): 供应商 ,
        var supplier:String = ""
        ///supplierName (string, optional): 供应商名字 ,
        var supplierName:String = ""
        ///type (integer, optional): 类型0普通1附加
        var type:String = ""
        var id:String = ""
        var costRate:String = ""
        var productNo:String = ""
        
        ///用车中
        var startTime:String = ""
        var startPoint:String = ""
        
        override init() {
            
        }
    }
    class BaseSuranceOrderProductVo:NSObject{
        var id:String = ""
        var suranceAgentPrice:String = ""
        //"suranceCompany":"保险公司",
        var suranceCompany:String = ""
        //"suranceDesc":"保险描述",
        var suranceDesc:String = ""
        //"suranceId":1,
        var suranceId:String = ""
        //保险名字,
        var suranceName:String = ""
        var suranceProductNo:String = ""
        var suranceSalePrice:String = ""
        var count:String = ""
    }
    override init() {
        
    }
}
