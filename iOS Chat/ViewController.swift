//
//  ViewController.swift
//  Network Chat
//
//  Created by Markus Stöbe on 20.01.19.
//  Copyright © 2019 Markus Stöbe. All rights reserved.
//

import UIKit
import Network

class ViewController: UIViewController {

	var sender = Sender()

	override func viewDidLoad() {
		super.viewDidLoad()

		sender.connect(to: "192.168.1.24")
	}
}



