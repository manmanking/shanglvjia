//
//  PhotoViewController.swift
//  shanglvjia
//
//  Created by manman on 2018/8/27.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import Moya

class PersonalPhotoViewController: PersonalBaseViewController{
    
    
    public var orderId:String = ""
    
    
    public var selectedImageView:UIImageView = UIImageView()
    
    public var localFileFullPath:String = ""
    
    fileprivate let bag = DisposeBag()
    
    private let pickerPhoto = UIImagePickerController()
    
    private let selectedImageViewBackgroundView:UIView = UIView()
    
    private var cancelButton:UIButton = UIButton()
    
    private var okayButton:UIButton = UIButton()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeWhite
        setNavigationBackButton(backImage: "BackCircle")
//        let imageView:UIImageView = UIImageView.init(image: image)
//
//        self.view.addSubview(imageView)
//        imageView.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//            make.left.right.equalToSuperview().inset(15)
//            make.top.bottom.equalToSuperview().inset(100)
//        }
        setSelectedImageView()
        //showPhotoView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setSelectedImageView() {
        selectedImageViewBackgroundView.backgroundColor = TBIThemeGrayLineColor
        self.view.addSubview(selectedImageViewBackgroundView)
        selectedImageViewBackgroundView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(100)
            make.left.right.equalToSuperview()
        }
        selectedImageViewBackgroundView.addSubview(selectedImageView)
        selectedImageView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        cancelButton.setTitle("取消", for: UIControlState.normal)
        cancelButton.layer.cornerRadius = 4
        cancelButton.layer.borderWidth = 2
        cancelButton.backgroundColor = PersonalThemeNormalColor
        cancelButton.layer.borderColor = PersonalThemeNormalColor.cgColor
        cancelButton.addTarget(self, action: #selector(cancelAction(sender:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(60)
            make.bottom.equalToSuperview().inset(50)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        okayButton.setTitle("确定", for: UIControlState.normal)
        okayButton.backgroundColor = PersonalThemeNormalColor
        okayButton.layer.cornerRadius = 4
        okayButton.layer.borderWidth = 2
        okayButton.layer.borderColor = PersonalThemeNormalColor.cgColor
        okayButton.addTarget(self, action: #selector(okayButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(okayButton)
        okayButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(60)
            make.bottom.equalToSuperview().inset(50)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        
        // self.view.addSubview(selectedImageViewBackgroundView)
        //self.view.sendSubview(toBack: selectedImageViewBackgroundView)
        //selectedImageViewBackgroundView.isHidden = true
    }
    
    
//
//    func showPhotoView(){
//        pickerPhoto.delegate = self
//        pickerPhoto.sourceType = sourcesType
//
//        //self.navigationController?.pushViewController(pickerPhoto, animated: true)
//        self.present(pickerPhoto, animated: true, completion: nil)
//    }
    
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let image:UIImage = (info["UIImagePickerControllerOriginalImage"] as? UIImage)!
//        selectedImageView.image = image
//
//        localFileFullPath = saveImageSuper(image: image, imageName: "pickedimage.png")
//        //self.navigationController?.popViewController(animated: true)
//        //self.dismiss(animated: true, completion: nil)
//        picker.dismiss(animated: true, completion: nil)
//
//    }

    
//
//    private func saveImageSuper(image:UIImage,imageName:String)->String {
//
//        let imageData:Data = UIImage.resetImgSize(sourceImage: image, maxImageLenght: 1024, maxSizeKB: 1024) //UIImagePNGRepresentation(image)!
//        let cachDir:String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask,true).first!
//        let fileFullPath:String =  "file://" + cachDir + "/" + imageName
//        let fileURL:URL = URL.init(string:fileFullPath)!
//        do {
//            try imageData.write(to:fileURL, options: Data.WritingOptions.atomicWrite)
//            printDebugLog(message: fileFullPath)
//            return fileFullPath
//        } catch let error {
//            printDebugLog(message: error)
//        }
//
//
//        return ""
//    }
//
//
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
    
    //Mark:------Action--------
    
    override func backButtonAction(sender: UIButton) {
        printDebugLog(message: self.navigationController?.childViewControllers)
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
    }
    
    
    
    /// 取消选中
    func cancelAction(sender:UIButton) {
        guard selectedImageViewBackgroundView.isHidden == false else {
            return
        }
        
        selectedImageViewBackgroundView.isHidden = true
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /// 上传
    func okayButtonAction(sender:UIButton) {
            uploadFile()

    }
    
    
    /// 上传文件
    func uploadFile() {
//        if DEBUG {
//            self.dismiss(animated: true, completion: nil)
//            return
//        }
//
        
        weak var weakSelf = self
        //let fileManager = FileManager.default
        
        
        
        //let filePath:String = Bundle.main.path(forResource:"pickedimage.png" , ofType: "image/png") ?? ""
        //(forResource: "test.png", withExtension: "") ?? URL.init(string: "")!
        //let filePath = "\(rootPath)/pickedimage.png"
        //上传图片
        if (localFileFullPath.isEmpty == false){
            //取得NSURL
            //let imageURL = URL(fileURLWithPath: filePath)
            self.showLoadingView()
            PersonalOrderServices.sharedInstance
                .orderVisaUploadFileExpressImage(fileName:localFileFullPath)
                .subscribe { (json) in
                    weakSelf?.hideLoadingView()
                    switch json {
                    case .next(let result):
                        printDebugLog(message: result)
                        if result.isEmpty == false {
                            weakSelf?.updateDeliveryUrl(deliveryUrl: result, orderId:weakSelf?.orderId ?? "" )
                        }
                        
                    case .error(let error):
                        try? weakSelf?.validateHttp(error)
                    case .completed:
                        break
                    }
                }.disposed(by: self.bag)
        }
    }
    
    
    func updateDeliveryUrl(deliveryUrl:String,orderId:String) {
            weak var weakSelf = self
            self.showLoadingView()
            PersonalOrderServices.sharedInstance
                .orderVisaUpdateDelivery(deliveryURL: deliveryUrl, orderId: orderId)
                .subscribe { (json) in
                    weakSelf?.hideLoadingView()
                    switch json {
                    case .next(let result):
                        printDebugLog(message: result)
                        weakSelf?.showSystemAlertView(titleStr: "提示", message: "上传成功", completeBlock: { (alertAction) in
                            weakSelf?.backButtonAction(sender: UIButton())
                        })
                        //weakSelf?.showSystemAlertView(titleStr: "提示", message:""
                        
                    case .error(let error):
                        try? weakSelf?.validateHttp(error)
                    case .completed:
                        break
                    }
                }.disposed(by: self.bag)
        
        
        
    }

    

}
