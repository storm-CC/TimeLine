//
//  TimeLineController.swift
//  timeLine
//
//  Created by stormVCC on 2020/9/18.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import UIKit

class TimeLineController: CCTableController {
    
    public var datas: (tweets: TimeLineTweets?, sender: TimeLineTweet.TimeLineSender?)?
    private var vm: TimeLineViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        
        vm = TimeLineViewModel.init(statusBarVM: TimeLineViewModel.StatusBarViewModel.init(contentOffSetY: tableView!.rx.contentOffset))
        if datas?.sender == nil {
            TimeLineTweets.getSender { (sender) in
                self.datas?.sender = sender
            }
        }
        
        if datas?.tweets == nil {
            TimeLineTweets.getInfo { (tws) in
                self.datas?.tweets = tws
            }
        }
    }
    
    private func customInit(){
        self.naviView.backBar.updateSubviews(UIImage(named: "navi_back_white"), nil)
        self.naviView.titleView.alpha = 0.0
        self.naviView.backgroundView.alpha = 0.0
    }
    
}



//导航栏滑动处理
extension TimeLineController{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        
        let value: CGFloat = 20.0
        
        let alpha = max(contentOffsetY-200, 0) / value
        
        self.naviView.backgroundView.alpha = min(alpha, 1.0)
        
        if contentOffsetY > 200{
            self.ctxs.statusBarStyle = .darkContent
            self.naviView.titleView.text = "朋友圈"
        }else{      //默认情况
            self.ctxs.statusBarStyle = .lightContent
            self.naviView.titleView.text = ""
        }
        
        CCHelper.updateBarStyle(self.ctxs.statusBarStyle)
    }
}
