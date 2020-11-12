//
//  ViewController.swift
//  timeLine
//
//  Created by stormVCC on 2020/9/18.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import UIKit
import Moya

class MainController: CCViewController {
    
    private var datas: (tweets: TimeLineTweets?, sender: TimeLineTweet.TimeLineSender?) = (nil, nil)
    
    
    var requests = [Cancellable]()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        requests.forEach { (c) in
            c.cancel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = CCButton.init(CGRect(x: self.contentView.center.x-50, y: self.contentView.center.y-50, width: 100, height: 100), image: nil, backgroundImage: UIImage(named: "wx"), title: nil, titleColor: .clear, titleFont: UIFont.systemFont(ofSize: 0), data: nil)
        btn.addTarget(self, action: #selector(wxClick), for: .touchUpInside)
        self.contentView.addSubview(btn)
        
        requests.append(TimeLineTweets.getInfo {[weak self] (tws) in
            self?.datas.tweets = tws
        })
        
        requests.append(TimeLineTweets.getSender {[weak self] (sender) in
            self?.datas.sender = sender
        })
        
    }

    @objc func wxClick(){
        let vc = TimeLineController.init(datas: datas)
        AppDelegate.navController.pushViewController(vc, animated: true)
    }

}

