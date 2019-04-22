//
//  POnsaleFlightCabinModel.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/6.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

class POnsaleFlightCabinModel: NSObject,ALSwiftyJSONAble  {
    
    var airfares:[AirfaresList] = Array()
    var arriveAirportName:String = ""
    var cacheId:String = ""
    var companys:[CompanysList] = Array()
    var returnDate:String = ""
    var takeOffAirportName:String = ""
    var takeOffDate:String = ""
    
    required init?(jsonData: JSON) {
        arriveAirportName = jsonData["arriveAirportName"].stringValue
        cacheId = jsonData["cacheId"].stringValue
        returnDate = jsonData["returnDate"].stringValue
        takeOffAirportName = jsonData["takeOffAirportName"].stringValue
        takeOffDate = jsonData["takeOffDate"].stringValue
        airfares = jsonData["airfares"].arrayValue.map{AirfaresList.init(jsonData: $0)!}
        companys = jsonData["companys"].arrayValue.map{CompanysList.init(jsonData: $0)!}
    }
    class AirfaresList:NSObject ,ALSwiftyJSONAble{
        
        var amount:String = ""
        var cabins:[CabinsList] = Array()
        var cacheId:String = ""
        var contraryPolicy:Bool = false
        var direct:Bool = false
        var discount:String = ""
        var flightInfos:[FlightInfosList] = Array()
        var id:String = ""
        var price:String = ""
        var protocolPrice:Bool = false
        var transferAirport:String = ""
        var transferCity:String = ""
        var transferTime:String = ""
        required init?(jsonData: JSON) {
            amount = jsonData["amount"].stringValue
            cacheId = jsonData["cacheId"].stringValue
            contraryPolicy = jsonData["contraryPolicy"].boolValue
            discount = jsonData["discount"].stringValue
            direct = jsonData["direct"].boolValue
            id = jsonData["id"].stringValue
            price = jsonData["price"].stringValue
            protocolPrice = jsonData["protocolPrice"].boolValue
            transferAirport = jsonData["transferAirport"].stringValue
            transferCity = jsonData["transferCity"].stringValue
            transferTime = jsonData["transferTime"].stringValue
            cabins = jsonData["cabins"].arrayValue.map{CabinsList.init(jsonData: $0)!}
            flightInfos = jsonData["flightInfos"].arrayValue.map{FlightInfosList.init(jsonData: $0)!}
        }
    }
    class CompanysList:NSObject ,ALSwiftyJSONAble{
        var code:String = ""
        var  name:String = ""
        required init?(jsonData: JSON) {
            code = jsonData["code"].stringValue
            name = jsonData["name"].stringValue
        }
    }
    class CabinsList:NSObject ,ALSwiftyJSONAble{
        var amount:String = ""
        var cacheId:String = ""
        var childFuelTax:String = ""
        var childPrice:String = ""
        var childTax:String = ""
        var code:String = ""
        var contraryPolicy:Bool = false
        var contraryPolicyDesc:String = ""
        var discount:String = ""
        var ei:String = ""
        var fuelTax:String = ""
        var id:String = ""
        var ifAccountCodePrice:Bool = false
        var orginPrice:String = ""
        var price:String = ""
        var priceType:String = ""
        var protocolPrice:Bool = false
        var shipping:String = ""
        var subCode:String = ""
        var tax:String = ""
        required init?(jsonData: JSON) {
            amount = jsonData["amount"].stringValue
            cacheId = jsonData["cacheId"].stringValue
            childFuelTax = jsonData["childFuelTax"].stringValue
            childPrice = jsonData["childPrice"].stringValue
            childTax = jsonData["childTax"].stringValue
            code = jsonData["code"].stringValue
            contraryPolicy = jsonData["contraryPolicy"].boolValue
            contraryPolicyDesc = jsonData["contraryPolicyDesc"].stringValue
            discount = jsonData["discount"].stringValue
            ei = jsonData["ei"].stringValue
            fuelTax = jsonData["fuelTax"].stringValue
            id = jsonData["id"].stringValue
            ifAccountCodePrice = jsonData["ifAccountCodePrice"].boolValue
            orginPrice = jsonData["orginPrice"].stringValue
            price = jsonData["price"].stringValue
            priceType = jsonData["priceType"].stringValue
            protocolPrice = jsonData["protocolPrice"].boolValue
            shipping = jsonData["shipping"].stringValue
            subCode = jsonData["subCode"].stringValue
            tax = jsonData["tax"].stringValue
    
        }
        
    }
    class FlightInfosList:NSObject,ALSwiftyJSONAble{
        var arriveAirportCode:String = ""
        var arriveAirportName:String = ""
        var arriveCity:String = ""
        var arriveDate:String = ""
        var arriveTerminal:String = ""
        var carriageCode:String = ""
        var carriageName:String = ""
        var carriageNo:String = ""
        var carriageShortName:String = ""
        var craftType:String = ""
        var craftTypeClass:String = ""
        var craftTypeClassShort:String = ""
        var craftTypeMaxSite:String = ""
        var craftTypeMinSite:String = ""
        var craftTypeName:String = ""
        var flightCode:String = ""
        var flightName:String = ""
        var flightNo:String = ""
        var flightShortName:String = ""
        var flightTime:String = ""
        var flyDays:String = ""
        var mealCode:String = ""
        var share:Bool = false
        var stopOver:Bool = false
        var stopOverCity:String = ""
        var stopOverTime:String = ""
        var takeOffAirportCode:String = ""
        var takeOffAirportName:String = ""
        var takeOffCity:String = ""
        var takeOffDate:String = ""
        var takeOffTerminal:String = ""
        var tripType:String = ""
        required init?(jsonData: JSON) {
            arriveAirportCode = jsonData["arriveAirportCode"].stringValue
            arriveAirportName = jsonData["arriveAirportName"].stringValue
            arriveCity = jsonData["arriveCity"].stringValue
            arriveDate = jsonData["arriveDate"].stringValue
            arriveTerminal = jsonData["arriveTerminal"].stringValue
            carriageCode = jsonData["carriageCode"].stringValue
            carriageName = jsonData["carriageName"].stringValue
            carriageNo = jsonData["carriageNo"].stringValue
            carriageShortName = jsonData["carriageShortName"].stringValue
            craftType = jsonData["craftType"].stringValue
            craftTypeClass = jsonData["craftTypeClass"].stringValue
            craftTypeClassShort = jsonData["craftTypeClassShort"].stringValue
            craftTypeMaxSite = jsonData["arriveAirportCode"].stringValue
            craftTypeMinSite = jsonData["craftTypeMinSite"].stringValue
            craftTypeName = jsonData["craftTypeName"].stringValue
            flightCode = jsonData["flightCode"].stringValue
            flightName = jsonData["flightName"].stringValue
            flightNo = jsonData["flightNo"].stringValue
            flightShortName = jsonData["flightShortName"].stringValue
            flightTime = jsonData["flightTime"].stringValue
            flyDays = jsonData["flyDays"].stringValue
            mealCode = jsonData["mealCode"].stringValue
            share = jsonData["share"].boolValue
            stopOver = jsonData["stopOver"].boolValue
            stopOverCity = jsonData["stopOverCity"].stringValue
            stopOverTime = jsonData["stopOverTime"].stringValue
            takeOffAirportCode = jsonData["takeOffAirportCode"].stringValue
            takeOffCity = jsonData["takeOffCity"].stringValue
            takeOffAirportName = jsonData["takeOffAirportName"].stringValue
            takeOffDate = jsonData["takeOffDate"].stringValue
            takeOffTerminal = jsonData["takeOffTerminal"].stringValue
            tripType = jsonData["tripType"].stringValue
        }
    }
    

}
