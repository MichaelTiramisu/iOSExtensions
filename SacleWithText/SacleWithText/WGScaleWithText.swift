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
    
    private var slider: UISlider

    override init(frame: CGRect) {
        slider = UISlider()
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        slider = UISlider()
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func draw(_ rect: CGRect) {
    }
    
    private func setupUI() {
        addSubview(slider)
        // 为slider添加约束
        slider.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left).offset(10)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(10)
        }
        
        slider.maximumTrackTintColor = UIColor.black
        slider.minimumTrackTintColor = UIColor.black
        slider.isContinuous = false
        
    }
    
    func buttonClick(_ sender: UIButton) {
        
    }
    

}
