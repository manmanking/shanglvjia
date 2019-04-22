//
//  PersonalOrderDetailViewController.swift
//  shanglvjia
//
//  Created by tbi on 23/08/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftDate

class PersonalOrderDetailViewController: PersonalBaseViewController,UIWebViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    public var urlString = ""
    
    private var button:UIButton = UIButton()
    
    private let webView:UIWebView = UIWebView()
    
    
    private let pickerCamera = UIImagePickerController()
    
    
    private let selectedImageViewBackgroundView:UIView = UIView()
    
    private var cancelButton:UIButton = UIButton()
    
    private var okayButton:UIButton = UIButton()
    
    private let selectedImageView:UIImageView = UIImageView()
    //private let pickerPhoto = UIImagePickerController()
    private var localFileFullPath:String = ""
    
    
    /// 上传快递单号 订单号
    private var uploadOrderId:String = ""
    
    

    
    
    let bag = DisposeBag()
    
    
    override func viewWillAppear(_ animated: Bool) {
        setBlackTitleAndNavigationColor(title: "订单详情")
        webView.loadRequest(URLRequest.init(url: URL.init(string:urlString)!))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        
        //self.automaticallyAdjustsScrollViewInsets = false
        setUIViewAutolayout()
        cleanCacheAndCookie()
    }
    
    
    func setUIViewAutolayout() {
        webView.delegate = self
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        printDebugLog(message: " into here ")
        printDebugLog(message: request.httpMethod)
        printDebugLog(message: request.url?.absoluteString)
        
        let requestUrlStr:String = (request.url?.absoluteString)!
        let requestParameters = requestUrlStr.urlParameters
        printDebugLog(message: requestParameters)
        
        if requestUrlStr.contains(PersonalVisaUploadDeliveryURL) == true {
            showChoicesCameraView(orderId: requestParameters!["orderId"] as! String)
            return false
        }
        if requestUrlStr.contains("pay.html?orderNo") == true
        {
            showPaymentView(orderId: requestParameters!["orderNo"] as! String, price: requestParameters!["totalPrice"] as! String)
            return false
        }
        if requestUrlStr.contains(PersonalFlightCommonRebookURL) {
            showFlightCommonSearchView(parameter: requestParameters)
            return false
        }
        
        if requestUrlStr.contains(PersonalTravelDownloadURL){
            openSiri(requestUrl:requestParameters!["travelDownload"] as! String)
            return false
        }
        
        if requestUrlStr.contains(PersonalOrderDownloadSurances){
            openSiri(requestUrl:requestParameters!["surancesURL"] as! String)
            return false
        }
        if requestUrlStr.contains(PersonalOrderDownloadInvoice){
            openSiri(requestUrl:requestParameters!["invoiceURL"] as! String)
            return false
        }
        if requestUrlStr.contains(PersonalFlightInternayionAndSpecialRebookURL) {
            showOrderStatusView(parameter: requestParameters)
            return false
        }
        
        
        
        
        
        return true
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        printDebugLog(message: " into here ")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        printDebugLog(message: " into here ")
        
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        printDebugLog(message: " into here ")
    }
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    
    
    func cleanCacheAndCookie()  {
        
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        let storage:HTTPCookieStorage = HTTPCookieStorage.shared
        if storage.cookies != nil && (storage.cookies?.count)! > 0 {
            storage.deleteCookie((storage.cookies?.last)!)
        }
        
    }
    //
    func showOrderStatusView(parameter:[String: AnyObject]?) {
        let orderStatus:String = parameter?["code"] as? String ?? ""
        //let message:String = parameter?["message"] as? String ?? ""
        if orderStatus == "100"
        {
            let submitOrderFailureView = SubmitOrderFailureViewController()
            submitOrderFailureView.submitOrderStatus = SubmitOrderFailureViewController.SubmitOrderStatus.Personal_Success_Change
            self.navigationController?.pushViewController(submitOrderFailureView, animated: true)
            
        }else{
            
            //showSystemAlertView(titleStr: "提示", message: message)
            let submitOrderFailureView = SubmitOrderFailureViewController()
            submitOrderFailureView.submitOrderStatus = SubmitOrderFailureViewController.SubmitOrderStatus.Personal_Failure_Change
            self.navigationController?.pushViewController(submitOrderFailureView, animated: true)
        }
        
        
        
        
    }
    
    
    func showFlightCommonSearchView(parameter:[String: AnyObject]?) {
        PCommonFlightManager.shareInStance.resetAllFlightInfo()
        let searchCondition = FlightSVSearchConditionModel()
        searchCondition.arriveAirportCode = parameter?["arriveAirportEn"] as! String
        searchCondition.arriveAirportName = parameter?["arriveAirport"] as! String
        searchCondition.takeOffAirportCode = parameter?["takeoffAirportEn"] as! String
        searchCondition.takeOffAirportName = parameter?["takeoffAirport"] as! String
        searchCondition.travellerUids = parameter?["personId"] as! String
        searchCondition.specialFlightCode =  parameter?["marketAirline"] as! String
        searchCondition.specialOrderId = parameter?["orderId"] as! String
        searchCondition.orderStatus = parameter?["orderStatus"] as! String
        searchCondition.orderNo = parameter?["orderNo"] as! String
        searchCondition.requireDetail = parameter?["ticketChangesInfo"] as! String
        searchCondition.lowestPrice = parameter?["minPrice"] as! String
        let takeOffDateStr:String = parameter?["takeoffTime"] as! String
        let takeOffDate:Date = takeOffDateStr.stringToDate(dateFormat: "yyyy-MM-dd HH:mm")
        searchCondition.departureDateFormat = takeOffDateStr + ":00"
        searchCondition.departureDate = NSInteger(takeOffDate.timeIntervalSince1970) * 1000
        PCommonFlightManager.shareInStance.flightConditionStore(searchConditionArr: [searchCondition])
        let searchView = PFlightViewController()
        searchView.flightViewType = .RebookCommonFlight
        self.navigationController?.pushViewController(searchView, animated: true)
        
    }
    
    
    func showChoicesCameraView(orderId:String) {
        uploadOrderId = orderId
        let alertController = UIAlertController(title: "上传图片", message: "选择图片或者拍照", preferredStyle:.actionSheet)
        weak var weakSelf = self
        let cameraViewAction = UIAlertAction.init(title: "相机", style: UIAlertActionStyle.default) { (alertAction) in
            weakSelf?.intoNextCameraView(sourcesType: .camera, orderId: orderId)
        }
        
        let photoViewAction = UIAlertAction.init(title: "相册", style: UIAlertActionStyle.default) { (alertAction) in
            weakSelf?.intoNextCameraView(sourcesType: .photoLibrary, orderId: orderId)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        // 添加到UIAlertController
        alertController.addAction(cancelAction)
        alertController.addAction(cameraViewAction)
        alertController.addAction(photoViewAction)
        // 弹出
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func intoNextCameraView(sourcesType:UIImagePickerControllerSourceType,orderId:String) {
        
        pickerCamera.sourceType = sourcesType
        pickerCamera.delegate = self
        //pickerCamera.orderId = orderId
       // let navicationiew = UINavigationController.init(rootViewController:personalView)
        //weak var weakSelf = self
//        personalView.photoViewSelectedImageBlock = { selectedImage in
//            weakSelf?.selectedImageView.image = selectedImage
//        }
        self.present(pickerCamera, animated: true, completion: nil)
        //self.navigationController?.pushViewController(personalView, animated: true)
    }
    
    func intoNextPreviewImageView() {
        let personalView = PersonalPhotoViewController()
        personalView.orderId = uploadOrderId
        personalView.selectedImageView = selectedImageView
        personalView.localFileFullPath = localFileFullPath
        self.navigationController?.pushViewController(personalView, animated: true)
        
    }
    
    
    func openSiri(requestUrl:String) {
        guard requestUrl.isEmpty == false else {
            return
        }
                        //let url = NSURL(string:urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        let url:URL = URL.init(string: requestUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
          UIApplication.shared.openURL(url)
    }
    
    
    
    
    func showPaymentView(orderId:String,price:String) {
        weak var weakSelf = self
        let payView:SelectPaymentView = SelectPaymentView(frame:ScreenWindowFrame)
        
        payView.setView(money: price)
        payView.paymentBlock = { btnTag in
            /// btnTag ==0微信支付 1：支付宝
            var paymentType:PaymentType = PaymentType.OtherPay
            switch btnTag {
            case 0:
                paymentType = PaymentType.Wechat
            case 1:
                paymentType = PaymentType.AliPay
            default:
                break
            }
            weakSelf?.choicePaymentType(type:paymentType, orderId: orderId)
            
        }
        KeyWindow?.addSubview(payView)
    }
    
    
    func choicePaymentType(type:PaymentType,orderId:String) {
        switch type {
        case PaymentType.AliPay:
            aliPayOrderInfo(type: type, orderId: orderId)
            break
        case PaymentType.Wechat:
            wechatOrderInfo(type: type, orderId: orderId)
            break
        case PaymentType.Unknow:
            break
        default: break
            
        }
    }
    func wechatOrderInfo(type:PaymentType,orderId:String)  {
        
        weak var weakSelf = self
        PaymentService.sharedInstance
            .wechatPersonalOrderInfo(order: orderId)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                if case .next(let result) = event {
                    print(result)
                    PayManager.sharedInstance.wxPayRequst(order:result)
                }
                if case .error(let result) = event {
                    try? weakSelf?.validateHttp(result)
                }
                
            }.disposed(by: bag)
    }
    
    func aliPayOrderInfo(type:PaymentType,orderId:String)  {
        
        weak var weakSelf = self
        PaymentService.sharedInstance
            .alipayPersonalOrderInfo(order:orderId)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                if case .next(let result) = event {
                    print(result)
                    PayManager.sharedInstance.aliPayRequest(order: result)
                }
                if case .error(let result) = event {
                    try? weakSelf?.validateHttp(result)
                    // weakSelf?.showSystemAlertView(titleStr: "提示", message: String(describing: result))
                }
            }.disposed(by: bag)
    }
    
    
    
    
    //MARK:-------UIImagePickerController--------
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image:UIImage = (info["UIImagePickerControllerOriginalImage"] as? UIImage)!
        selectedImageView.image = image
        
        localFileFullPath = saveImageSuper(image: image, imageName: "pickedimage.png")
        //self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
        picker.dismiss(animated: true, completion: nil)
        intoNextPreviewImageView()
    }
    
    private func saveImageSuper(image:UIImage,imageName:String)->String {
        let imageData:Data = UIImage.resetImgSize(sourceImage: image, maxImageLenght: 1024, maxSizeKB: 1024)
        let cachDir:String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask,true).first!
        let fileFullPath:String =  "file://" + cachDir + "/" + imageName
        let fileURL:URL = URL.init(string:fileFullPath)!
        do {
            try imageData.write(to:fileURL, options: Data.WritingOptions.atomicWrite)
            printDebugLog(message: fileFullPath)
            return fileFullPath
        } catch let error {
            printDebugLog(message: error)
        }
        
        
        return ""
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
