//
//  WGSegmentedScale.swift
//  WGSegmentedScale
//
//  Created by Siyang Liu on 17/3/29.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//

import UIKit

@IBDesignable
class WGSegmentedScale: UIView {
    
    // 代理变量
    public weak var delegate: WGSegmentedScaleDelegate?
    
    private var circle = WGCircleView()
    // 记录圆是否在移动
    private var isMoving = false
    // 记录触摸点的上一个位置
    private var lastPostion = CGPoint.zero
    
    // 一些UI常量
    struct UIConstants {
        static let horizontalBorder: CGFloat = 25.0
        static let verticalBorder: CGFloat = 2.0
        // 竖线的长度, 也就是每一段的高度
        static let segmentHeight: CGFloat = 6.0
        // 圆的半径
        static let diameter: CGFloat = 30.0
        // 圆移动的速度pixel/s
        static let moveSpeed: CGFloat = 300.0
    }

    // 总共的段数
    @IBInspectable
    var numberOfSegments: Int = 5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // 选中的索引
    @IBInspectable
    var selectedIndex: Int {
        set {
            _selectedIndex = max(min(newValue, numberOfSegments - 1), 0)
            slideToIndex(_selectedIndex)
        }
        get {
            return _selectedIndex
        }
    }
    
    private var _selectedIndex: Int = 0
    
    // 每一段的长度
    var segmentLength: CGFloat {
        let minX = bounds.minX + UIConstants.horizontalBorder
        let maxX = bounds.maxX - UIConstants.horizontalBorder
        return (maxX - minX) / CGFloat(numberOfSegments - 1)
    }
        
    
    // MARK: - 画图的方法
    override func draw(_ rect: CGRect) {
        let minX = rect.minX + UIConstants.horizontalBorder
        let maxX = rect.maxX - UIConstants.horizontalBorder
        
        let minY = rect.minY + UIConstants.verticalBorder
        let maxY = rect.maxY - UIConstants.verticalBorder
        let midY = (minY + maxY) / 2
        
        let path = UIBezierPath()
        
        // 先画一条长的横线
        path.move(to: CGPoint(x: minX, y: midY))
        path.addLine(to: CGPoint(x: maxX, y: midY))
        
        // 再画每一条竖线
        for i in 0..<numberOfSegments {
            let x = segmentLength * CGFloat(i) + UIConstants.horizontalBorder
            path.move(to: CGPoint(x: x, y: midY - UIConstants.segmentHeight / 2))
            path.addLine(to: CGPoint(x: x, y: midY + UIConstants.segmentHeight / 2))
        }
        // 添加圆
        self.addSubview(circle)
        circle.frame = CGRect(x: 0, y: 0, width: UIConstants.diameter, height: UIConstants.diameter)
        let circleX = segmentLength * CGFloat(_selectedIndex) + UIConstants.horizontalBorder
        circle.center = CGPoint(x: circleX, y: midY)
        
        path.stroke()
    }
    
