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
        
        let car = Car(brand: "BMW", year: 1980)
        
        Example.of("Object relationships") {
            car.shop = myLittileShop
            car.owner = marin
            
            print(car.shop == myLittileShop)
            print(car.owner!.name)
        }
        
        Example.of("Adding Object to a different Object's List property") {
            car.repairs.append(Repair(by: jack))
            car.repairs.append(objectsIn: [
                Repair(by: jack),
                Repair(by: jack),
                Repair(by: jack)
            ])
            
            print("\(car) has \(car.repairs.count) repairs")
            
            let firstRepair: Date? = car.repairs.min(ofProperty: "date")
            let lastRepair: Date? = car.repairs.max(ofProperty: "date")
            
            print("first Repair: \(firstRepair) - last Repair: \(lastRepair)")
        }
        
        Example.of("Adding Primitive types to Realm List(s)") {
            // String
            car.plates.append("WYZ 201 Q")
            car.plates.append("2MNYC0DZ")
            
            print(car.plates)
            print("Current registeration: \(car.plates.last!)")
            
            // Date
            car.checkups.append(Date(timeIntervalSinceNow: -31557600))
            car.checkups.append(Date())
            
            print(car.checkups)
            print(car.checkups.first!)
            print(car.checkups.max()!)
        }
        
        Example.of("Referencing objects from a different Realm file") {
            // Let's say we're storing those in "stickers.realm"
            let sticker = Sticker("Swift is my life")
            
            car.stickers.append(sticker.id)
            print(car.stickers)
            
            try! realm.write({
                realm.add(car)
                realm.add(sticker)
            })
            
            print("Linked stickers:")
            print(realm.objects(Sticker.self).filter("id IN %@", car.stickers))
        }
    }
}

