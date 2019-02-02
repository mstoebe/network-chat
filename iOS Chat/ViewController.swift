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

	var chat = Sender()

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		chat.connect(to: "192.168.1.24")
	}

	@IBAction func sendHello(_ sender: Any) {
		chat.sendHello()
	}


}



