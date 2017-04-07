//
//  WGSegmentedScaleDelegate.swift
//  WGSegmentedScale
//
//  Created by Siyang Liu on 17/3/30.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//

import Foundation

@objc
protocol WGSegmentedScaleDelegate : NSObjectProtocol {
    // 用户开始滑动的代理方法
    func userDidBeginSlide(in segmetedScale: WGSegmentedScale)
    // 用户直接点击的代理方法(没有点在圆上)
    func userDidClick(in segmetedScale: WGSegmentedScale)
    // 选定的索引改变的代理方法
    func didSelectedIndexChange(in segmentedScale: WGSegmentedScale, from oldValue: Int, to newValue: Int)
}
