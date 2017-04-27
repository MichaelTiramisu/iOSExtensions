//
//  ViewController.swift
//  SacleWithText
//
//  Created by Siyang Liu on 17/3/28.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scaleWithText: WGScaleWithText!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func deleteButtonClick(_ sender: UIButton) {
        scaleWithText.numberOfSegments -= 1
    }
    
    @IBAction func addButtonClick(_ sender: UIButton) {
        scaleWithText.numberOfSegments += 1
    }

}

