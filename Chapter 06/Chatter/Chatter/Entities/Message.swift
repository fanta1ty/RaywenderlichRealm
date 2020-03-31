//
//  Message.swift
//  Chatter
//
//  Created by User on 3/27/20.
//  Copyright © 2020 ThinhNguyen. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Message: Object {

  // MARK: - Properties
  dynamic var id = UUID().uuidString
  dynamic var date = Date()
  dynamic var from = ""
  dynamic var text = ""
  dynamic var isNew = true

  // MARK: - Init
  convenience init(from: String, text: String) {
    self.init()
    self.from = from
    self.text = text
  }

  // MARK: - Meta information
  override static func primaryKey() -> String? {
    return "id"
  }
}

extension Message {
  // MARK: - Property names
  public struct properties {
    static let id = "id"
    static let date = "date"
  }
}
