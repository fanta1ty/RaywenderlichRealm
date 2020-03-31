//
//  AppDelegate.swift
//  Chatter
//
//  Created by User on 3/27/20.
//  Copyright © 2020 ThinhNguyen. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let api = ChatAPI()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        api.connect { [unowned self] newMessages in
          self.persist(messages: newMessages)
        }
        
        return true
    }
    
    private func persist(messages: [(String, String)]) {
      // Persist a list of messages to database
      print(messages)
        SyncManager.shared.logLevel = .off
        
        DispatchQueue.global(qos: .background).async {
            let objects = messages.map { message in
                return Message(from: message.0, text: message.1)
            }
            
            let realm = try! Realm()
            try! realm.write({
                realm.add(objects)
            })
        }
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


}

