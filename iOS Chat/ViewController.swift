//
//  ViewController.swift
//  Network Chat
//
//  Created by Markus Stöbe on 20.01.19.
//  Copyright © 2019 Markus Stöbe. All rights reserved.
//

import UIKit
import Network

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

	@IBOutlet weak var inputText: UITextField!
	@IBOutlet weak var chatTableView: UITableView!

	var chat = Sender()
	var messageHistory = Array<String>()

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		chat.connect()
	}

	@IBAction func sendHello(_ sender: Any) {
		chat.sendHello()
	}

	@IBAction func sendText(_ sender: Any) {
		if let text = inputText.text {
			chat.sendText(textToSend: text)
			messageHistory.append(text)
			chatTableView.reloadData()
			inputText.text = ""
		}

	}

	//******************************************************************************************************************
	//* MARK: - TableView
	//******************************************************************************************************************
	let kCellID = "chatCell"

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1		// Default is 1 if not implemented
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messageHistory.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: kCellID)
		if (cell == nil) {
			cell = UITableViewCell.init(style:.default, reuseIdentifier:kCellID)
		}

		cell?.textLabel?.text = messageHistory[indexPath.row]
		return cell!
	}

	//******************************************************************************************************************
	//* MARK: - Textfield-Delegate
	//******************************************************************************************************************
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		sendText(self)
		textField.resignFirstResponder()
		return true
	}


}



