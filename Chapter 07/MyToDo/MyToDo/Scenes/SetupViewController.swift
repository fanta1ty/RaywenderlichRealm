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

class SetupViewController: UIViewController {
  var setPassword = false

  // MARK: - View controller life-cycle

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if setPassword {
        encryptRealm()
    } else {
        detectConfiguration()
    }
  }

  // Modify default configuration with unencrypted file path
  private func detectConfiguration() {
    if TodoRealm.encrypted.fileExists {
        askForPassword()
    } else {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(fileURL: TodoRealm.plain.url)
        showToDoList()
    }
  }

  // MARK: - Open encrypted Realm

  private func askForPassword() {
    userInputAlert("Enter a password to open the encrypted todo file", isSecure: true) { [weak self] password in
      self?.openRealm(with: password)
    }
  }

  // Modify default configuration with encrypted file path and a key
  private func openRealm(with password: String) {
    Realm.Configuration.defaultConfiguration = Realm.Configuration(fileURL: TodoRealm.encrypted.url, encryptionKey: password.sha512)
    
    // Try to open the Realm file
    do {
        _ = try Realm()
        showToDoList()
    } catch let error as NSError {
        print(error.localizedDescription)
        askForPassword()
    }
  }

  // MARK: - Encrypt existing realm

  // here we show how to copy a Realm over to a new configuration and delete an existing Realm file
  private func encryptRealm() {
    userInputAlert("Create a password to encrypt your to do list", isSecure: false) { [weak self] password in
        autoreleasepool {
            let plainConfig = Realm.Configuration(fileURL: TodoRealm.plain.url)
            let realm = try! Realm(configuration: plainConfig)
            try! realm.writeCopy(toFile: TodoRealm.encrypted.url, encryptionKey: password.sha512)
        }
        
        do {
            // Delete old file
            let files = FileManager.default.enumerator(at: try Path.documents(), includingPropertiesForKeys: [])!
            
            for file in files.allObjects {
                guard let url = file as? URL, url.lastPathComponent.hasPrefix("mytodo.") else {
                    continue
                }
                
                try FileManager.default.removeItem(at: url)
            }
        } catch let err {
            fatalError("Failed deleting unencrypted Realm: \(err)")
        }
        
        self?.detectConfiguration()
    }
  }

  // MARK: - Navigation

  private func showToDoList() {
    let list = storyboard!.instantiateViewController(withIdentifier: "ToDoNavigationController")
    UIView.transition(with: view.window!, duration: 0.33, options: .transitionFlipFromLeft, animations: {
      self.view.window!.rootViewController = list
    }, completion: nil)
  }
}
