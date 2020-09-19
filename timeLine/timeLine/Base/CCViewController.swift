//
//  CCViewController.swift
//  timeLine
//
//  Created by stormVCC on 2020/9/18.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import UIKit

open class CCViewController: UIViewController {
    //用于记录分页加载，或者自定义跳转等。
    public let ctxs = CCViewControllerWrapper()
    
    ///导航栏
    public let naviView = CCNaviView(frame: CGRect(x: 0, y: 0, width: CCDevice.w, height: CCDevice.topOffset))
    ///内容视图，不会被导航栏覆盖
    public let contentView = UIView(frame: CGRect(x: 0, y: CCDevice.topOffset, width: CCDevice.w, height: CCDevice.h-CCDevice.topOffset))
    
    
    ///子类中有需要在viewDidLoad之前的逻辑放在这个函数中，而不用重写构造函数
    open func setup() {
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = UIRectEdge.all
        if #available(iOS 11.0, *) {
        }
        else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CCHelper.color(247, 247, 247)
        
        self.contentView.frame = CGRect(x: 0, y: CCDevice.topOffset, width: self.view.w, height: self.view.h-CCDevice.topOffset)
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.backgroundColor = self.view.backgroundColor
        self.view.addSubview(self.contentView)
        
        self.naviView.frame = CGRect(x: 0, y: 0, width: self.view.w, height: CCDevice.topOffset)
        self.naviView.autoresizingMask = [.flexibleWidth]
        self.naviView.controller = self
        self.view.addSubview(self.naviView)
        self.naviView.updateSubviews("", nil)
    }
    
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateNavigationBar()
    }
    
    open override var prefersStatusBarHidden: Bool {
        return self.ctxs.statusBarStyle.rawValue == CCHelper.BarStyle.hidden.rawValue
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //在这里回调告知新的视图控制器已经加载完毕，用于在某些特殊场景移除上一个页面
        if let callbackViewAppeared = self.ctxs.callbackViewAppeared {
            callbackViewAppeared()
            self.ctxs.callbackViewAppeared = nil
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //创建视图:父类不会自动调用
    open func setupSubviews(){
        
    }
    
    //更新视图：父类不会自动调用
    open func updateSubviews(_ action: String, _ entities: [String:Any]?){
        
    }
    
    open func updateNavigationBar(){
        CCHelper.updateBarStyle(self.ctxs.statusBarStyle)
    }
    
    //返回按钮点击
    open func backBarAction(){
        close()
    }
    
    open func close(){
        if let _ = self.navigationController?.popViewController(animated: true) {
            
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //开始网络请求：处理加载框的开启/关闭,网络异常,参数异常等情况
    open func actionHTTPRequest(_ completion:((_ action: String, _ value: Any) -> ())? = nil){
    
    }
    
    //处理数据正确返回的情况
    open func endHTTPRequest(_ entities: [String: Any]?){
        
    }
}
