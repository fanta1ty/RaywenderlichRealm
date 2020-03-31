//
//  UITableView+RealmChanges.swift
//  Chatter
//
//  Created by User on 3/27/20.
//  Copyright © 2020 ThinhNguyen. All rights reserved.
//

import Foundation
import UIKit

extension IndexPath {
  static func fromRow(_ row: Int) -> IndexPath {
    return IndexPath(row: row, section: 0)
  }
}

extension UITableView {
  func applyChanges(deletions: [Int], insertions: [Int], updates: [Int]) {
    beginUpdates()
    deleteRows(at: deletions.map(IndexPath.fromRow), with: .automatic)
    insertRows(at: insertions.map(IndexPath.fromRow), with: .automatic)
    reloadRows(at: updates.map(IndexPath.fromRow), with: .none)
    endUpdates()
  }
}
