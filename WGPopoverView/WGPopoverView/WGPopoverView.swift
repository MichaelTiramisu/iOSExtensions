//
//  WGPopoverView.swift
//  WGPopoverView
//
//  Created by Siyang Liu on 17/3/29.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//

import UIKit

@IBDesignable
class WGPopoverView: UIView {
    // UI的常量
    struct UIConstants {
        static let border: CGFloat = 2.0
        // 线宽只在填充模式为空心(stroke)的时候有效
        static let lineWidth: CGFloat = 2.0
    }

    @IBInspectable
    var cornerRadius: CGFloat = 8.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // 箭头高度
    @IBInspectable
    var arrowHeight: CGFloat = 10.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    // 箭头的水平偏移量
    var arrowHorizontalOffset: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
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
    var shouldStroke: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    // 是否需要填充
    var shouldFill: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        let minX = rect.minX + UIConstants.border
        let maxX = rect.maxX - UIConstants.border
        let midX = (minX + maxX) / 2 + arrowHorizontalOffset
        
        let minY = rect.minY + UIConstants.border
        let maxY = rect.maxY - arrowHeight - UIConstants.border
        
        // 右下角的圆角圆心
        let cornerCenter1 = CGPoint(x: maxX - cornerRadius, y: maxY - cornerRadius)
        // 右上角的圆角圆心
        let cornerCenter2 = CGPoint(x: maxX - cornerRadius, y: minY + cornerRadius)
        // 左上角的圆角圆心
        let cornerCenter3 = CGPoint(x: minX + cornerRadius, y: minY + cornerRadius)
        // 左下角的圆角圆心
        let cornerCenter4 = CGPoint(x: minX + cornerRadius, y: maxY - cornerRadius)
        
        let path = UIBezierPath()
        // 从左边的尖点起笔
        path.move(to: CGPoint(x: midX - arrowHeight, y: maxY))
        // 画到最下边的尖点
        path.addLine(to: CGPoint(x: midX, y: maxY + arrowHeight))
        // 画到左右边的尖点
        path.addLine(to: CGPoint(x: midX + arrowHeight, y: maxY))
        // 画到右下角
        path.addLine(to: CGPoint(x: maxX - cornerRadius, y: maxY))
        // 画右下角的圆角
        path.addArc(withCenter: cornerCenter1, radius: cornerRadius, startAngle: CGFloat(M_PI_2), endAngle: 0, clockwise: false)
        // 画到右上角
        path.addLine(to: CGPoint(x: maxX, y: cornerRadius))
        // 画右上角的圆角
        path.addArc(withCenter: cornerCenter2, radius: cornerRadius, startAngle: 0, endAngle: CGFloat(-M_PI_2), clockwise: false)
        // 画到左上角
        path.addLine(to: CGPoint(x: cornerRadius, y: minY))
        // 画左上角的圆角
        path.addArc(withCenter: cornerCenter3, radius: cornerRadius, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(-M_PI), clockwise: false)
        // 画到左下角
        path.addLine(to: CGPoint(x: minX, y: maxY - cornerRadius))
        // 画左下角的圆角
        path.addArc(withCenter: cornerCenter4, radius: cornerRadius, startAngle: CGFloat(-M_PI), endAngle: CGFloat(-3 * M_PI_2), clockwise: false)
        
        path.close()
        // 设置线宽
        path.lineWidth = UIConstants.lineWidth
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
