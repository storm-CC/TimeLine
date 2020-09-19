//
//  UILabel+.swift
//  timeLine
//
//  Created by stormVCC on 2020/9/18.
//  Copyright © 2020 stormVCC. All rights reserved.
//

import UIKit

extension UILabel{
    /*
     初始化
     
     frame:显示范围
     text:文案
     font:字号
     color:颜色
     alignment:对齐方式
     */
    public convenience init(frame: CGRect,
                            text: String,
                            font: UIFont,
                            textColor: UIColor,
                            textAlignment: NSTextAlignment,
                            lineSpacing:CGFloat) {
        self.init(frame:frame)
        
        self.updateSubviews(text: text,
                            font: font,
                            textColor: textColor,
                            textAlignment: textAlignment,
                            lineSpacing: lineSpacing,
                            numberOfLines: 0)
    }
    
    open func updateSubviews(text: String,
                             font: UIFont,
                             textColor: UIColor,
                             textAlignment: NSTextAlignment,
                             lineSpacing:CGFloat,
                             numberOfLines:Int){
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.paragraphSpacingBefore = 0
        paragraphStyle.headIndent = 0
        paragraphStyle.tailIndent = 0
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineSpacing = lineSpacing
        
        self.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font,NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
    }
}
