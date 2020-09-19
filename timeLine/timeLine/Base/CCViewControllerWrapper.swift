//
//  CCViewControllerWrapper.swift
//  timeLine
//
//  Created by stormVCC on 2020/9/18.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import Foundation


open class CCViewControllerWrapper {
    open var index : Int = 0 ///用于记录当前正在请求或者展示的页面index，多用于分页加载
    open var next : Int = 1  ///用于记录下一页的索引值
    
    ///页面是否为空，如有缓存数据则可置为false。false不用展示加载动画
    open var isEmpty : Bool = true
    
    open var statusBarStyle = CCHelper.BarStyle.darkContent
    
    ///页面加载完毕触发(触发后会强制置为nil)
    open var callbackViewAppeared: (() -> ())?
}