    // MARK: - 点击的事件处理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentPosition = touches.first!.location(in: self)
        // 判断点是否在可滑动区域
        if isPointInControlZone(currentPosition) {
            // 标记圆开始移动
            isMoving = true
            // 记录开始触摸的点
            lastPostion = currentPosition
            // 判断是否点在了圆上
            if !circle.frame.contains(currentPosition) {
                // 不在圆上的话直接移动到点击点
                slideToPoint(currentPosition)
                // 用户点击的代理回调
                if let delegate = delegate {
                    if delegate.responds(to: #selector(WGSegmentedScaleDelegate.userDidClick(in:))) {
                        delegate.userDidClick(in: self)
                    }
                }
            } else {
                // 用户开始滑动的代理回调
                if let delegate = delegate {
                    if delegate.responds(to: #selector(WGSegmentedScaleDelegate.userDidBeginSlide(in:))) {
                        delegate.userDidBeginSlide(in: self)
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentPosition = touches.first!.location(in: self)
        // 判断是否处于移动状态, 并且需要在view上移动
        if (isMoving && self.bounds.contains(currentPosition)) {
            // 判断当前点与上一个点的偏移量
            let offsetX = currentPosition.x - lastPostion.x
            // 确保滑动的范围不会超过轨道
            let minX = bounds.minX + UIConstants.horizontalBorder
            let maxX = bounds.maxX - UIConstants.horizontalBorder
            let destinationX = max(min(circle.center.x + offsetX, maxX), minX)
            circle.center.x = destinationX
            lastPostion = currentPosition
        } else {
            // 取消移动
            isMoving = false
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMoving = false
        let oldValue = _selectedIndex
        let newValue = slideToNearestSegmentedPoint()
        // 代理回调
        if let delegate = delegate {
            if delegate.responds(to: #selector(WGSegmentedScaleDelegate.didSelectedIndexChange(in:from:to:))) {
                delegate.didSelectedIndexChange(in: self, from: oldValue, to: newValue)
            }
        }
        _selectedIndex = newValue
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMoving = false
        let oldValue = _selectedIndex
        let newValue = slideToNearestSegmentedPoint()
        // 这里先更新,要不然会有更新popover view的小bug
        _selectedIndex = newValue
        // 代理回调
        if let delegate = delegate {
            if delegate.responds(to: #selector(WGSegmentedScaleDelegate.didSelectedIndexChange(in:from:to:))) {
                delegate.didSelectedIndexChange(in: self, from: oldValue, to: newValue)
            }
        }
    }
    
    // MARK: - 判断是否点击在了可滑动区域
    private func isPointInControlZone(_ point: CGPoint) -> Bool {
        let minX = bounds.minX + UIConstants.horizontalBorder - UIConstants.diameter / 2
        let maxX = bounds.maxX - UIConstants.horizontalBorder + UIConstants.diameter / 2
        let minY = circle.frame.minY
        let maxY = circle.frame.maxY
        // 获取可滑动区域
        let controlRect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        if (controlRect.contains(point)) {
            return true
        }
        return false
    }
    
    // MARK: - 滑动到相应的点
    
    // 滑动到指定的点
    private func slideToPoint(_ point: CGPoint) {
        // 确保滑动的范围不会超过轨道
        let minX = bounds.minX + UIConstants.horizontalBorder
        let maxX = bounds.maxX - UIConstants.horizontalBorder
        let destinationX = max(min(point.x, maxX), minX)
        // 计算移动的时间
        let moveTime = abs((destinationX - circle.center.x)) / UIConstants.moveSpeed
        // 移动的时候还要有动画哦😊
        UIView.animate(withDuration: TimeInterval(moveTime), animations: {
            self.circle.center.x = destinationX
        })
    }
    
    // 滑倒到指定的索引
    private func slideToIndex(_ index: Int) {
        let minX = bounds.minX + UIConstants.horizontalBorder
        let maxX = bounds.maxX - UIConstants.horizontalBorder
        // 每一段的长度
        let segmentLength = (maxX - minX) / CGFloat(numberOfSegments - 1)
        let x = segmentLength * CGFloat(index) + UIConstants.horizontalBorder
        slideToPoint(CGPoint(x: x, y: circle.center.y))
    }
    
    // 滑倒最近的分段点
    // 返回该分段点的索引
    private func slideToNearestSegmentedPoint() -> Int {
        // 到最近分段点的距离
        var nearestDistance = CGFloat.greatestFiniteMagnitude
        // 最近点的索引值
        var nearestSegmentedIndex = -1
        // 最近点的X坐标
        var nearestSegmentedX = circle.center.x
        
        let minX = bounds.minX + UIConstants.horizontalBorder
        let maxX = bounds.maxX - UIConstants.horizontalBorder
        // 每一段的长度
        let segmentLength = (maxX - minX) / CGFloat(numberOfSegments - 1)
        // 圆心的当前X坐标
        let currentX = circle.center.x
        for i in 0..<numberOfSegments {
            let x = segmentLength * CGFloat(i) + UIConstants.horizontalBorder
            // 计算分段点到圆心的距离
            let distance = abs(x - currentX)
            if distance < nearestDistance {
                nearestDistance = distance
                nearestSegmentedIndex = i
                nearestSegmentedX = x
            }
        }
        // 滑动到最近点
        if currentX != nearestSegmentedX {
            slideToPoint(CGPoint(x: nearestSegmentedX, y: circle.center.y))
        }
        return nearestSegmentedIndex
    }
    

}
