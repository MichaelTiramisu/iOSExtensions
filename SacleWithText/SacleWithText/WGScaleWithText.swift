//
//  WGScaleWithText.swift
//  SacleWithText
//
//  Created by Siyang Liu on 17/3/28.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//

import UIKit
import SnapKit

@IBDesignable
class WGScaleWithText: UIView, WGSegmentedScaleDelegate {
    
    private var segmentedScale: WGSegmentedScale
    private var popoverView: WGPopoverView
    private var contentTextField: UITextField
    
    // 有多少段scale的外部暴露变量
    @IBInspectable public var numberOfSegments: Int {
        set {
            if newValue >= 2 {
                _numberOfSegments = newValue
            }
        }
        get {
            return _numberOfSegments
        }
    }
    
    // 有多少段scale
    private var _numberOfSegments = 5 {
        didSet {
            // 增加描述的数组元素个数
            if _numberOfSegments > oldValue {
                for _ in oldValue..<_numberOfSegments {
                    descriptions.append("")
                }
            }
            // 减少描述的数组元素个数
            if _numberOfSegments < oldValue {
                for _ in _numberOfSegments..<oldValue {
                    descriptions.removeLast()
                }
            }
            segmentedScale.numberOfSegments = numberOfSegments
            // 检查被选中的scale是否超过scale总数
            if segmentedScale.selectedIndex > _numberOfSegments - 1 {
                segmentedScale.selectedIndex = _numberOfSegments - 1
            }
            // 重新布局UI
            setNeedsLayout()
        }
    }
    
    // 存储scale描述的数组
    public var descriptions = [String]()

    override init(frame: CGRect) {
        segmentedScale = WGSegmentedScale(frame: frame)
        popoverView = WGPopoverView(frame: frame)
        contentTextField = UITextField(frame: frame)
        super.init(frame: frame)
        setupUI()
        // 初始化描述的数组
        for _ in 0..<numberOfSegments {
            descriptions.append("")
        }
        // 为contentTextField添加文字改变事件
        contentTextField.addTarget(self, action:#selector(textDidChange(in:)), for: .editingChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        segmentedScale = WGSegmentedScale(coder: aDecoder)!
        popoverView = WGPopoverView(coder: aDecoder)!
        contentTextField = UITextField(coder: aDecoder)!
        super.init(coder: aDecoder)
        setupUI()
        // 初始化描述的数组
        for _ in 0..<numberOfSegments {
            descriptions.append("")
        }
        // 为contentTextField添加文字改变事件
        contentTextField.addTarget(self, action:#selector(textDidChange(in:)), for: .editingChanged)
    }
    
    
    private func setupUI() {
        print(#function)
        addSubview(segmentedScale)
        // 添加代理
        segmentedScale.delegate = self
        // 为Segmented Scale添加约束
        segmentedScale.snp.makeConstraints { (make) in
            
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.height.equalTo(30)
        }
        addSubview(popoverView)
        popoverView.fillColor = UIColor(red: 249 / 255.0, green: 204 / 255.0, blue: 226 / 255.0, alpha: 1)
        popoverView.shouldFill = true
        popoverView.shouldStroke = false
        // 为popover view添加约束
        popoverView.snp.makeConstraints { (make) in
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
            make.height.equalTo(50)
//            make.centerX.equalTo(self.snp.centerX)
//            make.left.equalTo(self.snp.left).offset(5)
            make.bottom.equalTo(self.segmentedScale.snp.top).offset(-5)
        }
        // 添加输入的text field到popover view
        contentTextField.backgroundColor = UIColor.white
        contentTextField.borderStyle = .roundedRect
        popoverView.addSubview(contentTextField)
        // 为输入的text field添加约束
        contentTextField.snp.makeConstraints { (make) in
            make.top.equalTo(popoverView.snp.top).offset(5)
            make.bottom.equalTo(popoverView.snp.bottom).offset(-15)
            make.left.equalTo(popoverView.snp.left).offset(5)
            make.right.equalTo(popoverView.snp.right).offset(-5)
        }
        
        // 隐藏popover view
        popoverView.isHidden = true
    }
    
    // MARK: - Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
//        popoverView.frame.origin.x = 0
//        popoverView.arrowHorizontalOffset = -(popoverView.frame.midX - WGSegmentedScale.UIConstants.horizontalBorder)
        layoutPopoverView(for: segmentedScale.selectedIndex)
        print(#function)
        
    }
    
    // 布局popover view的水平位置
    func layoutPopoverView(for index: Int) {
        // 箭头在不发生偏移时, 可以到达的范围
        let minX = popoverView.bounds.width / 2
        let maxX = self.bounds.width - popoverView.bounds.width / 2
//        let segmentWidth = 
        let arrowX = segmentedScale.segmentLength * CGFloat(index) + WGSegmentedScale.UIConstants.horizontalBorder
        // 落在不需要发生偏移的地方
        if arrowX >= minX && arrowX <= maxX {
            popoverView.center.x = arrowX
            if popoverView.arrowHorizontalOffset != 0 {
                popoverView.arrowHorizontalOffset = 0
            }
        }
        // 需要往左边偏移
        if arrowX < minX {
            popoverView.center.x = minX
            // 这一步需要重绘UI, 先检测一下可以提高概率
            if popoverView.arrowHorizontalOffset != arrowX - minX {
                popoverView.arrowHorizontalOffset = arrowX - minX
            }
        }
        // 需要往右边偏移
        if arrowX > maxX {
            popoverView.center.x = maxX
            if popoverView.arrowHorizontalOffset != arrowX - maxX {
                popoverView.arrowHorizontalOffset = arrowX - maxX
            }
        }
//        contentTextField.frame = CGRect(x: popoverView.bounds.origin.x + 5, y: popoverView.bounds.origin.y + 5, width: popoverView.bounds.width - 10, height: popoverView.bounds.height - popoverView.arrowHeight - 10)
    }
    
    func buttonClick(_ sender: UIButton) {
        
    }
    
    // MARK: - WGSegmentedScale Delegate
    // 用户开始滑动的代理方法
    func userDidBeginSlide(in segmetedScale: WGSegmentedScale) {
        print(#function)
        UIView.animate(withDuration: 1, animations: {
            self.popoverView.alpha = 0
        })
    }
    
    // 用户直接点击的代理方法(没有点在圆上)
    func userDidClick(in segmetedScale: WGSegmentedScale) {
        print(#function)
        self.popoverView.alpha = 0
    }
    
    // 索引改变的代理
    func didSelectedIndexChange(in segmentedScale: WGSegmentedScale, from oldValue: Int, to newValue: Int) {
        print(#function)
        layoutPopoverView(for: newValue)
        if popoverView.isHidden {
            popoverView.isHidden = false
        }
        UIView.animate(withDuration: 1, animations: {
            self.popoverView.alpha = 1
        })
        // 设置ContentTextField对应的描述元素
        contentTextField.text = descriptions[newValue]
    }
    
    // MARK:- 处理contentTextField输入改变事件
    func textDidChange(in textField: UITextField) {
        descriptions[segmentedScale.selectedIndex] = textField.text!
    }

}
