//
//  TimeLineViewModel.swift
//  timeLine
//
//  Created by stormVCC on 2020/11/10.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct TimeLineViewModel {
    
    let statusBarVM: StatusBarViewModel
    
    
    struct StatusBarViewModel{
        let contentOffSetY: ControlProperty<CGPoint>
    }
    
}


