//
//  ChatViewController.swift
//  Chatter
//
//  Created by User on 3/27/20.
//  Copyright © 2020 ThinhNguyen. All rights reserved.
//

import Foundation
import RealmSwift

class ChatViewController: UITableViewController {
  private let highlightColor = UIColor(red: 243/255.0, green: 242/255.0, blue: 247/255.0, alpha: 1.0)
  private let formatter = DateFormatter.mediumTimeFormatter

    private var messages: Results<Message>?
    private var messageToken: NotificationToken?
    
  // MARK: - View controller life-cycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    let realm = try! Realm()
    messages = realm.objects(Message.self).sorted(byKeyPath: Message.properties.date, ascending: false)
    
    messageToken = messages!.observe({ [weak self] _ in
        self?.tableView.reloadData()
    })
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    messageToken?.invalidate()
  }
}

// MARK: - UITableView data source
extension ChatViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages?.count ?? 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
    
    let message = messages![indexPath.row]
    let formettedDate = formatter.string(from: message.date)
    cell.contentView.backgroundColor = message.isNew ? highlightColor: .white
    cell.textLabel?.text = message.isNew ? "[\(message.from)]" : message.from
    cell.detailTextLabel?.text = String(format: "(%@) %@", formettedDate, message.text)
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    let message = messages![indexPath.row]
    
    let realm = try! Realm()
    try! realm.write({
        message.isNew = false
    })
  }
}

// MARK: - UITableView delegate
extension ChatViewController {
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }

  }
}
