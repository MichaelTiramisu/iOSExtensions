//
//  WGRadioButton.swift
//  RadioButton
//
//  Created by Siyang Liu on 17/3/16.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//

import UIKit

@IBDesignable
class WGRadioGroup: UIView {
    
    let label = UILabel()
    
    @IBInspectable
    var numberOfChoices: Int = 4 {
        didSet {
            // Make sure the number of choices is between [2, 6]
            if numberOfChoices > 6 {
                numberOfChoices = 6
            }
            if numberOfChoices < 2 {
                numberOfChoices = 2
            }
        }
    }
    
    // Array to record which buttons are selected
    @IBInspectable
    var selected: [Bool]
    
    @IBInspectable
    var aha: Bool = false
    
    override init(frame: CGRect) {
        selected = [Bool]()
        for _ in 0..<numberOfChoices {
            selected.append(false)
        }
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        selected = [Bool]()
        for _ in 0..<numberOfChoices {
            selected.append(false)
        }
        super.init(coder: aDecoder)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        label.text = "Hello"
        label.frame = CGRect(x: 20, y: 20, width: 100, height: 100)
        self.addSubview(label)
        
        let button = WGRadioButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        addSubview(button)
    }
    
    
    func click() {
        print(1)
    }
    

}
