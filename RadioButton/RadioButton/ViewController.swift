//
//  ViewController.swift
//  RadioButton
//
//  Created by Siyang Liu on 17/3/16.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var radioGroup: WGRadioGroup!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    //    override func draw(_ rect: CGRect) {
    //        super.draw(rect)
    //
    //        let button = WGRadioButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    //        addSubview(button)
    //    }

    
    @IBAction func multipleSelectionButtonClick(_ sender: UIButton) {
        radioGroup.allowsMutipleSelection = !radioGroup.allowsMutipleSelection
    }
    
    @IBAction func changeTextColorButtonClick(_ sender: UIButton) {
        radioGroup.textColor = UIColor.random
    }
    
    @IBAction func changeOuterColorButtonClick(_ sender: UIButton) {
        radioGroup.borderColor = UIColor.random
    }
    
    @IBAction func changeinnerColorButtonClick(_ sender: UIButton) {
        radioGroup.buttonColor = UIColor.random
    }
}

