//
//  CCTableWrapper.swift
//  timeLine
//
//  Created by stormVCC on 2020/9/18.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import UIKit

class CCTableWrapper: CCCollection {
    //表视图样式
    open var tableViewStyle = UITableView.Style.grouped
    //视图
    open weak var tableView : CCTableView?
    //是否展示第一个section的头部
    open var showsFirstSectionHeader = false
    //是否显示最后一个section的尾部
    open var showsLastSectionFooter = false

    
    open func heightForHeader(at index: Int) -> CGFloat {
        if let header = self[index]?.header {
            
            //1.根据自身的高度赋值拿到header的高度
            if header.ctxs.h > 0 {
                return header.ctxs.h
            }
        }
        return 0.0
    }
    
    
    open func heightForRow(at indexPath: IndexPath) -> CGFloat {
        if let element = self[indexPath] {
            return element.ctxs.h
            
            //此处可返回自适应单元格高度
        }
        
        return 0.0
    }
    
    
    open func heightForFooter(at index: Int) -> CGFloat {
        if let footer = self[index]?.footer {
            //1.根据自身的高度赋值拿到header的高度
            if footer.ctxs.h > 0 {
                return footer.ctxs.h
            }
        }
        return 0.0
    }
}
