//
//  WGCircleView.swift
//  WGSegmentedScale
//
//  Created by Siyang Liu on 17/3/29.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//

import UIKit

@IBDesignable
class WGCircleView: UIView {
    
    // UI的常量
    struct UIConstants {
        static let border: CGFloat = 2.0
        // 线宽只在填充模式为空心(stroke)的时候有效
        static let lineWidth: CGFloat = 2.0
    }
    
    // 描边颜色
    @IBInspectable
    var strokeColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // 填充颜色
    @IBInspectable
    var fillColor: UIColor = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    // 是否需要描边
    var shouldStroke: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    // 是否需要填充
    var shouldFill: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }

    
    override func draw(_ rect: CGRect) {
        // 设置背景为透明
        backgroundColor = UIColor.clear
        
        let minX = rect.minX + UIConstants.border
        let maxX = rect.maxX - UIConstants.border
        
        let minY = rect.minY + UIConstants.border
        let maxY = rect.maxY - UIConstants.border
        
        let path = UIBezierPath(ovalIn: CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY))
        
        // 是否描边
        if shouldStroke {
            strokeColor.setStroke()
            path.stroke()
        }
        // 是否填充
        if shouldFill {
            fillColor.setFill()
            path.fill()
        }
    }
    

}
