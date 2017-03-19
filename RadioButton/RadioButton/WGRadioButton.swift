//
//  WGRadioButton.swift
//  RadioButton
//
//  Created by Siyang Liu on 17/3/16.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//

import UIKit

class WGRadioButton: UIControl {
    
    // Constants for the drawing relations
    private struct UIConstants {
        static let marginWidth: CGFloat = 1
        // The constant to mupltle when getting the inner circle from the outer circle
        static let borderToCircleRatio: CGFloat = 0.9
        // The constant to reduce when getting the inner circle from the outer circle
        static let borderToCircleOffset: CGFloat = 1
    }
    
    // The default color for thee button
    public var buttonColor: UIColor = UIColor.cyan {
        didSet {
            // Refresh the UI
            setNeedsDisplay()
        }
    }
    
    // The default color for the border
    public var borderColor: UIColor = UIColor.black {
        didSet {
            // Refresh the UI
            setNeedsDisplay()
        }
    }
    
    // Wheather or not this button is selected
    override var isSelected: Bool {
        didSet{
            // Refresh the UI
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Set the background color to transparent
        // or it will be black
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Set the background color to transparent
        // or it will be black
        backgroundColor = UIColor.clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Call this to refresh the UI when layout the subviews
        // Or it will generate all the UI to black
        setNeedsDisplay()
    }

    // Draw function
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // The center of the inner and outer(border) circle
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        // Tht radius for the outer circle
        let outerRadius = min(rect.width / 2, rect.height / 2) - 2 * UIConstants.marginWidth
        let outerCirclePath = UIBezierPath(arcCenter: center, radius: outerRadius, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: true)
        borderColor.setStroke()
        outerCirclePath.stroke()
        
        // If the button is selected, then draw the inner circle
        if isSelected {
            // Tht radius for the inner circle
            let innerRadius = outerRadius * UIConstants.borderToCircleRatio - UIConstants.borderToCircleOffset
            let innerCirclePath = UIBezierPath(arcCenter: center, radius: innerRadius, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: true)
            buttonColor.setFill()
            innerCirclePath.fill()
        }
    }

}
