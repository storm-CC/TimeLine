//
//  UIImage+WebCache.swift
//  timeLine
//
//  Created by stormVCC on 2020/11/11.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import Foundation
import UIKit

/**
 1.用runtime取出uiimage的imageSetter属性，如果没取到，就创建一个imageSetter然后使用runtime设置给UIImage，
 2.如果
 */


public extension UIImageView{
    func cc_setImageWithUrl(_ url: URL?, placeHolder: UIImage? = nil){
        image = placeHolder
        
    }
}


var lastUrlKey = 0
fileprivate extension UIImageView{
    
    func cc_getImageUrl() -> URL?{
        return objc_getAssociatedObject(self, &lastUrlKey) as? URL
    }
    
    func cc_setImageUrl(url: URL){
        objc_setAssociatedObject(self, &lastUrlKey, url, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
