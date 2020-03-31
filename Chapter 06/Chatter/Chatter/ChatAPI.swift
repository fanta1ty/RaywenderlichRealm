//
//  ChatAPI.swift
//  Chatter
//
//  Created by User on 3/31/20.
//  Copyright © 2020 ThinhNguyen. All rights reserved.
//

import Foundation
import UIKit

class ChatAPI {

  typealias MessagesCallback = ([(String, String)]) -> Void
  private var callback: MessagesCallback?

  // "connects" to chat api and starts periodically fetch messages
  // and feed them to the provided callback
  func connect(withMessagesCallback callback: @escaping MessagesCallback) {
    self.callback = callback
    receiveMessages()
  }

  private func receiveMessages() {
    var messages = [(String, String)]()

    for _ in 0...random(min: 1, max: 3) {
      messages.append((from.randomElement(), phrases.randomElement()))
    }

    // simulate fetching data from network
    UIApplication.shared.isNetworkActivityIndicatorVisible = true

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
      self?.callback?(messages)
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(random(min: 5, max: 10))) {[weak self] in
      self?.receiveMessages()
    }
  }

  private let phrases = ["hello everyone", "hey hey hey", "anyone around?", "Bye", "I'm outta here", "I have a question", "testing testing ... 1, 2, 3", "wubalubadubdub"]
  private let from = ["Josh", "Jane", "Peter", "Sam", "Ray", "Paul", "Adam", "Lana", "Derek", "Patrick"]
}

private func random(min: UInt32, max: UInt32) -> Int {
  return Int(arc4random_uniform(max) + min)
}

extension Array {
  func randomElement() -> Element {
    return self[random(min: 0, max: UInt32(count-1))]
  }
}
