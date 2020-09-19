//
//  CCTableViewCell.swift
//  timeLine
//
//  Created by stormVCC on 2020/9/18.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import UIKit

open class CCTableViewCell: UITableViewCell {
    open var value : Any? = nil
    open var separator = CALayer()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
        self.setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
        self.setupSubviews()
    }
    
    @objc open func setup(){
        
        if self.backgroundView == nil {
            self.backgroundView = UIView(frame: CGRect.zero)
            self.backgroundView?.backgroundColor = .white
            self.backgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        separator.backgroundColor = CCHelper.color(235, 235, 240).cgColor
        separator.isHidden = true
        self.backgroundView?.layer.addSublayer(separator)
    }
    
    /// 子类直接重写该方法进行UI视图的初始化和布局
    @objc open func setupSubviews(){
        
    }
    
    
    /// 子类重写该方法进行数据绑定操作
    @objc open func updateSubviews(_ action:String, _ value: Any?){
        
    }
    
    
    @objc open func willDisplay(_ item: Any?) {}
    @objc open func didEndDisplay(_ item: Any?) {}
}
