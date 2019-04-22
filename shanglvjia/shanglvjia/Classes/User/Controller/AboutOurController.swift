//
//  AboutOurController.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

//关于津旅商务
class AboutOurController: CompanyBaseViewController
{

    let contentYOffset:CGFloat = 20+44
    
    let myContentView:UIView = UIView()
    
    let sunContentText_1 = "天津津旅商务信息技术股份有限公司（以下简称“津旅商务”）是天津市国资委下属天津市旅游(控股)集团有限公司全资二级子公司。旅游集团为打造新型现代化服务业，创新“科技+服务”商业模式，于2015年7月16日在天津市滨海高新区滨海科技园注册成立津旅商务，注册资本金3000万元。"
    let sunContentText_2 = "津旅商务是具有“科技研发+互联网平台+实体服务+大数据”于一体的投资型科技服务企业，也是首家国有体制的企业差旅管理服务（TMC）公司，业务涉及范围包括差旅管理、网络租约车、MICE会议会奖、数据整合分析、企业电商等。截至2016年底，公司客户群有跨国外资、央企、大型民营企业及各大国有企业，共计300余家。"
    
    let sunContentText_3 = "作为成立1年之余的科技服务企业，津旅商务积极创新，取得了不菲的成绩。2015年底，被列为天津市国资委上市后备企业之一；2016年，获得国家级高新技术企业、天津市市级高新技术企业、科技型中小企业、双软企业认定，公司核心业务也获得了天津市科技服务业科技重大专项项目立项、市商务委滨海高新区现代服务业综合试点项目立项，以及中国创新创业大赛天津赛区的三等奖；2017年初，公司被天津高新区评为“2016年度现代服务业十强企业”。"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        initView()
    }
    override func backButtonAction(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func initView() -> Void
    {
        //设置Navgation的头部
        setBlackTitleAndNavigationColor(title:"关于津旅商务")
        
        self.view.backgroundColor=TBIThemeWhite
        //设置Content内容
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight - contentYOffset))
        self.view.addSubview(scrollView)
        //scrollView.contentSize = CGSize(width: ScreenWindowWidth, height: -1)
        
        
        scrollView.addSubview(myContentView)
        myContentView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(ScreenWindowWidth)
        }
        
        let topBigTitle = UILabel(text: "关于津旅商务", color: TBIThemePrimaryTextColor, size: 20)
        self.myContentView.addSubview(topBigTitle)
        topBigTitle.snp.makeConstraints{(make)->Void in
            make.left.equalTo(20)
            make.top.equalTo(30)
        }
        
        let imageView_1 = UIImageView(imageName: "about_img_001")
        self.myContentView.addSubview(imageView_1)
        imageView_1.snp.makeConstraints{(make)->Void in
            make.left.equalTo(20)
            make.top.equalTo(topBigTitle.snp.bottom).offset(20)
            make.right.equalTo(-20)
            
            //make.height.equalTo(50)
            let ratioH_W = (imageView_1.image?.size.height)!*1.0/(imageView_1.image?.size.width)!
            make.height.equalTo(ratioH_W*(ScreenWindowWidth - 40))
        }
        
        let subContentLabel_1 = UILabel(text: sunContentText_1, color: TBIThemePrimaryTextColor, size: 16)
        subContentLabel_1.numberOfLines = -1
        
        
        let attributedString1 = NSMutableAttributedString(string: sunContentText_1)
        let paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.alignment = .justified  //设置段落-对齐方式-两端对齐
        paragraphStyle1.lineSpacing = 8
        attributedString1.addAttributes([NSParagraphStyleAttributeName:paragraphStyle1], range:NSMakeRange(0,sunContentText_1.characters.count))
        subContentLabel_1.attributedText = attributedString1
        
        self.myContentView.addSubview(subContentLabel_1)
        subContentLabel_1.snp.makeConstraints{(make)->Void in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(imageView_1.snp.bottom).offset(20)
            
        }
        
        
        
        let imageView_2 = UIImageView(imageName: "about_img_002")
        self.myContentView.addSubview(imageView_2)
        imageView_2.snp.makeConstraints{(make)->Void in
            make.left.equalTo(20)
            make.top.equalTo(subContentLabel_1.snp.bottom).offset(20)
            make.right.equalTo(-20)
            
            //make.height.equalTo(50)
            let ratioH_W = (imageView_1.image?.size.height)!*1.0/(imageView_1.image?.size.width)!
            make.height.equalTo(ratioH_W*(ScreenWindowWidth - 40))
        }
        
        let subContentLabel_2 = UILabel(text: sunContentText_2, color: TBIThemePrimaryTextColor, size: 16)
        subContentLabel_2.numberOfLines = -1
        
        let attributedString2 = NSMutableAttributedString(string: sunContentText_2)
        let paragraphStyle2 = NSMutableParagraphStyle()
        paragraphStyle2.alignment = .justified  //设置段落-对齐方式-两端对齐
        paragraphStyle2.lineSpacing = 8
        attributedString2.addAttributes([NSParagraphStyleAttributeName:paragraphStyle2], range:NSMakeRange(0,sunContentText_2.characters.count))
        subContentLabel_2.attributedText = attributedString2
        
        self.myContentView.addSubview(subContentLabel_2)
        subContentLabel_2.snp.makeConstraints{(make)->Void in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(imageView_2.snp.bottom).offset(20)
        }
        
        
        
        let imageView_3 = UIImageView(imageName: "about_img_003")
        self.myContentView.addSubview(imageView_3)
        imageView_3.snp.makeConstraints{(make)->Void in
            make.left.equalTo(20)
            make.top.equalTo(subContentLabel_2.snp.bottom).offset(20)
            make.right.equalTo(-20)
            
            //make.height.equalTo(50)
            let ratioH_W = (imageView_1.image?.size.height)!*1.0/(imageView_1.image?.size.width)!
            make.height.equalTo(ratioH_W*(ScreenWindowWidth - 40))
        }
        
        let subContentLabel_3 = UILabel(text: sunContentText_3, color: TBIThemePrimaryTextColor, size: 16)
        subContentLabel_3.numberOfLines = -1
        
        let attributedString3 = NSMutableAttributedString(string: sunContentText_3)
        let paragraphStyle3 = NSMutableParagraphStyle()
        paragraphStyle3.alignment = .justified  //设置段落-对齐方式-两端对齐
        paragraphStyle3.lineSpacing = 8
        attributedString3.addAttributes([NSParagraphStyleAttributeName:paragraphStyle3], range:NSMakeRange(0,sunContentText_3.characters.count))
        subContentLabel_3.attributedText = attributedString3
        
        self.myContentView.addSubview(subContentLabel_3)
        subContentLabel_3.snp.makeConstraints{(make)->Void in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(imageView_3.snp.bottom).offset(20)
            
            make.bottom.equalTo(-30)
        }
    }
    
    
}
