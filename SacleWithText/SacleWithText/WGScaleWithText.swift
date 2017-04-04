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
class WGScaleWithText: UIView {
    
    private var segmentedScale: WGSegmentedScale
    private var popoverView: WGPopoverView

    override init(frame: CGRect) {
        segmentedScale = WGSegmentedScale(frame: frame)
        popoverView = WGPopoverView(frame: frame)
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        segmentedScale = WGSegmentedScale(coder: aDecoder)!
        popoverView = WGPopoverView(coder: aDecoder)!
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func draw(_ rect: CGRect) {
    }
    
    private func setupUI() {
        print(#function)
        addSubview(segmentedScale)
        // 为Segmented Scale添加约束
        segmentedScale.snp.makeConstraints { (make) in
            
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.height.equalTo(30)
        }
        addSubview(popoverView)
        // 为popover view添加约束
        popoverView.snp.makeConstraints { (make) in
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
            make.height.equalTo(50)
//            make.centerX.equalTo(self.snp.centerX)
            make.left.equalTo(self.snp.left).offset(5)
            make.bottom.equalTo(self.segmentedScale.snp.top).offset(-5)
        }
//        popoverView.arrowHorizontalOffset = -(popoverView.bounds.midX - WGSegmentedScale.UIConstants.horizontalBorder) + 75
    }
    
    // MARK: - Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        popoverView.backgroundColor = UIColor.blue
        popoverView.arrowHorizontalOffset = -(popoverView.bounds.midX - WGSegmentedScale.UIConstants.horizontalBorder) - 5
        print(#function)
    }
    
    func buttonClick(_ sender: UIButton) {
        
    }
    

}
