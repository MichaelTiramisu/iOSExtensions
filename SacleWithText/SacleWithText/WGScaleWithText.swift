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

    override init(frame: CGRect) {
        segmentedScale = WGSegmentedScale(frame: frame)
        popoverView = WGPopoverView(frame: frame)
        contentTextField = UITextField(frame: frame)
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        segmentedScale = WGSegmentedScale(coder: aDecoder)!
        popoverView = WGPopoverView(coder: aDecoder)!
        contentTextField = UITextField(coder: aDecoder)!
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func draw(_ rect: CGRect) {
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
//        popoverView.snp.makeConstraints { (make) in
//            make.top.equalTo(popoverView.snp.top)
//            make.bottom.equalTo(popoverView.snp.bottom)
////            make.left.equalTo(popoverView.snp.left)
////            make.right.equalTo(popoverView.snp.right)
//            make.leading.equalTo(popoverView.snp.leading)
//            make.trailing.equalTo(popoverView.snp.trailing)
//        }
        
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
        contentTextField.frame = CGRect(x: popoverView.bounds.origin.x + 5, y: popoverView.bounds.origin.y + 5, width: popoverView.bounds.width - 10, height: popoverView.bounds.height - popoverView.arrowHeight - 10)
//        contentTextField.backgroundColor = UIColor.white
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
        layoutPopoverView(for: newValue)
        if popoverView.isHidden {
            popoverView.isHidden = false
        }
        UIView.animate(withDuration: 1, animations: {
            self.popoverView.alpha = 1
        })
    }
    

}
