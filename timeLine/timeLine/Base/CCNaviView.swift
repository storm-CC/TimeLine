//
//  CCNaviView.swift
//  timeLine
//
//  Created by stormVCC on 2020/9/18.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import UIKit


//自定义导航栏
open class CCNaviView: CCView {
    open weak var controller : CCViewController?
    
    //导航栏背景
    open var backgroundView = UIImageView.init(frame: .zero)
    //导航栏content
    open var contentView = UIView.init(frame: .zero)
    //默认返回按钮
    open var backBar = CCNaviView.Bar.back(image:UIImage(named: "navi_back_black.png"), title: nil) //默认
    
    open var backView : UIView? {
        willSet{
            backView?.removeFromSuperview()
        }
        didSet {
            self.updateSubviews("", nil)
        }
    }
    
    
    open var title : String = "" {
        didSet {
            self.updateSubviews("", nil)
        }
    }
    //标题
    private var titleView = UILabel(frame: CGRect(x: 75.0, y: CCDevice.naviOffset, width: CCDevice.w-75.0*2, height: CCDevice.topOffset-CCDevice.naviOffset))
    
    //导航栏中间view
    open var centerView : UIView? {
        willSet{
            centerView?.removeFromSuperview()
        }
        didSet {
            self.updateSubviews("", nil)
        }
    }
    
    //导航栏bar
    open var forwardBar: CCNaviView.Bar? {
        didSet {
            self.updateSubviews("", nil)
        }
    }
    
    open var forwardView : UIView? {
        willSet{
            forwardView?.removeFromSuperview()
        }
        didSet {
            self.updateSubviews("", nil)
        }
    }
    
    open var backBarHidden = false
    
    //导航栏分隔线
    open var separator = CALayer()
    
    override open func setupSubviews(){
        super.setupSubviews()
        
        self.backgroundColor = UIColor.clear
        
        //这是整个导航栏的背景颜色
        self.backgroundView.frame = self.bounds
        self.backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backgroundView.backgroundColor = UIColor.clear
        self.backgroundView.image = CCHelper.image(color: CCHelper.color(0xfffff))
        
        //整个导航栏的子控件
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.backgroundColor = UIColor.clear
        
        self.titleView.frame = CGRect(x: 75.0, y: CCDevice.naviOffset, width: self.contentView.w-75.0*2, height: self.contentView.h-CCDevice.naviOffset)
        self.titleView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.titleView.textColor = CCHelper.color(51, 51, 51)
        self.titleView.font = CCHelper.font(17, true)
        self.titleView.textAlignment = .center
        self.contentView.addSubview(self.titleView)
        
        
        self.backBar.addTarget(nil, action: nil, completion:{[weak self] _ in
            self?.controller?.backBarAction()
        })
        self.backBar.autoresizingMask = [.flexibleHeight]
        self.backBar.frame = CGRect(x: 15, y: CCDevice.naviOffset, width: self.backBar.w, height: self.contentView.h-CCDevice.naviOffset)
        self.backBar.isHidden = true
        self.contentView.addSubview(self.backBar)
        
        self.separator.frame = CGRect(x: 0, y: self.contentView.h-CCDevice.pixel, width: self.contentView.w, height: CCDevice.pixel)
        self.separator.backgroundColor = CCHelper.color(235, 235, 240).cgColor
        self.separator.isHidden = true
        self.contentView.layer.addSublayer(self.separator)
    }
    
    open override func updateSubviews(_ action:String, _ value:Any?){
        self.separator.frame = CGRect(x: 0, y: self.contentView.h-CCDevice.pixel, width: self.contentView.w, height: CCDevice.pixel)
        
        
        let size = backBar.frame.size
        backBar.frame = CGRect(x: 15, y: CCDevice.naviOffset+(self.contentView.h-CCDevice.naviOffset-size.height)/2, width: size.width, height: size.height)
        
        if let controller = self.controller,
            let viewControllers = self.controller?.navigationController?.viewControllers,
            let index = viewControllers.firstIndex(of: controller), index >= 1 {
            self.backBar.isHidden = self.backBarHidden
        }
        
        
        
        if let backView = self.backView {
            let size = backView.frame.size
            backView.frame = CGRect(x: 15, y: CCDevice.naviOffset+(self.contentView.h-CCDevice.naviOffset-size.height)/2, width: size.width, height: size.height)
            if backView.superview == nil {
                self.contentView.addSubview(backView)
            }
            self.backBar.isHidden = true
        }
        
        if self.title.count > 0 {
            self.titleView.text = self.title
        }
        else if let title = self.controller?.title, title.count > 0 {
            self.titleView.text = title
        }
        
        if let centerView = self.centerView {
            let size = centerView.frame.size
            centerView.frame = CGRect(x: centerView.x, y: CCDevice.naviOffset+(self.contentView.h-CCDevice.naviOffset-size.height)/2, width: size.width, height: size.height)
            if centerView.superview == nil {
                self.contentView.addSubview(centerView)
            }
            self.titleView.isHidden = true
        }
        
        
        if let forwardView = self.forwardView {
            let size = forwardView.frame.size
            forwardView.frame = CGRect(x: self.contentView.w-15-size.width, y: CCDevice.naviOffset+(self.contentView.h-CCDevice.naviOffset-size.height)/2, width: size.width, height: size.height)
            if forwardView.superview == nil {
                self.contentView.addSubview(forwardView)
            }
        }
        else if let forwardBar = self.forwardBar {
            let size = forwardBar.frame.size
            forwardBar.frame = CGRect(x: self.contentView.w-15-size.width, y: CCDevice.naviOffset+(self.contentView.h-CCDevice.naviOffset-size.height)/2, width: size.width, height: size.height)
            if forwardBar.superview == nil {
                self.contentView.addSubview(forwardBar)
            }
        }
    }
}



