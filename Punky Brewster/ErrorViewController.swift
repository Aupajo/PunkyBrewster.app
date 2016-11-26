//
//  ErrorViewController.swift
//  Punky Brewster
//
//  Created by Luke McFarlane on 12/12/15.
//  Copyright © 2015 Pete Nicholls. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
}

