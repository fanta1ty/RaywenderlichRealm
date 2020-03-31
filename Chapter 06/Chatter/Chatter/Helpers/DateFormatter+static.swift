//
//  DateFormatter+static.swift
//  Chatter
//
//  Created by User on 3/27/20.
//  Copyright © 2020 ThinhNguyen. All rights reserved.
//

import Foundation

extension DateFormatter {
  static var mediumTimeFormatter: DateFormatter {
    let f = DateFormatter()
    f.dateStyle = .none
    f.timeStyle = .medium
    return f
  }
}
