//
//  UIView+Frame.swift
//  timeLine
//
//  Created by stormVCC on 2020/9/18.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import UIKit



extension UIView {
    open var x : CGFloat {
        set(x){
            var __frame = self.frame
            __frame.origin.x = x
            self.frame = __frame
        }
        get{
            return self.frame.origin.x
        }
    }
    
    open var y : CGFloat {
        set(y){
            var __frame = self.frame
            __frame.origin.y = y
            self.frame = __frame
        }
        get{
           return self.frame.origin.y
        }
    }
    
    open var w : CGFloat {
        set(w){
            var __frame = self.frame
            __frame.size.width = w
            self.frame = __frame
        }
        get{
            return self.frame.size.width
        }
    }
    
    open var h : CGFloat {
        set(h){
            var __frame = self.frame
            __frame.size.height = h
            self.frame = __frame
        }
        get{
           return self.frame.size.height
        }
    }
    
    open var maxX : CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }
    
    open var maxY : CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
}
