//
//  AppDelegate.swift
//  MyToDo
//
//  Created by User on 4/1/20.
//  Copyright © 2020 ThinhNguyen. All rights reserved.
//

import UIKit
import RealmSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupRealm()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    private func setupRealm() {
      SyncManager.shared.logLevel = .off
        if !TodoRealm.plain.fileExists && !TodoRealm.encrypted.fileExists {
            try! FileManager.default.copyItem(at: TodoRealm.bundle.url, to: TodoRealm.plain.url)
        }
    }
}

enum TodoRealm {
  case bundle
  case plain
  case encrypted

  var url: URL {
    do {
      switch self {
      case .bundle: return try Path.inBundle("bundled.realm")
      case .plain: return try Path.inDocuments("mytodo.realm")
      case .encrypted: return try Path.inDocuments("mytodoenc.realm")
      }
    } catch let err {
      fatalError("Failed finding expected path: \(err)")
    }
  }

  var fileExists: Bool {
    return FileManager.default.fileExists(atPath: path)
  }

  var path: String {
    return url.path
  }
}
