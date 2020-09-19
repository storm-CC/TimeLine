//
//  CCTableReusableView.swift
//  timeLine
//
//  Created by stormVCC on 2020/9/18.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import UIKit

open class CCTableReusableView: UITableViewHeaderFooterView {
    open var value : Any? = nil
    required public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    @objc open func setupSubviews(){
        let __backgroundView = UIView(frame: self.bounds)
        __backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        __backgroundView.backgroundColor = UIColor.clear
        self.backgroundView = __backgroundView
        
        self.contentView.backgroundColor = UIColor.clear
    }
    
    @objc open func updateSubviews(_ action:String, _ value: Any?) {
        if let element = value as? CCItem {
            self.value = element
            self.contentView.backgroundColor = element.ctxs.backgroundColor ?? UIColor.clear
        }
    }
    
    @objc open func willDisplay(_ data: Any?){
    
    }
    
    @objc open func didEndDisplay(_ data: Any?){
    
    }
}
