//
//  ViewController.swift
//  macOS Chat
//
//  Created by Markus Stöbe on 01.02.19.
//  Copyright © 2019 Markus Stöbe. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	let receiver = Receiver()

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do view setup here.
		receiver.start()
	}
}

