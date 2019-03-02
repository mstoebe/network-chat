//
//  ViewController.swift
//  macOS Chat
//
//  Created by Markus Stöbe on 01.02.19.
//  Copyright © 2019 Markus Stöbe. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, ReceiverDelegate, NSTableViewDataSource {
	@IBOutlet weak var chatTableView: NSTableView!

	let receiver = Receiver()
	var receivedMessages = Array<String>()

	//******************************************************************************************************************
	//* MARK: - Lifecycle
	//******************************************************************************************************************
	override func viewDidLoad() {
		super.viewDidLoad()
		receiver.delegate = self
		receiver.start()
	}

	//******************************************************************************************************************
	//* MARK: - ReceiverDelegate
	//******************************************************************************************************************
	func receiverDidReceiveText(text: String) {
		receivedMessages.append(text)
		DispatchQueue.main.async { [unowned self] in
			self.chatTableView.reloadData()
		}
	}

	//******************************************************************************************************************
	//* MARK: - TableViewDataSource
	//******************************************************************************************************************
	func numberOfRows(in tableView: NSTableView) -> Int {
		return receivedMessages.count
	}

	func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
		return receivedMessages[row]
	}




}

