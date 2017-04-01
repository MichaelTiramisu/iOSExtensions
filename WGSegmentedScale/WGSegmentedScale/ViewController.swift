//
//  ViewController.swift
//  WGSegmentedScale
//
//  Created by Siyang Liu on 17/3/29.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WGSegmentedScaleDelegate {

    @IBOutlet weak var segmentedScale: WGSegmentedScale!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        segmentedScale.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func buttonClick(_ sender: UIButton) {
//        segmentedScale.selectedIndex += 1
        segmentedScale.numberOfSegments += 1
    }
    
    func didSelectedIndexChange(in segmentedScale: WGSegmentedScale, from oldValue: Int, to newValue: Int) {
        
    }
    
}

