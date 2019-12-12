//
//  SearchViewController.swift
//  Final Project
//
//  Created by Josh DeMoss on 12/11/19.
//  Copyright © 2019 Josh DeMoss. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func cancelSearchDidTouch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
