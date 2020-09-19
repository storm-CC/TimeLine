//
//  CCHelper.swift
//  timeLine
//
//  Created by stormVCC on 2020/9/18.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import UIKit

//辅助类，一些小工具集合，未分离
public class CCHelper {
    //字体:
    public class func font(_ size: CGFloat, _ blod:Bool = false) -> UIFont {
        if blod {
            return UIFont.boldSystemFont(ofSize: size)
        }
        return UIFont.systemFont(ofSize: size)
    }
    
    //颜色:rgb+alpha, rgb:[0,255],a:[0,1]
    public class func color(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat, _ a:CGFloat = 1.0) -> UIColor{
        return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: a)
    }
    
    //颜色：hex+alpha
    public class func color(_ hex:Int, _ a: CGFloat = 1.0) -> UIColor {
        return color(((CGFloat)((hex & 0xFF0000) >> 16)), ((CGFloat)((hex & 0xFF00) >> 8)), ((CGFloat)(hex & 0xFF)), a)
    }
    
    /*
     颜色生成图片
     */
    public class func image(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 1)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let img = UIImage.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
        
        return img
    }
    
    
    public class func updateBarStyle(_ newValue: CCHelper.BarStyle, _ animated:Bool = true){
        let _currentValue = newValue.rawValue
        if _currentValue == CCHelper.BarStyle.hidden.rawValue {
            UIApplication.shared.isStatusBarHidden = true
        }
        else if _currentValue == CCHelper.BarStyle.automatic.rawValue {
            UIApplication.shared.isStatusBarHidden = false
            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: animated)
        }
        else if _currentValue == CCHelper.BarStyle.lightContent.rawValue {
            UIApplication.shared.isStatusBarHidden = false
            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: animated)
        }
        else if _currentValue == CCHelper.BarStyle.darkContent.rawValue {
            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: animated)
        }
    }
}


extension CCHelper{
    /**管理状态栏的样式*/
    public enum BarStyle : Int {
        case none = 0
        case hidden = 1
        case automatic = 2
        case lightContent = 3
        case darkContent = 4
    }
}



