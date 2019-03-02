//
//  Sender.swift
//  Network Chat
//
//  Created by Markus Stöbe on 01.02.19.
//  Copyright © 2019 Markus Stöbe. All rights reserved.
//

import Network

class Sender: NSObject {
	
	var connection: NWConnection!
	let queue = DispatchQueue(label: "senderQueue", attributes: .concurrent)

	func connect() {
		connection = NWConnection( to: .service(name: "Chat",
												type: "_chat._udp",
												domain: "local",
												interface: nil),
								   using: .udp)
		connection.stateUpdateHandler = { (newState) in
			switch (newState) {
			case .ready:
				//Verbindung aufgebaut
				print ("connection ready")
				self.sendHello()
			case .waiting(let error):
				//warten auf den Verbindungsaufbau
				print ("connection waiting (\(error))")
			case .failed(let error):
				//ein fataler Fehler ist aufgetreten
				print ("connection failed (\(error))")
			default:
				print ("connection \(newState)")
				break
			}
		}

		connection.start(queue: queue)
	}

	func sendHello() {
		if connection.state == .ready {
			connection.send(content: "hello".data(using: .utf8),
							completion: .contentProcessed(
								{error in
									if let error = error {
										print("error while sending hello: \(error)")
										return
									}

									print("message sent")
							}))
		} else {
			print ("connection is not ready!")
		}
	}

	func sendText(textToSend: String) {
		if connection.state == .ready {
			connection.send(content: textToSend.data(using: .utf8),
							completion: .contentProcessed(
								{error in
									if let error = error {
										print("error while sending text: \(error)")
										return
									}
									print("message sent")
							}))
		} else {
			print ("connection is not ready!")
		}
	}

}
