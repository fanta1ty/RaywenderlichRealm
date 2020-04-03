/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import RealmSwift

class ToDoListController: UITableViewController {
  private var items: Results<ToDoItem>?
  private var itemsToken: NotificationToken?

  // MARK: - View controller life-cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    items = ToDoItem.all()
    
    if Realm.Configuration.defaultConfiguration.encryptionKey != nil {
      navigationItem.leftBarButtonItem = nil
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    // Set up a changes observer and act on changes to the Realm data
    itemsToken = items!.observe { [weak tableView] changes in
      guard let tableView = tableView else { return }

      switch changes {
      case .initial:
        tableView.reloadData()
      case .update(_, let deletions, let insertions, let updates):
        tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
      case .error: break
      }
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    // Invalidate the Observer so we don't keep getting updates
    itemsToken?.invalidate()
  }

  // MARK: - Actions

  @IBAction func addItem() {
    userInputAlert("Add Todo Item") { text in
      ToDoItem.add(text: text)
    }
  }

  func toggleItem(_ item: ToDoItem) {
    item.toggleCompleted()
  }

  func deleteItem(item: ToDoItem) {
    item.delete()
  }

  @IBAction func encryptRealm() {
    showSetPassword()
  }

  // MARK: - Navigation
  func showSetPassword() {
    let list = storyboard!.instantiateViewController(withIdentifier: "SetupViewController") as! SetupViewController
    list.setPassword = true

    UIView.transition(with: view.window!,
                      duration: 0.33,
                      options: .transitionFlipFromRight,
                      animations: {
                        self.view.window!.rootViewController = list
                      },
                      completion: nil)
  }
}

// MARK: - Table Data Source

extension ToDoListController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items?.count ?? 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ToDoTableViewCell

    if let item = items?[indexPath.row] {
      cell.update(with: item)
      cell.didToggleCompleted = { [weak self] in
        self?.toggleItem(item)
      }
    }

    return cell
  }
}

// MARK: - Table Delegate

extension ToDoListController {
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }

    if let item = items?[indexPath.row] {
      deleteItem(item: item)
    }
  }
}
