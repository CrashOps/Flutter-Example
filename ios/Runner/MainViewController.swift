//
//  MainViewController.swift
//  Runner
//
//  Created by CrashOps on 17/03/2020.
//  Copyright © 2020 CrashOps. All rights reserved.
//

import Foundation

class MainViewController: FlutterViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        AppDelegate.observeFlutterCalls(rootViewController: self)
    }
}
