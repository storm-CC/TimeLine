//
//  CCTableController.swift
//  timeLine
//
//  Created by stormVCC on 2020/9/18.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import UIKit

class CCTableController: CCViewController{
    
    //表视图
    open var tableView: CCTableView? = nil
    //数据源管理对象
    public let tableWrapper = CCTableWrapper()

    
    override open func setup() {
        super.setup()
        self.ctxs.index = 1 //用以记录分页加载的索引（从1开始）
        self.ctxs.next = 1 //记录下一页的索引
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //tableView
        self.tableView = CCTableView(frame: self.contentView.bounds, style: tableWrapper.tableViewStyle)
        self.tableView?.frame = self.contentView.bounds
        self.tableView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView?.backgroundColor = .white
        self.tableView?.separatorColor = CCHelper.color(235, 235, 240)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.separatorStyle = .singleLine
        self.tableView?.tableFooterView?.frame = CGRect(x: 0, y: 0, width: self.contentView.w, height: 24)
        self.tableView?.contentInsetAdjustmentBehavior = .never
        
        self.contentView.addSubview(self.tableView!)

        tableView?.tableWrapper = self.tableWrapper
        self.tableWrapper.tableView = tableView
    }

}


extension CCTableController: UITableViewDelegate, UITableViewDataSource{
    //分组个数
    open func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableWrapper.count
    }
    
    //各组单元格个数
    open func tableView(_ tableView: UITableView, numberOfRowsInSection index: Int) -> Int {
        if let section = self.tableWrapper[index] {
            return section.count
        }
        return 0
    }
    
    //分组的头部：高度和视图
    open func tableView(_ tableView: UITableView, heightForHeaderInSection index: Int) -> CGFloat {
        if index == 0 && self.tableWrapper.showsFirstSectionHeader == false {
            return 0.0
        }
        return self.tableWrapper.heightForHeader(at: index)
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection index: Int) -> UIView? {
        if index == 0 && self.tableWrapper.showsFirstSectionHeader == false {
            return nil
        }
        
        if let header = self.tableWrapper[index]?.header {
            if let cls = header.ctxs.cls as? CCTableReusableView.Type {
                let reusableView = cls.init(reuseIdentifier:header.ctxs.reuse)
                reusableView.updateSubviews("update", header)
                return reusableView
            }
            else if let cls = header.ctxs.cls as? UIView.Type {
                return cls.init()
            }
        }
        
        return nil
    }
    
    //中间的单元格：高度和视图
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableWrapper.heightForRow(at: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let rs = self.tableWrapper.dequeue(self.tableView, indexPath) {
            rs.cell.updateSubviews("update", rs.element)
            return rs.cell
        }
        return CCTableViewCell()
    }
    
    //点击事件
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
