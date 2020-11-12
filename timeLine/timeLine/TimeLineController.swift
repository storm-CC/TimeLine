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
//    private var vm: TimeLineViewModel?
    
    private var notifyGroup = DispatchGroup.init()
    
    convenience init(datas: (tweets: TimeLineTweets?, sender: TimeLineTweet.TimeLineSender?)?) {
        self.init()
        self.datas = datas
        
        notifyGroup.enter()
        notifyGroup.notify(queue: DispatchQueue.main) {
            self.setupUI()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        if datas?.sender == nil {
            notifyGroup.enter()
            TimeLineTweets.getSender { (sender) in
                self.datas?.sender = sender
                self.notifyGroup.leave()
            }
        }
        if datas?.tweets == nil {
            notifyGroup.enter()
            TimeLineTweets.getInfo { (tws) in
                self.datas?.tweets = tws
                self.notifyGroup.leave()
            }
        }
        notifyGroup.leave()
    }
    
    private func customInit(){
        self.naviView.backBar.updateSubviews(UIImage(named: "navi_back_white"), nil)
        self.naviView.backgroundView.isHidden = false
        self.naviView.backgroundView.alpha = 0
        self.naviView.titleView.alpha = 0
        self.naviView.title = "朋友圈"
        self.contentView.frame = self.view.bounds
        self.tableView?.backgroundColor = .white
        
    }
    
    private func setupUI(){
        self.tableView?.tableHeaderView = tableViewHeader()
    }
    
    private func tableViewHeader() -> UIView?{
        guard let _datas = self.datas?.sender else { return nil}
        let header = UIView.init(frame: CGRect(x: 0, y: 0, width: CCDevice.w, height: 450.w()))
        
        let bgImgView = UIImageView.init(frame: CGRect(x: 0, y: -100.w(), width: CCDevice.w, height: 350.w()))
        bgImgView.backgroundColor = .gray
        bgImgView.setImageWith(URL(string: _datas.profileImage), placeholder: nil, options: YYWebImageOptions.refreshImageCache)
        header.addSubview(bgImgView)
        
        let avatarView = UIImageView.init(frame: CGRect(x: CCDevice.w-100, y: bgImgView.maxY-70, width: 100, height: 100))
        avatarView.setImageWith(URL(string: _datas.avatar), placeholder: nil, options: YYWebImageOptions.refreshImageCache) { (image, url, type, stage, error) in
            print("type == \(type), stage == \(stage)")
        }
        header.addSubview(avatarView)
        return header
    }
    
    deinit {
        print("dealloc", self)
    }
}



//导航栏滑动处理
extension TimeLineController{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let value: CGFloat = 20.0
        let alpha = max(contentOffsetY-150, 0) / value
        self.naviView.backgroundView.alpha = min(alpha, 1.0)
        self.naviView.titleView.alpha = min(alpha, 1.0)
        if contentOffsetY > 150{
            self.ctxs.statusBarStyle = .darkContent
            self.naviView.backBar.updateSubviews(UIImage(named: "navi_back_black"), nil)
        }else{      //默认情况
            self.ctxs.statusBarStyle = .lightContent
            self.naviView.backBar.updateSubviews(UIImage(named: "navi_back_white"), nil)
        }
        CCHelper.updateBarStyle(self.ctxs.statusBarStyle)
    }
}
