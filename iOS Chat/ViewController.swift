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
	@IBOutlet weak var inputTextfieldDistanceToBottom: NSLayoutConstraint!
	
	var chat = Sender()
	var messageHistory = Array<String>()
	var lastDistanceToBottom: CGFloat = 22.0

	//******************************************************************************************************************
	//* MARK: - Lifecycle
	//******************************************************************************************************************
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		//pay attention to appearing keyboard
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

		chat.connect()
	}

	override func viewWillDisappear(_ animated: Bool) {
		NotificationCenter.default.removeObserver(self)
	}

	//******************************************************************************************************************
	//* MARK: - IBActions
	//******************************************************************************************************************
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

	//******************************************************************************************************************
	//* MARK: - Keyboard-Handling
	//******************************************************************************************************************
	@objc func keyboardWillShow(notification: NSNotification) {
		if let userInfo = notification.userInfo {
			if let keyboardSize = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect {
				let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
				if let rate = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber {
					UIView.animate(withDuration: TimeInterval(rate.floatValue), animations: {
						self.lastDistanceToBottom = self.inputTextfieldDistanceToBottom.constant
						self.inputTextfieldDistanceToBottom.constant = keyboardSize.height + 10
						self.chatTableView.contentInset = contentInsets
						self.chatTableView.scrollIndicatorInsets = contentInsets
					})
				}
			}
		}
	}

	@objc func keyboardWillHide(notification: NSNotification) {
		if let userInfo = notification.userInfo {
			if let rate = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber {
				UIView.animate(withDuration: TimeInterval(rate.floatValue), animations: {
					self.inputTextfieldDistanceToBottom.constant = self.lastDistanceToBottom
					self.chatTableView.contentInset          = UIEdgeInsets.zero
					self.chatTableView.scrollIndicatorInsets = UIEdgeInsets.zero
				})

			}
		}
	}
}



