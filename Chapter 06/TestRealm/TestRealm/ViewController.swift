//
//  ViewController.swift
//  TestRealm
//
//  Created by User on 3/13/20.
//  Copyright © 2020 ThinhNguyen. All rights reserved.
//  Email: thinhnguyen12389@gmail.com
//

import UIKit
import Foundation
import RealmSwift
import CoreLocation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ObservingAnObject()
        // ObservingACollection()
        // CollectionChanges()
        // AvoidNotificationsForGivenTokens()
        RealmWideNotifications()
    }
}

extension ViewController {
    func ObservingAnObject() {
        Example.of("Observing an Object")
        
        //: **Setup Realm**
        let configuration = Realm.Configuration(inMemoryIdentifier: "TemporaryRealm")
        let realm = try! Realm(configuration: configuration)

        let article = Article()
        article.id = "new-article"

        try! realm.write({
            realm.add(article)
        })

        let token = article.observe { change in
            switch change {
            case .change(let properties):
                for property in properties {
                    switch property.name {
                    case "title":
                        print("📝 Article title changed from \(property.oldValue ?? "nil") to \(property.newValue ?? "nil")")
                        
                    case "author":
                        print("🌜Author changed to \(property.newValue ?? "nil")")
                        
                    default:
                        break
                    }
                }
                
                if properties.contains(where: { $0.name == "date" }) {
                    print("date has changed to \(String(describing: article.date))")
                }
                break
                
            case .error(let error):
                print("Error occurred: \(error)")
                
            case .deleted:
                print("Article was deleted")
            }
        }

        print("Subscription token: \(token)")

        try! realm.write({
            article.title = "Work in progress"
        })

        DispatchQueue.global(qos: .background).async {
            let realm = try! Realm(configuration: configuration)
            
            if let article = realm.object(ofType: Article.self, forPrimaryKey: "new-article") {
                try! realm.write({
                    article.title = "Actual title"
                    article.author = Person()
                })
            }
        }
    }
    
    func ObservingACollection() {
        Example.of("Observing a Collection")
        //: **Setup Realm and preload some data**
        let configuration = Realm.Configuration(inMemoryIdentifier: "TemporaryRealm")
        let realm = try! Realm(configuration: configuration)

        try! TestDataSet.create(in: realm)

        let people = realm.objects(Person.self).sorted(byKeyPath: "firstName")
        let token = people.observe { changes in
            print("Current count: \(people.count)")
        }

        try! realm.write({
            realm.add(Person())
        })

        try! realm.write({
            realm.add(Person())
        })

        DispatchQueue.global(qos: .background).sync {
            let realm = try! Realm(configuration: configuration)
            try! realm.write({
                realm.add(Person())
            })
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            token.invalidate()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            try! realm.write({
                realm.add(Person())
            })
        }

    }
    
    func CollectionChanges() {
        Example.of("Collection Changes")

        //: **Setup Realm and preload some data**
        let configuration = Realm.Configuration(inMemoryIdentifier: "TemporaryRealm")
        let realm = try! Realm(configuration: configuration)

        try! TestDataSet.create(in: realm)

        let article = Article()
        article.title = "New Article"

        try! realm.write({
            realm.add(article)
        })

        let token = article.people.observe { changes in
            switch changes {
            case .initial(let people):
                print("Initial count: \(people.count)")
            
            case .update(let people, let deletions, let insertions, let modifications):
                print("Current count: \(people.count)")
                print("Inserted \(insertions), Modified: \(modifications), Deleted \(deletions)")
            
            case .error(let error):
                print("Error: \(error)")
            }
        }

        try! realm.write({
            article.people.append(Person())
            article.people.append(Person())
            article.people.append(Person())
        })

        try! realm.write({
            article.people[1].isVIP = true
        })

        try! realm.write({
            article.people.remove(at: 0)
            article.people[1].firstName = "Joel"
        })

        try! realm.write({
            article.people.removeAll()
        })
    }
    
    func AvoidNotificationsForGivenTokens() {
        Example.of("Avoid notifications for given tokens")
        
        //: **Setup Realm and preload some data**
        let configuration = Realm.Configuration(inMemoryIdentifier: "TemporaryRealm")
        let realm = try! Realm(configuration: configuration)

        try! TestDataSet.create(in: realm)

        let people = realm.objects(Person.self)
        
        let token1 = people.observe { changes in
            switch changes {
            case .initial:
                print("Initial notification for token1")
                
            case .update:
                print("Change notification for token1")
                
            default:
                break
            }
        }

        let token2 = people.observe { changes in
            switch changes {
            case .initial:
                print("Initial notification for token2")
                
            case .update:
                print("Change notification for token2")
                
            default:
                break
            }
        }
        
        realm.beginWrite()
        realm.add(Person())
        try! realm.commitWrite(withoutNotifying: [token2])
        
    }
    
    func RealmWideNotifications() {
        Example.of("Realm wide notifications")
        //: **Setup Realm**
        let configuration = Realm.Configuration(inMemoryIdentifier: "TemporaryRealm")
        let realm = try! Realm(configuration: configuration)
        
        let token = realm.observe { notification, realm in
            print(notification)
        }
        
        try! realm.write({
            
        })
    }
}

