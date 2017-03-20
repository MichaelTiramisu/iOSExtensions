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
    
    let initialCholices = ["aaaaaaaaaaaaaaaaaaaaaaaaaa", "aaaaaaaaaaaaaaaaaaaaaaaaaa", "aaaaaaaaaaaaaaaaaaaaaaaaaa", "aaaaaaaaaaaaaaaaaaaaaaaaaa"]
    
    let anotherChoices = ["hello", "Hi", "Hello", "hi", "Hi", "Hello", "hi"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        radioGroup.choices = initialCholices
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    @IBAction func changeChoicesButtonClick(_ sender: UIButton) {
        radioGroup.choices = anotherChoices
    }
    
    @IBAction func ChangeChoiceCountButtonClick(_ sender: UIButton) {
        let number = Int(arc4random()) % 8
        print(number)
        radioGroup.numberOfChoices = number
    }
}