extension CCNaviView{
    
    open class Wrapper {
        
        public init(){}
        
        ///记录点击事件的变量
        weak var target : NSObject?
        public var selector : Selector?
        ///ui
        public var image: UIImage?
        public var title : String?
        
        
        ///记录owner
        weak var owner: CCNaviView.Bar?
        ///block
        public var completion : ((_ owner: CCNaviView.Bar) -> ())?
        ///采用block方式添加点击事件
        open func update(_ owner:CCNaviView.Bar, completion:((_ owner: CCNaviView.Bar) -> ())?){
            self.owner = owner
            self.completion = completion
            owner.addTarget(self, action: #selector(callback), for: .touchUpInside)
        }
        
        @objc open func callback(){
            if let __owner = self.owner {
                self.completion?(__owner)
            }
        }
    }
    
    open class Bar: UIButton {
        open var dicValue : [String: Any]?
        public let wrapper = CCNaviView.Wrapper()
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = UIColor.clear
            self.setupSubviews()
        }
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.backgroundColor = UIColor.clear
            self.setupSubviews()
        }
        
        open func setupSubviews(){
            self.frame.size = CGSize(width:70.0, height:44.0)
            self.setTitleColor(CCHelper.color(51, 51, 51), for: .normal)
            self.setTitleColor(CCHelper.color(153, 153, 153), for: .highlighted)
            self.titleLabel?.font = CCHelper.font(16)
        }
        
        open class  func back(image: UIImage?, title: String?) -> CCNaviView.Bar {
            let element = CCNaviView.Bar(frame: CGRect.zero)
            element.contentHorizontalAlignment = .left
            element.updateSubviews(image, title)
            return element
        }
        
        open class  func back(image: UIImage?, title: String?, target:Any?, action:Selector?) -> CCNaviView.Bar {
            let element = CCNaviView.Bar.back(image:image, title:title)
            element.addTarget(target, action:action, completion:nil)
            return element
        }
        
        open class func back(image: UIImage?, title: String?, completion:((_ owner:CCNaviView.Bar) -> ())?) -> CCNaviView.Bar {
            let element = CCNaviView.Bar.back(image:image, title:title)
            element.addTarget(nil, action:nil, completion:completion)
            return element
        }
        
        open class func forward(image: UIImage?, title: String?) -> CCNaviView.Bar {
            let element = CCNaviView.Bar(frame: CGRect.zero)
            element.contentHorizontalAlignment = .right
            element.updateSubviews(image, title)
            return element
        }
        
        open class func forward(image: UIImage?, title: String?, target:Any?, action:Selector?) -> CCNaviView.Bar {
            let element = CCNaviView.Bar.forward(image:image, title:title)
            element.addTarget(target, action:action, completion:nil)
            return element
        }
        
        open class func forward(image: UIImage?, title: String?, completion:((_ owner:CCNaviView.Bar) -> ())?) -> CCNaviView.Bar {
            let element = CCNaviView.Bar.forward(image:image, title:title)
            element.addTarget(nil, action:nil, completion:completion)
            return element
        }
        
        open func addTarget(_ target: Any?, action: Selector?, completion:((_ owner:CCNaviView.Bar) -> ())?) {
            if let __completion = completion {
                self.wrapper.update(self, completion: __completion)
            }
            else {
                if self.wrapper.target != nil && self.wrapper.selector != nil {
                    self.removeTarget(self.wrapper.target, action: self.wrapper.selector, for: UIControl.Event.touchUpInside)
                }
                if let __action = action {
                    super.addTarget(target, action: __action, for: UIControl.Event.touchUpInside)
                }
                self.wrapper.target = target as? NSObject
                self.wrapper.selector = action
            }
        }
        
        open func updateSubviews(_ image: UIImage?, _ title:String?){
            self.wrapper.image = image
            self.wrapper.title = title
            
            self.setImage(image, for: .normal)
            self.setTitle(title, for: .normal)
        }
    }
}
