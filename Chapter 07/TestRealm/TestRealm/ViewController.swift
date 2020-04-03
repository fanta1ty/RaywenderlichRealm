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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newConfiguration()
        
        defaultConfiguration()
        
        inMemoryConfiguration()
        
        documentFolderConfiguration()
        
        documentFolderConfiguration()
        
        libraryFolderConfiguration()
        
        readonlyConfiguration()
        
        objectSchemeConfiguration()
    }
}

extension ViewController {
    final private func newConfiguration() {
        Example.of("New Configuration") {
            let newConfig = Realm.Configuration()
            print(newConfig)
        }
    }
    
    final private func defaultConfiguration() {
        Example.of("Default Configuration") {
            let defaultConfig = Realm.Configuration.defaultConfiguration
            print(defaultConfig)
        }
    }
    
    final private func inMemoryConfiguration() {
        Example.of("In-Memory Configuration") {
            let memoryConfig1 = Realm.Configuration(inMemoryIdentifier: "InMemoryRealm1")
            print(memoryConfig1)
            
            let memoryConfig2 = Realm.Configuration(inMemoryIdentifier: "InMemoryRealm2")
            print(memoryConfig2)
            
            let realm1 = try! Realm(configuration: memoryConfig1)
            let people1 = realm1.objects(Person.self)
            try! realm1.write({
                realm1.add(Person())
            })
            
            print("People (1): \(people1.count)")
            
            let realm2 = try! Realm(configuration: memoryConfig2)
            let people2 = realm2.objects(Person.self)
            print("People (2): \(people2.count)")
        }
    }
    
    final private func documentFolderConfiguration() {
        Example.of("Documents Folder Configuration") {
            let documentsURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("myRealm.realm")
            
            let documentConfig = Realm.Configuration(fileURL: documentsURL)
            print("Documents-folder Realm in: \(documentConfig.fileURL)")
        }
    }
    
    final private func libraryFolderConfiguration() {
        Example.of("Library Folder Configuration") {
            let libraryURL = try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("myRealm.realm")
            
            let libraryConfig = Realm.Configuration(fileURL: libraryURL)
            print("Realm in Library folder: \(libraryConfig.fileURL)")
        }
    }
    
    final private func readonlyConfiguration() {
        Example.of("Read-only Realm") {
            let rwURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("newFile.realm")
            let rwConfig = Realm.Configuration(fileURL: rwURL)
            
            autoreleasepool {
                let rwRealm = try! Realm(configuration: rwConfig)
                try! rwRealm.write({
                    rwRealm.add(Person())
                })
                
                print("Regular Realm, is Read Only? : \(rwRealm.configuration.readOnly)")
                print("Saved objects: \(rwRealm.objects(Person.self).count) \n")
            }
            
            autoreleasepool {
                let roConfig = Realm.Configuration(fileURL: rwURL, readOnly: true)
                let roRealm = try! Realm(configuration: roConfig)
                print("Read-Only Realm, is Read Only?: \(roRealm.configuration.readOnly)")
                print("Read objects: \(roRealm.objects(Person.self).count)")
            }
        }
    }
    
    final private func objectSchemeConfiguration() {
        Example.of("Object Schema - Entire Realm") {
            let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "Realm"))
            print(realm.schema.objectSchema)
        }
        
        Example.of("Object Schema - Specific Object") {
            let config = Realm.Configuration(inMemoryIdentifier: "Realm2", objectTypes: [Person.self])
            let realm = try! Realm(configuration: config)
            
            print(realm.schema.objectSchema)
        }
    }
}

