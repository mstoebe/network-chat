//
//  Receiver.swift
//  Network Chat
//
//  Created by Markus Stöbe on 01.02.19.
//  Copyright © 2019 Markus Stöbe. All rights reserved.
//

import Foundation
import Network

protocol ReceiverDelegate {
	func receiverDidReceiveText(text: String)
}

class Receiver: NSObject {

	var listener: NWListener!
	var delegate: ReceiverDelegate?

	func start() {
		do {
			listener = try NWListener(using: .udp)
			listener.service = NWListener.Service(name: "Chat",
												  type: "_chat._udp",
												  domain: nil,
												  txtRecord: nil)
			listener.newConnectionHandler = { (newConnection) in
				print("incoming connection!")

				newConnection.stateUpdateHandler = { newState in
					switch newState {
					case .ready:
						print ("connection ready")
						self.receive(from: newConnection)
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

				newConnection.start(queue: DispatchQueue(label: "receiverQueue"))
			}

			print("starting to listen for connections...")
			listener.start(queue: DispatchQueue(label: "listenerQueue"))
		} catch {
			print("there was an error setting up the listener")
		}
	}

	func receive(from connection: NWConnection) {
		connection.receiveMessage { (data, context, isComplete, error) in
			//report an error
			if let error = error {
				print(error)
				return
			}

			//process received data
			if let data = data, let message = String(data: data, encoding: .utf8)  {
				print("received message: \(message)")
				self.delegate?.receiverDidReceiveText(text: message)
			}

			//restart receiving
			self.receive(from: connection)
		}
	}
}
