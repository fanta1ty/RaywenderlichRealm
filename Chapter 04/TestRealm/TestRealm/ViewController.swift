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
        // Do any additional setup after loading the view.
        // Setup
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TemporaryRealm"))
        print("Ready to play...")
        
        let marin = Person("Marin")
        let jack = Person("Jack")
        
        let myLittileShop = RepairShop()
        myLittileShop.name = "My Little Auto Shop"
        myLittileShop.contact = jack
    }
}

