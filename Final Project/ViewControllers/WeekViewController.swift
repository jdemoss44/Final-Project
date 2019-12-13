//
//  WeekViewController.swift
//  Final Project
//
//  Created by Josh DeMoss on 12/10/19.
//  Copyright © 2019 Josh DeMoss. All rights reserved.
//

import UIKit

class WeekViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func discoverButtonDidTouch(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToDiscover", sender: nil)
    }
    
}
