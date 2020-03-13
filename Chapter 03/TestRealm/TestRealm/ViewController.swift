//
//  ViewController.swift
//  TestRealm
//
//  Created by User on 3/13/20.
//  Copyright © 2020 ThinhNguyen. All rights reserved.
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
        
        Example.of("Basic Model") {
            let car1 = Car(brand: "BMW", year: 1980)
            print(car1)
        }
    }
}

