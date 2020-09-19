
//
//  CCTableView.swift
//  timeLine
//
//  Created by stormVCC on 2020/9/18.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import UIKit

class CCTableView: UITableView {
    open var backdropView : UIImageView? = nil
    weak open var tableWrapper : CCTableWrapper?

    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubviews()
    }
    
    open func setupSubviews(){
        self.estimatedRowHeight = 0
        self.estimatedSectionFooterHeight = 0
        self.estimatedSectionHeaderHeight = 0
        self.backgroundColor = .white
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.separatorColor = CCHelper.color(235, 235, 240)
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        if style == .plain {
            self.sectionHeaderHeight = 0
            self.sectionFooterHeight = 0
        }
        else {
            self.sectionHeaderHeight = 10
            self.sectionFooterHeight = 0
        }
        self.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: CCDevice.w, height: 0.01))
        self.tableHeaderView?.backgroundColor = UIColor.clear
        
        self.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: CCDevice.w, height: 0.01))
        self.tableFooterView?.backgroundColor = UIColor.clear
    }
    
    override open var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    
    //是否显示默认图
    open func updateSubviews(_ placeholderDisplay : Bool, _ relationshipRecalculation:Bool) {
        self.reloadData()
    }
    
    //加载的时候看是否需要显示默认图
    override open func reloadData() {
        
        /**
        
         此处展示tableView的placeHolder，删减～
         
         if let __tableWrapper = self.tableWrapper {
            if __tableWrapper.sections.isEmpty {
                
                if __tableWrapper.placeholderView.wrapper.isHidden == false {

                    var size  = CGSize(width: CCDevice.w, height: 0)
                    if __tableWrapper.placeholderView.wrapper.frame.width > 0 && __tableWrapper.placeholderView.wrapper.frame.height > 0 {
                        size.height = __tableWrapper.placeholderView.wrapper.frame.height
                    }
                    else {
                        var ___remainder = self.h - (self.tableHeaderView?.h ?? 0) - (self.tableFooterView?.h ?? 0)
                        ___remainder = ___remainder - self.contentInset.top - self.contentInset.bottom
                        size.height = max(___remainder, 250)
                    }
                    __tableWrapper.addPlaceholderView(CGRect(origin: CGPoint.zero, size: size))
                }
            }
            
            if __tableWrapper.relationshipRecalculation {
                __tableWrapper.sections.forEach { (__section) in
                    __section.elements.forEach { (__element) in
                        __element.ctxs.at.first = false
                        __element.ctxs.at.last = false
                    }
                    __section.elements.first?.ctxs.at.first = true
                    __section.elements.last?.ctxs.at.last = true
                }
            }
        }
        */
        super.reloadData()
    }
}
