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
        
        Example.of("Basic Model") {
            let car1 = Car(brand: "BMW", year: 1980)
            print(car1)
        }
        
        Example.of("Complex Model") {
            let person = Person(firstName: "Marin", born: Date(timeIntervalSince1970: 0), id: 1035)
            person.hairCount = 1284639265974
            person.isVIP = true
            
            print(type(of: person))
            print(type(of: person).primaryKey() ?? "no primary key")
            print(type(of: person).className())
            print(person)
        }
    }
}

