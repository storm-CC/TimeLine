//
//  ViewController.swift
//  timeLine
//
//  Created by stormVCC on 2020/9/18.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import UIKit

class ViewController: CCViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = CCButton.init(CGRect(x: self.contentView.center.x-50, y: self.contentView.center.y-50, width: 100, height: 100), image: nil, backgroundImage: UIImage(named: "wx"), title: nil, titleColor: .clear, titleFont: UIFont.systemFont(ofSize: 0), data: nil)
        btn.addTarget(self, action: #selector(wxClick), for: .touchUpInside)
        self.contentView.addSubview(btn)
        
    }

    @objc func wxClick(){
        let vc = TimeLineController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

