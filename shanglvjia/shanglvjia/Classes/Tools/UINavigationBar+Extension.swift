//
//  UINavigationBar+Extension.swift
//  shop
//
//  Created by TBI on 2018/1/17.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit


// MARK: -
// MARK: -
// MARK: -
extension UINavigationBar {
    // MARK: - 接口
    /**
     *  隐藏导航栏下的横线，背景色置空 viewWillAppear调用
     */
    func star() {
        let shadowImg: UIImageView? = self.findNavLineImageViewOn(view: self)
        shadowImg?.isHidden = true
        self.backgroundColor = nil
    }

    /**
     在func scrollViewDidScroll(_ scrollView: UIScrollView)调用
     @param color 最终显示颜色
     @param scrollView 当前滑动视图
     @param value 滑动临界值，依据需求设置
     */
    func homeChange(_ color: UIColor, with scrollView: UIScrollView, andValue value: CGFloat) {
        let image: UIImage? = imageColor()
        self.setBackgroundImage(image, for: .default)
//        if scrollView.contentOffset.y <= -value{
//            // 下拉时导航栏隐藏，无所谓，可以忽略
//            //self.isHidden = true
//            //设置一个颜色并转化为图片
//            let image: UIImage? = imageColor()
//            self.setBackgroundImage(image, for: .default)
//        } else {
//            //self.isHidden = false
//            // 计算透明度
//            let alpha: CGFloat = (scrollView.contentOffset.y + 64) / value > 1.0 ? 1 : (scrollView.contentOffset.y + 64) / value
//            //设置一个颜色并转化为图片
//            let image: UIImage? = imageFromColor(color: color.withAlphaComponent(alpha))
//            self.setBackgroundImage(image, for: .default)
//        }
    }
    
    
    
    /**
     在func scrollViewDidScroll(_ scrollView: UIScrollView)调用
     @param color 最终显示颜色
     @param scrollView 当前滑动视图
     @param value 滑动临界值，依据需求设置
     */
    func change(_ color: UIColor, with scrollView: UIScrollView, andValue value: CGFloat) {
        let alpha: CGFloat = scrollView.contentOffset.y / value > 1.0 ? 1 : scrollView.contentOffset.y / value
        if scrollView.contentOffset.y <= -value{
            let image: UIImage? = imageFromColor(color: color.withAlphaComponent(0))
            self.setBackgroundImage(image, for: .default)
        } else {
            //设置一个颜色并转化为图片
            let image: UIImage? = imageFromColor(color: color.withAlphaComponent(alpha))
            self.setBackgroundImage(image, for: .default)
        }
    }

    /**
     *  还原导航栏  viewWillDisAppear调用
     */
    func reset() {
        let shadowImg = findNavLineImageViewOn(view: self)
        shadowImg?.isHidden = false
        self.setBackgroundImage(nil,for: .default)
    }


    // MARK: - 其他内部方法
    //寻找导航栏下的横线  （递归查询导航栏下边那条分割线）
    fileprivate func findNavLineImageViewOn(view: UIView) -> UIImageView? {
        if (view.isKind(of: UIImageView.classForCoder())  && view.bounds.size.height <= 1.0) {
            return view as? UIImageView
        }
        for subView in view.subviews {
            let imageView = findNavLineImageViewOn(view: subView)
            if imageView != nil {
                return imageView
            }
        }
        return nil
    }

    // 通过"UIColor"返回一张“UIImage”
    fileprivate func imageFromColor(color: UIColor) -> UIImage {
        //创建1像素区域并开始图片绘图
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)

        //创建画板并填充颜色和区域
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)

        //从画板上获取图片并关闭图片绘图
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }
    
    
    /// 用图片设置导航栏颜色
    ///
    /// - Parameter color: 颜色
    func setNavigationColor (color:UIColor,alpha:CGFloat) {
        let image: UIImage? = imageFromColor(color: color.withAlphaComponent(alpha))
        self.setBackgroundImage(image, for: .default)
    }
    
    
    // 通过填充颜色返回一张“UIImage”
    fileprivate func imageColor() -> UIImage {
        //创建1像素区域并开始图片绘图
        let rect = CGRect(x: 0, y: 0, width: self.bounds.width, height: BaseViewController.navBarBottom())
        UIGraphicsBeginImageContext(rect.size)
        
        
        //创建画板并填充颜色和区域
        let context = UIGraphicsGetCurrentContext()
        
        //使用rgb颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        //颜色数组（这里使用三组颜色作为渐变）fc6820
        let compoents:[CGFloat] = [0, 0, 0, 0.8,
                                   0, 0, 0, 0.4,
                                   0, 0, 0, 0]
        //没组颜色所在位置（范围0~1)
        let locations:[CGFloat] = [0,0.5,1]
        //生成渐变色（count参数表示渐变个数）
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: compoents,
                                  locations: locations, count: locations.count)!
        //渐变开始位置
        let start = CGPoint(x: self.bounds.minX, y: self.bounds.minY)
        //渐变结束位置
        //let end = CGPoint(x: self.bounds.maxX, y: self.bounds.minY)
        let end = CGPoint(x: self.bounds.minX, y: BaseViewController.navBarBottom())
        //绘制渐变
        context!.drawLinearGradient(gradient, start: start, end: end,
                                   options: .drawsAfterEndLocation)
        
        //从画板上获取图片并关闭图片绘图
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
}
